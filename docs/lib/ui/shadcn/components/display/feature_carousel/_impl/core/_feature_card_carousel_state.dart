// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../feature_carousel.dart';

/// _FeatureCardCarouselState holds mutable state for the feature carousel implementation.
class _FeatureCardCarouselState extends State<FeatureCardCarousel>
    with SingleTickerProviderStateMixin {
  late int _index;

  late AnimationController _controller;

  _CarouselDirection _direction = _CarouselDirection.right;

  bool _leftPressed = false;

  bool _rightPressed = false;

  bool _ctaPressed = false;

  bool _leftHover = false;

  bool _rightHover = false;

  int _animationIndex = 0;

  Timer? _autoTimer;

  FeatureCarouselController? _ownedController;

  late FeatureCarouselController _config;

  double _dragDistance = 0;

  FeatureCarouselThemeData get _theme =>
      widget.theme ?? FeatureCarouselThemeData.defaults();

  /// Implements `_resolveTheme` behavior for feature carousel.
  FeatureCarouselThemeData _resolveTheme(BuildContext context) {
    if (widget.theme != null) {
      return _theme;
    }
    final scheme = shadcn_theme.Theme.of(context).colorScheme;
    return _theme.copyWith(
      backgroundColor: scheme.background,
      cardFillColor: scheme.card,
      cardBorderColor: scheme.border,
      ghostFillColor: scheme.muted,
      ghostBorderColor: scheme.border.withValues(alpha: 0.4),
      arrowBackground: scheme.muted.withValues(alpha: 0.35),
      arrowIconColor: scheme.mutedForeground,
      ctaBackground: scheme.muted.withValues(alpha: 0.3),
      ctaBorderColor: scheme.border.withValues(alpha: 0.55),
      ctaTextColor: scheme.foreground,
      titleColor: scheme.mutedForeground,
      descriptionColor: scheme.mutedForeground,
      accentColor: scheme.primary,
    );
  }

  /// Initializes controllers and listeners required by feature carousel.
  @override
  void initState() {
    super.initState();
    _config = widget.controller ?? _createOwnedController();
    _config.addListener(_handleControllerChange);
    _index = _config.index.clamp(0, widget.items.length - 1);
    _controller = AnimationController(
      vsync: this,
      duration: _theme.transitionDuration,
    );
    _controller.value = 1;
    _startAutoPlay();
  }

  /// Updates internal state when feature carousel configuration changes.
  @override
  void didUpdateWidget(FeatureCardCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChange);
      if (widget.controller != null) {
        _ownedController?.dispose();
        _ownedController = null;
        _config = widget.controller!;
        _config.addListener(_handleControllerChange);
      } else {
        _config = _createOwnedController();
        _config.addListener(_handleControllerChange);
      }
    }
    if (oldWidget.items.length != widget.items.length) {
      _index = _index.clamp(0, widget.items.length - 1);
    }
    _startAutoPlay();
  }

  /// Disposes resources allocated by this feature carousel state.
  @override
  void dispose() {
    _controller.dispose();
    _autoTimer?.cancel();
    _config.removeListener(_handleControllerChange);
    _ownedController?.dispose();
    super.dispose();
  }

  /// Implements `_createOwnedController` behavior for feature carousel.
  FeatureCarouselController _createOwnedController() {
    _ownedController?.dispose();
    _ownedController = FeatureCarouselController();
    return _ownedController!;
  }

  /// Implements `_handleControllerChange` behavior for feature carousel.
  void _handleControllerChange() {
    if (!mounted) return;

    /// Implements `setState` behavior for feature carousel.
    setState(() {
      _index = _config.index.clamp(0, widget.items.length - 1);
    });
    _startAutoPlay();
  }

  /// Implements `_startAutoPlay` behavior for feature carousel.
  void _startAutoPlay() {
    _autoTimer?.cancel();
    if (!_config.autoPlay || widget.items.length <= 1) {
      return;
    }
    _autoTimer = Timer.periodic(_config.autoPlayInterval, (_) {
      if (!mounted) return;
      _goRight(auto: true);
    });
  }

  /// Implements `_changeIndex` behavior for feature carousel.
  void _changeIndex(int next, _CarouselDirection direction) {
    if (widget.items.isEmpty) {
      return;
    }

    /// Implements `setState` behavior for feature carousel.
    setState(() {
      _direction = direction;
      _index = (next + widget.items.length) % widget.items.length;
      _config.index = _index;
      if (_config.cycleAnimationStyles) {
        _animationIndex =
            (_animationIndex + 1) % FeatureCarouselAnimationStyle.values.length;
      }
    });
    _controller.forward(from: 0);
  }

  /// Implements `_goLeft` behavior for feature carousel.
  void _goLeft({bool auto = false}) {
    _changeIndex(_index - 1, _CarouselDirection.left);
    if (!auto) {
      _startAutoPlay();
    }
  }

  /// Implements `_goRight` behavior for feature carousel.
  void _goRight({bool auto = false}) {
    _changeIndex(_index + 1, _CarouselDirection.right);
    if (!auto) {
      _startAutoPlay();
    }
  }

  /// Implements `_handleCta` behavior for feature carousel.
  void _handleCta() {
    if (widget.items.isEmpty) {
      return;
    }
    _config.onPrimaryAction?.call(widget.items[_index], _index);
    if (!kIsWeb) {
      HapticFeedback.lightImpact();
    }
  }

  /// Implements `_handleDragEnd` behavior for feature carousel.
  void _handleDragEnd(DragEndDetails details) {
    if (!_config.enableSwipe) {
      return;
    }

    final dragDistance = _dragDistance;
    _dragDistance = 0;

    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() > 550) {
      velocity < 0 ? _goRight() : _goLeft();
      return;
    }
    if (dragDistance.abs() > 40) {
      dragDistance < 0 ? _goRight() : _goLeft();
    }
  }

  /// Implements `_handleDragUpdate` behavior for feature carousel.
  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_config.enableSwipe) {
      return;
    }
    _dragDistance += details.delta.dx;
  }

  FeatureCarouselAnimationStyle get _resolvedAnimationStyle {
    if (!_config.cycleAnimationStyles) {
      return _config.animationStyle;
    }
    return FeatureCarouselAnimationStyle.values[_animationIndex %
        FeatureCarouselAnimationStyle.values.length];
  }

  /// Implements `_buildTransition` behavior for feature carousel.
  Widget _buildTransition(Widget child, Animation<double> animation) {
    final direction = _direction == _CarouselDirection.right ? 1 : -1;
    final curve = CurvedAnimation(
      parent: animation,
      curve: _theme.transitionCurve,
    );
    switch (_resolvedAnimationStyle) {
      case FeatureCarouselAnimationStyle.crossfadeScale:
        return FadeTransition(
          opacity: curve,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.985, end: 1).animate(curve),
            child: child,
          ),
        );
      case FeatureCarouselAnimationStyle.blurFade:
        return FadeTransition(
          opacity: curve,
          child: AnimatedBuilder(
            animation: curve,
            builder: (context, _) {
              final sigma = (1 - curve.value) * 4;
              return ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                child: child,
              );
            },
          ),
        );
      case FeatureCarouselAnimationStyle.rotateParallax:
        return FadeTransition(
          opacity: curve,
          child: Transform.translate(
            offset: Offset(
              12 * direction * (1 - curve.value),
              6 * (1 - curve.value),
            ),
            child: Transform.rotate(
              angle: (1 - curve.value) * (direction * 0.03),
              child: Transform.scale(
                scale: Tween<double>(begin: 0.985, end: 1).animate(curve).value,
                child: child,
              ),
            ),
          ),
        );
      case FeatureCarouselAnimationStyle.liftFade:
        return FadeTransition(
          opacity: curve,
          child: Transform.translate(
            offset: Offset(0, 12 * (1 - curve.value)),
            child: Transform.scale(
              scale: Tween<double>(begin: 0.99, end: 1).animate(curve).value,
              child: child,
            ),
          ),
        );
      case FeatureCarouselAnimationStyle.slideFade:
        final slide = Tween<Offset>(
          begin: Offset(0.05 * direction, 0),
          end: Offset.zero,
        ).animate(curve);
        return FadeTransition(
          opacity: curve,
          child: SlideTransition(
            position: slide,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.985, end: 1).animate(curve),
              child: child,
            ),
          ),
        );
      case FeatureCarouselAnimationStyle.slideUpFade:
        return FadeTransition(
          opacity: curve,
          child: Transform.translate(
            offset: Offset(0, 14 * (1 - curve.value)),
            child: child,
          ),
        );
      case FeatureCarouselAnimationStyle.slideDownFade:
        return FadeTransition(
          opacity: curve,
          child: Transform.translate(
            offset: Offset(0, -14 * (1 - curve.value)),
            child: child,
          ),
        );
      case FeatureCarouselAnimationStyle.rotateFade:
        return FadeTransition(
          opacity: curve,
          child: Transform.rotate(
            angle: (1 - curve.value) * 0.04 * direction,
            child: child,
          ),
        );
      case FeatureCarouselAnimationStyle.zoomFade:
        return FadeTransition(
          opacity: curve,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.97, end: 1).animate(curve),
            child: child,
          ),
        );
    }
  }

  /// Builds the widget tree for feature carousel.
  @override
  Widget build(BuildContext context) {
    final theme = shadcn_theme.Theme.of(context);

    final densityGap = theme.density.baseGap * theme.scaling;
    final densityContentPadding =
        theme.density.baseContentPadding * theme.scaling;
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    final resolvedTheme = _resolveTheme(context);

    final width = widget.width ?? resolvedTheme.carouselWidth;

    final height = widget.height ?? resolvedTheme.carouselHeight;

    final cardWidth = resolvedTheme.cardWidth;

    final cardHeight = resolvedTheme.cardHeight;

    final titleStyle = TextStyle(
      fontSize: resolvedTheme.titleFontSize,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
      color: resolvedTheme.titleColor,
    );

    final descriptionStyle = TextStyle(
      fontSize: resolvedTheme.descriptionFontSize,
      height: resolvedTheme.descriptionLineHeight,
      color: resolvedTheme.descriptionColor,
      fontWeight: FontWeight.w400,
    );

    final background =
        widget.backgroundBuilder?.call(context, resolvedTheme) ??
        Container(
          decoration: BoxDecoration(color: resolvedTheme.backgroundColor),
        );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.titleBuilder?.call(context, widget.items[_index], _index) ??
            (widget.items[_index].title != null
                ? Text(
                    widget.items[_index].title!,
                    style: titleStyle,
                    textAlign: TextAlign.center,
                  )
                : const SizedBox.shrink()),

        SizedBox(height: densityGap * 2.25),

        RepaintBoundary(
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _GhostCard(
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                  theme: resolvedTheme,
                  animation: _controller,
                  indexFromFront: 3,
                ),

                _GhostCard(
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                  theme: resolvedTheme,
                  animation: _controller,
                  indexFromFront: 2,
                ),

                _GhostCard(
                  cardWidth: cardWidth,
                  cardHeight: cardHeight,
                  theme: resolvedTheme,
                  animation: _controller,
                  indexFromFront: 1,
                ),

                GestureDetector(
                  onHorizontalDragUpdate: _handleDragUpdate,
                  onHorizontalDragEnd: _handleDragEnd,
                  child: AnimatedSwitcher(
                    duration: _theme.transitionDuration,
                    switchInCurve: _theme.transitionCurve,
                    switchOutCurve: _theme.transitionCurve,
                    transitionBuilder: (child, animation) =>
                        _buildTransition(child, animation),
                    child:
                        widget.cardBuilder?.call(
                          context,
                          widget.items[_index],
                          _index,
                          _theme,
                        ) ??
                        _CenterCard(
                          key: ValueKey(
                            '${_index}_${widget.items[_index].title ?? 'item'}',
                          ),
                          item: widget.items[_index],
                          width: cardWidth,
                          height: cardHeight,
                          theme: resolvedTheme,
                        ),
                  ),
                ),
                if (_config.showNavArrows)
                  Positioned(
                    left: 0,
                    child: _NavArrow(
                      direction: _CarouselDirection.left,
                      size: resolvedTheme.arrowSize,
                      radius: resolvedTheme.arrowRadius,
                      background: resolvedTheme.arrowBackground,
                      iconColor: resolvedTheme.arrowIconColor,
                      pressed: _leftPressed,
                      hovered: _leftHover,
                      onPressed: _goLeft,
                      onPressedChanged: (pressed) {
                        /// Implements `setState` behavior for feature carousel.
                        setState(() => _leftPressed = pressed);
                      },
                      onHoverChanged: (hovered) {
                        /// Implements `setState` behavior for feature carousel.
                        setState(() => _leftHover = hovered);
                      },
                    ),
                  ),
                if (_config.showNavArrows)
                  Positioned(
                    right: 0,
                    child: _NavArrow(
                      direction: _CarouselDirection.right,
                      size: resolvedTheme.arrowSize,
                      radius: resolvedTheme.arrowRadius,
                      background: resolvedTheme.arrowBackground,
                      iconColor: resolvedTheme.arrowIconColor,
                      pressed: _rightPressed,
                      hovered: _rightHover,
                      onPressed: _goRight,
                      onPressedChanged: (pressed) {
                        /// Implements `setState` behavior for feature carousel.
                        setState(() => _rightPressed = pressed);
                      },
                      onHoverChanged: (hovered) {
                        /// Implements `setState` behavior for feature carousel.
                        setState(() => _rightHover = hovered);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),

        SizedBox(height: densityGap * 2.75),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: densityContentPadding * 1.25,
            ),
            child:
                widget.descriptionBuilder?.call(
                  context,
                  widget.items[_index],
                  _index,
                ) ??
                (widget.items[_index].description != null
                    ? Text(
                        widget.items[_index].description!,
                        style: descriptionStyle,
                        textAlign: TextAlign.center,
                      )
                    : const SizedBox.shrink()),
          ),
        ),
        if (_config.showCta) ...[
          SizedBox(height: densityGap * 2.25),
          widget.ctaBuilder?.call(
                context,
                widget.items[_index],
                _index,
                _handleCta,
              ) ??
              _CtaButton(
                label: _config.primaryActionLabel,
                theme: resolvedTheme,
                pressed: _ctaPressed,
                onPressed: _handleCta,
                onPressedChanged: (pressed) {
                  /// Implements `setState` behavior for feature carousel.
                  setState(() => _ctaPressed = pressed);
                },
              ),
        ],
      ],
    );

    final wrapped = Stack(
      alignment: Alignment.center,
      children: [background, content],
    );

    if (!_config.enableKeyboardNavigation) {
      return Semantics(label: 'Feature carousel', child: wrapped);
    }

    return FocusableActionDetector(
      autofocus: false,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.arrowLeft): _CarouselIntent.left,

        LogicalKeySet(LogicalKeyboardKey.arrowRight): _CarouselIntent.right,

        LogicalKeySet(LogicalKeyboardKey.enter): _CarouselIntent.action,

        LogicalKeySet(LogicalKeyboardKey.space): _CarouselIntent.action,
      },
      actions: {
        _CarouselIntent: CallbackAction<_CarouselIntent>(
          onInvoke: (intent) {
            switch (intent.direction) {
              case _CarouselDirection.left:
                _goLeft();
              case _CarouselDirection.right:
                _goRight();
              case null:
                _handleCta();
            }
            return null;
          },
        ),
      },
      child: Semantics(label: 'Feature carousel', child: wrapped),
    );
  }
}
