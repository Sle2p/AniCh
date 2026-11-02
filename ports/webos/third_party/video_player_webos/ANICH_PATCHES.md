# AniCh webOS integration

Source: https://github.com/lg-flutter-webos/plugins/tree/3a742bb86b04e261044f0864f9b1f71acf0bbad3/packages/video_player

The package and its BSD license are retained. The first Dart-only compatibility patch
makes `setVolume(1.0)` a no-op: standard Flutter video_player automatically sets
its default volume during initialization, whereas LG's implementation returns
an unsupported error for every volume call. Other volume values still return
an unsupported error. AniCh exposes no per-player volume control on TV; use the
TV remote. These volume changes do not alter native media playback.

A second Dart-only lifecycle patch cancels the video widget's resize timer,
stops its post-frame loop after unmounting, and removes its stale state from the
plugin registry. This avoids calling setState on an unmounted video widget
when switching episodes or leaving the player. This lifecycle patch changes
Dart code only.

Regression test: `test/webos_video_player_test.dart` initializes the standard
VideoPlayerController against LG's Dart platform implementation with only the
hardware transport replaced; the real default volume code remains under test.
It also verifies that attempts to change per-player volume still fail.
# Physical exported-video destination coordinates

The exported-window channel expects destination rectangles in physical pixels.
AniCh converts the render box position and size with `View.devicePixelRatio`
before caching or scheduling the rectangle update. This fixes quarter-size video
on a DPR 2 / 4K Flutter surface and also re-exports when only DPR changes.
The source video rectangle and the Flutter `Hole` drawing are unchanged.

# Independent logger replacement

The upstream `webos/log.h` and `webos/log.cc` carried the file-level identifier
`LicenseRef-LGE-Proprietary`, despite the package-level BSD license. Those two
implementations have been replaced in full with an independently written,
BSD-3-Clause logger by the AniCh webOS contributors. The additional copyright
notice is included in this package's `LICENSE`; the other upstream notices
remain intact.

The replacement preserves the call expressions used by the player sources:
`LogVerbose(tag)`, `LogDebug(tag)`, `LogInfo(tag)`, `LogWarn(tag)`, and
`LogError(tag)`, followed by stream insertions. Each is an alias for a scoped
message builder. It accepts ordinary streamable values and manipulators such
as `std::hex` and `std::endl`, and emits its buffered message on destruction.
Insertions and destruction catch formatting failures; the destructor is
`noexcept` so logging cannot propagate an exception during player cleanup.

Messages go directly to standard error with a severity and tag. There are no
logging callbacks, PmLog calls, or private temporary log files in the new
implementation. It uses only the C++ standard library and does not change the
player's media API or require changes at its existing logging call sites.
