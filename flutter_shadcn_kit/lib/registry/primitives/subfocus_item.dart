// A single focusable item inside a [SubFocusScope].
//
// Ported from `shared/primitives/subfocus.dart` + `_impl/core/sub_focus.dart`
// and `_impl/state/__sub_focus_state.dart`.

import 'package:flutter/widgets.dart';

import '../foundation/data.dart';
import 'subfocus.dart';

/// An individual focusable item within a [SubFocusScope].
///
/// Attaches itself to the nearest scope, tracks focus state and exposes it
/// to [builder].
class SubFocus extends StatefulWidget {
  /// Builds the child from the current focus state.
  final SubFocusBuilder builder;

  /// Whether this item can receive focus. Defaults to true.
  final bool enabled;

  /// Creates a focusable item.
  const SubFocus({super.key, required this.builder, this.enabled = true});

  @override
  State<SubFocus> createState() => _SubFocusState();
}

class _SubFocusState extends State<SubFocus> with SubFocusState {
  SubFocusScopeState? _scope;
  bool _focused = false;
  bool _active = true;
  int _focusCount = 0;

  @override
  int get focusCount => _focusCount;

  @override
  bool unfocus() {
    return _scope?.unfocus(this) ?? false;
  }

  @override
  void activate() {
    super.activate();
    _active = true;
  }

  @override
  void deactivate() {
    _active = false;
    super.deactivate();
  }

  @override
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
  bool requestFocus() {
    if (!mounted || !_active || !widget.enabled) return false;
    if (_scope != null) {
      return _scope!.requestFocus(this);
    }
    return false;
  }

  @override
  bool get isFocused => _focused && widget.enabled;

  @override
  bool get isEnabled => widget.enabled;

  @override
  RenderBox? findRenderObject() {
    if (!mounted || !_active) {
      return null;
    }
    return context.findRenderObject() as RenderBox?;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newScope = Data.maybeOf<SubFocusScopeState>(context);
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
  void dispose() {
    _scope?.detach(this);
    super.dispose();
  }

  @override
  void markFocused(bool focus) {
    if (!mounted || !_active) {
      return;
    }
    setState(() {
      if (focus) {
        _focusCount++;
      }
      _focused = focus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, this);
  }
}
