// SPDX-FileCopyrightText: Copyright 2023 LG Electronics Inc.
// SPDX-License-Identifier: BSD-3-Clause

#include <pbnjson.hpp>
#include <NDL/NDL_media.h>

#include "webos_player.h"
#include "plugin_player_delegate.h"
#include "log.h"

#ifdef TAG
#undef TAG
#endif
#define TAG "WebOSPlayer::"

/******************************************************/
/*                 Simple Json writer                 */
/******************************************************/
class JsonWriter {
public:
  JsonWriter() {}
  ~JsonWriter() {}

  void StartObject() {
    if (!start_) {
      string_buf_ += ",";
    }
    string_buf_ += "{";
    start_ = true;
  }

  void Key(const std::string& key) {
    if (!start_) {
      string_buf_ += ",";
    }
    string_buf_ += "\"" + key + "\":";
    start_ = true;
  }

  void String(const std::string& value) {
    if (!start_) {
      string_buf_ += ",";
    }
    string_buf_ += "\"" + value + "\"";
    start_ = false;
  }

  void Bool(bool set) {
    if (!start_) {
      string_buf_ += ",";
    }
    string_buf_ += set ? "true" : "false";
    start_ = false;
  }

  void Int64(int64_t start_position) {
    if (!start_) {
      string_buf_ += ",";
    }
    string_buf_ += std::to_string(start_position);
    start_ = false;
  }

  void EndObject() {
    string_buf_ += "}";
  }

  std::string GetString() {
    return string_buf_;
  }

private:
  std::string string_buf_;
  bool start_ = true;
};

/******************************************************/
/*                 Static state                       */
/******************************************************/
GMainContext* WebOSPlayer::s_main_context_ = nullptr;
WebOSPlayer* WebOSPlayer::s_slots_[WebOSPlayer::kMaxSlots] = { nullptr };
std::mutex WebOSPlayer::s_slots_mutex_;
bool WebOSPlayer::s_lib_initialized_ = false;
bool WebOSPlayer::s_slot_initialized_[WebOSPlayer::kMaxSlots] = { false };
std::string WebOSPlayer::s_slot_window_id_[WebOSPlayer::kMaxSlots];

int WebOSPlayer::allocateSlot(WebOSPlayer* self) {
  std::lock_guard<std::mutex> lock(s_slots_mutex_);
  for (int i = 0; i < kMaxSlots; ++i) {
    if (s_slots_[i] == nullptr) {
      s_slots_[i] = self;
      return i;
    }
  }
  return -1;
}

void WebOSPlayer::releaseSlot(int slot) {
  std::lock_guard<std::mutex> lock(s_slots_mutex_);
  if (slot >= 0 && slot < kMaxSlots) {
    s_slots_[slot] = nullptr;
  }
}

void WebOSPlayer::OnSlotEvent_0(char* event) { dispatchEvent(0, event); }
void WebOSPlayer::OnSlotEvent_1(char* event) { dispatchEvent(1, event); }
void WebOSPlayer::OnSlotEvent_2(char* event) { dispatchEvent(2, event); }
void WebOSPlayer::OnSlotEvent_3(char* event) { dispatchEvent(3, event); }
void WebOSPlayer::OnSlotEvent_4(char* event) { dispatchEvent(4, event); }

// Holds the slot-table mutex for the duration of the dispatch so the
// instance cannot be torn down underneath us.
void WebOSPlayer::dispatchEvent(int slot, char* event) {
  std::lock_guard<std::mutex> lock(s_slots_mutex_);
  if (slot < 0 || slot >= kMaxSlots) {
    return;
  }
  WebOSPlayer* self = s_slots_[slot];
  if (self == nullptr) {
    return;
  }
  if (event == nullptr) {
    return;
  }
  self->handleEvent(std::string(event));
}

