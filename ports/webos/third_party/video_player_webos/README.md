# video_player_webos

The WebOS implementation of [`video_player`](https://pub.dev/packages/video_player).

## Supported platforms

This plugin is supported on webOS 26 media or above.

## Usage

This package is not an _endorsed_ implementation of `video_player`.
Therefore, you have to include `video_player_webos` alongside `video_player`
as dependencies in your `pubspec.yaml` file.

**pubspec.yaml:**

```yaml
dependencies:
  video_player: ^2.9.0
  video_player_webos:
    git:
      url: https://github.com/lg-flutter-webos/plugins.git
      path: packages/video_player
      ref: main
```

**Import:**

```dart
import 'package:video_player/video_player.dart';
```

## Required configurations

Video playback uses a transparent Flutter surface so the platform video plane
can show through. Set `transparent: true` in your application's
`appinfo.json`:

```json
{
  "transparent": true
}
```

## Example

See the [upstream example application](https://github.com/lg-flutter-webos/plugins/blob/3a742bb86b04e261044f0864f9b1f71acf0bbad3/packages/video_player/example/lib/main.dart) at this integration's pinned source revision. The example directory is not included in this vendored copy.

## API Reference

See the [API Reference](API_REFERENCE.md) for the list of supported APIs and webOS-specific behavior.

## Limitations

- Up to **5 video players** can run concurrently in a single application.
  When the limit is reached, the next `VideoPlayerController` creation
  automatically evicts the least-recently-created player; that player
  receives an `error` event with code `-1` ("num of pipelines") so the
  Dart side can detect the eviction.
- `VideoPlayerController.setVolume` is not supported on webOS in this
  release. Calling it surfaces a Dart exception with error code
  `unsupported`. Apps that need per-stream volume control should rely
  on system-wide volume controls.
- The `httpHeaders` option of `VideoPlayerController.network` is not
  supported.
- `VideoPlayerOptions.mixWithOthers` is not supported.
