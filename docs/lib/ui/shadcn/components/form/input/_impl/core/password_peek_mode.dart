// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../input.dart';

/// Mode for password visibility toggling.
///
/// Determines whether the password visibility toggle holds (shows while pressed)
/// or toggles (switches state on each press).
enum PasswordPeekMode {
  /// Show password only while button is held down.
  hold,

  /// Toggle password visibility on each press.
  toggle,
}
