#ifndef ANICH_RENDER_SCALE_H_
#define ANICH_RENDER_SCALE_H_

#include <fstream>
#include <istream>
#include <string>
#include <string_view>

namespace anich {

constexpr int kDefaultRenderScale = 2;

struct RenderScalePreference {
  int scale;
  const char* source;
};

// This file is deliberately a single value, not a general numeric format.
// In particular, do not accept a prefix of "1.5", "1 2", or corrupted data.
inline int ParseRenderScale(std::string_view text) {
  if (text == "1" || text == "1\n" || text == "1\r\n") return 1;
  if (text == "2" || text == "2\n" || text == "2\r\n") return 2;
  return 0;
}

inline RenderScalePreference ReadRenderScaleStream(std::istream& input) {
  // Valid values are at most three bytes. Read one additional byte to reject
  // trailing data without loading an arbitrarily large preference file.
  char contents[4] = {};
  input.read(contents, sizeof(contents));
  const int parsed = input.bad()
                         ? 0
                         : ParseRenderScale(std::string_view(
                               contents, static_cast<size_t>(input.gcount())));
  return parsed == 0
             ? RenderScalePreference{kDefaultRenderScale, "default_invalid_file"}
             : RenderScalePreference{parsed, "saved"};
}

inline RenderScalePreference ReadRenderScalePreference(const char* app_data_home,
                                                       const char* app_id) {
  if (app_data_home == nullptr || app_data_home[0] == '\0' ||
      app_id == nullptr || app_id[0] == '\0') {
    return {kDefaultRenderScale, "default_missing_environment"};
  }

  // Matches path_provider_webos.getApplicationSupportPath(): data home / app id.
  std::string path(app_data_home);
  if (path.back() != '/') path += '/';
  path += app_id;
  path += "/anich-render-scale.txt";
  std::ifstream input(path, std::ios::binary);
  if (!input.is_open()) return {kDefaultRenderScale, "default_missing_file"};
  return ReadRenderScaleStream(input);
}

}  // namespace anich

#endif  // ANICH_RENDER_SCALE_H_
