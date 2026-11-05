import 'dart:io';

/// webOS uses Dart's Linux platform, but does not provide desktop plugins.
class PlatformInfo {
  static const bool isWebOS = bool.fromEnvironment('ANICH_WEBOS');

  static bool get isDesktop =>
      !isWebOS && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);
}
