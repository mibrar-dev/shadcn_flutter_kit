// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../gooey_toast.dart';

class GooeyToastController extends ChangeNotifier {
  GooeyToastController();

  /// Active toast records keyed by toast id.
  final Map<String, _GooeyToastRecord> _records = {};

  /// Monotonic id seed used when caller does not provide an explicit id.
  int _nonce = 0;

  /// Returns active toasts sorted newest-first by last update.
  List<GooeyToastDetails> get activeToasts {
    final items =
        _records.values
            .map((r) => r.details)
            .whereType<GooeyToastDetails>()
            .toList()
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return List<GooeyToastDetails>.unmodifiable(items);
  }

  /// Returns whether a toast with [id] is currently active.
  bool containsToast(String id) => _records.containsKey(id);

  /// Dismisses a toast by [id], if present.
  void dismiss(String id) {
    final record = _records.remove(id);
    if (record == null) return;
    final data = record.data.value;
    record.dispose();
    record.entry.remove();
    _refreshRegionAutoDismiss(data.position, data.expandDirection);
    _rebuildAllEntries();
    notifyListeners();
  }

  /// Pauses or resumes dismiss countdown for the toast [id].
  ///
  /// When [value] is `true`, current countdown is paused and remaining time is
  /// preserved. When `false`, countdown resumes from remaining duration.
  void setInteracting(String id, bool value) {
    final record = _records[id];
    if (record == null) return;
    if (record.interacting == value) return;
    record.interacting = value;

    final data = record.data.value;
    if (data.persistUntilDismissed || data.duration <= Duration.zero) return;

    if (value) {
      final startedAt = record.dismissStartedAt;
      if (startedAt != null) {
        final elapsed = DateTime.now().difference(startedAt);
        final base = record.remaining ?? data.duration;
        var next = base - elapsed;
        if (next.isNegative) next = Duration.zero;
        record.remaining = next;
      }
      record.dismissTimer?.cancel();
      record.dismissTimer = null;
      record.dismissStartedAt = null;
      return;
    }

    final remaining = record.remaining ?? data.duration;
    if (remaining <= Duration.zero) {
      dismiss(id);
      return;
    }
    record.dismissTimer?.cancel();
    record.dismissStartedAt = DateTime.now();
    record.dismissTimer = Timer(remaining, () {
      if (_records.containsKey(id)) dismiss(id);
    });
  }

