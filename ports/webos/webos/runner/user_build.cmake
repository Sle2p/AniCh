# User application sources and include directories.
#
# This is the only build file you are expected to edit. Add your own runner
# sources and header search paths here; the SDK assembles the rest of the
# build graph.

set(USER_APP_EXTRA_SRCS
  runner/main.cc
)

set(USER_APP_EXTRA_INCLUDE_DIRS
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}/runner
)
