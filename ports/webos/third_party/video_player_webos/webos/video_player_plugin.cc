// SPDX-FileCopyrightText: Copyright 2023 LG Electronics Inc.
// SPDX-License-Identifier: BSD-3-Clause

#include "include/video_player_webos/video_player_web_os_plugin.h"

#include <pbnjson.hpp>
#include "video_player_plugin.h"
#include "video_player.h"
#include "log.h"

#ifdef TAG
#undef TAG
#endif
#define TAG "VideoPlayerPlugin::"

static constexpr char kSendScreenSaverStatusMethodName[] = "screenSaverStatus";
static constexpr char kSendAppLifecycleStateMethodName[] = "appLifecycleState";
static const size_t MAX_PIPELINES = 5;

void VideoPlayerPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrar *registrar,
    FlutterDesktopViewRef view) {
  auto plugin = std::make_unique<VideoPlayerPlugin>(registrar, view);
  registrar->AddPlugin(std::move(plugin));
}

VideoPlayerPlugin::VideoPlayerPlugin(
    flutter::PluginRegistrar *registrar,
    FlutterDesktopViewRef view)
: plugin_registrar_(registrar) {
  std::string app_id = ::getenv("FLUTTER_APP_ID");

  if (app_id.find("com.webos.") == 0) {
    std::string path = ::getenv("FLUTTER_BUNDLE_PATH");
    path += "/appinfo.json";
    pbnjson::JValue doc = pbnjson::JDomParser::fromFile(path.c_str());

    background_run_ = doc["enableBackgroundRun"].isBoolean()
                    ? doc["enableBackgroundRun"].asBool()
                    : false;

    bool pig_screensaver = doc["enablePigScreenSaver"].isBoolean()
                         ? doc["enablePigScreenSaver"].asBool()
                         : true;
    if (!pig_screensaver) {
      FlutterDesktopViewAddListener(
        view,
        kSendScreenSaverStatusMethodName,
        std::bind(&VideoPlayerPlugin::handleScreenSaver, this, std::placeholders::_1));
    }
  }

  // listen appLifecycle
  FlutterDesktopViewAddListener(
    view,
    kSendAppLifecycleStateMethodName,
    std::bind(&VideoPlayerPlugin::handleAppLifecycle, this, std::placeholders::_1));

  // aux method channel
  aux_channel_ = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
                   registrar->messenger(),
                   "videoplayer_webos",
                   &flutter::StandardMethodCodec::GetInstance());

  aux_channel_->SetMethodCallHandler(
          [this](const auto &call, auto result) {
    handleAuxChannel(call, std::move(result));
  });

  // aux event channel
  aux_event_channel_ = std::make_unique<flutter::EventChannel<flutter::EncodableValue>>(
                         registrar->messenger(),
                         "webos/video_player/events",
                          &flutter::StandardMethodCodec::GetInstance());

  auto handler = std::make_unique<
      flutter::StreamHandlerFunctions<flutter::EncodableValue>>(
      [&](const flutter::EncodableValue *arguments,
          std::unique_ptr<flutter::EventSink<>> &&events)
          -> std::unique_ptr<flutter::StreamHandlerError<>> {
        LogDebug(TAG) << "event channel connected";
        aux_event_sink_ = std::move(events);
        return nullptr;
      },
      [&](const flutter::EncodableValue *arguments)
          -> std::unique_ptr<flutter::StreamHandlerError<>> {
        aux_event_sink_ = nullptr;
        return nullptr;
      });
  aux_event_channel_->SetStreamHandler(std::move(handler));

  WebOsVideoPlayerApi::SetUp(registrar->messenger(), this);
}

VideoPlayer* VideoPlayerPlugin::getVideoPlayer(int64_t textureId) {
  auto it = players_.find(textureId);
  if (it != players_.end()) {
    return it->second.get();
  }
  return nullptr;
}

VideoPlayer* VideoPlayerPlugin::getTopVideoPlayer() {
  size_t size = create_history_.size();
  if (size == 0) {
    return nullptr;
  }
  return getVideoPlayer(create_history_[size-1]);
}

bool VideoPlayerPlugin::IsTopAndResumed(int64_t texture_id) {
  if (lifecycle_state_ != "AppLifecycleState.resumed") {
    return false;
  }

  VideoPlayer* top = getTopVideoPlayer();
  VideoPlayer* player = getVideoPlayer(texture_id);
  if (!top || !player) {
    return false;
  }
  return top == player;
}

