import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/animation.dart';
import '../../primitives/clickable.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'feature_carousel_style.dart';

export 'feature_carousel_style.dart';

typedef FeatureCarouselCardBuilder =
    Widget Function(
      BuildContext context,
      FeatureCarouselItem item,
      int index,
      FeatureCarouselTheme theme,
    );

class FeatureCarousel extends StatefulWidget {
  const FeatureCarousel({
    super.key,
    required this.items,
    this.controller,
    this.width,
    this.height,
    this.theme,
    this.cardBuilder,
    this.autofocus = false,
  });

  final List<FeatureCarouselItem> items;

  final FeatureCarouselController? controller;

  final double? width;

  final double? height;

  final FeatureCarouselTheme? theme;

  final FeatureCarouselCardBuilder? cardBuilder;

  final bool autofocus;

  @override
  State<FeatureCarousel> createState() => _FeatureCarouselState();
}

class _FeatureCarouselState extends State<FeatureCarousel> {
  late FeatureCarouselController _config;
  FeatureCarouselController? _owned;
  int _index = 0;
  double _direction = 1;
  double _drag = 0;
  Timer? _timer;
  bool _lastAutoPlay = false;
  Duration _lastInterval = Duration.zero;

  int get _max => widget.items.isEmpty ? 0 : widget.items.length - 1;

  @override
  void initState() {
    super.initState();
    _attach();
    _index = _config.index.clamp(0, _max);
    _lastAutoPlay = _config.autoPlay;
    _lastInterval = _config.autoPlayInterval;
    _autoplay();
  }

  void _attach() {
    _owned = widget.controller == null ? FeatureCarouselController() : null;
    _config = widget.controller ?? _owned!;
    _config.addListener(_onConfig);
  }

