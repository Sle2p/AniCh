// SPDX-FileCopyrightText: Copyright 2023 LG Electronics Inc.
// SPDX-License-Identifier: BSD-3-Clause

#ifndef VIDEO_PLAYER_PLUGIN_H_
#define VIDEO_PLAYER_PLUGIN_H_

#include <flutter/encodable_value.h>
#include <flutter/method_channel.h>
#include <flutter/event_stream_handler_functions.h>
#include <flutter/event_channel.h>
#include <flutter/plugin_registrar.h>
#include <flutter/standard_method_codec.h>
#include <flutter_webos.h>

#include <map>
#include <memory>
#include <string>

#include "messages.h"
#include "video_player.h"

class VideoPlayerPlugin : public flutter::Plugin,
                          public WebOsVideoPlayerApi {
public:
  static void RegisterWithRegistrar(flutter::PluginRegistrar* registrar,
                                    FlutterDesktopViewRef view);

  VideoPlayerPlugin(flutter::PluginRegistrar* registrar,
                         FlutterDesktopViewRef view);

  flutter::PluginRegistrar* PluginRegistrar() { return plugin_registrar_; }
  bool IsTopAndResumed(int64_t texture_id);
  void OnVideoPlayerError(int64_t texture_id);

  virtual ~VideoPlayerPlugin();

  virtual std::optional<FlutterError> Initialize() override;
  virtual ErrorOr<TextureMessage> Create(const CreateMessage &msg) override;
  virtual std::optional<FlutterError> Dispose(
      const TextureMessage &msg) override;
  virtual std::optional<FlutterError> SetLooping(
      const LoopingMessage &msg) override;
  virtual std::optional<FlutterError> SetVolume(
      const VolumeMessage &msg) override;
  virtual std::optional<FlutterError> SetPlaybackSpeed(
      const PlaybackSpeedMessage &msg) override;
  virtual std::optional<FlutterError> Play(const TextureMessage &msg) override;
  virtual ErrorOr<PositionMessage> Position(const TextureMessage &msg) override;
  virtual void SeekTo(
      const PositionMessage &msg,
      std::function<void(std::optional<FlutterError> reply)> result) override;
  virtual std::optional<FlutterError> Pause(const TextureMessage &msg) override;
  virtual std::optional<FlutterError> SetMixWithOthers(
      const MixWithOthersMessage &msg) override;

private:
  template <typename T>
  T LookupEncodableMap(const flutter::EncodableValue& map, const char* key) {
    auto values = std::get<flutter::EncodableMap>(map);
    auto value = values[flutter::EncodableValue(key)];
    if (!std::holds_alternative<T>(value)) {
      return T();
    }
    return std::get<T>(value);
  }

  int64_t LookupEncodableMapLong(const flutter::EncodableValue& map, const char* key) {
    auto values = std::get<flutter::EncodableMap>(map);
    auto value = values[flutter::EncodableValue(key)];
    return value.LongValue();
  }

  VideoPlayer* getVideoPlayer(int64_t textureId);
  VideoPlayer* getTopVideoPlayer();
  void disposeAllPlayers();
  void handleAuxChannel(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
  void handleScreenSaver(const std::string& response);
  void handleAppLifecycle(const std::string& lifecycle);
  FlutterError flutterErrorInternal(const std::string& code, const std::string& message);

  void dispose(int64_t texture_id);
  void onVideoPlayerError(int64_t texture_id);
  void historyAdd(int64_t texture_id);
  void historyErase(int64_t texture_id);
  void historyClear();

  std::string headTrimmer(const std::string& path);

  std::map<int64_t, std::unique_ptr<VideoPlayer>> players_;
  std::map<int64_t, std::unique_ptr<VideoPlayer>> disposed_players_;
  std::vector<int64_t> disposed_texture_ids_;
  std::vector<int64_t> create_history_;
  flutter::PluginRegistrar* plugin_registrar_;

  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> aux_channel_;
  std::unique_ptr<flutter::EventChannel<flutter::EncodableValue>> aux_event_channel_;
  std::unique_ptr<flutter::EventSink<flutter::EncodableValue>> aux_event_sink_;

  bool background_run_ = false;
  std::string lifecycle_state_;
  bool visibility_ = false;
  bool screen_saver_ = false;
  std::map<int64_t, bool> forced_pauses_;
  std::map<int64_t, bool> paused_by_screen_savers_;
};
#endif  // VIDEO_PLAYER_PLUGIN_H_
