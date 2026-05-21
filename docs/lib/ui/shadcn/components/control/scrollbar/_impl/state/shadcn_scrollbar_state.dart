// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../../../../shared/theme/theme.dart';
import '../../../../../shared/utils/style_value.dart';
import '../themes/base/scrollbar_theme.dart';
import '../core/shadcn_scrollbar.dart';

/// Stores `_kScrollbarMinLength` state/configuration for this implementation.
const double _kScrollbarMinLength = 48.0;

/// ShadcnScrollbarState defines a reusable type for this registry module.
class ShadcnScrollbarState extends RawScrollbarState<ShadcnScrollbar> {
  /// Stores `_hoverAnimationController` state/configuration for this implementation.
  late AnimationController _hoverAnimationController;

  /// Stores `_hoverIsActive` state/configuration for this implementation.
  bool _hoverIsActive = false;

  /// Stores `_theme` state/configuration for this implementation.
  late ThemeData _theme;

  @override
  /// Executes `didChangeDependencies` behavior for this component/composite.
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
  }

  @override
  /// Stores `enableGestures` state/configuration for this implementation.
  bool get enableGestures => widget.interactive ?? true;

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _hoverAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    /// Creates a `_hoverAnimationController.addListener` instance.
    _hoverAnimationController.addListener(() {
      updateScrollbarPainter();
    });
  }

  @override
  /// Executes `updateScrollbarPainter` behavior for this component/composite.
  void updateScrollbarPainter() {
    final compTheme = ComponentTheme.maybeOf<ScrollbarTheme>(context);
    scrollbarPainter
      ..color = styleValue(
        widgetValue: widget.color,
        themeValue: compTheme?.color,
        defaultValue: _theme.colorScheme.border,
      )
      ..textDirection = Directionality.of(context)
      ..thickness = styleValue(
        widgetValue: widget.thickness,
        themeValue: compTheme?.thickness,
        defaultValue: 7.0 * _theme.scaling,
      )
      ..radius = styleValue(
        widgetValue: widget.radius,
        themeValue: compTheme?.radius,
        defaultValue: Radius.circular(_theme.radiusSm),
      )
      ..minLength = _kScrollbarMinLength
      ..padding = MediaQuery.paddingOf(context) + EdgeInsets.all(_theme.scaling)
      ..scrollbarOrientation = widget.scrollbarOrientation
      ..ignorePointer = !enableGestures;
  }

  @override
  /// Executes `handleHover` behavior for this component/composite.
  void handleHover(PointerHoverEvent event) {
    if (isPointerOverScrollbar(event.position, event.kind, forHover: true)) {
      /// Creates a `setState` instance.
      setState(() {
        _hoverIsActive = true;
      });
      _hoverAnimationController.forward();
    } else if (_hoverIsActive) {
      /// Creates a `setState` instance.
      setState(() {
        _hoverIsActive = false;
      });
      _hoverAnimationController.reverse();
    }
    super.handleHover(event);
  }

  @override
  /// Executes `handleHoverExit` behavior for this component/composite.
  void handleHoverExit(PointerExitEvent event) {
    super.handleHoverExit(event);

    /// Creates a `setState` instance.
    setState(() {
      _hoverIsActive = false;
    });
    _hoverAnimationController.reverse();
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    _hoverAnimationController.dispose();
    super.dispose();
  }
}