void VideoPlayerPlugin::handleAuxChannel(
    const flutter::MethodCall<
        flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>>
        result) {
  const auto& method = method_call.method_name();
  const auto& arguments = *method_call.arguments();
  if (method.compare("unload") == 0) {
    int64_t texture_id = LookupEncodableMapLong(arguments, "textureId");
    VideoPlayer* player = getVideoPlayer(texture_id);
    if (player) {
      LogInfo(TAG) << "Unload(" << texture_id << ")";
      player->Unload();
    }
    result->Success();
  } else if (method.compare("reload") == 0) {
    int64_t texture_id = LookupEncodableMapLong(arguments, "textureId");
    std::string window_id = LookupEncodableMap<std::string>(arguments, "windowId");
    VideoPlayer* player = getVideoPlayer(texture_id);
    if (player) {
      LogInfo(TAG) << "Reload("
                   << texture_id << ","
                   << window_id << ")";
      player->Reload(window_id);
    }
    result->Success();
  } else {
    LogWarn(TAG) << "unexpected method is called: " << method;
    result->NotImplemented();
  }
}

void VideoPlayerPlugin::handleScreenSaver(const std::string& response) {
  pbnjson::JValue doc = pbnjson::JDomParser::fromString(response);
  bool screen_saver = doc["screensaver"].asBool();
  if (screen_saver == screen_saver_) {
    return;
  }

  screen_saver_ = screen_saver;
  LogInfo(TAG) << "handleScreenSaver(" << screen_saver << ")";
  if (screen_saver) {
    paused_by_screen_savers_.clear();
  }

  for (int64_t& textureId : create_history_) {
    VideoPlayer* player = getVideoPlayer(textureId);
    if (player == nullptr) {
      continue;
    }
    if (screen_saver) {
      if (player->IsPlaying()) {
        player->Pause();
        player->OnPlayingStateChanged(false);
        paused_by_screen_savers_[textureId] = true;
      }
    } else {
      if (paused_by_screen_savers_.find(textureId) !=
          paused_by_screen_savers_.end()) {
        player->Play();
        player->OnPlayingStateChanged(true);
        paused_by_screen_savers_.erase(textureId);
      }
    }
  }
}

void VideoPlayerPlugin::handleAppLifecycle(const std::string& lifecycle) {
  lifecycle_state_ = lifecycle;

  if (aux_event_sink_) {
    LogDebug(TAG) << "send " << lifecycle;
    flutter::EncodableMap result = {
        {flutter::EncodableValue("event"),
         flutter::EncodableValue("appLifecycleState")},
        {flutter::EncodableValue("state"),
         flutter::EncodableValue(lifecycle)},
      };
    aux_event_sink_->Success(flutter::EncodableValue(result));
  }
  if (lifecycle == "AppLifecycleState.resumed") {
    VideoPlayer* player = getTopVideoPlayer();
    if (player  && player->IsRemovedAtPlaying()) {
      player->Play();
    }
  }

  bool visibility = visibility_;
  if (lifecycle == "AppLifecycleState.inactive" ||
      lifecycle == "AppLifecycleState.resumed") {
    visibility = true;
  } else if (lifecycle == "AppLifecycleState.paused") {
    visibility = false;
  }
  if (visibility_ == visibility) {
    return;
  }

  visibility_ = visibility;
  LogInfo(TAG) << "visibility: " << visibility;
  if (!visibility) {
    forced_pauses_.clear();
  }

  for (int64_t& textureId : create_history_) {
    VideoPlayer* player = getVideoPlayer(textureId);
    if (player == nullptr) {
      continue;
    }
    player->SetVisibility(visibility);

    if (visibility) {
      if (forced_pauses_.find(textureId) != forced_pauses_.end()) {
        player->Play();
        player->OnPlayingStateChanged(true);
        forced_pauses_.erase(textureId);
      }
    } else if (!background_run_) {
      if (player->IsPlaying()) {
        player->Pause();
        player->OnPlayingStateChanged(false);
        forced_pauses_[textureId] = true;
      }
    }
  }
}

void VideoPlayerPlugin::OnVideoPlayerError(int64_t texture_id) {
  dispose(texture_id);
}

VideoPlayerPlugin::~VideoPlayerPlugin() {
  disposeAllPlayers();
}

void VideoPlayerPlugin::disposeAllPlayers() {
  std::vector<int64_t> ids = create_history_;
  for (int64_t& id : ids) {
    dispose(id);
  }
}

std::optional<FlutterError> VideoPlayerPlugin::Initialize() {
  disposeAllPlayers();
  return std::nullopt;
}

