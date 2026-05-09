// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../menu.dart';

/// _MenuGroupState defines a reusable type for this registry module.
class _MenuGroupState extends State<MenuGroup> {
  /// Stores `_data` state/configuration for this implementation.
  late List<MenuData> _data;

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _data = List.generate(widget.children.length, (i) {
      return MenuData();
    });
  }

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant MenuGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.children, widget.children)) {
      /// Stores `oldKeyedData` state/configuration for this implementation.
      Map<Key, MenuData> oldKeyedData = {};
      for (int i = 0; i < oldWidget.children.length; i++) {
        oldKeyedData[oldWidget.children[i].key ?? ValueKey(i)] = _data[i];
      }
      _data = List.generate(widget.children.length, (i) {
        /// Stores `child` state/configuration for this implementation.
        var child = widget.children[i];
        var key = child.key ?? ValueKey(i);

        /// Stores `oldData` state/configuration for this implementation.
        var oldData = oldKeyedData[key];
        if (oldData != null) {
          if (child.popoverController != null &&
              oldData.popoverController != child.popoverController) {
            oldData.popoverController.dispose();
            oldData = MenuData(popoverController: child.popoverController);
          }
        } else {
          oldData = MenuData(popoverController: child.popoverController);
        }
        return oldData;
      });
      // dispose unused data
      for (var data in oldKeyedData.values) {
        if (!_data.contains(data)) {
          data.popoverController.dispose();
        }
      }
    }
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    for (var data in _data) {
      data.popoverController.dispose();
    }
    super.dispose();
  }

  /// Executes `closeAll` behavior for this component/composite.
  void closeAll() {
    /// Stores `data` state/configuration for this implementation.
    MenuGroupData? data = widget.parent;
    if (data == null) {
      widget.onDismissed?.call();
      return;
    }
    data.closeOthers();
    data.closeAll();
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final parentGroupData = Data.maybeOf<MenuGroupData>(context);
    final menubarData = Data.maybeOf<MenubarState>(context);
    final compTheme = ComponentTheme.maybeOf<MenuTheme>(context);
    final itemPadding =
        widget.itemPadding ?? compTheme?.itemPadding ?? EdgeInsets.zero;

    /// Stores `subMenuOffset` state/configuration for this implementation.
    final subMenuOffset = widget.subMenuOffset ?? compTheme?.subMenuOffset;

    /// Stores `children` state/configuration for this implementation.
    List<Widget> children = [];

    /// Stores `hasLeading` state/configuration for this implementation.
    bool hasLeading = false;
    for (int i = 0; i < widget.children.length; i++) {
      /// Stores `child` state/configuration for this implementation.
      final child = widget.children[i];

      /// Stores `data` state/configuration for this implementation.
      final data = _data[i];
      if (child.hasLeading) {
        hasLeading = true;
      }
      children.add(Data<MenuData>.inherit(data: data, child: child));
    }
    final direction = Directionality.of(context);
    return SubFocusScope(
      autofocus: widget.autofocus,
      builder: (context, scope) {
        return Actions(
          actions: {
            NextMenuFocusIntent: CallbackAction<NextMenuFocusIntent>(
              onInvoke: (intent) {
                /// Creates a `scope.nextFocus` instance.
                scope.nextFocus(
                  intent.forward
                      ? widget.direction == Axis.horizontal
                            ? TraversalDirection.left
                            : TraversalDirection.up
                      : widget.direction == Axis.horizontal
                      ? TraversalDirection.right
                      : TraversalDirection.down,
                );
                return;
              },
            ),
            DirectionalMenuFocusIntent: CallbackAction<DirectionalMenuFocusIntent>(
              onInvoke: (intent) {
                if (widget.direction == Axis.vertical) {
                  if (intent.direction == TraversalDirection.left) {
                    if (direction == TextDirection.ltr) {
                      for (final menu in parentGroupData?.children ?? []) {
                        menu.popoverController.close();
                      }
                      return;
                    } else {}
                  } else if (intent.direction == TraversalDirection.right) {
                    if (direction == TextDirection.ltr) {
                      bool? result =
                          /// Creates a `scope.invokeActionOnFocused` instance.
                          scope.invokeActionOnFocused(
                                /// Creates a `OpenSubMenuIntent` instance.
                                const OpenSubMenuIntent(),
                              )
                              as bool?;
                      if (result != true) {
                        parentGroupData?.root.focusScope.nextFocus(
                          TraversalDirection.right,
                        );
                      }
                      return;
                    } else {}
                  }
                }
                if (!scope.nextFocus(intent.direction)) {
                  for (final menu in parentGroupData?.children ?? []) {
                    menu.popoverController.close();
                  }
                  parentGroupData?.focusScope.nextFocus(intent.direction);
                }
                return;
              },
            ),
            CloseMenuIntent: CallbackAction<CloseMenuIntent>(
              onInvoke: (intent) {
                closeAll();
                return;
              },
            ),
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (intent) {
                scope.invokeActionOnFocused(const ActivateIntent());
                return;
              },
            ),
            ...widget.actions,
          },
          child: Shortcuts(
            shortcuts: {
              /// Creates a `SingleActivator` instance.
              const SingleActivator(LogicalKeyboardKey.arrowUp):
                  /// Creates a `DirectionalMenuFocusIntent` instance.
                  const DirectionalMenuFocusIntent(TraversalDirection.up),

              /// Creates a `SingleActivator` instance.
              const SingleActivator(LogicalKeyboardKey.arrowDown):
                  /// Creates a `DirectionalMenuFocusIntent` instance.
                  const DirectionalMenuFocusIntent(TraversalDirection.down),

              /// Creates a `SingleActivator` instance.
              const SingleActivator(LogicalKeyboardKey.arrowLeft):
                  /// Creates a `DirectionalMenuFocusIntent` instance.
                  const DirectionalMenuFocusIntent(TraversalDirection.left),

              /// Creates a `SingleActivator` instance.
              const SingleActivator(LogicalKeyboardKey.arrowRight):
                  /// Creates a `DirectionalMenuFocusIntent` instance.
                  const DirectionalMenuFocusIntent(TraversalDirection.right),

              /// Creates a `SingleActivator` instance.
              const SingleActivator(
                LogicalKeyboardKey.tab,
              ): DirectionalMenuFocusIntent(
                widget.direction == Axis.vertical
                    ? TraversalDirection.down
                    : TraversalDirection.right,
              ),

              /// Creates a `SingleActivator` instance.
              const SingleActivator(
                LogicalKeyboardKey.tab,
                shift: true,
              ): DirectionalMenuFocusIntent(
                widget.direction == Axis.vertical
                    ? TraversalDirection.up
                    : TraversalDirection.left,
              ),

              /// Creates a `SingleActivator` instance.
              const SingleActivator(LogicalKeyboardKey.escape):
                  /// Creates a `CloseMenuIntent` instance.
                  const CloseMenuIntent(),

              /// Creates a `SingleActivator` instance.
              const SingleActivator(LogicalKeyboardKey.enter):
                  /// Creates a `ActivateIntent` instance.
                  const ActivateIntent(),

              /// Creates a `SingleActivator` instance.
              const SingleActivator(LogicalKeyboardKey.space):
                  /// Creates a `ActivateIntent` instance.
                  const ActivateIntent(),

              /// Creates a `SingleActivator` instance.
              const SingleActivator(LogicalKeyboardKey.backspace):
                  /// Creates a `CloseMenuIntent` instance.
                  const CloseMenuIntent(),

              /// Creates a `SingleActivator` instance.
              const SingleActivator(LogicalKeyboardKey.numpadEnter):
                  /// Creates a `ActivateIntent` instance.
                  const ActivateIntent(),
            },
            child: Focus(
              autofocus: menubarData == null,
              focusNode: widget.focusNode,
              child: Data.inherit(
                data: MenuGroupData(
                  widget.parent,
                  _data,
                  hasLeading,
                  subMenuOffset,
                  widget.onDismissed,
                  widget.regionGroupId,
                  widget.direction,
                  itemPadding,
                  scope,
                ),
                child: Builder(
                  builder: (context) {
                    return widget.builder(context, children);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Intent for closing the current menu via keyboard action.
///
/// Used with keyboard shortcuts to dismiss open menus.