/******************************************************/
/*                 WebOS Player                       */
/******************************************************/
WebOSPlayer::WebOSPlayer(PluginPlayerDelegate* delegate, const std::string& window_id)
    : delegate_(delegate)
    , slot_(-1)
    , visibility_(false)
    , speed_(1.0)
    , volume_(100)
    , audio_out_(true)
    , state_(UNLOADED)
    , current_(0)
    , duration_(0)
    , seekable_(false)
    , has_video_(false)
    , has_audio_(false)
    , videoW_(0)
    , videoH_(0)
    , buffering_(false)
    , buffering_start_(0)
    , buffering_end_(0) {
  if (s_main_context_ == nullptr) {
    s_main_context_ = g_main_context_ref_thread_default();
  }

  slot_ = allocateSlot(this);
  if (slot_ < 0) {
    LogError(TAG) << "no free slot (limit=" << kMaxSlots << ")";
    return;
  }

  if (NDL_MediaSetPlayer(slot_) != 0) {
    LogError(TAG) << "NDL_MediaSetPlayer(" << slot_ << ") failed";
    releaseSlot(slot_);
    slot_ = -1;
    return;
  }

  static void (*trampolines[kMaxSlots])(char*) = {
    OnSlotEvent_0, OnSlotEvent_1, OnSlotEvent_2, OnSlotEvent_3, OnSlotEvent_4
  };

  if (!s_slot_initialized_[slot_]) {
    // Bind the caller's (Flutter) external windowId at init so the platform
    // renders the video plane onto the app's own surface. The windowId is
    // bound once per slot at init; an empty windowId uses the default behavior.
    // This also avoids libNDL's SDL exported-window fallback, which returns a
    // null windowId in a non-SDL (Flutter) app and crashes TVDisplay::Initialize.
    if (NDL_MediaInitWithWindowId(
            0, window_id.empty() ? nullptr : window_id.c_str()) != 0) {
      LogError(TAG) << "NDL_MediaInitWithWindowId(" << slot_ << ") failed";
      releaseSlot(slot_);
      slot_ = -1;
      return;
    }
    if (NDL_MediaSubscribeEvents(trampolines[slot_]) != 0) {
      LogError(TAG) << "NDL_MediaSubscribeEvents(" << slot_ << ") failed";
    }
    s_slot_initialized_[slot_] = true;
    s_slot_window_id_[slot_] = window_id;
    LogInfo(TAG) << "slot[" << slot_ << "] init complete (windowId=" << window_id << ")";
  } else {
    // The previous instance on this slot ran NDL_MediaUnsubscribeEvents
    // from its dtor to keep the platform callback thread from dispatching
    // into freshly unmapped code; re-subscribe the trampoline here. Init
    // itself is kept alive for the process lifetime on purpose.
    if (NDL_MediaSubscribeEvents(trampolines[slot_]) != 0) {
      LogWarn(TAG) << "NDL_MediaSubscribeEvents(" << slot_
                   << ") re-subscribe failed (likely already subscribed)";
    }
    // The windowId is bound once per slot at init and is not rebound on reuse,
    // so a reused slot keeps its original windowId. This is benign: video
    // position/size is driven by the exported window and the sink's payload
    // windowId, not by this binding, so playback/display stays correct on reuse.
    if (s_slot_window_id_[slot_] != window_id) {
      LogInfo(TAG) << "slot[" << slot_ << "] windowId differs on reuse: bound="
                   << s_slot_window_id_[slot_] << " requested=" << window_id
                   << " (platform keeps original; display handled by exported window)";
    }
    // Safety net: drop any leftover pipeline state from the previous user
    // of this slot. Owner-driven dispose normally calls unload() first,
    // but this guards the edge case where it did not.
    NDL_MediaUnload();
  }
}

WebOSPlayer::~WebOSPlayer() {
  if (slot_ >= 0) {
    if (NDL_MediaSetPlayer(slot_) == 0) {
      // Drop the platform event subscription so the uMediaClient callback
      // thread cannot dispatch into a freshly-destroyed instance. The race
      // window that produced the SEGV in libumedia_api.so closes here.
      NDL_MediaUnsubscribeEvents();
      // NDL_MediaUnload is intentionally skipped: VideoPlayer::Dispose
      // already drove the pipeline to UNLOADED via player_.unload() before
      // releasing this instance, and issuing Unload again would emit an
      // unloadCompleted event that races teardown.
      // NDL_MediaQuit is intentionally skipped: it deletes the underlying
      // uMediaClient (player[pId]) without joining the callback thread,
      // and additionally unregisters a global HRegisterAppState hook with
      // cross-plugin side effects. The corresponding ctor reuses the
      // per-slot init for the rest of the process lifetime.
    }
    releaseSlot(slot_);
  }
  std::lock_guard<std::recursive_mutex> autoLock(mutex_);
  run_ = false;
  if (idle_source_) {
    g_source_destroy(idle_source_);
    idle_source_ = nullptr;
  }
  if (timer_source_) {
    g_source_destroy(timer_source_);
    timer_source_ = nullptr;
  }
  callbacks_.clear();
}

