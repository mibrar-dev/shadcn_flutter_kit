// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../sortable.dart';

/// _SortableState defines a reusable type for this registry module.
class _SortableState<T> extends State<Sortable<T>>
    with AutomaticKeepAliveClientMixin {
  final ValueNotifier<_SortableDraggingSession<T>?> topCandidate =
      ValueNotifier(null);
  final ValueNotifier<_SortableDraggingSession<T>?> leftCandidate =
      ValueNotifier(null);
  final ValueNotifier<_SortableDraggingSession<T>?> rightCandidate =
      ValueNotifier(null);
  final ValueNotifier<_SortableDraggingSession<T>?> bottomCandidate =
      ValueNotifier(null);

  final ValueNotifier<_DroppingTarget<T>?> _currentTarget = ValueNotifier(null);
  final ValueNotifier<_SortableDropFallbackState<T>?> _currentFallback =
      ValueNotifier(null);
  final ValueNotifier<bool> _hasClaimedDrop = ValueNotifier(false);
  final ValueNotifier<bool> _hasDraggedOff = ValueNotifier(false);

  (_SortableState<T>, Offset)? _findState(
    _SortableLayerState target,
    Offset globalPosition,
  ) {
    BoxHitTestResult result = BoxHitTestResult();
    RenderBox renderBox = target.context.findRenderObject() as RenderBox;
    renderBox.hitTest(result, position: globalPosition);
    for (final HitTestEntry entry in result.path) {
      if (entry.target is RenderMetaData) {
        /// Stores `metaData` state/configuration for this implementation.
        RenderMetaData metaData = entry.target as RenderMetaData;
        if (metaData.metaData is _SortableState<T> &&
            metaData.metaData != this) {
          return (
            metaData.metaData as _SortableState<T>,
            (entry as BoxHitTestEntry).localPosition,
          );
        }
      }
    }
    return null;
  }

  _SortableDropFallbackState<T>? _findFallbackState(
    _SortableLayerState target,
    Offset globalPosition,
  ) {
    BoxHitTestResult result = BoxHitTestResult();
    RenderBox renderBox = target.context.findRenderObject() as RenderBox;
    renderBox.hitTest(result, position: globalPosition);
    for (final HitTestEntry entry in result.path) {
      if (entry.target is RenderMetaData) {
        /// Stores `metaData` state/configuration for this implementation.
        RenderMetaData metaData = entry.target as RenderMetaData;
        if (metaData.metaData is _SortableDropFallbackState<T> &&
            metaData.metaData != this) {
          return metaData.metaData as _SortableDropFallbackState<T>;
        }
      }
    }
    return null;
  }

  /// Stores `_dragging` state/configuration for this implementation.
  bool _dragging = false;

  /// Stores `_claimUnchanged` state/configuration for this implementation.
  bool _claimUnchanged = false;

  /// Stores `_session` state/configuration for this implementation.
  _SortableDraggingSession<T>? _session;

  /// Stores `_scrollableLayer` state/configuration for this implementation.
  _ScrollableSortableLayerState? _scrollableLayer;

  @override
  /// Executes `didChangeDependencies` behavior for this component/composite.
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollableLayer = Data.maybeOf<_ScrollableSortableLayerState>(context);
  }

  /// Executes `_onDragStart` behavior for this component/composite.
  void _onDragStart(DragStartDetails details) {
    if (_hasClaimedDrop.value) {
      return;
    }
    _hasDraggedOff.value = false;
    _SortableLayerState? layer = Data.maybeFind<_SortableLayerState>(context);
    assert(layer != null, 'Sortable must be a descendant of SortableLayer');
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    RenderBox layerRenderBox = layer!.context.findRenderObject() as RenderBox;
    Matrix4 transform = renderBox.getTransformTo(layerRenderBox);

    /// Stores `size` state/configuration for this implementation.
    Size size = renderBox.size;
    Offset minOffset = MatrixUtils.transformPoint(transform, Offset.zero);
    Offset maxOffset = MatrixUtils.transformPoint(
      transform,

      /// Creates a `Offset` instance.
      Offset(size.width, size.height),
    );

    /// Stores `ghost` state/configuration for this implementation.
    final ghost = widget.ghost ?? widget.child;

    /// Stores `candidateFallback` state/configuration for this implementation.
    final candidateFallback = widget.candidateFallback;
    _session = _SortableDraggingSession(
      layer: layer,
      layerRenderBox: layerRenderBox,
      target: this,
      transform: transform,
      size: size,
      ghost: ListenableBuilder(
        listenable: _currentTarget,
        builder: (context, child) {
          if (_currentTarget.value != null) {
            return candidateFallback ?? widget.child;
          }
          return ghost;
        },
      ),
      placeholder: widget.placeholder ?? widget.child,
      data: widget.data,
      minOffset: minOffset,
      maxOffset: maxOffset,
      lock: layer.widget.lock,
      offset: Offset.zero,
    );
    layer.pushDraggingSession(_session!);
    widget.onDragStart?.call();

    /// Creates a `setState` instance.
    setState(() {
      _dragging = true;
    });
    _scrollableLayer?._startDrag(this, details.globalPosition);
  }

  ValueNotifier<_SortableDraggingSession<T>?> _getByLocation(
    _SortableDropLocation location,
  ) {
    switch (location) {
      case _SortableDropLocation.top:
        return topCandidate;
      case _SortableDropLocation.left:
        return leftCandidate;
      case _SortableDropLocation.right:
        return rightCandidate;
      case _SortableDropLocation.bottom:
        return bottomCandidate;
    }
  }

  /// Executes `_handleDrag` behavior for this component/composite.
  void _handleDrag(Offset delta) {
    /// Stores `minOffset` state/configuration for this implementation.
    Offset minOffset = _session!.minOffset;

    /// Stores `maxOffset` state/configuration for this implementation.
    Offset maxOffset = _session!.maxOffset;
    if (_session != null) {
      RenderBox sessionRenderBox =
          _session!.layer.context.findRenderObject() as RenderBox;

      /// Stores `size` state/configuration for this implementation.
      Size size = sessionRenderBox.size;
      if (_session!.lock) {
        /// Stores `minX` state/configuration for this implementation.
        double minX = -minOffset.dx;

        /// Stores `maxX` state/configuration for this implementation.
        double maxX = size.width - maxOffset.dx;

        /// Stores `minY` state/configuration for this implementation.
        double minY = -minOffset.dy;

        /// Stores `maxY` state/configuration for this implementation.
        double maxY = size.height - maxOffset.dy;
        _session!.offset.value = Offset(
          (_session!.offset.value.dx + delta.dx).clamp(
            /// Creates a `min` instance.
            min(minX, maxX),

            /// Creates a `max` instance.
            max(minX, maxX),
          ),
          (_session!.offset.value.dy + delta.dy).clamp(
            /// Creates a `min` instance.
            min(minY, maxY),

            /// Creates a `max` instance.
            max(minY, maxY),
          ),
        );
      } else {
        _session!.offset.value += delta;
      }
      Offset globalPosition =
          _session!.offset.value +
          minOffset +
          /// Creates a `Offset` instance.
          Offset(
            (maxOffset.dx - minOffset.dx) / 2,
            (maxOffset.dy - minOffset.dy) / 2,
          );
      (_SortableState<T>, Offset)? target = _findState(
        _session!.layer,
        globalPosition,
      );
      if (target == null) {
        _SortableDropFallbackState<T>? fallback = _findFallbackState(
          _session!.layer,
          globalPosition,
        );
        _currentFallback.value = fallback;
        if (_currentTarget.value != null && fallback == null) {
          _currentTarget.value!.dispose(_session!);
          _currentTarget.value = null;
        }
      } else {
        _hasDraggedOff.value = true;
        _currentFallback.value = null;
        if (_currentTarget.value != null) {
          _currentTarget.value!.dispose(_session!);
        }
        var targetRenderBox = target.$1.context.findRenderObject() as RenderBox;

        /// Stores `size` state/configuration for this implementation.
        var size = targetRenderBox.size;
        _SortableDropLocation? location = _getPosition(
          target.$2,
          size,
          acceptTop: widget.onAcceptTop != null,
          acceptLeft: widget.onAcceptLeft != null,
          acceptRight: widget.onAcceptRight != null,
          acceptBottom: widget.onAcceptBottom != null,
        );
        if (location != null) {
          ValueNotifier<_SortableDraggingSession<T>?> candidate = target.$1
              ._getByLocation(location);

          candidate.value = _session;
          _currentTarget.value = _DroppingTarget(
            candidate: candidate,
            source: target.$1,
            location: location,
          );
        }
      }
    }
  }

  /// Executes `_getCallback` behavior for this component/composite.
  ValueChanged<SortableData<T>>? _getCallback(_SortableDropLocation location) {
    switch (location) {
      case _SortableDropLocation.top:
        return widget.onAcceptTop;
      case _SortableDropLocation.left:
        return widget.onAcceptLeft;
      case _SortableDropLocation.right:
        return widget.onAcceptRight;
      case _SortableDropLocation.bottom:
        return widget.onAcceptBottom;
    }
  }

  /// Executes `_getPredicate` behavior for this component/composite.
  Predicate<SortableData<T>>? _getPredicate(_SortableDropLocation location) {
    switch (location) {
      case _SortableDropLocation.top:
        return widget.canAcceptTop;
      case _SortableDropLocation.left:
        return widget.canAcceptLeft;
      case _SortableDropLocation.right:
        return widget.canAcceptRight;
      case _SortableDropLocation.bottom:
        return widget.canAcceptBottom;
    }
  }

  /// Executes `_onDragUpdate` behavior for this component/composite.
  void _onDragUpdate(DragUpdateDetails details) {
    if (_hasClaimedDrop.value) {
      return;
    }
    _handleDrag(details.delta);
    _scrollableLayer?._updateDrag(this, details.globalPosition);
  }

  /// Executes `_onDragEnd` behavior for this component/composite.
  void _onDragEnd(DragEndDetails details) {
    widget.onDragEnd?.call();
    if (_session != null) {
      if (_currentTarget.value != null) {
        _currentTarget.value!.dispose(_session!);

        /// Stores `target` state/configuration for this implementation.
        var target = _currentTarget.value!.source;

        /// Stores `location` state/configuration for this implementation.
        var location = _currentTarget.value!.location;
        var predicate = target._getPredicate(location);

        /// Stores `sortData` state/configuration for this implementation.
        var sortData = _session!.data;
        if (predicate == null || predicate(sortData)) {
          var callback = target._getCallback(location);
          if (callback != null) {
            callback(sortData);
          }
        }
        _session!.layer.removeDraggingSession(_session!);
        _currentTarget.value = null;
      } else if (_hasDraggedOff.value) {
        /// Stores `target` state/configuration for this implementation.
        var target = _currentFallback.value;
        if (target != null) {
          /// Stores `sortData` state/configuration for this implementation.
          var sortData = _session!.data;
          if (target.widget.canAccept == null ||
              target.widget.canAccept!(sortData)) {
            target.widget.onAccept?.call(sortData);
          }
        }
        _session!.layer.removeDraggingSession(_session!);
        if (target == null) {
          _session!.layer._claimDrop(this, _session!.data, true);
        }
      } else {
        // basically the same as drag cancel, because the drag has not been
        // dragged off of itself
        _session!.layer.removeDraggingSession(_session!);
        widget.onDropFailed?.call();
        _session!.layer._claimDrop(this, _session!.data, true);
      }
      _claimUnchanged = true;
      _session = null;
    }

    /// Creates a `setState` instance.
    setState(() {
      _dragging = false;
    });
    _scrollableLayer?._endDrag(this);
  }

  /// Executes `_onDragCancel` behavior for this component/composite.
  void _onDragCancel() {
    if (_session != null) {
      if (_currentTarget.value != null) {
        _currentTarget.value!.dispose(_session!);
        _currentTarget.value = null;
      }
      _session!.layer.removeDraggingSession(_session!);
      _session!.layer._claimDrop(this, _session!.data, true);
      _session = null;
    }

    /// Creates a `setState` instance.
    setState(() {
      _dragging = false;
    });
    widget.onDragCancel?.call();
    _scrollableLayer?._endDrag(this);
  }

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    final layer = Data.maybeFind<_SortableLayerState>(context);
    if (layer != null) {
      /// Stores `data` state/configuration for this implementation.
      var data = widget.data;
      if (layer._canClaimDrop(this, data)) {
        _hasClaimedDrop.value = true;
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (mounted) {
            layer._claimDrop(this, data);
          }
        });
      }
    }
  }

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant Sortable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (!widget.enabled && _dragging) {
        _onDragCancel();
      }
    }
    if (widget.data != oldWidget.data || _claimUnchanged) {
      _claimUnchanged = false;
      final layer = Data.maybeFind<_SortableLayerState>(context);
      if (layer != null && layer._canClaimDrop(this, widget.data)) {
        _hasClaimedDrop.value = true;

        /// Stores `data` state/configuration for this implementation.
        final data = widget.data;
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (mounted) {
            layer._claimDrop(this, data);
          }
        });
      }
    }
  }

  final GlobalKey _key = GlobalKey();
  final GlobalKey _gestureKey = GlobalKey();

  Widget _buildAnimatedSize({
    AlignmentGeometry alignment = Alignment.center,
    Widget? child,
    bool hasCandidate = false,
    required Duration duration,
  }) {
    if (!hasCandidate) {
      return child!;
    }
    return AnimatedSize(duration: duration, alignment: alignment, child: child);
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    super.dispose();
    if (_dragging) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _scrollableLayer?._endDrag(this);
        _session!.layer.removeDraggingSession(_session!);
        _currentTarget.value = null;
      });
    }
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    super.build(context);
    final layer = Data.of<_SortableLayerState>(context);
    return MetaData(
      behavior: HitTestBehavior.translucent,
      metaData: this,
      // must define the generic type to avoid type inference _SortableState<T>
      child: Data<_SortableState>.inherit(
        data: this,
        child: ListenableBuilder(
          listenable: layer._sessions,
          builder: (context, child) {
            /// Stores `hasCandidate` state/configuration for this implementation.
            bool hasCandidate = layer._sessions.value.isNotEmpty;
            Widget container = GestureDetector(
              key: _gestureKey,
              behavior: widget.behavior,
              onPanStart: widget.enabled ? _onDragStart : null,
              onPanUpdate: widget.enabled ? _onDragUpdate : null,
              onPanEnd: widget.enabled ? _onDragEnd : null,
              onPanCancel: widget.enabled ? _onDragCancel : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Creates a `AbsorbPointer` instance.
                  AbsorbPointer(
                    child: _buildAnimatedSize(
                      duration: kDefaultDuration,
                      alignment: Alignment.centerRight,
                      hasCandidate: hasCandidate,
                      child: ListenableBuilder(
                        listenable: leftCandidate,
                        builder: (context, child) {
                          if (leftCandidate.value != null) {
                            return SizedBox.fromSize(
                              size: leftCandidate.value!.size,
                              child: leftCandidate.value!.placeholder,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),

                  /// Creates a `Flexible` instance.
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Creates a `AbsorbPointer` instance.
                        AbsorbPointer(
                          child: _buildAnimatedSize(
                            duration: kDefaultDuration,
                            alignment: Alignment.bottomCenter,
                            hasCandidate: hasCandidate,
                            child: ListenableBuilder(
                              listenable: topCandidate,
                              builder: (context, child) {
                                if (topCandidate.value != null) {
                                  return SizedBox.fromSize(
                                    size: topCandidate.value!.size,
                                    child: topCandidate.value!.placeholder,
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),

                        /// Creates a `Flexible` instance.
                        Flexible(
                          child: _dragging
                              ? widget.fallback ??
                                    /// Creates a `ListenableBuilder` instance.
                                    ListenableBuilder(
                                      listenable: _hasDraggedOff,
                                      builder: (context, child) {
                                        return (_hasDraggedOff.value
                                            ? AbsorbPointer(
                                                child: Visibility(
                                                  visible: false,
                                                  maintainState: true,
                                                  child: KeyedSubtree(
                                                    key: _key,
                                                    child: widget.child,
                                                  ),
                                                ),
                                              )
                                            : AbsorbPointer(
                                                child: Visibility(
                                                  maintainSize: true,
                                                  maintainAnimation: true,
                                                  maintainState: true,
                                                  visible: false,
                                                  child: KeyedSubtree(
                                                    key: _key,
                                                    child: widget.child,
                                                  ),
                                                ),
                                              ));
                                      },
                                    )
                              : ListenableBuilder(
                                  listenable: _hasClaimedDrop,
                                  builder: (context, child) {
                                    return IgnorePointer(
                                      ignoring:
                                          hasCandidate || _hasClaimedDrop.value,
                                      child: Visibility(
                                        maintainSize: true,
                                        maintainAnimation: true,
                                        maintainState: true,
                                        visible: !_hasClaimedDrop.value,
                                        child: KeyedSubtree(
                                          key: _key,
                                          child: widget.child,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),

                        /// Creates a `AbsorbPointer` instance.
                        AbsorbPointer(
                          child: _buildAnimatedSize(
                            duration: kDefaultDuration,
                            alignment: Alignment.topCenter,
                            hasCandidate: hasCandidate,
                            child: ListenableBuilder(
                              listenable: bottomCandidate,
                              builder: (context, child) {
                                if (bottomCandidate.value != null) {
                                  return SizedBox.fromSize(
                                    size: bottomCandidate.value!.size,
                                    child: bottomCandidate.value!.placeholder,
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Creates a `AbsorbPointer` instance.
                  AbsorbPointer(
                    child: _buildAnimatedSize(
                      duration: kDefaultDuration,
                      alignment: Alignment.centerLeft,
                      hasCandidate: hasCandidate,
                      child: ListenableBuilder(
                        listenable: rightCandidate,
                        builder: (context, child) {
                          if (rightCandidate.value != null) {
                            return SizedBox.fromSize(
                              size: rightCandidate.value!.size,
                              child: rightCandidate.value!.placeholder,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
            if (!hasCandidate) {
              return container;
            }
            return AnimatedSize(duration: kDefaultDuration, child: container);
          },
        ),
      ),
    );
  }

  @override
  /// Stores `wantKeepAlive` state/configuration for this implementation.
  bool get wantKeepAlive => _dragging;
}

/// A dedicated drag handle for initiating sortable drag operations.
///
/// SortableDragHandle provides a specific area within a sortable widget that
/// can be used to initiate drag operations. This is useful when you want to
/// restrict drag initiation to a specific handle area rather than the entire
/// sortable widget.
///
/// The handle automatically detects its parent Sortable widget and delegates
/// drag operations to it. It provides visual feedback with appropriate mouse
/// cursors and can be enabled/disabled independently.
///
/// Features:
/// - Dedicated drag initiation area within sortable widgets
/// - Automatic mouse cursor management (grab/grabbing states)
/// - Independent enable/disable control
/// - Automatic cleanup and lifecycle management
///
/// Example:
/// ```dart
/// Sortable<String>(
///   data: SortableData('item'),
///   child: Row(
///     children: [
///       SortableDragHandle(
///         child: Icon(Icons.drag_handle),
///       ),
///       Expanded(child: Text('Drag me by the handle')),
///     ],
///   ),
/// )
/// ```
