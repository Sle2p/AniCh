# API Reference — video_player_webos

> **Note:** For standard API documentation, see [video_player on pub.dev](https://pub.dev/documentation/video_player/latest/).
> This document covers webOS-specific behavior and the support matrix of upstream APIs only.

## Features

- Inline video playback via the webOS native media subsystem
- Support for asset, file, network, and content-uri data sources
- Playback controls: play, pause, seek, looping, playback speed
- Event streams for state, position, buffering, and completion
- Platform-managed video plane rendered through a transparent Flutter surface

## Overview

This plugin provides the webOS platform implementation of `video_player`. Users interact with the standard `video_player` API (`VideoPlayerController`, `VideoPlayer` widget, etc.) — this package is registered automatically and requires no direct usage.

## Supported APIs

| API | Supported | Notes |
|-----|-----------|-------|
| `VideoPlayerController.asset(...)` | Yes | |
| `VideoPlayerController.file(...)` | Yes | |
| `VideoPlayerController.network(...)` | Partial | `httpHeaders` option not supported |
| `VideoPlayerController.networkUrl(...)` | Partial | `httpHeaders` option not supported |
| `VideoPlayerController.contentUri(...)` | Yes | |
| `initialize()` | Yes | |
| `play()` | Yes | |
| `pause()` | Yes | |
| `seekTo(Duration position)` | Yes | |
| `setLooping(bool looping)` | Yes | |
| `setVolume(double volume)` | No | Surfaces a Dart exception with code `unsupported`. Use system-wide volume controls instead |
| `setPlaybackSpeed(double speed)` | Yes | |
| `setClosedCaptionFile(Future<ClosedCaptionFile>?)` | Yes | |
| `position` getter | Yes | |
| `dispose()` | Yes | |
| `VideoPlayerOptions.mixWithOthers` | No | |
| `VideoPlayerOptions.allowBackgroundPlayback` | Yes | |

## webOS-Specific Behavior

- **Concurrent player limit:** Up to 5 `VideoPlayerController` instances can run simultaneously in a single application. Creating a sixth controller automatically evicts the least-recently-created player; the evicted player receives an `error` event with code `-1` (message: `num of pipelines`).
- **Transparent surface:** The plugin requires the application to enable `transparent: true` in `appinfo.json` so the platform video plane is visible underneath the Flutter surface. See [README — Required configurations](README.md#required-configurations).
- **Video plane rendering:** Video frames are rendered on a dedicated hardware video plane, not as Flutter textures. The Flutter widget area becomes transparent to expose the underlying video plane.
