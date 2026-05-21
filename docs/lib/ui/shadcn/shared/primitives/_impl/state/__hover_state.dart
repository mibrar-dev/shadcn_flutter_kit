// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../hover.dart';

/// _HoverState defines a reusable type for this registry module.
class _HoverState extends State<Hover> {
  /// Stores `_hovered` state/configuration for this implementation.
  bool _hovered = false;

  /// Stores `_showed` state/configuration for this implementation.
  bool _showed = false;

  /// Stores `_timer` state/configuration for this implementation.
  Timer? _timer;

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final compTheme = ComponentTheme.maybeOf<HoverTheme>(context);
    final waitDuration = styleValue(
      widgetValue: widget.waitDuration,
      themeValue: compTheme?.waitDuration,
      defaultValue: const Duration(milliseconds: 300),
    );
    final minDuration = styleValue(
      widgetValue: widget.minDuration,
      themeValue: compTheme?.minDuration,
      defaultValue: const Duration(milliseconds: 0),
    );
    final showDuration = styleValue(
      widgetValue: widget.showDuration,
      themeValue: compTheme?.showDuration,
      defaultValue: const Duration(milliseconds: 150),
    );

    return HoverActivity(
      hitTestBehavior: HitTestBehavior.deferToChild,
      onEnter: () {
        _hovered = true;
        _timer?.cancel();
        _timer = Timer(waitDuration, () {
          if (_hovered) {
            widget.onHover?.call(true);
            _showed = true;
          }
        });
      },
      onExit: () {
        _hovered = false;
        if (_showed) {
          _timer?.cancel();
          _timer = Timer(minDuration + showDuration, () {
            _showed = false;
            widget.onHover?.call(false);
          });
        }
      },
      child: widget.child,
    );
  }
}
