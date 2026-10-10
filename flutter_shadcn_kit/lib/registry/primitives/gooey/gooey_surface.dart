// An expandable metaball surface: a compact pill that morphs into an expanded
// body, with autopilot timing and hover/press interaction. Carved from the
// presentation half of the old `_GooeyToastState` in `overlay/gooey_toast`;
// the queue/stack lives in `gooey_stack.dart`, the per-frame composition in
// `gooey_frame.dart` and the silhouette in `gooey_shape.dart`.

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'gooey_content.dart';
import 'gooey_frame.dart';

/// Compact pill height; the pill never changes size with content.
const double kGooeySurfacePillHeight = 40;

/// Minimum expanded height as a multiple of the pill height.
const double _kMinExpandRatio = 2.25;

/// One gooey surface: a compact pill plus a body that expands out of it.
///
/// Expansion is driven by hover/press, by a tap on the pill and — when
/// [expandDelay] / [collapseDelay] are set — by an autopilot timer. The
/// component owns the queue and supplies resolved content, styles and colours.
class GooeySurface extends StatefulWidget {
  /// Creates a gooey surface.
  const GooeySurface({
    super.key,
    required this.title,
    required this.titleStyle,
    required this.morphKey,
    this.leading,
    this.description,
    this.descriptionStyle,
    this.body,
    this.action,
    this.expandable = true,
    this.width = 350,
    this.fill = const ThemedColor.ref(ColorRef.popover),
    this.fillAlpha = 1,
    this.roundness = 18,
    this.compactAlignment = Alignment.centerLeft,
    this.expandUp = false,
    this.enableGooeyBlur = true,
    this.surfaceBlur = 0,
    this.openDuration = const Duration(milliseconds: 600),
    this.openCurve = Curves.easeInOutCubic,
    this.bodyAnimation = GooeySurfaceBodyAnimation.fade,
    this.expandDelay,
    this.collapseDelay,
    this.pauseOnHover = true,
    this.onInteractionChanged,
    this.onExpansionChanged,
  });

  final String title;

  final TextStyle titleStyle;

  /// Identity of the compact content, so title/state changes morph.
  final Object morphKey;

  final Widget? leading;

  final String? description;

  final TextStyle? descriptionStyle;

  final Widget? body;

  final Widget? action;

  /// Whether the body may expand; `false` keeps the pill shut.
  final bool expandable;

  final double width;

  /// Surface fill; resolves per build, so a preset switch restyles it.
  final ThemedColor fill;

  /// Whole-surface opacity.
  final double fillAlpha;

  final double roundness;

  /// Horizontal alignment of the compact pill.
  final Alignment compactAlignment;

  /// Whether the body grows upwards instead of downwards.
  final bool expandUp;

  /// Whether the metaball blur pass runs.
  final bool enableGooeyBlur;

  /// Backdrop blur sigma clipped to the silhouette.
  final double surfaceBlur;

  /// Open/close animation duration.
  final Duration openDuration;

  /// Open/close animation curve.
  final Curve openCurve;

  /// Body content animation profile.
  final GooeySurfaceBodyAnimation bodyAnimation;

  /// Delay before the autopilot expands the body; `null` disables it.
  final Duration? expandDelay;

  /// Delay before the autopilot collapses the body; `null` disables it.
  final Duration? collapseDelay;

  /// Whether hover/press pauses an enclosing toast countdown.
  final bool pauseOnHover;

  /// Called when hover/press starts or stops, for the pause policy.
  final ValueChanged<bool>? onInteractionChanged;

  /// Called with `true` when the surface starts opening, `false` when closed.
  final ValueChanged<bool>? onExpansionChanged;

  @override
  State<GooeySurface> createState() => _GooeySurfaceState();
}

/// Metaball blur sigma as a fraction of the roundness.
const double _kBlurRatio = 0.5;