bool WebOSPlayer::load(const std::string& appId,
        const std::string& winId,
        const std::string& uri,
        const std::string& webos_payload,
        const std::string& webos_format,
        int64_t start_position) {
  if (slot_ < 0) {
    LogError(TAG) << "load(): no slot";
    return false;
  }

  loadParams_.appId = appId;
  loadParams_.winId = winId;
  loadParams_.uri = uri;
  loadParams_.payload = webos_payload;
  loadParams_.format = webos_format;
  loadParams_.start_position = start_position;

  if (state_ != UNLOADED) {
    LogWarn(TAG) <<"currentState is" << stateToString(state_) << ", I will unload pipeline";
    unload(true);
  }
  if (start_position != 0) {
    LogInfo(TAG) <<"load(sartPosition:" << start_position << ")";
  }
  current_ = start_position;

  std::string media_transport_type;
  if (webos_format.find("MPEG-DASH") != std::string::npos) {
    media_transport_type = "MPEG-DASH";
  } else if (webos_format.find("HLS") != std::string::npos) {
    media_transport_type = "HLS";
  } else if (webos_format.find("MSIIS") != std::string::npos) {
    media_transport_type = "MSIIS";
  } else if (uri.find("udp://") == 0) {
    media_transport_type = "UDP";
  } else if (uri.find("rtp://") == 0) {
    media_transport_type = "RTP";
  } else if (uri.find("rtsp://") == 0) {
    media_transport_type = "RTSP";
  } else if (uri.find("m3u8") != std::string::npos) {
    media_transport_type = "HLS";
  }

  std::string payload;
  pbnjson::JValue doc = pbnjson::JDomParser::fromString(webos_payload);
  if (!doc.isObject()) {
    doc = pbnjson::JDomParser::fromString("{}");
  }

  pbnjson::JGenerator serializer(nullptr);
  std::string serialized;
  if (serializer.toString(doc, pbnjson::JSchema::AllSchema(), serialized)) {
    payload = serialized;
  } else {
    payload = "{}";
  }

  const std::string object_header = "{";
  const std::string option_header = "\"option\":{";
  auto object_start = payload.find(object_header);
  auto option_start = payload.find(option_header);
  bool empty_option = option_start == std::string::npos
                    ? true : false;
  if (empty_option) {
    payload.insert(object_start + object_header.size(), option_header + "}");
    option_start = payload.find(option_header);
  }

  JsonWriter tw;
  if (!media_transport_type.empty() &&
      !doc["mediaTransportType"].isString()) {
    tw.Key("mediaTransportType");
    tw.String(media_transport_type);
  }

  JsonWriter ow;
  if (!doc["option"]["appId"].isString()) {
    ow.Key("appId");
    ow.String(appId);
  }
  if (!winId.empty()) {
    ow.Key("windowId");
    ow.String(winId);
  }

  if (start_position > 0 &&
      !doc["option"]["transmission"].isObject()) {
    ow.Key("transmission");
    ow.StartObject();
      ow.Key("playTime");
      ow.StartObject();
        ow.Key("start");
        ow.Int64(start_position);
      ow.EndObject();
    ow.EndObject();
  }

  std::string option = ow.GetString();
  if (!option.empty()) {
    if (!empty_option) {
      option += ",";
    }
    payload.insert(option_start + option_header.size(), option);
  }

  std::string type = tw.GetString();
  if (!type.empty()) {
    type += ",";
    payload.insert(object_start + object_header.size(), type);
  }

  LogInfo(TAG) << "url: " << uri;
  LogInfo(TAG) << "payload: " << payload;

  if (NDL_MediaSetPlayer(slot_) != 0) {
    LogError(TAG) << "NDL_MediaSetPlayer(" << slot_ << ") failed";
    return false;
  }
  if (NDL_MediaLoadWithOption(uri.c_str(), payload.c_str()) != 0) {
    LogError(TAG) << "NDL_MediaLoadWithOption failed";
    return false;
  }

  state_ = IN_LOADING;
  delegate_->OnStateChanged(state_);
  return true;
}