  Future<void> transitionAfterClosed({
    required BuildContext context,
    required String id,
    required String currentTitle,
    required GooeyToastState currentState,
    Widget? currentIcon,
    Widget? currentCompactChild,
    Duration? currentDuration,
    required String nextTitle,
    required GooeyToastState nextState,
    Object? nextStateTag,
    String? nextDescription,
    Widget? nextIcon,
    Widget? nextCompactChild,
    Widget? nextExpandedChild,
    Duration? nextDuration,
    Duration closeFallback = const Duration(milliseconds: 420),
    Duration nextCompactGap = const Duration(milliseconds: 120),
    GooeyAutopilot nextExpandedAutopilot = const GooeyAutopilot(
      expandDelay: Duration.zero,
      collapseDelay: Duration(milliseconds: 2200),
    ),
    GooeyToastPosition position = GooeyToastPosition.left,
    GooeyToastExpandDirection expandDirection =
        GooeyToastExpandDirection.bottom,
    double? width,
    Color? fill,
    double? roundness,
    GooeyToastAnimationStyle? animationStyle,
    GooeyToastShapeStyle? shapeStyle,
    GooeyToastBodyAnimationStyle? bodyAnimationStyle,
    bool? enableGooeyBlur,
    bool? pauseOnHover,
    bool? swipeToDismiss,
    Set<GooeyToastSwipeDirection>? dismissDirections,
    double? dismissDragThreshold,
    double? spacing,
    bool? overlapStackWhenMultiple,
    double? overlapStackOffset,
    bool? pauseAutoDismissWhenMultiple,
    Duration? stackAnimationDuration,
    Curve? stackAnimationCurve,
    int? maxVisibleCount,
    bool? dismissWholeStackWhenMultiple,

    /// Strategy for handling another toast shown in the same region.
    ///
    /// `stack` keeps current behavior. `dismissPrevious` clears prior toasts in
    /// the target region before inserting the next toast.
    GooeyToastNewToastBehavior? newToastBehavior,
    bool persistUntilDismissed = false,
    ValueChanged<double>? onNextExpansionProgressChanged,
    GooeyCompactMorph compactMorph = const GooeyCompactMorph(),
  }) async {
    final closeCompleter = Completer<void>();
    var resolved = false;

    void resolveClosed() {
      if (resolved) return;
      resolved = true;
      closeCompleter.complete();
    }

    show(
      context: context,
      id: id,
      stateTag: '${nextStateTag ?? nextTitle}:close-current',
      title: currentTitle,
      state: currentState,
      icon: currentIcon,
      compactChild: currentCompactChild,
      expandedChild: null,
      duration: currentDuration ?? nextDuration,
      autopilot: null,
      position: position,
      expandDirection: expandDirection,
      width: width,
      fill: fill,
      roundness: roundness,
      animationStyle: animationStyle,
      shapeStyle: shapeStyle,
      bodyAnimationStyle: bodyAnimationStyle,
      enableGooeyBlur: enableGooeyBlur,
      pauseOnHover: pauseOnHover,
      swipeToDismiss: swipeToDismiss,
      dismissDirections: dismissDirections,
      dismissDragThreshold: dismissDragThreshold,
      spacing: spacing,
      overlapStackWhenMultiple: overlapStackWhenMultiple,
      overlapStackOffset: overlapStackOffset,
      pauseAutoDismissWhenMultiple: pauseAutoDismissWhenMultiple,
      stackAnimationDuration: stackAnimationDuration,
      stackAnimationCurve: stackAnimationCurve,
      maxVisibleCount: maxVisibleCount,
      dismissWholeStackWhenMultiple: dismissWholeStackWhenMultiple,
      newToastBehavior: newToastBehavior,
      persistUntilDismissed: persistUntilDismissed,
      onExpansionPhaseChanged: (phase) {
        if (phase == GooeyToastExpansionPhase.closed) resolveClosed();
      },
      compactMorph: compactMorph,
    );

    Timer(closeFallback, resolveClosed);
    await closeCompleter.future;
    if (!context.mounted) return;

    show(
      context: context,
      id: id,
      stateTag: '${nextStateTag ?? nextTitle}:compact',
      title: nextTitle,
      state: nextState,
      icon: nextIcon,
      compactChild: nextCompactChild,
      expandedChild: null,
      duration: nextDuration,
      autopilot: null,
      position: position,
      expandDirection: expandDirection,
      width: width,
      fill: fill,
      roundness: roundness,
      animationStyle: animationStyle,
      shapeStyle: shapeStyle,
      bodyAnimationStyle: bodyAnimationStyle,
      enableGooeyBlur: enableGooeyBlur,
      pauseOnHover: pauseOnHover,
      swipeToDismiss: swipeToDismiss,
      dismissDirections: dismissDirections,
      dismissDragThreshold: dismissDragThreshold,
      spacing: spacing,
      overlapStackWhenMultiple: overlapStackWhenMultiple,
      overlapStackOffset: overlapStackOffset,
      pauseAutoDismissWhenMultiple: pauseAutoDismissWhenMultiple,
      stackAnimationDuration: stackAnimationDuration,
      stackAnimationCurve: stackAnimationCurve,
      maxVisibleCount: maxVisibleCount,
      dismissWholeStackWhenMultiple: dismissWholeStackWhenMultiple,
      newToastBehavior: newToastBehavior,
      persistUntilDismissed: persistUntilDismissed,
      onExpansionProgressChanged: onNextExpansionProgressChanged,
      compactMorph: compactMorph,
    );

    if (nextDescription == null && nextExpandedChild == null) return;
    await Future<void>.delayed(nextCompactGap);
    if (!context.mounted) return;

    show(
      context: context,
      id: id,
      stateTag: '${nextStateTag ?? nextTitle}:expanded',
      title: nextTitle,
      state: nextState,
      description: nextDescription,
      icon: nextIcon,
      compactChild: nextCompactChild,
      expandedChild: nextExpandedChild,
      duration: nextDuration,
      autopilot: nextExpandedAutopilot,
      position: position,
      expandDirection: expandDirection,
      width: width,
      fill: fill,
      roundness: roundness,
      animationStyle: animationStyle,
      shapeStyle: shapeStyle,
      bodyAnimationStyle: bodyAnimationStyle,
      enableGooeyBlur: enableGooeyBlur,
      pauseOnHover: pauseOnHover,
      swipeToDismiss: swipeToDismiss,
      dismissDirections: dismissDirections,
      dismissDragThreshold: dismissDragThreshold,
      spacing: spacing,
      overlapStackWhenMultiple: overlapStackWhenMultiple,
      overlapStackOffset: overlapStackOffset,
      pauseAutoDismissWhenMultiple: pauseAutoDismissWhenMultiple,
      stackAnimationDuration: stackAnimationDuration,
      stackAnimationCurve: stackAnimationCurve,
      maxVisibleCount: maxVisibleCount,
      dismissWholeStackWhenMultiple: dismissWholeStackWhenMultiple,
      newToastBehavior: newToastBehavior,
      persistUntilDismissed: persistUntilDismissed,
      onExpansionProgressChanged: onNextExpansionProgressChanged,
      compactMorph: compactMorph,
    );
  }

