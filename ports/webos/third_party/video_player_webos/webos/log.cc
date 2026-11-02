// Copyright (c) 2026 AniCh webOS contributors.
// SPDX-License-Identifier: BSD-3-Clause

#include "log.h"

#include <cstdio>

namespace anich_webos {

void WriteLog(LogSeverity severity, const std::string& tag,
              const std::string& message) noexcept {
  const char* label = "INFO";
  switch (severity) {
    case LogSeverity::verbose:
      label = "VERBOSE";
      break;
    case LogSeverity::debug:
      label = "DEBUG";
      break;
    case LogSeverity::info:
      break;
    case LogSeverity::warning:
      label = "WARN";
      break;
    case LogSeverity::error:
      label = "ERROR";
      break;
  }

  std::fprintf(stderr, "video_player_webos %s [%s] %s\n", label,
               tag.c_str(), message.c_str());
  std::fflush(stderr);
}

}  // namespace anich_webos
