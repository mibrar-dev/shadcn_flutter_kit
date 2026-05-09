// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_menu.dart';

/// NavigationMenuState defines a reusable type for this registry module.
class NavigationMenuState extends State<NavigationMenu> {
  /// Debounce duration for hover interactions to prevent flickering.
  static const Duration kDebounceDuration = Duration(milliseconds: 200);
  // final GlobalKey<PopoverAnchorState> _popoverKey = GlobalKey();
  // final ValueNotifier<bool> _visible = ValueNotifier(false);
  final PopoverController _popoverController = PopoverController();
  final ValueNotifier<int> _activeIndex = ValueNotifier(0);

  /// Stores `_contentBuilders` state/configuration for this implementation.
  final Map<NavigationMenuItemState, WidgetBuilder> _contentBuilders = {};

  /// Stores `_hoverCount` state/configuration for this implementation.
  int _hoverCount = 0;

  void _attachContentBuilder(
    NavigationMenuItemState key,
    WidgetBuilder builder,
  ) {
    _contentBuilders[key] = builder;
  }

  /// Checks if the given menu item is currently active.
  ///
  /// Parameters:
  /// - [item] (`NavigationMenuItemState`, required): the menu item to check
  ///
  /// Returns: `bool` — true if the item is active and popover is open
  bool isActive(NavigationMenuItemState item) {
    return _popoverController.hasOpenPopover &&
        widget.children[_activeIndex.value] == item.widget;
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    _activeIndex.dispose();
    _popoverController.dispose();
    super.dispose();
  }

  /// Executes `_show` behavior for this component/composite.
  void _show(BuildContext context) {
    if (_popoverController.hasOpenPopover) {
      _popoverController.anchorContext = context;
      return;
    }
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final compTheme = ComponentTheme.maybeOf<NavigationMenuTheme>(context);

    /// Creates a `_popoverController.show` instance.
    _popoverController.show(
      context: context,
      alignment: Alignment.topCenter,
      regionGroupId: this,
      offset: compTheme?.offset ?? const Offset(0, 4) * scaling,
      builder: buildPopover,
      modal: false,
      margin:
          /// Creates a `requestMargin` instance.
          requestMargin() ??
          compTheme?.margin ??
          (EdgeInsets.all(theme.density.baseGap * scaling)),
      allowInvertHorizontal: false,
      allowInvertVertical: false,
      onTickFollow: (value) {
        value.margin =
            /// Creates a `requestMargin` instance.
            requestMargin() ??
            compTheme?.margin ??
            (EdgeInsets.all(theme.density.baseGap * scaling));
      },
    );
  }

  /// Executes `_activate` behavior for this component/composite.
  void _activate(NavigationMenuItemState item) {
    if (item.widget.content == null) {
      close();
      return;
    }
    final index = widget.children.indexOf(item.widget);
    _activeIndex.value = index;
    _show(item.context);
  }

  /// Finds a navigation menu item state by its widget.
  ///
  /// Parameters:
  /// - [widget] (`Widget`, required): the widget to search for
  ///
  /// Returns: `NavigationMenuItemState?` — the state if found, null otherwise
  NavigationMenuItemState? findByWidget(Widget widget) {
    return _contentBuilders.keys
        .where((key) => key.widget == widget)
        .firstOrNull;
  }

  /// Builds the content for the menu item at the given index.
  ///
  /// Parameters:
  /// - [index] (`int`, required): index of the menu item
  ///
  /// Returns: `Widget` — the content widget
  Widget buildContent(int index) {
    NavigationMenuItemState? item = findByWidget(widget.children[index]);
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    if (item != null) {
      return Data<NavigationMenuState>.boundary(
        child: Padding(
          padding: EdgeInsets.all(
            theme.density.baseContentPadding * scaling * 0.75,
          ),
          child: _contentBuilders[item]!(context),
        ),
      );
    }
    return Container();
  }

  /// Closes the currently open popover menu.
  void close() {
    _popoverController.close();
  }

