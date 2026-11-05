#include "../../webos/runner/render_scale.h"

#include <cassert>
#include <filesystem>
#include <iostream>
#include <sstream>
#include <vector>

int main(int argc, char** argv) {
  assert(argc == 2);
  for (const auto& value : {"1", "1\n", "1\r\n"}) {
    assert(anich::ParseRenderScale(value) == 1);
  }
  for (const auto& value : {"2", "2\n", "2\r\n"}) {
    assert(anich::ParseRenderScale(value) == 2);
  }
  const std::vector<std::string> invalid = {
      "",     "0",     "3",    "1.5",  "2.0",   "1 2", "01", " 1",
      "1 ",   "1\n2",  "1\n\n", "1\r", "2\r\n2", "-1",  "nan",
      std::string("1\0", 2), std::string(1024 * 1024, '1')};
  for (const auto& value : invalid) {
    assert(anich::ParseRenderScale(value) == 0);
    std::istringstream input(value);
    const auto preference = anich::ReadRenderScaleStream(input);
    assert(preference.scale == 2);
    assert(std::string(preference.source) == "default_invalid_file");
    assert(input.gcount() <= 4);
  }
  std::istringstream valid("1\n");
  assert(anich::ReadRenderScaleStream(valid).scale == 1);
  std::istringstream bad("1");
  bad.setstate(std::ios::badbit);
  assert(anich::ReadRenderScaleStream(bad).scale == 2);

  assert(anich::ReadRenderScalePreference(nullptr, "com.anich.tv").scale == 2);
  assert(anich::ReadRenderScalePreference("", "com.anich.tv").scale == 2);
  assert(anich::ReadRenderScalePreference(argv[1], nullptr).scale == 2);
  assert(anich::ReadRenderScalePreference(argv[1], "").scale == 2);

  // Use an isolated test directory supplied by the caller. It exercises the
  // same data-home/app-id path as Dart's application support directory.
  const std::filesystem::path root(argv[1]);
  assert(!std::filesystem::exists(root));
  std::filesystem::create_directories(root / "com.anich.tv");
  const auto file = root / "com.anich.tv" / "anich-render-scale.txt";
  assert(anich::ReadRenderScalePreference(argv[1], "com.anich.tv").scale == 2);
  { std::ofstream out(file, std::ios::binary); out << "1\n"; }
  assert(anich::ReadRenderScalePreference(argv[1], "com.anich.tv").scale == 1);
  const auto with_slash = root.string() + "/";
  assert(anich::ReadRenderScalePreference(with_slash.c_str(), "com.anich.tv")
             .scale == 1);
  { std::ofstream out(file, std::ios::binary); out << "1.5"; }
  assert(anich::ReadRenderScalePreference(argv[1], "com.anich.tv").scale == 2);
  { std::ofstream out(file, std::ios::binary); out << "2\r\n"; }
  assert(anich::ReadRenderScalePreference(argv[1], "com.anich.tv").scale == 2);
  std::filesystem::remove_all(root);
  std::cout << "Native render scale tests passed.\n";
}
