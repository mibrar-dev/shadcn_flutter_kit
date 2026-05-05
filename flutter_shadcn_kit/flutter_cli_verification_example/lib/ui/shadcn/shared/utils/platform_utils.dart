import 'package:flutter/foundation.dart';

/// Executes `isMobile` behavior for this component/composite.
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