ErrorOr<TextureMessage> VideoPlayerPlugin::Create(
    const CreateMessage &msg) {
  std::string uri;
  std::string webos_payload;
  if (msg.asset() && !msg.asset()->empty()) {
    std::string content = *msg.asset();
    std::string assets_path = ::getenv("FLUTTER_ASSETS_PATH");

    uri = "file://" + assets_path + "/" + headTrimmer(content);
  } else if (msg.uri() && !msg.uri()->empty()) {
    uri = *msg.uri();
    std::string content = headTrimmer(uri);
    if (content.size() != uri.size()) {
      uri = "file:///" + content;
    }
    auto& http = msg.http_headers();
    webos_payload = LookupEncodableMap<std::string>(flutter::EncodableValue(http), "payload");
    LogDebug(TAG) << "payload " << webos_payload;
  } else {
    return flutterErrorInternal("Invalid argument", "Either asset or uri must be set.");
  }

  std::string webos_format;
  if (msg.format_hint() && !msg.format_hint()->empty()) {
    std::string format_hint = *msg.format_hint();
    if (format_hint.find("hls") != std::string::npos) {
      webos_format = "HLS";
    } else if (format_hint.find("dash") != std::string::npos) {
      webos_format = "MPEG-DASH";
    } else if (format_hint.find("ss") != std::string::npos) {
      webos_format = "MSIIS";
    }
    LogDebug(TAG) << "format_hint " << format_hint;
  }

  std::string window_id;
  if (msg.window_id() && !msg.window_id()->empty()) {
    window_id = *msg.window_id();
  }

  int64_t texture_id = 0;
  auto player = std::make_unique<VideoPlayer>(this,
                                              visibility_,
                                              window_id,
                                              uri,
                                              webos_payload,
                                              webos_format);
  texture_id = player->GetTextureId();
  players_[texture_id] = std::move(player);
  historyAdd(texture_id);

  LogInfo(TAG) << "Create(" << window_id << "," << texture_id << "," << uri << ")";
  LogInfo(TAG) << players_.size() << " players are running";
  TextureMessage result(texture_id);
  return result;
}

void VideoPlayerPlugin::dispose(int64_t texture_id) {
  if (players_.find(texture_id) != players_.end()) {
    VideoPlayer* pplayer = players_[texture_id].get();
    disposed_players_[texture_id] = std::move(players_[texture_id]);
    players_.erase(texture_id);
    historyErase(texture_id);

    pplayer->Dispose([this](int64_t texture_id) -> void {
      disposed_texture_ids_.push_back(texture_id);

      // Delay actual destruction so any in-flight Luna messages from the
      // platform media subsystem can drain before the underlying media
      // client is torn down — otherwise the message thread dereferences a
      // freed vtable on the just-destroyed client. 500ms proved insufficient
      // under tab-switch load; 2000ms gives a wider margin during
      // verification.
      WebOSPlayer::attachToGMainLoop([](void* data) -> int {
        VideoPlayerPlugin* self = (VideoPlayerPlugin*)data;
        for (int64_t& texture_id : self->disposed_texture_ids_) {
          self->disposed_players_.erase(texture_id);
        }
        self->disposed_texture_ids_.clear();
        return G_SOURCE_REMOVE;
      }, this, 2000);
    });
  }

  paused_by_screen_savers_.erase(texture_id);
  forced_pauses_.erase(texture_id);
}

std::optional<FlutterError> VideoPlayerPlugin::Dispose(
    const TextureMessage &msg) {
  int64_t texture_id = msg.texture_id();
  LogInfo(TAG) << "Dispose(" << texture_id << ")";

  dispose(texture_id);
  LogInfo(TAG) << players_.size() << " players are running";
  return std::nullopt;
}

std::optional<FlutterError> VideoPlayerPlugin::SetLooping(
    const LoopingMessage &msg) {
  LogDebug(TAG) << "SetLooping(" << msg.texture_id() << "," << msg.is_looping() << ")";

  int64_t texture_id = msg.texture_id();
  VideoPlayer* player = getVideoPlayer(texture_id);
  if (player) {
    player->SetLooping(msg.is_looping());
    return std::nullopt;
  }
  return flutterErrorInternal("Invalid argument", "Player not found.");
}

std::optional<FlutterError> VideoPlayerPlugin::SetVolume(
    const VolumeMessage &msg) {
  LogDebug(TAG) << "SetVolume(" << msg.texture_id() << "," << msg.volume() << ")";
  return flutterErrorInternal(
      "unsupported",
      "Per-stream volume control is not supported on this platform.");
}

