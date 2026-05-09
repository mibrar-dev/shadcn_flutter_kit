// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../select.dart';

/// _SelectPopupState stores and manages mutable widget state.
class _SelectPopupState<T> extends State<SelectPopup<T>>
    with SelectPopupHandle {
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  SelectData? _selectData;

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _searchController = widget.searchController ?? TextEditingController();
    _scrollController = widget.scrollController ?? ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // because the controller did not get notified when a scroll position is attached
      if (!mounted) return;

      /// Triggers a rebuild after mutating local state.
      setState(() {});
    });
  }

  /// Reacts to widget configuration updates from the parent.
  @override
  void didUpdateWidget(covariant SelectPopup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchController != oldWidget.searchController) {
      _searchController = widget.searchController ?? TextEditingController();
    }
    if (widget.scrollController != oldWidget.scrollController) {
      _scrollController = widget.scrollController ?? ScrollController();
    }
  }

  /// Updates derived state when inherited dependencies change.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectData = Data.maybeOf<SelectData>(context);
  }

  @override
  bool get hasSelection => _selectData?.hasSelection ?? false;

  /// Performs `isSelected` logic for this form component.
  @override
  bool isSelected(Object? value) {
    return _selectData?.isSelected(value) ?? false;
  }

  /// Performs `selectItem` logic for this form component.
  @override
  void selectItem(Object? value, bool selected) {
    _selectData?.onChanged(value, selected);
    if (widget.autoClose ?? _selectData?.autoClose == true) {
      closeOverlay(context, value);
    }
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    return SubFocusScope(
      builder: (context, subFocusScope) {
        return Actions(
          actions: {
            NextItemIntent: CallbackAction<NextItemIntent>(
              onInvoke: (intent) {
                subFocusScope.nextFocus();
                return null;
              },
            ),
            PreviousItemIntent: CallbackAction<PreviousItemIntent>(
              onInvoke: (intent) {
                subFocusScope.nextFocus(TraversalDirection.up);
                return null;
              },
            ),
            CloseMenuIntent: CallbackAction<CloseMenuIntent>(
              onInvoke: (intent) {
                closeOverlay(context);
                return null;
              },
            ),
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (intent) {
                subFocusScope.invokeActionOnFocused(intent);
                return null;
              },
            ),
          },
          child: Shortcuts(
            shortcuts: {
              LogicalKeySet(LogicalKeyboardKey.tab): const NextItemIntent(),
              LogicalKeySet(LogicalKeyboardKey.shift, LogicalKeyboardKey.tab):
                  const PreviousItemIntent(),
              LogicalKeySet(LogicalKeyboardKey.escape): const CloseMenuIntent(),
              LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
              LogicalKeySet(LogicalKeyboardKey.numpadEnter):
                  const ActivateIntent(),
              LogicalKeySet(LogicalKeyboardKey.arrowDown):
                  const NextItemIntent(),
              LogicalKeySet(LogicalKeyboardKey.arrowUp):
                  const PreviousItemIntent(),
            },
            child: Focus(
              autofocus: !widget
                  .enableSearch, // autofocus on TextField when search enabled instead
              child: Data<SelectPopupHandle>.inherit(
                data: this,
                child: ModalContainer(
                  clipBehavior: Clip.hardEdge,
                  surfaceBlur: widget.surfaceBlur,
                  surfaceOpacity: widget.surfaceOpacity,
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.enableSearch)
                        ComponentTheme(
                          data: const FocusOutlineTheme(
                            border: Border.fromBorderSide(BorderSide.none),
                          ),
                          child: TextField(
                            controller: _searchController,
                            border: const Border.fromBorderSide(
                              BorderSide.none,
                            ),
                            borderRadius: BorderRadius.zero,
                            features: [
                              InputFeature.leading(
                                const Icon(
                                  LucideIcons.search,
                                ).iconSmall().iconMutedForeground(),
                              ),
                            ],
                            autofocus: true,
                            placeholder: widget.searchPlaceholder,
                            padding:
                                const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 12,
                                ) *
                                scaling,
                          ),
                        ),
                      Flexible(
                        child: ListenableBuilder(
                          listenable: _searchController,
                          builder: (context, _) {
                            return CachedValueWidget(
                              value: _searchController.text.isEmpty
                                  ? null
                                  : _searchController.text,
                              builder: (context, searchQuery) {
                                return FutureOrBuilder<SelectItemDelegate?>(
                                  future: widget.builder != null
                                      ? widget.builder!.call(
                                          context,
                                          searchQuery,
                                        )
                                      : widget.items != null
                                      ? widget.items!
                                      : SelectItemDelegate.empty,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      Widget? loadingBuilder = widget
                                          .loadingBuilder
                                          ?.call(context);
                                      if (loadingBuilder != null) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            if (widget.enableSearch)
                                              const Divider(),
                                            Flexible(child: loadingBuilder),
                                          ],
                                        );
                                      }
                                      return const SizedBox();
                                    }
                                    if (snapshot.hasError) {
                                      Widget? errorBuilder = widget.errorBuilder
                                          ?.call(
                                            context,
                                            snapshot.error!,
                                            snapshot.stackTrace,
                                          );
                                      if (errorBuilder != null) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            if (widget.enableSearch)
                                              const Divider(),
                                            Flexible(child: errorBuilder),
                                          ],
                                        );
                                      }
                                      return const SizedBox();
                                    }
                                    if (snapshot.hasData &&
                                        snapshot.data?.estimatedChildCount !=
                                            0) {
                                      var data = snapshot.data!;
                                      return CachedValueWidget(
                                        value: data,
                                        builder: (context, data) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              if (widget.enableSearch)
                                                const Divider(),
                                              Flexible(
                                                child: Stack(
                                                  fit: StackFit.passthrough,
                                                  children: [
                                                    if (widget
                                                        .disableVirtualization)
                                                      SingleChildScrollView(
                                                        controller:
                                                            _scrollController,
                                                        padding:
                                                            const EdgeInsets.all(
                                                              4,
                                                            ) *
                                                            scaling,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          children: [
                                                            for (
                                                              var i = 0;
                                                              i <
                                                                  (data
                                                                          as SelectItemList)
                                                                      .children
                                                                      .length;
                                                              i++
                                                            )
                                                              data.build(
                                                                context,
                                                                i,
                                                              ),
                                                          ],
                                                        ),
                                                      )
                                                    else
                                                      ListView.builder(
                                                        controller:
                                                            _scrollController,
                                                        padding:
                                                            const EdgeInsets.all(
                                                              4,
                                                            ) *
                                                            scaling,
                                                        itemBuilder: data.build,
                                                        shrinkWrap:
                                                            widget.shrinkWrap,
                                                        itemCount: data
                                                            .estimatedChildCount,
                                                      ),
                                                    ListenableBuilder(
                                                      listenable:
                                                          _scrollController,
                                                      builder: (context, child) {
                                                        return Visibility(
                                                          visible:
                                                              _scrollController
                                                                  .offset >
                                                              0,
                                                          child: Positioned(
                                                            top: 0,
                                                            left: 0,
                                                            right: 0,
                                                            child: HoverActivity(
                                                              hitTestBehavior:
                                                                  HitTestBehavior
                                                                      .translucent,
                                                              debounceDuration:
                                                                  const Duration(
                                                                    milliseconds:
                                                                        16,
                                                                  ),
                                                              onHover: () {
                                                                // decrease scroll offset
                                                                var value =
                                                                    _scrollController
                                                                        .offset -
                                                                    8;
                                                                value = value.clamp(
                                                                  0.0,
                                                                  _scrollController
                                                                      .position
                                                                      .maxScrollExtent,
                                                                );
                                                                _scrollController
                                                                    .jumpTo(
                                                                      value,
                                                                    );
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      vertical:
                                                                          4,
                                                                    ) *
                                                                    scaling,
                                                                child: const Icon(
                                                                  RadixIcons
                                                                      .chevronUp,
                                                                ).iconX3Small(),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    ListenableBuilder(
                                                      listenable:
                                                          _scrollController,
                                                      builder: (context, child) {
                                                        return Visibility(
                                                          visible:
                                                              _scrollController
                                                                  .hasClients &&
                                                              _scrollController
                                                                  .position
                                                                  .hasContentDimensions &&
                                                              _scrollController
                                                                      .offset <
                                                                  _scrollController
                                                                      .position
                                                                      .maxScrollExtent,
                                                          child: Positioned(
                                                            bottom: 0,
                                                            left: 0,
                                                            right: 0,
                                                            child: HoverActivity(
                                                              hitTestBehavior:
                                                                  HitTestBehavior
                                                                      .translucent,
                                                              debounceDuration:
                                                                  const Duration(
                                                                    milliseconds:
                                                                        16,
                                                                  ),
                                                              onHover: () {
                                                                // increase scroll offset
                                                                var value =
                                                                    _scrollController
                                                                        .offset +
                                                                    8;
                                                                value = value.clamp(
                                                                  0.0,
                                                                  _scrollController
                                                                      .position
                                                                      .maxScrollExtent,
                                                                );
                                                                _scrollController
                                                                    .jumpTo(
                                                                      value,
                                                                    );
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      vertical:
                                                                          4,
                                                                    ) *
                                                                    scaling,
                                                                child: const Icon(
                                                                  RadixIcons
                                                                      .chevronDown,
                                                                ).iconX3Small(),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                    Widget? emptyBuilder = widget.emptyBuilder
                                        ?.call(context);
                                    if (emptyBuilder != null) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          if (widget.enableSearch)
                                            const Divider(),
                                          Flexible(child: emptyBuilder),
                                        ],
                                      );
                                    }
                                    return const SizedBox();
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
