// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../keyboard_shortcut.dart';

/// _KeyboardShortcutDisplayMapperState holds mutable state for the keyboard shortcut implementation.
class _KeyboardShortcutDisplayMapperState
    extends State<KeyboardShortcutDisplayMapper> {
  late KeyboardShortcutDisplayHandle _handle;

  /// Initializes controllers and listeners required by keyboard shortcut.
  @override
  void initState() {
    super.initState();
    _handle = KeyboardShortcutDisplayHandle(widget.builder);
  }

  /// Updates internal state when keyboard shortcut configuration changes.
  @override
  void didUpdateWidget(covariant KeyboardShortcutDisplayMapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.builder != widget.builder) {
      _handle = KeyboardShortcutDisplayHandle(widget.builder);
    }
  }

  /// Builds the widget tree for keyboard shortcut.
  @override
  Widget build(BuildContext context) {
    return Data.inherit(data: _handle, child: widget.child);
  }
}