  void show({
    required BuildContext context,
    String? id,
    Object? stateTag,
    required String title,
    String? description,
    GooeyToastState state = GooeyToastState.success,
    GooeyToastPosition position = GooeyToastPosition.left,
    GooeyToastExpandDirection expandDirection =
        GooeyToastExpandDirection.bottom,
    Duration? duration,
    Widget? icon,
    Widget? compactChild,
    Widget? expandedChild,
    double? width,
    Color? fill,
    double? roundness,
    GooeyAutopilot? autopilot = const GooeyAutopilot(),
    GooeyToastAnimationStyle? animationStyle,
    GooeyToastShapeStyle? shapeStyle,
    GooeyToastBodyAnimationStyle? bodyAnimationStyle,
    bool? enableGooeyBlur,
    bool? pauseOnHover,
    bool? swipeToDismiss,
    Set<GooeyToastSwipeDirection>? dismissDirections,
    double? dismissDragThreshold,
    double? spacing,
    bool? overlapStackWhenMultiple,
    double? overlapStackOffset,
    bool? pauseAutoDismissWhenMultiple,
    Duration? stackAnimationDuration,
    Curve? stackAnimationCurve,
    int? maxVisibleCount,
    bool? dismissWholeStackWhenMultiple,
    GooeyToastNewToastBehavior? newToastBehavior,
    GooeyToastAction? action,
    bool persistUntilDismissed = false,
    ValueChanged<GooeyToastExpansionPhase>? onExpansionPhaseChanged,
    ValueChanged<double>? onExpansionProgressChanged,
    GooeyCompactMorph compactMorph = const GooeyCompactMorph(),
  }) {
    final gooeyTheme = shad.ComponentTheme.maybeOf<GooeyToastTheme>(context);
    final resolvedDuration = duration ?? _kDefaultDuration;
    final resolvedWidth = width ?? gooeyTheme?.width ?? _kToastWidth;
    final resolvedFill = fill;
    final resolvedRoundness =
        roundness ?? gooeyTheme?.roundness ?? _kDefaultRoundness;
    final resolvedAnimationStyle =
        animationStyle ??
        gooeyTheme?.animationStyle ??
        GooeyToastDefaults.animationStyle;
    final resolvedShapeStyle =
        shapeStyle ?? gooeyTheme?.shapeStyle ?? GooeyToastDefaults.shapeStyle;
    final resolvedBodyAnimationStyle =
        bodyAnimationStyle ??
        gooeyTheme?.bodyAnimationStyle ??
        GooeyToastDefaults.bodyAnimationStyle;
    final resolvedEnableGooeyBlur =
        enableGooeyBlur ??
        gooeyTheme?.enableGooeyBlur ??
        GooeyToastDefaults.enableGooeyBlur;
    final resolvedPauseOnHover =
        pauseOnHover ??
        gooeyTheme?.pauseOnHover ??
        GooeyToastDefaults.pauseOnHover;
    final resolvedSwipeToDismiss =
        swipeToDismiss ??
        gooeyTheme?.swipeToDismiss ??
        GooeyToastDefaults.swipeToDismiss;
    final resolvedDismissDirections =
        dismissDirections ??
        gooeyTheme?.dismissDirections ??
        (resolvedSwipeToDismiss
            ? _defaultDismissDirections(
                position: position,
                expandDirection: expandDirection,
              )
            : const <GooeyToastSwipeDirection>{});
    final resolvedDismissDragThreshold =
        dismissDragThreshold ??
        gooeyTheme?.dismissDragThreshold ??
        GooeyToastDefaults.dismissDragThreshold;
    final resolvedSpacing =
        spacing ?? gooeyTheme?.spacing ?? GooeyToastDefaults.spacing;
    final resolvedOverlapStackWhenMultiple =
        overlapStackWhenMultiple ??
        gooeyTheme?.overlapStackWhenMultiple ??
        GooeyToastDefaults.overlapStackWhenMultiple;
    final resolvedOverlapStackOffset =
        overlapStackOffset ??
        gooeyTheme?.overlapStackOffset ??
        GooeyToastDefaults.overlapStackOffset;
    final resolvedPauseAutoDismissWhenMultiple =
        pauseAutoDismissWhenMultiple ??
        gooeyTheme?.pauseAutoDismissWhenMultiple ??
        GooeyToastDefaults.pauseAutoDismissWhenMultiple;
    final resolvedStackAnimationDuration =
        stackAnimationDuration ??
        gooeyTheme?.stackAnimationDuration ??
        GooeyToastDefaults.stackAnimationDuration;
    final resolvedStackAnimationCurve =
        stackAnimationCurve ??
        gooeyTheme?.stackAnimationCurve ??
        Curves.easeOutCubic;
    final resolvedMaxVisibleCount =
        maxVisibleCount ??
        gooeyTheme?.maxVisibleCount ??
        GooeyToastDefaults.maxVisibleCount;
    final resolvedDismissWholeStackWhenMultiple =
        dismissWholeStackWhenMultiple ??
        gooeyTheme?.dismissWholeStackWhenMultiple ??
        GooeyToastDefaults.dismissWholeStackWhenMultiple;
    final resolvedNewToastBehavior =
        newToastBehavior ?? GooeyToastDefaults.newToastBehavior;

    final resolvedPosition = position;
    final resolvedExpandDirection = expandDirection;
    final inRegion = _regionRecords(resolvedPosition, resolvedExpandDirection);
    final hasExplicitId = id != null && id.isNotEmpty;
    final toastId =
        resolvedNewToastBehavior == GooeyToastNewToastBehavior.transition
        ? (inRegion.isNotEmpty
              ? inRegion.first.id
              : (hasExplicitId ? id : 'gooey-${_nonce++}'))
        : (hasExplicitId ? id : 'gooey-${_nonce++}');

    final resolvedAnchors = _resolveAnchors(
      context: context,
      width: resolvedWidth,
      position: resolvedPosition,
      expandDirection: resolvedExpandDirection,
    );

    final data = _GooeyToastRenderData(
      id: toastId,
      stateTag: stateTag,
      title: title,
      description: description,
      state: state,
      position: resolvedPosition,
      expandDirection: resolvedExpandDirection,
      duration: resolvedDuration,
      icon: icon,
      compactChild: compactChild,
      expandedChild: expandedChild,
      width: resolvedWidth,
      fill: resolvedFill,
      roundness: resolvedRoundness,
      autopilot: autopilot,
      animationStyle: resolvedAnimationStyle,
      shapeStyle: resolvedShapeStyle,
      bodyAnimationStyle: resolvedBodyAnimationStyle,
      enableGooeyBlur: resolvedEnableGooeyBlur,
      action: action,
      onExpansionPhaseChanged: onExpansionPhaseChanged,
      onExpansionProgressChanged: onExpansionProgressChanged,
      compactMorph: compactMorph,
      pauseOnHover: resolvedPauseOnHover,
      swipeToDismiss: resolvedSwipeToDismiss,
      dismissDirections: resolvedDismissDirections,
      dismissDragThreshold: resolvedDismissDragThreshold,
      spacing: resolvedSpacing,
      overlapStackWhenMultiple: resolvedOverlapStackWhenMultiple,
      overlapStackOffset: resolvedOverlapStackOffset,
      pauseAutoDismissWhenMultiple: resolvedPauseAutoDismissWhenMultiple,
      stackAnimationDuration: resolvedStackAnimationDuration,
      stackAnimationCurve: resolvedStackAnimationCurve,
      maxVisibleCount: resolvedMaxVisibleCount,
      dismissWholeStackWhenMultiple: resolvedDismissWholeStackWhenMultiple,
      persistUntilDismissed: persistUntilDismissed,
      left: resolvedAnchors.$1,
      right: resolvedAnchors.$2,
      top: resolvedAnchors.$3,
      bottom: resolvedAnchors.$4,
    );

    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    final existing = _records[toastId];
    if (existing != null) {
      if (resolvedNewToastBehavior == GooeyToastNewToastBehavior.transition) {
        _runTransitionUpdate(toastId, data);
        return;
      }
      existing.transitionToken++;
      existing.cancelTransitionTimers();
      existing.data.value = data;
      existing.updatedAt = DateTime.now();
      _updateDetails(toastId, data);
      _scheduleAutoDismiss(toastId, data);
      _enforceMaxVisibleCount(resolvedPosition, resolvedExpandDirection);
      _refreshRegionAutoDismiss(resolvedPosition, resolvedExpandDirection);
      _rebuildAllEntries();
      notifyListeners();
      return;
    }

    if (resolvedNewToastBehavior ==
        GooeyToastNewToastBehavior.dismissPrevious) {
      final previousIds =
          _regionRecords(resolvedPosition, resolvedExpandDirection)
              .map((record) => record.id)
              .where((itemId) => itemId != toastId)
              .toList();
      for (final previousId in previousIds) {
        dismiss(previousId);
      }
    }

    final notifier = ValueNotifier<_GooeyToastRenderData>(data);
    final entry = OverlayEntry(
      builder: (entryContext) {
        final record = _records[toastId];
        if (record == null) return const SizedBox.shrink();
        final stackList = _regionRecords(
          record.data.value.position,
          record.data.value.expandDirection,
        );
        final index = stackList.indexWhere((r) => r.id == toastId);
        final renderData = record.data.value;
        final hasMultiple = stackList.length > 1;
        final visibleLimit = renderData.maxVisibleCount;
        if (visibleLimit > 0 && index >= visibleLimit) {
          return const SizedBox.shrink();
        }
        final stackOffset = hasMultiple && renderData.overlapStackWhenMultiple
            ? renderData.overlapStackOffset
            : renderData.spacing;
        final offset = (index < 0 ? 0 : index) * stackOffset;
        final top = record.data.value.top == null
            ? null
            : record.data.value.top! + offset;
        final bottom = record.data.value.bottom == null
            ? null
            : record.data.value.bottom! + offset;
        final isPrimary = index == 0;

        return ValueListenableBuilder<_GooeyToastRenderData>(
          valueListenable: record.data,
          builder: (context, render, _) {
            final toastChild = GooeyToastStackScope(
              hasMultiple: hasMultiple,
              isPrimary: isPrimary,
              expanded: false,
              itemExpanded: false,
              dismissAll: () =>
                  _dismissRegion(render.position, render.expandDirection),
              setExpanded: (_) {},
              child: GooeyToast(
                title: render.title,
                stateTag: render.stateTag,
                description: render.description,
                state: render.state,
                position: render.position,
                expandDirection: render.expandDirection,
                duration: render.duration,
                icon: render.icon,
                compactChild: render.compactChild,
                expandedChild: render.expandedChild,
                width: render.width,
                fill: render.fill,
                roundness: render.roundness,
                autopilot: render.autopilot,
                animationStyle: render.animationStyle,
                shapeStyle: render.shapeStyle,
                bodyAnimationStyle: render.bodyAnimationStyle,
                enableGooeyBlur: render.enableGooeyBlur,
                pauseOnHover: render.pauseOnHover,
                action: render.action,
                onExpansionPhaseChanged: render.onExpansionPhaseChanged,
                onExpansionProgressChanged: render.onExpansionProgressChanged,
                onInteractionChanged: (isInteracting) {
                  if (!render.pauseOnHover) return;
                  setInteracting(render.id, isInteracting);
                },
                compactMorph: render.compactMorph,
              ),
            );
            final wrappedToast =
                render.swipeToDismiss &&
                    render.dismissDirections.isNotEmpty &&
                    render.dismissDragThreshold > 0
                ? _GooeyToastSwipeDismissRegion(
                    dismissDirections: render.dismissDirections,
                    dismissDragThreshold: render.dismissDragThreshold,
                    onDismissed: () {
                      if (render.dismissWholeStackWhenMultiple && hasMultiple) {
                        _dismissRegion(render.position, render.expandDirection);
                        return;
                      }
                      dismiss(render.id);
                    },
                    child: toastChild,
                  )
                : toastChild;
            return AnimatedPositioned(
              duration: render.stackAnimationDuration,
              curve: render.stackAnimationCurve,
              top: top,
              bottom: bottom,
              left: render.left,
              right: render.right,
              child: wrappedToast,
            );
          },
        );
      },
    );

    _records[toastId] = _GooeyToastRecord(
      id: toastId,
      entry: entry,
      data: notifier,
      updatedAt: DateTime.now(),
    );

    _updateDetails(toastId, data);
    overlay.insert(entry);
    _scheduleAutoDismiss(toastId, data);
    _enforceMaxVisibleCount(resolvedPosition, resolvedExpandDirection);
    _refreshRegionAutoDismiss(resolvedPosition, resolvedExpandDirection);
    _rebuildAllEntries();
    notifyListeners();
  }

