// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../history.dart';

/// _ColorListNotifier represents a form-related type in the registry.
class _ColorListNotifier extends ChangeNotifier {
  /// Field storing `_recentColors` for this form implementation.
  List<Color> _recentColors;

  _ColorListNotifier(this._recentColors);

  /// Performs `_notify` logic for this form component.
  void _notify() {
    notifyListeners();
  }
}
