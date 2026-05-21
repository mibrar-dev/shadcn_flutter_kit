// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../window.dart';

/// _WindowLayerGroup defines a reusable type for this registry module.
class _WindowLayerGroup extends StatelessWidget {
  /// Stores `constraints` state/configuration for this implementation.
  final BoxConstraints constraints;

  /// Stores `windows` state/configuration for this implementation.
  final List<Window> windows;

  /// Stores `handle` state/configuration for this implementation.
  final _WindowNavigatorState handle;

  /// Stores `alwaysOnTop` state/configuration for this implementation.
  final bool alwaysOnTop;

  /// Stores `showTopSnapBar` state/configuration for this implementation.
  final bool showTopSnapBar;

  /// Creates a `_WindowLayerGroup` instance.
  const _WindowLayerGroup({
    required this.constraints,
    required this.windows,
    required this.handle,
    required this.alwaysOnTop,
    required this.showTopSnapBar,
  });

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `createPaneSnapStrategy` state/configuration for this implementation.
    final createPaneSnapStrategy = handle._createPaneSnapStrategy;
    return GroupWidget(
      children: [
        for (int i = windows.length - 1; i >= 0; i--)
          if (windows[i] != handle._draggingWindow.value?.window)
            windows[i]._build(
              size: constraints.biggest,
              navigator: handle,
              focused: i == 0,
              alwaysOnTop: false,
              ignorePointer: false,
              minifyDragging:
                  handle._snappingStrategy.value != null &&
                  handle._snappingStrategy.value!.shouldMinifyWindow &&
                  handle._draggingWindow.value != null &&
                  handle._draggingWindow.value!.window == windows[i],
            ),
        if (handle._snappingStrategy.value != null &&
            handle._draggingWindow.value != null &&
            handle._draggingWindow.value!.window.alwaysOnTop == alwaysOnTop)
          /// Creates a `GroupPositioned.fromRect` instance.
          GroupPositioned.fromRect(
            rect: Rect.fromLTWH(
              handle._snappingStrategy.value!.relativeBounds.left *
                  constraints.biggest.width,
              handle._snappingStrategy.value!.relativeBounds.top *
                  constraints.biggest.height,
              handle._snappingStrategy.value!.relativeBounds.width *
                  constraints.biggest.width,
              handle._snappingStrategy.value!.relativeBounds.height *
                  constraints.biggest.height,
            ),
            child: _BlurContainer(
              key: ValueKey(handle._snappingStrategy.value),
            ),
          ),
        if (showTopSnapBar)
          /// Creates a `ListenableBuilder` instance.
          ListenableBuilder(
            listenable: handle._hoveringTopSnapper,
            builder: (context, _) {
              return GroupPositioned(
                top: 0,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: MouseRegion(
                    onEnter: (_) {
                      handle._hoveringTopSnapper.value = true;
                    },
                    onExit: (_) {
                      handle._hoveringTopSnapper.value = false;
                      handle._snappingStrategy.value = null;
                    },
                    hitTestBehavior: HitTestBehavior.translucent,
                    child: AnimatedValueBuilder(
                      value:
                          handle._draggingWindow.value == null ||
                              handle
                                      ._draggingWindow
                                      .value!
                                      .window
                                      .alwaysOnTop !=
                                  alwaysOnTop
                          ? -1.0
                          : handle._hoveringTopSnapper.value
                          ? 0.0
                          : -0.85,
                      duration: handle._hoveringTopSnapper.value
                          ? const Duration(milliseconds: 300)
                          : kDefaultDuration,
                      curve: Curves.easeInOut,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(
                            0,

                            /// Creates a `unlerpDouble` instance.
                            unlerpDouble(value, -1.0, 0.0).clamp(0, 1) * 24,
                          ),
                          child: FractionalTranslation(
                            translation: Offset(0, value),
                            child: OutlinedContainer(
                              height: 100,
                              padding: EdgeInsets.all(
                                theme.density.baseGap * theme.scaling,
                              ),
                              child: Opacity(
                                opacity: unlerpDouble(
                                  value,
                                  -0.85,
                                  0.0,
                                ).clamp(0, 1),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  spacing:
                                      theme.density.baseGap * theme.scaling,
                                  children: [
                                    // 0.5 | 0.5
                                    /// Creates a `AspectRatio` instance.
                                    AspectRatio(
                                      aspectRatio:
                                          constraints.biggest.width /
                                          constraints.biggest.height,
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          /// Stores `size` state/configuration for this implementation.
                                          final size = constraints.biggest;
                                          return GroupWidget(
                                            children: [
                                              /// Creates a `createPaneSnapStrategy` instance.
                                              createPaneSnapStrategy(
                                                size,
                                                theme,

                                                /// Creates a `WindowSnapStrategy` instance.
                                                const WindowSnapStrategy(
                                                  relativeBounds: Rect.fromLTWH(
                                                    0,
                                                    0,
                                                    0.5,
                                                    1,
                                                  ),
                                                ),
                                                topRight: true,
                                                bottomRight: true,
                                              ),

                                              /// Creates a `createPaneSnapStrategy` instance.
                                              createPaneSnapStrategy(
                                                size,
                                                theme,

                                                /// Creates a `WindowSnapStrategy` instance.
                                                const WindowSnapStrategy(
                                                  relativeBounds: Rect.fromLTWH(
                                                    0.5,
                                                    0,
                                                    0.5,
                                                    1,
                                                  ),
                                                ),
                                                topLeft: true,
                                                bottomLeft: true,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    // 0.7 | 0.3
                                    /// Creates a `AspectRatio` instance.
                                    AspectRatio(
                                      aspectRatio:
                                          constraints.biggest.width /
                                          constraints.biggest.height,
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          /// Stores `size` state/configuration for this implementation.
                                          final size = constraints.biggest;
                                          return GroupWidget(
                                            children: [
                                              /// Creates a `createPaneSnapStrategy` instance.
                                              createPaneSnapStrategy(
                                                size,
                                                theme,

                                                /// Creates a `WindowSnapStrategy` instance.
                                                const WindowSnapStrategy(
                                                  relativeBounds: Rect.fromLTWH(
                                                    0,
                                                    0,
                                                    0.7,
                                                    1,
                                                  ),
                                                ),
                                                topRight: true,
                                                bottomRight: true,
                                              ),

                                              /// Creates a `createPaneSnapStrategy` instance.
                                              createPaneSnapStrategy(
                                                size,
                                                theme,

                                                /// Creates a `WindowSnapStrategy` instance.
                                                const WindowSnapStrategy(
                                                  relativeBounds: Rect.fromLTWH(
                                                    0.7,
                                                    0,
                                                    0.3,
                                                    1,
                                                  ),
                                                ),
                                                topLeft: true,
                                                bottomLeft: true,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    // (0.5, 1) | (0.5, 0.5)
                                    //          | (0.5, 0.5)
                                    /// Creates a `AspectRatio` instance.
                                    AspectRatio(
                                      aspectRatio:
                                          constraints.biggest.width /
                                          constraints.biggest.height,
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          /// Stores `size` state/configuration for this implementation.
                                          final size = constraints.biggest;
                                          return GroupWidget(
                                            children: [
                                              /// Creates a `createPaneSnapStrategy` instance.
                                              createPaneSnapStrategy(
                                                size,
                                                theme,

                                                /// Creates a `WindowSnapStrategy` instance.
                                                const WindowSnapStrategy(
                                                  relativeBounds: Rect.fromLTWH(
                                                    0,
                                                    0.0,
                                                    0.5,
                                                    1.0,
                                                  ),
                                                ),
                                                topRight: true,
                                                bottomRight: true,
                                              ),

                                              /// Creates a `createPaneSnapStrategy` instance.
                                              createPaneSnapStrategy(
                                                size,
                                                theme,

                                                /// Creates a `WindowSnapStrategy` instance.
                                                const WindowSnapStrategy(
                                                  relativeBounds: Rect.fromLTWH(
                                                    0.5,
                                                    0,
                                                    0.5,
                                                    0.5,
                                                  ),
                                                ),
                                                bottomLeft: true,
                                                bottomRight: true,
                                                topLeft: true,
                                              ),

                                              /// Creates a `createPaneSnapStrategy` instance.
                                              createPaneSnapStrategy(
                                                size,
                                                theme,

                                                /// Creates a `WindowSnapStrategy` instance.
                                                const WindowSnapStrategy(
                                                  relativeBounds: Rect.fromLTWH(
                                                    0.5,
                                                    0.5,
                                                    0.5,
                                                    0.5,
                                                  ),
                                                ),
                                                topLeft: true,
                                                topRight: true,
                                                bottomLeft: true,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    // (0.5, 0.5) | (0.5, 0.5)
                                    // (0.5, 0.5) | (0.5, 0.5)
                                    /// Creates a `AspectRatio` instance.
                                    AspectRatio(
                                      aspectRatio:
                                          constraints.biggest.width /
                                          constraints.biggest.height,
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          /// Stores `size` state/configuration for this implementation.
                                          final size = constraints.biggest;
                                          return GroupWidget(
                                            children: [
                                              /// Creates a `createPaneSnapStrategy` instance.
                                              createPaneSnapStrategy(
                                                size,
                                                theme,

                                                /// Creates a `WindowSnapStrategy` instance.
                                                const WindowSnapStrategy(
                                                  relativeBounds: Rect.fromLTWH(
                                                    0,
                                                    0,
                                                    0.5,
                                                    0.5,
                                                  ),
                                                ),
                                                bottomRight: true,
                                                topRight: true,
                                                bottomLeft: true,
                                              ),

                                              /// Creates a `createPaneSnapStrategy` instance.
                                              createPaneSnapStrategy(
                                                size,
                                                theme,

                                                /// Creates a `WindowSnapStrategy` instance.
                                                const WindowSnapStrategy(
                                                  relativeBounds: Rect.fromLTWH(
                                                    0.5,
                                                    0,
                                                    0.5,
                                                    0.5,
                                                  ),
                                                ),
                                                bottomLeft: true,
                                                topLeft: true,
                                                bottomRight: true,
                                              ),

                                              /// Creates a `createPaneSnapStrategy` instance.
                                              createPaneSnapStrategy(
                                                size,
                                                theme,

                                                /// Creates a `WindowSnapStrategy` instance.
                                                const WindowSnapStrategy(
                                                  relativeBounds: Rect.fromLTWH(
                                                    0,
                                                    0.5,
                                                    0.5,
                                                    0.5,
                                                  ),
                                                ),
                                                topLeft: true,
                                                topRight: true,
                                                bottomRight: true,
                                              ),

                                              /// Creates a `createPaneSnapStrategy` instance.
                                              createPaneSnapStrategy(
                                                size,
                                                theme,

                                                /// Creates a `WindowSnapStrategy` instance.
                                                const WindowSnapStrategy(
                                                  relativeBounds: Rect.fromLTWH(
                                                    0.5,
                                                    0.5,
                                                    0.5,
                                                    0.5,
                                                  ),
                                                ),
                                                topLeft: true,
                                                topRight: true,
                                                bottomLeft: true,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    // 1/3 | 1/3 | 1/3
                                    /// Creates a `AspectRatio` instance.
                                    AspectRatio(
                                      aspectRatio:
                                          constraints.biggest.width /
                                          constraints.biggest.height,
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          /// Stores `size` state/configuration for this implementation.
                                          final size = constraints.biggest;
                                          return GroupWidget(
                                            children: [
                                              /// Creates a `createPaneSnapStrategy` instance.
                                              createPaneSnapStrategy(
                                                size,
                                                theme,

                                                /// Creates a `WindowSnapStrategy` instance.
                                                const WindowSnapStrategy(
                                                  relativeBounds: Rect.fromLTWH(
                                                    0,
                                                    0,
                                                    1 / 3,
                                                    1,
                                                  ),
                                                ),
                                                topRight: true,
                                                bottomRight: true,
                                              ),

                                              /// Creates a `createPaneSnapStrategy` instance.
                                              createPaneSnapStrategy(
                                                size,
                                                theme,

                                                /// Creates a `WindowSnapStrategy` instance.
                                                const WindowSnapStrategy(
                                                  relativeBounds: Rect.fromLTWH(
                                                    1 / 3,
                                                    0,
                                                    1 / 3,
                                                    1,
                                                  ),
                                                ),
                                                allLeft: true,
                                                allRight: true,
                                              ),

                                              /// Creates a `createPaneSnapStrategy` instance.
                                              createPaneSnapStrategy(
                                                size,
                                                theme,

                                                /// Creates a `WindowSnapStrategy` instance.
                                                const WindowSnapStrategy(
                                                  relativeBounds: Rect.fromLTWH(
                                                    2 / 3,
                                                    0,
                                                    1 / 3,
                                                    1,
                                                  ),
                                                ),
                                                topLeft: true,
                                                bottomLeft: true,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    // 2/7 | 3/7 | 2/7
                                    /// Creates a `AspectRatio` instance.
                                    AspectRatio(
                                      aspectRatio:
                                          constraints.biggest.width /
                                          constraints.biggest.height,
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          /// Stores `size` state/configuration for this implementation.
                                          final size = constraints.biggest;
                                          return GroupWidget(
                                            children: [
                                              /// Creates a `createPaneSnapStrategy` instance.
                                              createPaneSnapStrategy(
                                                size,
                                                theme,

                                                /// Creates a `WindowSnapStrategy` instance.
                                                const WindowSnapStrategy(
                                                  relativeBounds: Rect.fromLTWH(
                                                    0,
                                                    0,
                                                    2 / 7,
                                                    1,
                                                  ),
                                                ),
                                                topRight: true,
                                                bottomRight: true,
                                              ),

                                              /// Creates a `createPaneSnapStrategy` instance.
                                              createPaneSnapStrategy(
                                                size,
                                                theme,

                                                /// Creates a `WindowSnapStrategy` instance.
                                                const WindowSnapStrategy(
                                                  relativeBounds: Rect.fromLTWH(
                                                    2 / 7,
                                                    0,
                                                    3 / 7,
                                                    1,
                                                  ),
                                                ),
                                                allLeft: true,
                                                allRight: true,
                                              ),

                                              /// Creates a `createPaneSnapStrategy` instance.
                                              createPaneSnapStrategy(
                                                size,
                                                theme,

                                                /// Creates a `WindowSnapStrategy` instance.
                                                const WindowSnapStrategy(
                                                  relativeBounds: Rect.fromLTWH(
                                                    5 / 7,
                                                    0,
                                                    2 / 7,
                                                    1,
                                                  ),
                                                ),
                                                topLeft: true,
                                                bottomLeft: true,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        if (handle._draggingWindow.value != null &&
            handle._draggingWindow.value!.window.alwaysOnTop == alwaysOnTop)
          handle._draggingWindow.value!.window._build(
            size: constraints.biggest,
            navigator: handle,
            focused: true,
            alwaysOnTop:
                handle._draggingWindow.value!.window.alwaysOnTop ??
                handle
                    ._draggingWindow
                    .value!
                    .window
                    .controller
                    ?.value
                    .alwaysOnTop ??
                false,
            minifyDragging:
                handle._snappingStrategy.value != null &&
                handle._snappingStrategy.value!.shouldMinifyWindow,
            ignorePointer: true,
          ),
      ],
    );
  }
}
