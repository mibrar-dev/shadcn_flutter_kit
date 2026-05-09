// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../subfocus.dart';

/// _SubFocusState defines a reusable type for this registry module.
class _SubFocusState extends State<SubFocus> with SubFocusState {
  /// Stores `_scope` state/configuration for this implementation.
  SubFocusScopeState? _scope;

  /// Stores `_focused` state/configuration for this implementation.
  bool _focused = false;

  /// Stores `_active` state/configuration for this implementation.
  bool _active = true;

  /// Stores `_focusCount` state/configuration for this implementation.
  int _focusCount = 0;

  @override
  /// Stores `focusCount` state/configuration for this implementation.
  int get focusCount => _focusCount;

  @override
  /// Executes `unfocus` behavior for this component/composite.
  bool unfocus() {
    return _scope?.unfocus(this) ?? false;
  }

  @override
  /// Executes `activate` behavior for this component/composite.
  void activate() {
    super.activate();
    _active = true;
  }

  @override
  /// Executes `deactivate` behavior for this component/composite.
  void deactivate() {
    _active = false;
    super.deactivate();
  }

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant SubFocus oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      if (widget.enabled) {
        _focused = _scope?.attach(this) ?? false;
      } else {
        _focused = false;
        _scope?.detach(this);
      }
    }
  }

  @override
  /// Executes `invokeAction` behavior for this component/composite.
  Object? invokeAction(Intent intent) {
    return Actions.invoke(context, intent);
  }

  @override
  void ensureVisible({
    ScrollPositionAlignmentPolicy alignmentPolicy =
        ScrollPositionAlignmentPolicy.explicit,
  }) {
    if (!mounted || !_active) return;
    Scrollable.ensureVisible(context, alignmentPolicy: alignmentPolicy);
  }

  @override
  /// Executes `requestFocus` behavior for this component/composite.
  bool requestFocus() {
    if (!mounted || !_active) return false;
    if (_scope != null) {
      return _scope!.requestFocus(this);
    }
    return false;
  }

  @override
  /// Stores `isFocused` state/configuration for this implementation.
  bool get isFocused => _focused && widget.enabled;

  @override
  /// Executes `findRenderObject` behavior for this component/composite.
  RenderBox? findRenderObject() {
    if (!mounted || !_active) {
      return null;
    }
    return context.findRenderObject() as RenderBox?;
  }

  @override
  /// Executes `didChangeDependencies` behavior for this component/composite.
  void didChangeDependencies() {
    super.didChangeDependencies();
    var newScope = Data.maybeOf<SubFocusScopeState>(context);
    if (newScope != _scope) {
      _focusCount = 0;
      _scope?.detach(this);
      _scope = newScope;
      if (widget.enabled) {
        _focused = _scope?.attach(this) ?? false;
      }
    }
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    _scope?.detach(this);
    super.dispose();
  }

  @override
  /// Executes `markFocused` behavior for this component/composite.
  void markFocused(bool focus) {
    if (!mounted || !_active) {
      return;
    }

    /// Creates a `setState` instance.
    setState(() {
      if (focus) {
        _focusCount++;
      }
      _focused = focus;
    });
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return widget.builder(context, this);
  }
}