  void _runTransitionUpdate(String id, _GooeyToastRenderData nextData) {
    final record = _records[id];
    if (record == null) return;
    record.transitionToken++;
    final token = record.transitionToken;
    record.cancelTransitionTimers();

    final current = record.data.value;
    final closeDuration = _durationForAnimationStyle(current.animationStyle);
    // Smooth close phase before compact/expand handoff.
    final closeDelay = Duration(
      milliseconds: (closeDuration.inMilliseconds * 0.72).round().clamp(
        160,
        620,
      ),
    );
    const compactGap = Duration(milliseconds: 72);

    // Phase 1: collapse current toast body.
    final closeData = current.copyWith(
      stateTag: '${current.stateTag ?? current.title}:close-current',
      description: null,
      expandedChild: null,
      action: null,
      autopilot: null,
    );
    record.data.value = closeData;
    record.updatedAt = DateTime.now();
    _updateDetails(id, closeData);
    _scheduleAutoDismiss(id, closeData);
    _rebuildAllEntries();
    notifyListeners();

    void runCompactPhase() {
      final compactRecord = _records[id];
      if (compactRecord == null || compactRecord.transitionToken != token) {
        return;
      }
      // Phase 2: show next compact state.
      final compactData = nextData.copyWith(
        stateTag: '${nextData.stateTag ?? nextData.title}:compact-next',
        description: null,
        expandedChild: null,
        action: null,
        autopilot: null,
      );
      compactRecord.data.value = compactData;
      compactRecord.updatedAt = DateTime.now();
      _updateDetails(id, compactData);
      _scheduleAutoDismiss(id, compactData);
      _rebuildAllEntries();
      notifyListeners();

      final hasExpandedContent =
          nextData.description != null ||
          nextData.expandedChild != null ||
          nextData.action != null;
      if (!hasExpandedContent) return;

      // Phase 3: reopen into next expanded content.
      final expandTimer = Timer(compactGap, () {
        final expandRecord = _records[id];
        if (expandRecord == null || expandRecord.transitionToken != token) {
          return;
        }
        final expandedData = nextData.copyWith(
          stateTag: '${nextData.stateTag ?? nextData.title}:expanded-next',
          autopilot: _transitionExpandedAutopilot(nextData.autopilot),
        );
        expandRecord.data.value = expandedData;
        expandRecord.updatedAt = DateTime.now();
        _updateDetails(id, expandedData);
        _scheduleAutoDismiss(id, expandedData);
        _rebuildAllEntries();
        notifyListeners();
      });
      compactRecord.transitionTimers.add(expandTimer);
    }

    final closeTimer = Timer(closeDelay, runCompactPhase);
    record.transitionTimers.add(closeTimer);
  }