bool WebOSPlayer::unload(bool reset) {
  bool retv = true;
  if (state_ != UNLOADED) {
    if (slot_ >= 0 && NDL_MediaSetPlayer(slot_) == 0) {
      if (NDL_MediaUnload() != 0) {
        LogWarn(TAG) << "NDL_MediaUnload(" << slot_ << ") at "
                     << stateToString(state_) << " failed";
        retv = false;
      }
    }

    if (reset) {
      volume_ = 100;
      current_ = 0;
      duration_ = 0;
      seekable_ = false;
      has_video_ = false;
      has_audio_ = false;
      videoW_ = 0;
      videoH_ = 0;
    }
    speed_ = 1.0;
    audio_out_ = true;
    buffering_ = false;
    buffering_start_ = 0;
    buffering_end_ = 0;

    state_ = UNLOADED;
    delegate_->OnStateChanged(state_);
  }
  return retv;
}

bool WebOSPlayer::play() {
  if (state_ == UNLOADED ||
      state_ == IN_LOADING ||
      state_ == REMOVED ||
      slot_ < 0) {
    return true;
  }

  if (NDL_MediaSetPlayer(slot_) != 0 || NDL_MediaPlay() != 0) {
    LogWarn(TAG) << "NDL_MediaPlay(" << slot_ << ") at "
                 << stateToString(state_) << " failed";
    return false;
  }
  return true;
}

bool WebOSPlayer::setPlayRate(double playRate, bool audioOut) {
  if (playRate == speed_ &&
      audioOut == audio_out_) {
    return true;
  }
  LogInfo(TAG) << "setPlayRate(" << playRate << ", audioOut:" << audioOut << ")";
  speed_ = playRate;
  audio_out_ = audioOut;

  if (state_ == UNLOADED ||
      state_ == IN_LOADING ||
      state_ == REMOVED ||
      slot_ < 0) {
    return true;
  }
  if (NDL_MediaSetPlayer(slot_) != 0 || NDL_MediaSetPlaybackRate(playRate) != 0) {
    LogWarn(TAG) << "NDL_MediaSetPlaybackRate(" << playRate << ") at "
                 << stateToString(state_) << " failed";
    return false;
  }
  return true;
}

bool WebOSPlayer::pause() {
  if (state_ == UNLOADED ||
      state_ == IN_LOADING ||
      state_ == REMOVED ||
      slot_ < 0) {
    return true;
  }

  if (NDL_MediaSetPlayer(slot_) != 0 || NDL_MediaPause() != 0) {
    LogWarn(TAG) << "NDL_MediaPause(" << slot_ << ") at "
                 << stateToString(state_) << " failed";
    return false;
  }
  return true;
}

bool WebOSPlayer::seek(int64_t position, bool update_position) {
  if (!seekable_ && position != 0) {
    LogInfo(TAG) << "can't seek, because it's not a seekable contents";
    return false;
  }
  if (state_ == UNLOADED ||
      state_ == IN_LOADING ||
      state_ == REMOVED ||
      slot_ < 0) {
    return false;
  }
  if (NDL_MediaSetPlayer(slot_) != 0 || NDL_MediaSeekTo(position) != 0) {
    LogWarn(TAG) << "NDL_MediaSeekTo(" << position << ") at "
                 << stateToString(state_) << " failed";
    return false;
  }
  if (update_position) {
    current_ = position;
  }
  return true;
}

