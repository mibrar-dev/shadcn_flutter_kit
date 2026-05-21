// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ErrorScopeType: identifies where an error is published in AppErrorHub.
// app = global, persists across navigation; screen = per-feature/screen, disposed when the screen unmounts.

/// ErrorScopeType enumerates fixed values used by this implementation.
enum ErrorScopeType {
  /// App-level errors that persist across screens until cleared.
  app,

  /// Screen-level errors intended to be disposed when a screen is removed.
  screen,
}