  GooeyAutopilot _transitionExpandedAutopilot(GooeyAutopilot? autopilot) {
    if (autopilot == null) {
      return const GooeyAutopilot(
        expandDelay: Duration.zero,
        collapseDelay: Duration.zero,
      );
    }
    return GooeyAutopilot(
      expandDelay: Duration.zero,
      collapseDelay: autopilot.collapseDelay,
    );
  }

  void success({
    required BuildContext context,
    required String title,
    String? description,
    Color? fill,
    GooeyAutopilot? autopilot,
  }) {
    show(
      context: context,
      title: title,
      description: description,
      state: GooeyToastState.success,
      fill: fill,
      autopilot: autopilot,
    );
  }

  void error({
    required BuildContext context,
    required String title,
    String? description,
    Color? fill,
    GooeyAutopilot? autopilot,
  }) {
    show(
      context: context,
      title: title,
      description: description,
      state: GooeyToastState.error,
      fill: fill,
      autopilot: autopilot,
    );
  }

  @override
  void dispose() {
    for (final id in _records.keys.toList()) {
      dismiss(id);
    }
    super.dispose();
  }

  void _scheduleAutoDismiss(String id, _GooeyToastRenderData data) {
    final record = _records[id];
    if (record == null) return;

    record.dismissTimer?.cancel();
    record.dismissTimer = null;
    record.dismissStartedAt = null;

    if (data.persistUntilDismissed) return;
    if (data.duration <= Duration.zero) return;

    if (record.interacting) {
      record.remaining = record.remaining ?? data.duration;
      return;
    }

    record.remaining = data.duration;
    record.dismissStartedAt = DateTime.now();
    record.dismissTimer = Timer(data.duration, () {
      if (_records.containsKey(id)) dismiss(id);
    });
  }

  void _pauseAutoDismiss(String id, _GooeyToastRecord record) {
    final data = record.data.value;
    if (data.persistUntilDismissed || data.duration <= Duration.zero) return;

    final startedAt = record.dismissStartedAt;
    if (startedAt != null) {
      final elapsed = DateTime.now().difference(startedAt);
      final base = record.remaining ?? data.duration;
      final next = base - elapsed;
      record.remaining = next.isNegative ? Duration.zero : next;
    } else {
      record.remaining ??= data.duration;
    }
    record.dismissTimer?.cancel();
    record.dismissTimer = null;
    record.dismissStartedAt = null;
  }

  void _resumeAutoDismiss(String id, _GooeyToastRecord record) {
    final data = record.data.value;
    if (data.persistUntilDismissed || data.duration <= Duration.zero) return;
    if (record.interacting || record.dismissTimer != null) return;

    final remaining = record.remaining ?? data.duration;
    if (remaining <= Duration.zero) {
      dismiss(id);
      return;
    }

    record.dismissStartedAt = DateTime.now();
    record.dismissTimer = Timer(remaining, () {
      if (_records.containsKey(id)) dismiss(id);
    });
  }

  void _refreshRegionAutoDismiss(
    GooeyToastPosition position,
    GooeyToastExpandDirection direction,
  ) {
    final records = _regionRecords(position, direction);
    final hasMultiple = records.length > 1;
    for (final record in records) {
      final data = record.data.value;
      if (!data.pauseAutoDismissWhenMultiple) continue;
      if (hasMultiple) {
        _pauseAutoDismiss(record.id, record);
      } else {
        _resumeAutoDismiss(record.id, record);
      }
    }
  }

