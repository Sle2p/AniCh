// Copyright (c) 2026 LG Electronics, Inc. All rights reserved.
// Copyright 2021 Sony Corporation. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include <flutter_window.h>

#include <cstdio>
#include <cstdlib>
#include <syslog.h>

#include "flutter/generated_plugin_registrant.h"
#include "render_scale.h"

class App : public FlutterWindow {
 public:
  bool OnCreate() override {
    if (!FlutterWindow::OnCreate()) return false;
    RegisterPlugins(GetRegistrar());
    return true;
  }

 protected:
  void OnBuildViewProperties(
      flutter::FlutterViewController::ViewProperties& properties) override {
    const auto preference = anich::ReadRenderScalePreference(
        std::getenv("FLUTTER_APPDATA_HOME"), std::getenv("FLUTTER_APP_ID"));
    // The LG Wayland embedder multiplies these fixed logical bounds by the
    // scale to allocate its physical render target. Both modes preserve the
    // 1920x1080 layout; a 4K buffer does not prove 1:1 panel presentation.
    properties.width = 1920;
    properties.height = 1080;
    properties.force_scale_factor = true;
    properties.scale_factor = static_cast<double>(preference.scale);
    // Report only the selected mode and fixed bounds, never local paths.
    std::fprintf(stderr,
                 "AniCh render scale=%d source=%s logical=1920x1080 "
                 "requested_buffer=%dx%d\n",
                 preference.scale, preference.source, 1920 * preference.scale,
                 1080 * preference.scale);
    std::fflush(stderr);
    syslog(LOG_INFO,
           "AniCh render scale=%d source=%s logical=1920x1080 "
           "requested_buffer=%dx%d",
           preference.scale, preference.source, 1920 * preference.scale,
           1080 * preference.scale);
  }
};

int main(int argc, char** argv) {
  App app;
  return app.Run(argc, argv);
}