class _GooeySurfaceState extends State<GooeySurface>
    with TickerProviderStateMixin {
  bool _ready = false;
  bool _expanded = false;
  bool _hovered = false;
  bool _pressed = false;
  bool _lastInteracting = false;
  Timer? _expandTimer;
  Timer? _collapseTimer;
  double _measuredBodyHeight = 0;
  double _frozenBodyHeight = kGooeySurfacePillHeight * _kMinExpandRatio;
  late final AnimationController _open;
  late CurvedAnimation _openCurve;

  bool get _hasBodyContent =>
      widget.body != null ||
      widget.description != null ||
      widget.action != null;

  bool get _hasBody => widget.expandable && _hasBodyContent;

  bool get _isInteracting => _hovered || _pressed;

  bool get _targetOpen => _hasBody && _expanded;

  @override
  void initState() {
    super.initState();
    _open = AnimationController(
      vsync: this,
      duration: widget.openDuration,
      reverseDuration: widget.openDuration,
    );
    _openCurve = CurvedAnimation(parent: _open, curve: widget.openCurve);
    _scheduleAutopilot();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _ready = true);
      }
    });
  }

  @override
  void didUpdateWidget(covariant GooeySurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.openDuration != widget.openDuration) {
      _open
        ..duration = widget.openDuration
        ..reverseDuration = widget.openDuration;
    }
    if (oldWidget.openCurve != widget.openCurve) {
      _openCurve.dispose();
      _openCurve = CurvedAnimation(parent: _open, curve: widget.openCurve);
    }
    final bool contentChanged =
        oldWidget.expandable != widget.expandable ||
        oldWidget.body != widget.body ||
        oldWidget.description != widget.description ||
        oldWidget.action != widget.action ||
        oldWidget.expandDelay != widget.expandDelay ||
        oldWidget.collapseDelay != widget.collapseDelay;
    if (contentChanged) {
      if (!_hasBody && _expanded) {
        _expanded = false;
      }
      _syncOpen();
      _scheduleAutopilot();
    }
  }

  @override
  void dispose() {
    widget.onInteractionChanged?.call(false);
    _expandTimer?.cancel();
    _collapseTimer?.cancel();
    _openCurve.dispose();
    _open.dispose();
    super.dispose();
  }

  void _setExpanded(bool value) {
    if (_expanded == value) {
      return;
    }
    setState(() => _expanded = value);
    _syncOpen();
  }

  void _syncOpen() {
    if (_targetOpen) {
      widget.onExpansionChanged?.call(true);
      _open.forward();
    } else {
      widget.onExpansionChanged?.call(false);
      _open.reverse();
    }
  }

  void _toggle() {
    if (!_hasBody) {
      return;
    }
    _collapseTimer?.cancel();
    _setExpanded(!_expanded);
  }

  void _scheduleAutopilot() {
    _expandTimer?.cancel();
    _collapseTimer?.cancel();
    if (!_hasBody) {
      return;
    }
    final Duration? expandDelay = widget.expandDelay;
    final Duration? collapseDelay = widget.collapseDelay;
    if (expandDelay != null) {
      _expandTimer = Timer(
        expandDelay > Duration.zero ? expandDelay : Duration.zero,
        () {
          if (mounted) {
            _setExpanded(true);
          }
        },
      );
    }
    if (collapseDelay != null && collapseDelay > Duration.zero) {
      _collapseTimer = Timer(collapseDelay, () {
        if (!mounted || !_hasBody || _isInteracting) {
          return;
        }
        _setExpanded(false);
      });
    }
  }

  void _setHovered(bool value) {
    if (_hovered == value || !mounted) {
      return;
    }
    setState(() => _hovered = value);
    _emitInteraction();
    if (!_hasBody) {
      return;
    }
    if (value) {
      _collapseTimer?.cancel();
      _setExpanded(true);
    } else {
      _setExpanded(false);
    }
  }

  void _setPressed(bool value) {
    if (_pressed == value || !mounted) {
      return;
    }
    setState(() => _pressed = value);
    _emitInteraction();
  }

  void _emitInteraction() {
    if (!widget.pauseOnHover) {
      return;
    }
    final bool interacting = _isInteracting;
    if (interacting == _lastInteracting) {
      return;
    }
    _lastInteracting = interacting;
    widget.onInteractionChanged?.call(interacting);
  }

  void _onBodyMeasured(Size size) {
    final double next = size.height.clamp(0.0, 4000.0).toDouble();
    if (!mounted || (next - _measuredBodyHeight).abs() < 0.5) {
      return;
    }
    setState(() => _measuredBodyHeight = next);
  }

  @override
  Widget build(BuildContext context) {
    final double pillHeight = kGooeySurfacePillHeight;
    final double blur = widget.enableGooeyBlur
        ? widget.roundness * _kBlurRatio
        : 0.0;
    final double pillBase = pillHeight + blur * 3;
    final double rawBody = _hasBody
        ? (_measuredBodyHeight + pillHeight)
              .clamp(pillHeight * _kMinExpandRatio, 1000.0)
              .toDouble()
        : pillHeight * _kMinExpandRatio;
    if (_targetOpen) {
      _frozenBodyHeight = rawBody;
    }
    // Measure with the style the pill paints (ambient + theme, family incl.).
    final TextStyle titleStyle = DefaultTextStyle.of(
      context,
    ).style.merge(widget.titleStyle);
    final double pillWidth = GooeySurfacePill.measureWidth(
      title: widget.title,
      style: titleStyle,
      direction: Directionality.of(context),
      pillHeight: pillHeight,
      maxWidth: widget.width,
    );
    final double alignX = widget.compactAlignment.x;
    final double pillX = alignX <= -0.5
        ? 0
        : alignX >= 0.5
        ? widget.width - pillWidth
        : (widget.width - pillWidth) / 2;
    return MouseRegion(
      onEnter: (PointerEnterEvent event) => _setHovered(true),
      onExit: (PointerExitEvent event) => _setHovered(false),
      child: Listener(
        onPointerDown: (PointerDownEvent event) => _setPressed(true),
        onPointerUp: (PointerUpEvent event) => _setPressed(false),
        onPointerCancel: (PointerCancelEvent event) => _setPressed(false),
        child: AnimatedBuilder(
          animation: _openCurve,
          builder: (BuildContext context, Widget? child) => GooeySurfaceFrame(
            ready: _ready,
            progress: _openCurve.value,
            width: widget.width,
            pillHeight: pillHeight,
            pillBase: pillBase,
            targetHeight: _targetOpen ? rawBody : _frozenBodyHeight,
            pillWidth: pillWidth,
            pillX: pillX,
            roundness: widget.roundness,
            color: widget.fill.resolve(ShadcnTheme.of(context).colors),
            fillAlpha: widget.fillAlpha,
            blur: blur,
            surfaceBlur: widget.surfaceBlur,
            enableGooeyBlur: widget.enableGooeyBlur,
            expandUp: widget.expandUp,
            bodyAnimation: widget.bodyAnimation,
            pill: GooeySurfacePill(
              title: widget.title,
              titleStyle: titleStyle,
              width: pillWidth,
              height: pillHeight,
              morphKey: widget.morphKey,
              leading: widget.leading,
              expandUp: widget.expandUp,
              onTap: _hasBody ? _toggle : null,
            ),
            body: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget? _buildBody() {
    if (!_hasBody) {
      return null;
    }
    return GooeySurfaceBody(
      width: widget.width,
      onSizeChanged: _onBodyMeasured,
      description: widget.description,
      descriptionStyle: widget.descriptionStyle,
      body: widget.body,
      action: widget.action,
    );
  }
}
