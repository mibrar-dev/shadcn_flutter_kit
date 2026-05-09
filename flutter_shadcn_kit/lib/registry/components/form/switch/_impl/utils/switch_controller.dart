// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../switch.dart';

/// Controller for managing switch state.
class SwitchController extends ValueNotifier<bool>
    with ComponentController<bool> {
  SwitchController([super.value = false]);

  /// Converts this value using `toggle` logic.
  void toggle() {
    value = !value;
  }
}