  void _enforceMaxVisibleCount(
    GooeyToastPosition position,
    GooeyToastExpandDirection direction,
  ) {
    final records = _regionRecords(position, direction);
    if (records.isEmpty) return;
    final limits = records
        .map((record) => record.data.value.maxVisibleCount)
        .where((value) => value > 0);
    if (limits.isEmpty) return;
    final maxVisible = limits.reduce((a, b) => a < b ? a : b);
    if (records.length <= maxVisible) return;
    final overflowIds = records.skip(maxVisible).map((record) => record.id);
    for (final id in overflowIds.toList()) {
      dismiss(id);
    }
  }

  void _updateDetails(String id, _GooeyToastRenderData data) {
    final record = _records[id];
    if (record == null) return;
    record.details = GooeyToastDetails(
      id: id,
      stateTag: data.stateTag,
      title: data.title,
      description: data.description,
      state: data.state,
      position: data.position,
      expandDirection: data.expandDirection,
      duration: data.duration,
      persistUntilDismissed: data.persistUntilDismissed,
      updatedAt: DateTime.now(),
    );
    record.updatedAt = DateTime.now();
  }

  List<_GooeyToastRecord> _regionRecords(
    GooeyToastPosition position,
    GooeyToastExpandDirection direction,
  ) {
    final items = _records.values.where((r) {
      final d = r.data.value;
      return d.position == position && d.expandDirection == direction;
    }).toList()..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return items;
  }

  void _dismissRegion(
    GooeyToastPosition position,
    GooeyToastExpandDirection direction,
  ) {
    final ids = _regionRecords(position, direction).map((e) => e.id).toList();
    for (final id in ids) {
      dismiss(id);
    }
  }

  (double?, double?, double?, double?) _resolveAnchors({
    required BuildContext context,
    required double width,
    required GooeyToastPosition position,
    required GooeyToastExpandDirection expandDirection,
  }) {
    const edgeInset = 16.0;
    final media = MediaQuery.maybeOf(context);
    final screenWidth = media?.size.width ?? width;
    final screenHeight =
        media?.size.height ?? (_kToastHeight * _kMinExpandRatio);
    final leftCenter = ((screenWidth - width) / 2).clamp(
      edgeInset,
      screenWidth - width - edgeInset,
    );
    final centerTop = ((screenHeight - _kToastHeight) / 2).clamp(
      edgeInset,
      screenHeight - (_kToastHeight * _kMinExpandRatio) - edgeInset,
    );
    final isCenterBandPosition =
        position == GooeyToastPosition.centerLeft ||
        position == GooeyToastPosition.centerRight;

    final resolvedLeft = switch (position) {
      GooeyToastPosition.left => edgeInset,
      GooeyToastPosition.center => leftCenter.toDouble(),
      GooeyToastPosition.right => null,
      GooeyToastPosition.centerLeft => edgeInset,
      GooeyToastPosition.centerRight => null,
    };
    final resolvedRight = switch (position) {
      GooeyToastPosition.left => null,
      GooeyToastPosition.center => null,
      GooeyToastPosition.right => edgeInset,
      GooeyToastPosition.centerLeft => null,
      GooeyToastPosition.centerRight => edgeInset,
    };
    final showTop = expandDirection == GooeyToastExpandDirection.bottom;
    final resolvedTop = isCenterBandPosition
        ? centerTop.toDouble()
        : (showTop ? edgeInset : null);
    final resolvedBottom = isCenterBandPosition
        ? null
        : (showTop ? null : edgeInset);

    return (resolvedLeft, resolvedRight, resolvedTop, resolvedBottom);
  }

  void _rebuildAllEntries() {
    for (final record in _records.values) {
      record.entry.markNeedsBuild();
    }
  }
}

class _GooeyToastRecord {
  _GooeyToastRecord({
    required this.id,
    required this.entry,
    required this.data,
    required this.updatedAt,
  });

  /// Stable toast id.
  final String id;

  /// Inserted overlay entry for this toast.
  final OverlayEntry entry;

  /// Mutable render data driving overlay rebuilds.
  final ValueNotifier<_GooeyToastRenderData> data;

  /// Last mutation timestamp for region ordering.
  DateTime updatedAt;

  /// Public-facing toast snapshot used by [activeToasts].
  GooeyToastDetails? details;

  /// Active dismiss timer, if currently counting down.
  Timer? dismissTimer;

  /// Remaining dismiss duration while paused due to interaction.
  Duration? remaining;

  /// Timestamp captured when dismiss timer started/resumed.
  DateTime? dismissStartedAt;

  /// Whether pointer interaction is currently active for this toast.
  bool interacting = false;

  /// Monotonic token used to invalidate stale transition callbacks.
  int transitionToken = 0;

  /// Timers driving staged transition updates.
  final List<Timer> transitionTimers = [];

  void cancelTransitionTimers() {
    for (final timer in transitionTimers) {
      timer.cancel();
    }
    transitionTimers.clear();
  }

  void dispose() {
    cancelTransitionTimers();
    dismissTimer?.cancel();
    data.dispose();
  }
}

const Object _kGooeyNoValue = Object();

