// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../shared/theme/theme.dart';
import '../../../../../shared/utils/style_value.dart';
import '../themes/base/hover_theme.dart';
import '../core/hover_widget.dart';

/// HoverState defines a reusable type for this registry module.
class HoverState extends State<Hover> with SingleTickerProviderStateMixin {
  /// Stores `_controller` state/configuration for this implementation.
  late AnimationController _controller;

  /// Stores `_enterTime` state/configuration for this implementation.
  int? _enterTime;

  /// Stores `_waitDur` state/configuration for this implementation.
  late Duration _waitDur;

  /// Stores `_minDur` state/configuration for this implementation.
  late Duration _minDur;

  /// Stores `_showDur` state/configuration for this implementation.
  late Duration _showDur;

  /// Stores `_behavior` state/configuration for this implementation.
  late HitTestBehavior _behavior;

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _waitDur = widget.waitDuration ?? const Duration(milliseconds: 500);
    _minDur = widget.minDuration ?? const Duration(milliseconds: 0);
    _showDur = widget.showDuration ?? const Duration(milliseconds: 200);
    _controller = AnimationController(vsync: this, duration: _waitDur);
    _controller.addStatusListener(_onStatusChanged);
  }

  /// Executes `_onEnter` behavior for this component/composite.
  void _onEnter() {
    _enterTime = DateTime.now().millisecondsSinceEpoch;
    _controller.forward();
  }

  /// Executes `_onExit` behavior for this component/composite.
  void _onExit(bool cursorOut) {
    /// Stores `minDuration` state/configuration for this implementation.
    int minDuration = _minDur.inMilliseconds;

    /// Stores `enterTime` state/configuration for this implementation.
    int? enterTime = _enterTime;
    if (enterTime != null) {
      int duration = DateTime.now().millisecondsSinceEpoch - enterTime;
      _controller.reverseDuration = cursorOut
          ? Duration(milliseconds: duration < minDuration ? minDuration : 0)
          : _showDur;
      _controller.reverse();
    }
    _enterTime = null;
  }

  /// Executes `_onStatusChanged` behavior for this component/composite.
  void _onStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onHover(true);
    } else if (status == AnimationStatus.dismissed) {
      widget.onHover(false);
    }
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
    final platform = Theme.of(context).platform;
    final compTheme = ComponentTheme.maybeOf<HoverTheme>(context);
    _waitDur = styleValue(
      widgetValue: widget.waitDuration,
      themeValue: compTheme?.waitDuration,
      defaultValue: const Duration(milliseconds: 500),
    );
    _minDur = styleValue(
      widgetValue: widget.minDuration,
      themeValue: compTheme?.minDuration,
      defaultValue: const Duration(milliseconds: 0),
    );
    _showDur = styleValue(
      widgetValue: widget.showDuration,
      themeValue: compTheme?.showDuration,
      defaultValue: const Duration(milliseconds: 200),
    );
    _behavior = styleValue(
      widgetValue: widget.hitTestBehavior,
      themeValue: compTheme?.hitTestBehavior,
      defaultValue: HitTestBehavior.deferToChild,
    );
    _controller.duration = _waitDur;
    bool enableLongPress =
        platform == TargetPlatform.iOS ||
        platform == TargetPlatform.android ||
        platform == TargetPlatform.fuchsia;
    return TapRegion(
      behavior: _behavior,
      onTapOutside: (details) {
        _onExit(true);
      },
      child: MouseRegion(
        hitTestBehavior: _behavior,
        onEnter: (_) => _onEnter(),
        onExit: (_) {
          _onExit(true);
        },
        child: GestureDetector(
          // for mobile platforms, hover is triggered by a long press
          onLongPressDown: enableLongPress
              ? (details) {
                  _onEnter();
                }
              : null,
          onLongPressCancel: enableLongPress
              ? () {
                  _onExit(true);
                }
              : null,
          onLongPressUp: enableLongPress
              ? () {
                  _onExit(true);
                }
              : null,
          child: widget.child,
        ),
      ),
    );
  }
}