// The platform media subsystem in this configuration does not provide a
// per-stream volume control. Calling code may still invoke this; we treat
// the call as a no-op success after recording the requested level so the
// state machine stays consistent. The plugin layer surfaces this to Dart
// as an "unsupported" error event.
bool WebOSPlayer::setVolume(int32_t volume) {
  volume_ = volume;
  return false;
}

bool WebOSPlayer::notifyVisibility(bool visibility) {
  visibility_ = visibility;

  if (state_ == UNLOADED ||
      state_ == IN_LOADING ||
      state_ == REMOVED ||
      slot_ < 0) {
    return true;
  }

  // The platform media subsystem does not expose a direct
  // foreground/background notification, so we approximate it by muting
  // the video output surface while the visibility is off.
  if (NDL_MediaSetPlayer(slot_) != 0 || NDL_MediaMuteDisplay(!visibility) != 0) {
    LogWarn(TAG) << "NDL_MediaMuteDisplay(" << (!visibility) << ") at "
                 << stateToString(state_) << " failed";
    return false;
  }
  return true;
}

/******************************************************/
/*           Event JSON dispatch (worker thread)      */
/******************************************************/
void WebOSPlayer::handleEvent(const std::string& event_json) {
  LogDebug(TAG) << "event[" << slot_ << "]: " << event_json;
  pbnjson::JValue obj = pbnjson::JDomParser::fromString(event_json);
  if (obj.isNull() || !obj.isObject()) {
    return;
  }

  if (!obj["loadCompleted"].isNull()) {
    pushCallback(BasicCb{ kTypeLoadCompleted });
  } else if (!obj["playing"].isNull()) {
    pushCallback(BasicCb{ kTypePlaying });
  } else if (!obj["paused"].isNull()) {
    pushCallback(BasicCb{ kTypePaused });
  } else if (!obj["seekDone"].isNull()) {
    pushCallback(BasicCb{ kTypeSeekDone });
  } else if (!obj["bufferingStart"].isNull()) {
    pushCallback(BasicCb{ kTypeBufferingStart });
  } else if (!obj["bufferingEnd"].isNull()) {
    pushCallback(BasicCb{ kTypeBufferingEnd });
  } else if (!obj["endOfStream"].isNull()) {
    pushCallback(BasicCb{ kTypeEndOfStream });
  } else if (!obj["currentTime"].isNull()) {
    pbnjson::JValue ct = obj["currentTime"];
    int64_t t = 0;
    if (ct["currentTime"].isNumber()) {
      ct["currentTime"].asNumber(t);
    } else {
      ct.asNumber(t);
    }
    if (current_ != t) {
      current_ = t;
    }
  } else if (!obj["sourceInfo"].isNull()) {
    pbnjson::JValue src = obj["sourceInfo"];
    pbnjson::JValue progs = src["programInfo"];
    if (!progs.isArray() || progs.arraySize() == 0) {
      return;
    }
    pbnjson::JValue p0 = progs[0];
    int64_t dur = 0, num_video = 0, num_audio = 0;
    if (p0["duration"].isNumber())       p0["duration"].asNumber(dur);
    if (p0["numVideoTracks"].isNumber()) p0["numVideoTracks"].asNumber(num_video);
    if (p0["numAudioTracks"].isNumber()) p0["numAudioTracks"].asNumber(num_audio);
    // The platform emits a placeholder sourceInfo whose programInfo[0] has
    // all-zero duration/track counts before the real event arrives with
    // populated data. Dispatching the placeholder would raise a premature
    // OnInitialized(duration:0). isNumber() alone doesn't catch this because
    // 0 is still a valid number — gate on actual content.
    if (dur == 0 && num_video == 0 && num_audio == 0) {
      return;
    }

    SourceInfoCb cb = { true, dur, num_video > 0, num_audio > 0, 0, 0 };
    if (src["seekable"].isBoolean()) {
      cb.seekable = src["seekable"].asBool();
    }
    cb.video_width = videoW_;
    cb.video_height = videoH_;
    pushCallback(cb);
  } else if (!obj["videoInfo"].isNull()) {
    pbnjson::JValue vi = obj["videoInfo"];
    int w = 0, h = 0;
    if (vi["width"].isNumber()) {
      vi["width"].asNumber(w);
    }
    if (vi["height"].isNumber()) {
      vi["height"].asNumber(h);
    }
    if (w > 0 && h > 0 && (w != videoW_ || h != videoH_)) {
      videoW_ = w;
      videoH_ = h;
      // Only refresh via SourceInfoCb if real source metadata has already
      // arrived. videoInfo can land before sourceInfo, in which case the
      // cached source state is all-zero and pushing it here would fire a
      // premature OnInitialized(duration:0). The next real sourceInfo
      // will pick up the new dims through cb.video_width = videoW_.
      if (duration_ > 0 || has_video_ || has_audio_) {
        SourceInfoCb cb = { seekable_, duration_, has_video_, has_audio_, w, h };
        pushCallback(cb);
      }
    }
  } else if (!obj["error"].isNull()) {
    pbnjson::JValue err = obj["error"];
    int64_t code = 0;
    std::string text;
    if (err["errorCode"].isNumber()) {
      err["errorCode"].asNumber(code);
    }
    if (err["errorText"].isString()) {
      text = err["errorText"].asString();
    }
    pushCallback(ErrorCb{ code, text });
  }
}