class _GooeyToastRenderData {
  const _GooeyToastRenderData({
    required this.id,
    required this.stateTag,
    required this.title,
    required this.description,
    required this.state,
    required this.position,
    required this.expandDirection,
    required this.duration,
    required this.icon,
    required this.compactChild,
    required this.expandedChild,
    required this.width,
    required this.fill,
    required this.roundness,
    required this.autopilot,
    required this.animationStyle,
    required this.shapeStyle,
    required this.bodyAnimationStyle,
    required this.enableGooeyBlur,
    required this.action,
    required this.onExpansionPhaseChanged,
    required this.onExpansionProgressChanged,
    required this.compactMorph,
    required this.pauseOnHover,
    required this.swipeToDismiss,
    required this.dismissDirections,
    required this.dismissDragThreshold,
    required this.spacing,
    required this.overlapStackWhenMultiple,
    required this.overlapStackOffset,
    required this.pauseAutoDismissWhenMultiple,
    required this.stackAnimationDuration,
    required this.stackAnimationCurve,
    required this.maxVisibleCount,
    required this.dismissWholeStackWhenMultiple,
    required this.persistUntilDismissed,
    required this.left,
    required this.right,
    required this.top,
    required this.bottom,
  });

  /// Stable id of this toast render payload.
  final String id;

  /// State tag for compact morph transitions.
  final Object? stateTag;

  /// Compact title text.
  final String title;

  /// Expanded description text.
  final String? description;

  /// Semantic visual state.
  final GooeyToastState state;

  /// Horizontal anchor.
  final GooeyToastPosition position;

  /// Vertical growth direction.
  final GooeyToastExpandDirection expandDirection;

  /// Auto-dismiss duration.
  final Duration duration;

  /// Optional compact icon override.
  final Widget? icon;

  /// Optional compact body override.
  final Widget? compactChild;

  /// Optional expanded body override.
  final Widget? expandedChild;

  /// Render width.
  final double width;

  /// Surface fill.
  final Color? fill;

  /// Base roundness.
  final double roundness;

  /// Expand/collapse autopilot policy.
  final GooeyAutopilot? autopilot;

  /// Expansion animation style.
  final GooeyToastAnimationStyle animationStyle;

  /// Shape style variant.
  final GooeyToastShapeStyle shapeStyle;

  /// Expanded body content animation style.
  final GooeyToastBodyAnimationStyle bodyAnimationStyle;

  /// Gooey blur toggle.
  final bool enableGooeyBlur;

  /// Optional expanded action.
  final GooeyToastAction? action;

  /// Expansion phase callback.
  final ValueChanged<GooeyToastExpansionPhase>? onExpansionPhaseChanged;

  /// Expansion progress callback.
  final ValueChanged<double>? onExpansionProgressChanged;

  /// Compact morph configuration.
  final GooeyCompactMorph compactMorph;

  /// Pause-dismiss-on-hover behavior toggle.
  final bool pauseOnHover;

  /// Swipe dismiss behavior toggle.
  final bool swipeToDismiss;

  /// Allowed swipe dismiss directions.
  final Set<GooeyToastSwipeDirection> dismissDirections;

  /// Swipe threshold in px.
  final double dismissDragThreshold;

  /// Inter-toast spacing in stacked region.
  final double spacing;

  /// Whether stacked toasts should use overlap offset instead of spacing.
  final bool overlapStackWhenMultiple;

  /// Per-item offset when overlap stacking is active.
  final double overlapStackOffset;

  /// Whether auto-dismiss pauses while the region has multiple toasts.
  final bool pauseAutoDismissWhenMultiple;

  /// Duration used when stack entries reflow.
  final Duration stackAnimationDuration;

  /// Curve used when stack entries reflow.
  final Curve stackAnimationCurve;

  /// Max visible entries in this region. `0` means unlimited.
  final int maxVisibleCount;

  /// Whether a dismiss gesture clears the whole region stack.
  final bool dismissWholeStackWhenMultiple;

  /// Whether manual dismiss is required.
  final bool persistUntilDismissed;

  /// Resolved left anchor.
  final double? left;

  /// Resolved right anchor.
  final double? right;

  /// Resolved top anchor.
  final double? top;

  /// Resolved bottom anchor.
  final double? bottom;