std::optional<FlutterError> VideoPlayerPlugin::SetPlaybackSpeed(
    const PlaybackSpeedMessage &msg) {
  LogDebug(TAG) << "SetPlayerbackSpeed(" << msg.texture_id() << "," << msg.speed() << ")";

  int64_t texture_id = msg.texture_id();
  VideoPlayer* player = getVideoPlayer(texture_id);
  if (player) {
    player->SetPlaybackSpeed(msg.speed());
    return std::nullopt;
  }
  return flutterErrorInternal("Invalid argument", "Player not found.");
}

std::optional<FlutterError> VideoPlayerPlugin::Play(
    const TextureMessage &msg) {
  LogDebug(TAG) << "Play(" << msg.texture_id() << ")";

  int64_t texture_id = msg.texture_id();
  VideoPlayer* player = getVideoPlayer(texture_id);
  if (player) {
    player->Play();
    return std::nullopt;
  }
  return flutterErrorInternal("Invalid argument", "Player not found.");
}

std::optional<FlutterError> VideoPlayerPlugin::Pause(
    const TextureMessage &msg) {
  LogDebug(TAG) << "Pause(" << msg.texture_id() << ")";

  int64_t texture_id = msg.texture_id();
  VideoPlayer* player = getVideoPlayer(texture_id);
  if (player) {
    if (!visibility_ && player->IsPlaying()) {
      forced_pauses_[texture_id] = true;
      LogDebug(TAG) << "forced_pause(" << texture_id << ") by video_player_plugin";
    }
    player->Pause();
    return std::nullopt;
  }
  return flutterErrorInternal("Invalid argument", "Player not found.");
}

ErrorOr<PositionMessage> VideoPlayerPlugin::Position(
    const TextureMessage &msg) {
  int64_t texture_id = msg.texture_id();
  VideoPlayer* player = getVideoPlayer(texture_id);
  if (player) {
    int64_t position = player->GetPosition();
    PositionMessage result(texture_id, position);
    return result;
  }
  return flutterErrorInternal("Invalid argument", "Player not found.");
}

void VideoPlayerPlugin::SeekTo(
    const PositionMessage &msg,
    std::function<void(std::optional<FlutterError> reply)> result) {
  LogDebug(TAG) << "SeekTo(" << msg.texture_id() << "," << msg.position() << ")";

  int64_t texture_id = msg.texture_id();
  VideoPlayer* player = getVideoPlayer(texture_id);
  if (player) {
    player->Seek(msg.position());
    result(std::nullopt);
    return;
  }
  result(flutterErrorInternal("Invalid argument", "Player not found."));
}

std::optional<FlutterError> VideoPlayerPlugin::SetMixWithOthers(
    const MixWithOthersMessage &msg) {
  LogInfo(TAG) << "SetMixWithOthers(" << msg.mix_with_others() << ")";
  return flutterErrorInternal(
      "unsupported",
      "VideoPlayerOptions.mixWithOthers is not supported on this platform.");
}

FlutterError VideoPlayerPlugin::flutterErrorInternal(const std::string& code, const std::string& message) {
  LogError(TAG) << code << " " << message;
  return FlutterError(code,message);
}

// Path utils...
std::string VideoPlayerPlugin::headTrimmer(const std::string& path) {
  std::string str = path;

  if (0 == str.find("/")) {
    str = str.substr(1,str.size());
  } else if (0 == path.find("./")) {
    str = str.substr(2,str.size());
  }
  return str;
}

void VideoPlayerPlugin::historyAdd(int64_t texture_id) {
  if (create_history_.size() >= MAX_PIPELINES) {
    int64_t texId = create_history_.front();
    VideoPlayer* player = getVideoPlayer(texId);
    if (player) {
      player->OnError(VideoPlayer::ERROR_PLUGIN, "num of pipelines");
    }
  }

  create_history_.push_back(texture_id);
}

void VideoPlayerPlugin::historyErase(int64_t texture_id) {
  for (auto it = create_history_.begin(); it != create_history_.end(); ++it) {
    if (*it == texture_id) {
      create_history_.erase(it);
      break;
    }
  }
}

void VideoPlayerPlugin::historyClear() {
  create_history_.clear();
}

void VideoPlayerWebOsPluginRegisterWithRegistrar(FlutterDesktopPluginRegistrarRef registrar) {
  VideoPlayerPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
         ->GetRegistrar<flutter::PluginRegistrar>(registrar),
      FlutterDesktopPluginRegistrarGetView(registrar));
}