/******************************************************/
/*           Main-thread state transitions            */
/******************************************************/
void WebOSPlayer::execLoadCompleted() {
  state_ = LOADED;

  notifyVisibility(visibility_);
  if (speed_ != 1.0 ||
      audio_out_ != true) {
    if (slot_ >= 0 && NDL_MediaSetPlayer(slot_) == 0) {
      NDL_MediaSetPlaybackRate(speed_);
    }
  }
  delegate_->OnStateChanged(LOADED);
}

void WebOSPlayer::execPlaying() {
  state_ = PLAYING;
  delegate_->OnStateChanged(PLAYING);
}

void WebOSPlayer::execPaused() {
  state_ = PAUSED;
  delegate_->OnStateChanged(PAUSED);
}

void WebOSPlayer::execSeekDone() {
  delegate_->OnSeekCompleted();
}

void WebOSPlayer::execBufferingStart() {
  if (buffering_) {
    return;
  }
  buffering_ = true;
  delegate_->OnBufferingStart();
}

void WebOSPlayer::execBufferingEnd() {
  if (!buffering_) {
    return;
  }
  buffering_ = false;
  delegate_->OnBufferingEnd();
}

void WebOSPlayer::execEndOfStream() {
  state_ = EOS;
  current_ = duration_;
  delegate_->OnStateChanged(EOS);
  delegate_->OnPlayCompleted();
}

void WebOSPlayer::execBufferRange(int64_t begin, int64_t end) {
  if (begin == buffering_start_ &&
      end == buffering_end_) {
    return;
  }

  buffering_start_ = begin;
  buffering_end_ = end;
  delegate_->OnBuffered(buffering_start_, buffering_end_);
}

void WebOSPlayer::execError(int64_t code, const std::string& text) {
  LogInfo(TAG) << "execError(" << code << "," << text << ") at " << stateToString(state_);

  if (code == MediaPipelineStatus::SMP_SEEK_FAILURE) {
    // ignored
  } else if (code == MediaPipelineStatus::SMP_RM_RELATED_ERROR) {
    state_ = REMOVED;
    delegate_->OnStateChanged(REMOVED);
  } else if (code == MediaPipelineStatus::SMP_MEDIA_API_PLAYING_ERROR) {
    if (state_ == IN_LOADING) {
      if (slot_ >= 0 && NDL_MediaSetPlayer(slot_) == 0) {
        NDL_MediaUnload();
      }
      state_ = UNLOADED;

      LoadParams& params = loadParams_;
      load(params.appId,
           params.winId,
           params.uri,
           params.payload,
           params.format,
           params.start_position);
    } else if (slot_ >= 0 && NDL_MediaSetPlayer(slot_) == 0) {
      NDL_MediaSeekTo(0);
    }
  } else {
    delegate_->OnError(code, text);
  }
}

