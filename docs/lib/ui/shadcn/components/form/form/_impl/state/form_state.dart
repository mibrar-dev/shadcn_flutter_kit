// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// State class for the [Form] widget that manages form controller lifecycle.
///
/// This state class is responsible for initializing and updating the
/// [FormController] used by the [Form] widget. It ensures proper controller
/// management when the controller property changes and provides the controller
/// to descendant widgets through the data inheritance mechanism.
///
/// The state handles two scenarios:
/// - Creates a default [FormController] if none is provided
/// - Updates to a new controller when the widget's controller property changes
///
/// See also:
/// - [Form], the widget that uses this state
/// - [FormController], the controller managed by this state
class FormState extends State<Form> {
  /// Controller used to coordinate `_controller` behavior.
  late FormController _controller;

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? FormController();
  }

  /// Reacts to widget configuration updates from the parent.
  @override
  void didUpdateWidget(covariant Form oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller = widget.controller ?? FormController();
    }
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Data.inherit(
      data: this,
      child: Data.inherit(data: _controller, child: widget.child),
    );
  }
}
