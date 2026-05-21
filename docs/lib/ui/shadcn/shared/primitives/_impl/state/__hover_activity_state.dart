// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../hover.dart';

/// _HoverActivityState defines a reusable type for this registry module.
class _HoverActivityState extends State<HoverActivity>
    with SingleTickerProviderStateMixin {
  /// Stores `_controller` state/configuration for this implementation.
  late AnimationController _controller;

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.debounceDuration,
    );
    _controller.addStatusListener(_onStatusChanged);
  }

  /// Executes `_onStatusChanged` behavior for this component/composite.
  void _onStatusChanged(AnimationStatus status) {
    widget.onHover?.call();
  }

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant HoverActivity oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.debounceDuration;
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final compTheme = ComponentTheme.maybeOf<HoverTheme>(context);
    final debounceDuration = styleValue(
      widgetValue: widget.debounceDuration,
      themeValue: compTheme?.debounceDuration,
      defaultValue: const Duration(milliseconds: 100),
    );
    final behavior = styleValue(
      widgetValue: widget.hitTestBehavior,
      themeValue: compTheme?.hitTestBehavior,
      defaultValue: HitTestBehavior.deferToChild,
    );
    _controller.duration = debounceDuration;
    return MouseRegion(
      hitTestBehavior: behavior,
      onEnter: (_) {
        widget.onEnter?.call();
        _controller.repeat(reverse: true);
      },
      onExit: (_) {
        _controller.stop();
        widget.onExit?.call();
      },
      child: widget.child,
    );
  }
}

/// Hover wrapper that controls delayed show/hide callbacks.
