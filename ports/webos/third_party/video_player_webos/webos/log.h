// Copyright (c) 2026 AniCh webOS contributors.
// SPDX-License-Identifier: BSD-3-Clause

#ifndef ANICH_WEBOS_SCOPED_LOG_H_
#define ANICH_WEBOS_SCOPED_LOG_H_

#include <ostream>
#include <sstream>
#include <string>

namespace anich_webos {

enum class LogSeverity { verbose, debug, info, warning, error };

// Writes one complete diagnostic line. Playback never depends on log output.
void WriteLog(LogSeverity severity, const std::string& tag,
              const std::string& message) noexcept;

template <LogSeverity severity>
class ScopedLog final {
 public:
  explicit ScopedLog(const std::string& tag) : tag_(tag) {}

  ScopedLog(const ScopedLog&) = delete;
  ScopedLog& operator=(const ScopedLog&) = delete;
  ScopedLog(ScopedLog&&) = delete;
  ScopedLog& operator=(ScopedLog&&) = delete;

  ~ScopedLog() noexcept {
    try {
      WriteLog(severity, tag_, message_.str());
    } catch (...) {
      // Formatting or allocation failure must not interrupt playback cleanup.
    }
  }

  template <typename Value>
  ScopedLog& operator<<(const Value& value) noexcept {
    try {
      message_ << value;
    } catch (...) {
      // A failed insertion leaves the remaining diagnostic best-effort.
    }
    return *this;
  }

  // Explicit overloads also accept overloaded manipulators such as std::endl.
  ScopedLog& operator<<(std::ostream& (*manipulator)(std::ostream&)) noexcept {
    try {
      manipulator(message_);
    } catch (...) {
    }
    return *this;
  }

  ScopedLog& operator<<(std::ios_base& (*manipulator)(std::ios_base&)) noexcept {
    try {
      manipulator(message_);
    } catch (...) {
    }
    return *this;
  }

 private:
  const std::string tag_;
  std::ostringstream message_;
};

}  // namespace anich_webos

// Keep the stream-expression names used by the upstream player sources.
using LogVerbose = anich_webos::ScopedLog<anich_webos::LogSeverity::verbose>;
using LogDebug = anich_webos::ScopedLog<anich_webos::LogSeverity::debug>;
using LogInfo = anich_webos::ScopedLog<anich_webos::LogSeverity::info>;
using LogWarn = anich_webos::ScopedLog<anich_webos::LogSeverity::warning>;
using LogError = anich_webos::ScopedLog<anich_webos::LogSeverity::error>;

#endif  // ANICH_WEBOS_SCOPED_LOG_H_