  _GooeyToastRenderData copyWith({
    String? id,
    Object? stateTag,
    String? title,
    Object? description = _kGooeyNoValue,
    GooeyToastState? state,
    GooeyToastPosition? position,
    GooeyToastExpandDirection? expandDirection,
    Duration? duration,
    Widget? icon,
    Widget? compactChild,
    Object? expandedChild = _kGooeyNoValue,
    double? width,
    Color? fill,
    double? roundness,
    Object? autopilot = _kGooeyNoValue,
    GooeyToastAnimationStyle? animationStyle,
    GooeyToastShapeStyle? shapeStyle,
    GooeyToastBodyAnimationStyle? bodyAnimationStyle,
    bool? enableGooeyBlur,
    Object? action = _kGooeyNoValue,
    ValueChanged<GooeyToastExpansionPhase>? onExpansionPhaseChanged,
    ValueChanged<double>? onExpansionProgressChanged,
    GooeyCompactMorph? compactMorph,
    bool? pauseOnHover,
    bool? swipeToDismiss,
    Set<GooeyToastSwipeDirection>? dismissDirections,
    double? dismissDragThreshold,
    double? spacing,
    bool? overlapStackWhenMultiple,
    double? overlapStackOffset,
    bool? pauseAutoDismissWhenMultiple,
    Duration? stackAnimationDuration,
    Curve? stackAnimationCurve,
    int? maxVisibleCount,
    bool? dismissWholeStackWhenMultiple,
    bool? persistUntilDismissed,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    return _GooeyToastRenderData(
      id: id ?? this.id,
      stateTag: stateTag ?? this.stateTag,
      title: title ?? this.title,
      description: identical(description, _kGooeyNoValue)
          ? this.description
          : description as String?,
      state: state ?? this.state,
      position: position ?? this.position,
      expandDirection: expandDirection ?? this.expandDirection,
      duration: duration ?? this.duration,
      icon: icon ?? this.icon,
      compactChild: compactChild ?? this.compactChild,
      expandedChild: identical(expandedChild, _kGooeyNoValue)
          ? this.expandedChild
          : expandedChild as Widget?,
      width: width ?? this.width,
      fill: fill ?? this.fill,
      roundness: roundness ?? this.roundness,
      autopilot: identical(autopilot, _kGooeyNoValue)
          ? this.autopilot
          : autopilot as GooeyAutopilot?,
      animationStyle: animationStyle ?? this.animationStyle,
      shapeStyle: shapeStyle ?? this.shapeStyle,
      bodyAnimationStyle: bodyAnimationStyle ?? this.bodyAnimationStyle,
      enableGooeyBlur: enableGooeyBlur ?? this.enableGooeyBlur,
      action: identical(action, _kGooeyNoValue)
          ? this.action
          : action as GooeyToastAction?,
      onExpansionPhaseChanged:
          onExpansionPhaseChanged ?? this.onExpansionPhaseChanged,
      onExpansionProgressChanged:
          onExpansionProgressChanged ?? this.onExpansionProgressChanged,
      compactMorph: compactMorph ?? this.compactMorph,
      pauseOnHover: pauseOnHover ?? this.pauseOnHover,
      swipeToDismiss: swipeToDismiss ?? this.swipeToDismiss,
      dismissDirections: dismissDirections ?? this.dismissDirections,
      dismissDragThreshold: dismissDragThreshold ?? this.dismissDragThreshold,
      spacing: spacing ?? this.spacing,
      overlapStackWhenMultiple:
          overlapStackWhenMultiple ?? this.overlapStackWhenMultiple,
      overlapStackOffset: overlapStackOffset ?? this.overlapStackOffset,
      pauseAutoDismissWhenMultiple:
          pauseAutoDismissWhenMultiple ?? this.pauseAutoDismissWhenMultiple,
      stackAnimationDuration:
          stackAnimationDuration ?? this.stackAnimationDuration,
      stackAnimationCurve: stackAnimationCurve ?? this.stackAnimationCurve,
      maxVisibleCount: maxVisibleCount ?? this.maxVisibleCount,
      dismissWholeStackWhenMultiple:
          dismissWholeStackWhenMultiple ?? this.dismissWholeStackWhenMultiple,
      persistUntilDismissed:
          persistUntilDismissed ?? this.persistUntilDismissed,
      left: left ?? this.left,
      right: right ?? this.right,
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
    );
  }
}

class _GooeyToastSwipeDismissRegion extends StatefulWidget {
  const _GooeyToastSwipeDismissRegion({
    required this.dismissDirections,
    required this.dismissDragThreshold,
    required this.onDismissed,
    required this.child,
  });

  /// Allowed directions that can dismiss this toast.
  final Set<GooeyToastSwipeDirection> dismissDirections;

  /// Minimum drag distance required to trigger dismiss.
  final double dismissDragThreshold;

  /// Called once when a valid dismiss drag finishes.
  final VoidCallback onDismissed;

  /// Child toast content.
  final Widget child;

  @override
  State<_GooeyToastSwipeDismissRegion> createState() =>
      _GooeyToastSwipeDismissRegionState();
}

class _GooeyToastSwipeDismissRegionState
    extends State<_GooeyToastSwipeDismissRegion> {
  /// Active pointer being tracked for drag-dismiss.
  int? _activePointer;

  /// Global pointer down position for current drag.
  Offset? _dragStart;

  /// Last global pointer position seen for current drag.
  Offset? _dragLast;

  void _resetDrag() {
    _activePointer = null;
    _dragStart = null;
    _dragLast = null;
  }

  GooeyToastSwipeDirection _resolveDirection(Offset delta) {
    if (delta.dx.abs() >= delta.dy.abs()) {
      return delta.dx >= 0
          ? GooeyToastSwipeDirection.right
          : GooeyToastSwipeDirection.left;
    }
    return delta.dy >= 0
        ? GooeyToastSwipeDirection.down
        : GooeyToastSwipeDirection.up;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.deferToChild,
      onPointerDown: (event) {
        _activePointer ??= event.pointer;
        if (_activePointer != event.pointer) return;
        _dragStart = event.position;
        _dragLast = event.position;
      },
      onPointerMove: (event) {
        if (_activePointer != event.pointer) return;
        _dragLast = event.position;
      },
      onPointerCancel: (event) {
        if (_activePointer != event.pointer) return;
        _resetDrag();
      },
      onPointerUp: (event) {
        if (_activePointer != event.pointer) return;
        final start = _dragStart;
        final end = _dragLast ?? event.position;
        _resetDrag();
        if (start == null) return;
        final delta = end - start;
        if (delta.distance < widget.dismissDragThreshold) return;
        final direction = _resolveDirection(delta);
        if (!widget.dismissDirections.contains(direction)) return;
        widget.onDismissed();
      },
      child: widget.child,
    );
  }
}

class GooeyToastStackScope extends InheritedWidget {
  const GooeyToastStackScope({
    super.key,
    required this.hasMultiple,
    required this.isPrimary,
    required this.expanded,
    required this.itemExpanded,
    required this.dismissAll,
    required this.setExpanded,
    required super.child,
  });

  final bool hasMultiple;
  final bool isPrimary;
  final bool expanded;
  final bool itemExpanded;
  final VoidCallback dismissAll;
  final ValueChanged<bool> setExpanded;

  static GooeyToastStackScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GooeyToastStackScope>();
  }

  @override
  bool updateShouldNotify(covariant GooeyToastStackScope oldWidget) {
    return hasMultiple != oldWidget.hasMultiple ||
        isPrimary != oldWidget.isPrimary ||
        expanded != oldWidget.expanded ||
        itemExpanded != oldWidget.itemExpanded;
  }
}
