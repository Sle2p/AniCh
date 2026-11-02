cmake_minimum_required(VERSION 3.10)
set(PROJECT_NAME "video_player")
project(${PROJECT_NAME} LANGUAGES C CXX)

find_package(PkgConfig)
pkg_check_modules(PMLOG REQUIRED PmLogLib)
pkg_check_modules(PBNJSON_CPP REQUIRED pbnjson_cpp)
pkg_check_modules(GLIB REQUIRED glib-2.0)
pkg_check_modules(NDLMEDIA REQUIRED ndlmedia)

if( ${CMAKE_SYSTEM_PROCESSOR} STREQUAL "arm" AND
    NOT "${CMAKE_CXX_COMPILER}" MATCHES "aarch64" )
  ADD_COMPILE_OPTIONS(-mfpu=neon -mfloat-abi=softfp)
  add_definitions (-D__ARM_NEON)
endif()

# This value is used when generating builds using this plugin, so it must
# not be changed
set(PLUGIN_NAME "video_player_webos_plugin")

add_library(${PLUGIN_NAME} SHARED
  "log.cc"
  "messages.cc"
  "video_player_plugin.cc"
  "video_player.cc"
  "webos_player.cc"
)

apply_standard_settings(${PLUGIN_NAME})
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)

target_include_directories(${PLUGIN_NAME} INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/include")

target_include_directories(${PLUGIN_NAME} PRIVATE
   ${CMAKE_CURRENT_SOURCE_DIR}
   ${PMLOG_INCLUDE_DIRS}
   ${PBNJSON_CPP_INCLUDE_DIRS}
   ${GLIB_INCLUDE_DIRS}
   ${NDLMEDIA_INCLUDE_DIRS}
)

target_link_libraries(
  ${PLUGIN_NAME} PRIVATE flutter
  ${PMLOG_LIBRARIES}
  ${PBNJSON_CPP_LIBRARIES}
  ${GLIB_LIBRARIES}
  ${NDLMEDIA_LIBRARIES}
  atomic
)

# List of absolute paths to libraries that should be bundled with the plugin
set(video_player_bundled_libraries
  ""
  PARENT_SCOPE
)
