import 'package:flutter/foundation.dart';

/// Whether [platform] is a mobile target (Android, iOS or Fuchsia).
bool isMobile(TargetPlatform platform) {
  switch (platform) {
    case TargetPlatform.android:
    case TargetPlatform.iOS:
    case TargetPlatform.fuchsia:
      return true;
    case TargetPlatform.macOS:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      return false;
  }
}