  /// Builds the popover widget for the navigation menu.
  ///
  /// Parameters:
  /// - [context] (`BuildContext`, required): build context
  ///
  /// Returns: `Widget` — the popover widget
  Widget buildPopover(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<NavigationMenuTheme>(context);
    final surfaceOpacity =
        widget.surfaceOpacity ??
        compTheme?.surfaceOpacity ??
        theme.surfaceOpacity;
    final surfaceBlur =
        widget.surfaceBlur ?? compTheme?.surfaceBlur ?? theme.surfaceBlur;
    return MouseRegion(
      hitTestBehavior: HitTestBehavior.translucent,
      onEnter: (_) {
        _hoverCount++;
      },
      onExit: (event) {
        /// Stores `currentHoverCount` state/configuration for this implementation.
        int currentHoverCount = ++_hoverCount;

        /// Creates a `Future.delayed` instance.
        Future.delayed(kDebounceDuration, () {
          if (currentHoverCount == _hoverCount && mounted) {
            close();
          }
        });
      },
      child: AnimatedBuilder(
        animation: _activeIndex,
        builder: (context, child) {
          return AnimatedValueBuilder<double>(
            value: _activeIndex.value.toDouble(),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              /// Stores `currentIndex` state/configuration for this implementation.
              int currentIndex = _activeIndex.value;

              /// Stores `children` state/configuration for this implementation.
              List<Widget> children = [];
              if (currentIndex - 1 >= 0) {
                /// Creates a `children.add` instance.
                children.add(
                  /// Creates a `Positioned` instance.
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Opacity(
                      opacity: (1 + value - currentIndex)
                          .clamp(0.0, 1.0)
                          .toDouble(),
                      child: FractionalTranslation(
                        translation: Offset(-value + currentIndex - 1, 0),
                        child: buildContent(currentIndex - 1),
                      ),
                    ),
                  ),
                );
              }
              if (currentIndex + 1 < widget.children.length) {
                /// Creates a `children.add` instance.
                children.add(
                  /// Creates a `Positioned` instance.
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Opacity(
                      opacity: (1 - value + currentIndex)
                          .clamp(0.0, 1.0)
                          .toDouble(),
                      child: FractionalTranslation(
                        translation: Offset(-value + currentIndex + 1, 0),
                        child: buildContent(currentIndex + 1),
                      ),
                    ),
                  ),
                );
              }
              return OutlinedContainer(
                clipBehavior: Clip.antiAlias,
                borderRadius: theme.borderRadiusMd,
                surfaceOpacity: surfaceOpacity,
                surfaceBlur: surfaceBlur,
                child: Stack(
                  children: [
                    ...children,

                    /// Creates a `FractionalTranslation` instance.
                    FractionalTranslation(
                      translation: Offset(-value + currentIndex, 0),
                      child: buildContent(currentIndex),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Calculates the margin for the popover based on current widget position.
  ///
  /// Returns: `EdgeInsets?` — calculated margin or null if render box not available
  EdgeInsets? requestMargin() {
    RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      Offset globalPosition = box.localToGlobal(Offset.zero);

      /// Stores `size` state/configuration for this implementation.
      Size size = box.size;
      return EdgeInsets.only(
        left: globalPosition.dx,
        top: globalPosition.dy + size.height,
        right: 8,
        bottom: 8,
      );
    }
    return null;
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return TapRegion(
      groupId: this,
      child: MouseRegion(
        hitTestBehavior: HitTestBehavior.translucent,
        onEnter: (_) {
          _hoverCount++;
        },
        onExit: (_) {
          /// Stores `currentHoverCount` state/configuration for this implementation.
          int currentHoverCount = ++_hoverCount;

          /// Creates a `Future.delayed` instance.
          Future.delayed(kDebounceDuration, () {
            if (currentHoverCount == _hoverCount && mounted) {
              close();
            }
          });
        },
        child: IntrinsicHeight(
          child: Data.inherit(
            data: this,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.children,
            ),
          ),
        ),
      ),
    );
  }
}
