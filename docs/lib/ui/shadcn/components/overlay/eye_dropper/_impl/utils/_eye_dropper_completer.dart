// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../eye_dropper.dart';

/// _EyeDropperCompleter defines a reusable type for this registry module.
class _EyeDropperCompleter {
  /// Stores `completer` state/configuration for this implementation.
  final Completer<Color?> completer;

  /// Stores `recentColorsScope` state/configuration for this implementation.
  final Set<ColorHistoryStorage> recentColorsScope;

  _EyeDropperCompleter(this.completer, this.recentColorsScope);
}