void WebOSPlayer::execSourceInfo(const SourceInfoCb& info) {
  seekable_ = info.seekable;
  duration_ = info.duration;
  has_video_ = info.has_video;
  has_audio_ = info.has_audio;
  if (info.video_width > 0)  videoW_ = info.video_width;
  if (info.video_height > 0) videoH_ = info.video_height;

  LogInfo(TAG) << "WH[" << videoW_ << "," << videoH_ << "],duration: "
    << duration_/1000 << ",seekable:" << seekable_
    << ",hasAudio:" << has_audio_ << ",hasVideo:" << has_video_;

  // Defensive double-guard: don't fire OnInitialized until we have real
  // metadata — duration > 0 or at least one track. This catches any path
  // (sourceInfo, videoInfo refresh) that might dispatch placeholder data.
  if (duration_ == 0 && !has_audio_ && !has_video_) {
    return;
  }
  // Defer until video dimensions are known when the stream has a video
  // track; videoInfo will trigger a refresh once it arrives.
  if (has_video_ && (videoW_ == 0 || videoH_ == 0)) {
    return;
  }
  delegate_->OnInitialized();
}

void WebOSPlayer::pushCallback(CallbackVariant cb) {
  std::lock_guard<std::recursive_mutex> autoLock(mutex_);
  if (run_) {
    callbacks_.push_back(cb);

    if (idle_source_ == nullptr) {
      idle_source_ = attachToGMainLoop([](void* data) -> int {
        WebOSPlayer* self = (WebOSPlayer*)data;
        self->popCallbacks();
        return G_SOURCE_REMOVE;
      }, this);
    }
  }
}

void WebOSPlayer::popCallbacks() {
  std::vector<CallbackVariant> callbacks;
  {
    std::lock_guard<std::recursive_mutex> autoLock(mutex_);
    idle_source_ = nullptr;
    std::swap(callbacks_, callbacks);
  }

  for (auto& cb : callbacks) {
    if (auto basic_cb = std::get_if<BasicCb>(&cb)) {
      switch (basic_cb->type) {
        case kTypeLoadCompleted:  execLoadCompleted(); break;
        case kTypePlaying:        execPlaying(); break;
        case kTypePaused:         execPaused(); break;
        case kTypeSeekDone:       execSeekDone(); break;
        case kTypeBufferingStart: execBufferingStart(); break;
        case kTypeBufferingEnd:   execBufferingEnd(); break;
        case kTypeEndOfStream:
          {
          const int64_t MAX_WAIT = 1000;
          if (timer_source_) {
            g_source_destroy(timer_source_);
          }
          timer_source_ = attachToGMainLoop([](void* data) -> int {
            WebOSPlayer* self = (WebOSPlayer*)data;
            self->timer_source_ = nullptr;
            self->execEndOfStream();
            return G_SOURCE_REMOVE;
          }, this, std::min(duration_ - current_, MAX_WAIT));
          }
          break;
        default: break;
      }
    } else if (auto bufferrange_cb = std::get_if<BufferRangeCb>(&cb)) {
      execBufferRange(bufferrange_cb->start, bufferrange_cb->end);
    } else if (auto error_cb = std::get_if<ErrorCb>(&cb)) {
      execError(error_cb->code, error_cb->text);
    } else if (auto info = std::get_if<SourceInfoCb>(&cb)) {
      execSourceInfo(*info);
    }
  }
}

GSource* WebOSPlayer::attachToGMainLoop(GMainLoopCallback cb, void* data, int64_t msec) {
  GSource* src = (msec > 0) ?  g_timeout_source_new(msec) : g_idle_source_new();
  g_source_set_callback(src,cb,data,NULL);
  g_source_attach(src,s_main_context_);
  g_source_unref(src);
  return src;
}

std::string WebOSPlayer::stateToString(int state) {
  std::string name = "UNKNOWN";

  if (state == UNLOADED) name = "UNLOADED";
  else if (state == IN_LOADING) name = "IN_LOADING";
  else if (state == LOADED) name = "LOADED";
  else if (state == PLAYING) name = "PLAYING";
  else if (state == PAUSED) name = "PAUSED";
  else if (state == EOS) name = "EOF";
  else if (state == REMOVED) name = "REMOVED";

  return name;
}