  @override
  void didUpdateWidget(covariant FeatureCarousel old) {
    super.didUpdateWidget(old);
    final bool controllerChanged = old.controller != widget.controller;
    if (controllerChanged) {
      _config.removeListener(_onConfig);
      _owned?.dispose();
      _attach();
    }
    if (widget.items.isNotEmpty) {
      _index = _index.clamp(0, _max);
    }
    // A parent rebuild must not restart the autoplay timer: only restart when
    // the controller instance, the item count, or an autoplay field changed.
    final bool autoplayChanged =
        controllerChanged ||
        old.items.length != widget.items.length ||
        _config.autoPlay != _lastAutoPlay ||
        _config.autoPlayInterval != _lastInterval;
    if (autoplayChanged) {
      _autoplay();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _config.removeListener(_onConfig);
    _owned?.dispose();
    super.dispose();
  }

  void _onConfig() {
    if (!mounted) {
      return;
    }
    setState(() => _index = _config.index.clamp(0, _max));
    _autoplay();
  }

  void _autoplay() {
    _timer?.cancel();
    _lastAutoPlay = _config.autoPlay;
    _lastInterval = _config.autoPlayInterval;
    if (!_config.autoPlay || widget.items.length <= 1) {
      return;
    }
    _timer = Timer.periodic(_config.autoPlayInterval, (_) {
      if (mounted) {
        _go(1, auto: true);
      }
    });
  }

  void _go(int delta, {bool auto = false}) {
    if (widget.items.isEmpty) {
      return;
    }
    // The controller setter notifies, which drives `_onConfig` → `setState`,
    // so no explicit `setState` here (it double-rebuilt before).
    _direction = delta >= 0 ? 1 : -1;
    _index = (_index + delta) % widget.items.length;
    _config.index = _index;
    if (!auto) {
      _autoplay();
    }
  }

  void _onDrag(DragUpdateDetails details) {
    if (_config.enableSwipe) {
      _drag += details.delta.dx;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_config.enableSwipe) {
      return;
    }
    final double velocity = details.primaryVelocity ?? 0;
    final double distance = _drag;
    _drag = 0;
    if (velocity.abs() > 550) {
      _go(velocity < 0 ? 1 : -1);
    } else if (distance.abs() > 40) {
      _go(distance < 0 ? 1 : -1);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final FeatureCarouselTheme theme =
        resolveComponentStyle<FeatureCarouselTheme, FeatureCarouselTheme>(
          context,
          widget: widget.theme,
          select: (t) => t,
          defaults: featureCarouselDefaults,
        );
    final ShadcnColors colors = ambient.colors;
    final FeatureCarouselItem item = widget.items[_index];
    final double gap = ambient.spacing.sm;
    final double scaling = ambient.scaling;
    final Color textColor = theme.controlForeground!.resolve(colors);
    final Widget body = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _text(item.title, colors.foreground, FontWeight.w500, null, scaling),
        Gap(gap * 2.25),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double want = widget.width ?? featureCarouselDefaultWidth;
            final double viewportWidth = constraints.maxWidth.isFinite
                ? (want > constraints.maxWidth ? constraints.maxWidth : want)
                : want;
            return SizedBox(
              width: viewportWidth,
              height: widget.height ?? featureCarouselDefaultHeight,
              child: _viewport(theme, colors, item),
            );
          },
        ),
        Gap(gap * 2.75),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal:
                ambient.density.baseContentPadding * ambient.scaling * 1.25,
          ),
          child: _text(
            item.description,
            textColor,
            FontWeight.w400,
            1.35,
            scaling,
          ),
        ),
        if (_config.showCta) ...<Widget>[
          Gap(gap * 2.25),
          _cta(theme, colors, scaling),
        ],
      ],
    );
    final Widget stack = Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned.fill(child: ColoredBox(color: colors.background)),
        body,
      ],
    );
    final Widget labelled = Semantics(label: 'Feature carousel', child: stack);
    return _config.enableKeyboardNavigation ? _keyboard(labelled) : labelled;
  }

  Widget _viewport(
    FeatureCarouselTheme theme,
    ShadcnColors colors,
    FeatureCarouselItem item,
  ) {
    final Color border = theme.cardBorder!.resolve(colors);
    final List<BoxShadow> shadow = featureCarouselCardShadow(context, theme);
    final Widget card =
        widget.cardBuilder?.call(context, item, _index, theme) ??
        FeatureCarouselCenterCard(
          item: item,
          radius: theme.radius!,
          fill: theme.cardFill!.resolve(colors),
          border: border,
          accent: (item.accentColor ?? theme.accentColor!).resolve(colors),
          shadow: shadow,
        );
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        for (final int i in <int>[3, 2, 1])
          FeatureCarouselGhostCard(
            indexFromFront: i,
            radius: theme.radius!,
            fill: theme.ghostFill!.resolve(colors),
            border: border,
          ),
        GestureDetector(
          onHorizontalDragUpdate: _onDrag,
          onHorizontalDragEnd: _onDragEnd,
          child: AnimatedSwitcher(
            duration: theme.transitionDuration!,
            switchInCurve: featureCarouselTransitionCurve,
            switchOutCurve: featureCarouselTransitionCurve,
            transitionBuilder: (Widget child, Animation<double> value) {
              return AnimatedStyleTransition(
                animation: value,
                curve: featureCarouselTransitionCurve,
                style: featureCarouselTransitionStyle(
                  _config.animationStyle,
                  _direction,
                ),
                child: child,
              );
            },
            child: KeyedSubtree(key: ValueKey<int>(_index), child: card),
          ),
        ),
        if (_config.showNavArrows)
          Positioned(left: 0, child: _arrow(false, theme, colors)),
        if (_config.showNavArrows)
          Positioned(right: 0, child: _arrow(true, theme, colors)),
      ],
    );
  }

  Widget _arrow(bool next, FeatureCarouselTheme theme, ShadcnColors colors) {
    return _control(
      onPressed: () => _go(next ? 1 : -1),
      label: next ? 'Next' : 'Previous',
      background: theme.controlBackground!.resolve(colors),
      foreground: theme.controlForeground!.resolve(colors),
      width: featureCarouselDefaultArrowSize,
      height: featureCarouselDefaultArrowSize,
      radius: BorderRadius.circular(theme.radius ?? 12),
      child: Icon(
        next ? LucideIcons.chevronRight : LucideIcons.chevronLeft,
        size: 24,
      ),
    );
  }

  Widget _cta(FeatureCarouselTheme theme, ShadcnColors colors, double scaling) {
    return _control(
      onPressed: () {
        if (widget.items.isNotEmpty) {
          _config.onPrimaryAction?.call(widget.items[_index], _index);
        }
      },
      background: theme.controlBackground!.resolve(colors),
      foreground: theme.controlForeground!.resolve(colors),
      height: featureCarouselDefaultCtaHeight,
      minWidth: featureCarouselDefaultCtaMinWidth,
      radius: BorderRadius.circular(featureCarouselDefaultCtaHeight / 2),
      child: Text(
        _config.primaryActionLabel,
        style: TextStyle(fontSize: 16 * scaling, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _control({
    required VoidCallback onPressed,
    required Color background,
    required Color foreground,
    required Widget child,
    double? width,
    double? height,
    double? minWidth,
    BorderRadiusGeometry? radius,
    String? label,
  }) {
    return Semantics(
      button: true,
      label: label,
      child: Clickable(
        onPressed: onPressed,
        mouseCursor: const WidgetStatePropertyAll<MouseCursor>(
          SystemMouseCursors.click,
        ),
        decoration: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
          final bool lit =
              states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.pressed);
          final Color fill = lit
              ? background.withValues(
                  alpha: (background.a * 0.5).clamp(0.0, 1.0),
                )
              : background;
          return BoxDecoration(color: fill, borderRadius: radius);
        }),
        textStyle: WidgetStatePropertyAll<TextStyle>(
          TextStyle(color: foreground),
        ),
        iconTheme: WidgetStatePropertyAll<IconThemeData>(
          IconThemeData(color: foreground),
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: minWidth ?? 0),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }

  Widget _text(
    String? value,
    Color color,
    FontWeight weight,
    double? height,
    double scaling,
  ) {
    if (value == null) {
      return const SizedBox.shrink();
    }
    return Text(
      value,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: featureCarouselDefaultFontSize * scaling,
        fontWeight: weight,
        height: height,
        color: color,
      ),
    );
  }

  Widget _keyboard(Widget child) {
    return FocusableActionDetector(
      autofocus: widget.autofocus,
      shortcuts: <ShortcutActivator, Intent>{
        const SingleActivator(LogicalKeyboardKey.arrowLeft):
            const _CarouselIntent(_CarouselAction.previous),
        const SingleActivator(LogicalKeyboardKey.arrowRight):
            const _CarouselIntent(_CarouselAction.next),
        const SingleActivator(LogicalKeyboardKey.enter): const _CarouselIntent(
          _CarouselAction.primary,
        ),
        const SingleActivator(LogicalKeyboardKey.space): const _CarouselIntent(
          _CarouselAction.primary,
        ),
      },
      actions: <Type, Action<Intent>>{
        _CarouselIntent: CallbackAction<_CarouselIntent>(
          onInvoke: (_CarouselIntent intent) {
            switch (intent.action) {
              case _CarouselAction.previous:
                _go(-1);
              case _CarouselAction.next:
                _go(1);
              case _CarouselAction.primary:
                if (widget.items.isNotEmpty) {
                  _config.onPrimaryAction?.call(widget.items[_index], _index);
                }
            }
            return null;
          },
        ),
      },
      child: child,
    );
  }
}

enum _CarouselAction { previous, next, primary }

class _CarouselIntent extends Intent {
  const _CarouselIntent(this.action);

  final _CarouselAction action;
}
