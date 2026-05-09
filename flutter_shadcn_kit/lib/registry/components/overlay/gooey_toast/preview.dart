// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:async';

import 'package:flutter/material.dart';

import 'gooey_toast.dart';

/// GooeyToastPreview defines a reusable type for this registry module.
class GooeyToastPreview extends StatefulWidget {
  const GooeyToastPreview({super.key});

  @override
  State<GooeyToastPreview> createState() => _GooeyToastPreviewState();
}

class _GooeyToastPreviewState extends State<GooeyToastPreview> {
  /// Controller used to show, update, and dismiss demo toasts.
  final GooeyToastController _controller = GooeyToastController();

  /// Timer used by simple async/promise demo.
  Timer? _promiseTimer;

  /// Timers used by multi-step scripted flows.
  final List<Timer> _flowTimers = [];

  /// Selected viewport preset index.
  int _selectedPresetIndex = 2;

  /// Last selected demo action chip.
  _DemoAction? _selectedAction;

  /// Active animation style override.
  GooeyToastAnimationStyle _animationStyle = GooeyToastAnimationStyle.sileo;

  /// Active body content animation style override.
  GooeyToastBodyAnimationStyle _bodyAnimationStyle =
      GooeyToastBodyAnimationStyle.fade;

  /// Active shape style override.
  GooeyToastShapeStyle _shapeStyle = GooeyToastShapeStyle.defaultShape;

  /// Whether blur pass is enabled for newly triggered demos.
  bool _enableGooeyBlur = true;

  /// Whether autopilot expand/collapse is enabled for demo toasts.
  bool _autopilotEnabled = true;

  /// Whether interaction pauses dismiss countdown.
  bool _pauseOnHover = true;

  /// Dismiss policy mode for swipe directions.
  _DismissBehavior _dismissBehavior = _DismissBehavior.auto;

  /// Same-region insertion strategy for new toasts.
  GooeyToastNewToastBehavior _newToastBehavior =
      GooeyToastNewToastBehavior.stack;

  /// Custom dismiss directions used when dismiss behavior is [custom].
  final Set<GooeyToastSwipeDirection> _customDismissDirections = {
    GooeyToastSwipeDirection.up,
    GooeyToastSwipeDirection.right,
  };

  /// Custom flow id input controller.
  final TextEditingController _customFlowIdController = TextEditingController(
    text: 'custom-flow-demo',
  );

  /// Custom step title input controller.
  final TextEditingController _customTitleController = TextEditingController(
    text: 'Booking In Progress',
  );

  /// Custom step description input controller.
  final TextEditingController _customDescriptionController =
      TextEditingController(
        text: 'Preparing your itinerary and verifying payment.',
      );

  /// Custom step duration input controller in milliseconds.
  final TextEditingController _customDurationController = TextEditingController(
    text: '1800',
  );

  /// Custom step state selection.
  GooeyToastState _customState = GooeyToastState.loading;

  /// Whether current input step should open expanded.
  bool _customStepExpanded = true;

  /// Whether current input step should persist until manual dismiss.
  bool _customStepPersistent = false;

  /// Stored custom flow steps.
  final List<_CustomStateStep> _customSteps = [];

  /// Current index within active flow.
  int _customFlowCurrentIndex = -1;

  /// Current active flow id.
  String _customFlowActiveId = '';

  /// Whether flow runner is currently in-progress.
  bool _customFlowRunning = false;

  /// Monotonic token used to invalidate stale async flow callbacks.
  int _customFlowRunToken = 0;

  /// Start trigger flag set by UI before flow runner executes.
  bool _customFlowStartRequested = false;

  /// Selected flow-advance mode.
  _FlowAdvanceMode _customFlowAdvanceMode = _FlowAdvanceMode.phaseClosed;

  /// Progress threshold used by progress-based flow advance mode.
  double _customFlowProgressTrigger = 0.9;

  /// Compact morph duration control in milliseconds.
  int _compactMorphMs = 400;

  /// Compact morph slide amount.
  double _compactMorphSlide = 0.10;

  /// Compact morph start scale.
  double _compactMorphScaleFrom = 0.80;

  /// Selected compact morph curve preset.
  _MorphCurvePreset _morphCurvePreset = _MorphCurvePreset.emphasized;

  static const List<_ViewportPreset> _presets = [
    _ViewportPreset(
      label: 'top-left',
      position: GooeyToastPosition.left,
      expandDirection: GooeyToastExpandDirection.bottom,
    ),
    _ViewportPreset(
      label: 'top-center',
      position: GooeyToastPosition.center,
      expandDirection: GooeyToastExpandDirection.bottom,
    ),
    _ViewportPreset(
      label: 'top-right',
      position: GooeyToastPosition.right,
      expandDirection: GooeyToastExpandDirection.bottom,
    ),
    _ViewportPreset(
      label: 'center-left',
      position: GooeyToastPosition.centerLeft,
      expandDirection: GooeyToastExpandDirection.bottom,
    ),
    _ViewportPreset(
      label: 'center',
      position: GooeyToastPosition.center,
      expandDirection: GooeyToastExpandDirection.bottom,
    ),
    _ViewportPreset(
      label: 'center-right',
      position: GooeyToastPosition.centerRight,
      expandDirection: GooeyToastExpandDirection.bottom,
    ),
    _ViewportPreset(
      label: 'bottom-left',
      position: GooeyToastPosition.left,
      expandDirection: GooeyToastExpandDirection.top,
    ),
    _ViewportPreset(
      label: 'bottom-center',
      position: GooeyToastPosition.center,
      expandDirection: GooeyToastExpandDirection.top,
    ),
    _ViewportPreset(
      label: 'bottom-right',
      position: GooeyToastPosition.right,
      expandDirection: GooeyToastExpandDirection.top,
    ),
  ];

  static const List<_DemoAction> _actions = [
    _DemoAction.success,
    _DemoAction.error,
    _DemoAction.warning,
    _DemoAction.info,
    _DemoAction.action,
    _DemoAction.icon,
    _DemoAction.promise,
    _DemoAction.customCompact,
    _DemoAction.customExpanded,
    _DemoAction.customBoth,
    _DemoAction.flightPath,
    _DemoAction.interactiveReply,
    _DemoAction.flightPromise,
    _DemoAction.customStateFlow,
    _DemoAction.tabsListView,
    _DemoAction.positionTriggers,
  ];

  @override
  void dispose() {
    _promiseTimer?.cancel();
    for (final timer in _flowTimers) {
      timer.cancel();
    }
    _customFlowIdController.dispose();
    _customTitleController.dispose();
    _customDescriptionController.dispose();
    _customDurationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _triggerDemo(_DemoAction action) {
    setState(() => _selectedAction = action);
    _promiseTimer?.cancel();
    for (final timer in _flowTimers) {
      timer.cancel();
    }
    _flowTimers.clear();

    final preset = _presets[_selectedPresetIndex];
    final defaultToastId = 'demo-${action.name}';
    final swipeToDismiss = _dismissBehavior != _DismissBehavior.off;
    final customDirections = _customDismissDirections.isEmpty
        ? <GooeyToastSwipeDirection>{GooeyToastSwipeDirection.up}
        : Set<GooeyToastSwipeDirection>.from(_customDismissDirections);
    final dismissDirections = switch (_dismissBehavior) {
      _DismissBehavior.auto => null,
      _DismissBehavior.off => <GooeyToastSwipeDirection>{},
      _DismissBehavior.custom => customDirections,
    };
    final compactMorph = GooeyCompactMorph(
      duration: Duration(milliseconds: _compactMorphMs.clamp(80, 1200)),
      curve: _morphCurvePreset.curve,
      slideOffset: Offset(0, _compactMorphSlide.clamp(0.0, 0.5)),
      scaleFrom: _compactMorphScaleFrom.clamp(0.7, 1.0),
    );

    void show({
      required String title,
      String? id,
      Object? stateTag,
      String? description,
      GooeyToastState state = GooeyToastState.success,
      Widget? icon,
      GooeyToastAction? action,
      Widget? compactChild,
      Widget? expandedChild,
      Duration? duration,
      GooeyAutopilot? autopilot,
      bool? persistUntilDismissed,
      ValueChanged<GooeyToastExpansionPhase>? onExpansionPhaseChanged,
      ValueChanged<double>? onExpansionProgressChanged,
      bool? enableGooeyBlur,
    }) {
      _controller.show(
        context: context,
        id: id ?? defaultToastId,
        stateTag: stateTag,
        title: title,
        description: description,
        state: state,
        position: preset.position,
        expandDirection: preset.expandDirection,
        animationStyle: _animationStyle,
        bodyAnimationStyle: _bodyAnimationStyle,
        shapeStyle: _shapeStyle,
        enableGooeyBlur: enableGooeyBlur ?? _enableGooeyBlur,
        pauseOnHover: _pauseOnHover,
        swipeToDismiss: swipeToDismiss,
        dismissDirections: dismissDirections,
        dismissDragThreshold: 68,
        autopilot:
            autopilot ?? (_autopilotEnabled ? const GooeyAutopilot() : null),
        icon: icon,
        action: action,
        compactChild: compactChild,
        expandedChild: expandedChild,
        duration: duration,
        persistUntilDismissed: persistUntilDismissed ?? false,
        onExpansionPhaseChanged: onExpansionPhaseChanged,
        onExpansionProgressChanged: onExpansionProgressChanged,
        compactMorph: compactMorph,
        newToastBehavior: _newToastBehavior,
      );
    }

    Future<void> transitionToState({
      required String id,
      required Object stateTag,
      required String title,
      required GooeyToastState state,
      String? description,
      Widget? compactChild,
      Widget? expandedChild,
      Duration? duration,
      Duration? compactGap,
      GooeyAutopilot? expandedAutopilot,
      bool? persistUntilDismissed,
      Duration? nextCompactGap,
      ValueChanged<GooeyToastExpansionPhase>? onExpandedPhaseChanged,
      ValueChanged<double>? onExpandedProgressChanged,
    }) async {
      final resolvedCompactGap =
          compactGap ?? const Duration(milliseconds: 260);
      final resolvedExpandedAutopilot =
          expandedAutopilot ??
          const GooeyAutopilot(
            expandDelay: Duration.zero,
            collapseDelay: Duration(milliseconds: 2200),
          );
      final resolvedPersist = persistUntilDismissed ?? false;
      final resolvedNextCompactGap =
          nextCompactGap ?? const Duration(milliseconds: 120);
      GooeyToastDetails? current;
      for (final item in _controller.activeToasts) {
        if (item.id == id) {
          current = item;
          break;
        }
      }

      if (current == null) {
        show(
          id: id,
          stateTag: '$stateTag:next-compact',
          title: title,
          state: state,
          description: null,
          compactChild: compactChild,
          expandedChild: null,
          duration: duration,
          autopilot: null,
          persistUntilDismissed: resolvedPersist,
        );
        if (description == null && expandedChild == null) return;
        await Future<void>.delayed(resolvedNextCompactGap);
        if (!mounted) return;
        show(
          id: id,
          stateTag: '$stateTag:expanded',
          title: title,
          state: state,
          description: description,
          compactChild: compactChild,
          expandedChild: expandedChild,
          duration: duration,
          autopilot: resolvedExpandedAutopilot,
          persistUntilDismissed: resolvedPersist,
          onExpansionPhaseChanged: onExpandedPhaseChanged,
          onExpansionProgressChanged: onExpandedProgressChanged,
        );
        return;
      }

      await _controller.transitionAfterClosed(
        context: context,
        id: id,
        currentTitle: current.title,
        currentState: current.state,
        nextTitle: title,
        nextState: state,
        nextStateTag: stateTag,
        nextDescription: description,
        nextCompactChild: compactChild,
        nextExpandedChild: expandedChild,
        nextDuration: duration,
        closeFallback: Duration(
          milliseconds: resolvedCompactGap.inMilliseconds + 160,
        ),
        nextCompactGap: resolvedNextCompactGap,
        nextExpandedAutopilot: resolvedExpandedAutopilot,
        position: preset.position,
        expandDirection: preset.expandDirection,
        animationStyle: _animationStyle,
        bodyAnimationStyle: _bodyAnimationStyle,
        shapeStyle: _shapeStyle,
        pauseOnHover: _pauseOnHover,
        swipeToDismiss: swipeToDismiss,
        dismissDirections: dismissDirections,
        dismissDragThreshold: 68,
        newToastBehavior: _newToastBehavior,
        persistUntilDismissed: resolvedPersist,
        compactMorph: compactMorph,
        onNextExpansionProgressChanged: onExpandedProgressChanged,
      );
      if (onExpandedPhaseChanged != null) {
        onExpandedPhaseChanged(GooeyToastExpansionPhase.open);
      }
    }

    void showRenderVariantComparison() {
      _controller.dismiss('variant-gooey');
      _controller.dismiss('variant-flat');
      _controller.show(
        context: context,
        id: 'variant-gooey',
        stateTag: 'variant-gooey',
        title: 'With Gooey Blur',
        description: 'Metaball blur pass enabled.',
        state: GooeyToastState.info,
        position: GooeyToastPosition.centerLeft,
        expandDirection: GooeyToastExpandDirection.bottom,
        animationStyle: _animationStyle,
        bodyAnimationStyle: _bodyAnimationStyle,
        shapeStyle: _shapeStyle,
        enableGooeyBlur: true,
        pauseOnHover: _pauseOnHover,
        swipeToDismiss: swipeToDismiss,
        dismissDirections: dismissDirections,
        dismissDragThreshold: 68,
        newToastBehavior: _newToastBehavior,
        autopilot: _autopilotEnabled ? const GooeyAutopilot() : null,
      );
      _controller.show(
        context: context,
        id: 'variant-flat',
        stateTag: 'variant-flat',
        title: 'Without Gooey Blur',
        description: 'Crisp-only paint pass, no metaball blur.',
        state: GooeyToastState.info,
        position: GooeyToastPosition.centerRight,
        expandDirection: GooeyToastExpandDirection.bottom,
        animationStyle: _animationStyle,
        bodyAnimationStyle: _bodyAnimationStyle,
        shapeStyle: _shapeStyle,
        enableGooeyBlur: false,
        pauseOnHover: _pauseOnHover,
        swipeToDismiss: swipeToDismiss,
        dismissDirections: dismissDirections,
        dismissDragThreshold: 68,
        newToastBehavior: _newToastBehavior,
        autopilot: _autopilotEnabled ? const GooeyAutopilot() : null,
      );
    }

    switch (action) {
      case _DemoAction.success:
        show(
          title: 'Changes Saved',
          description:
              'Changes saved successfully to the database.\nPlease refresh the page to see the changes.',
          state: GooeyToastState.success,
        );
      case _DemoAction.error:
        show(
          title: 'Upload Failed',
          description: 'Please check your connection and try again.',
          state: GooeyToastState.error,
        );
      case _DemoAction.warning:
        show(
          title: 'Storage Warning',
          description: 'You are running out of storage space.',
          state: GooeyToastState.warning,
        );
      case _DemoAction.info:
        show(
          title: 'Heads up',
          description: 'A new update is available for your workspace.',
          state: GooeyToastState.info,
        );
      case _DemoAction.action:
        show(
          title: 'New Message',
          description: 'Click reply to respond from this thread.',
          state: GooeyToastState.action,
          action: GooeyToastAction(label: 'Reply', onPressed: () {}),
        );
      case _DemoAction.icon:
        show(
          title: 'Custom Icon',
          description: 'Toasts can render a custom leading icon widget.',
          state: GooeyToastState.success,
          icon: const Icon(Icons.auto_awesome_rounded),
        );
      case _DemoAction.promise:
        show(
          id: defaultToastId,
          stateTag: 'promise:loading',
          title: 'Saving Changes',
          description: 'Waiting for server response...',
          state: GooeyToastState.loading,
          duration: const Duration(milliseconds: 2600),
          autopilot: const GooeyAutopilot(
            expandDelay: Duration.zero,
            collapseDelay: Duration(milliseconds: 1400),
          ),
        );
        _promiseTimer = Timer(const Duration(milliseconds: 1700), () {
          if (!mounted) return;
          transitionToState(
            id: defaultToastId,
            stateTag: 'promise:success',
            title: 'Changes Saved',
            state: GooeyToastState.success,
            description:
                'Operation completed successfully and synced to the database.',
            duration: const Duration(milliseconds: 2800),
          );
        });
      case _DemoAction.customCompact:
        show(
          title: 'Deploy Complete',
          description:
              'Changes are live. Expanded body uses the default layout for this variant.',
          state: GooeyToastState.success,
          compactChild: Row(
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: const BoxDecoration(
                  color: Color(0x1A63C65E),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  size: 14,
                  color: Color(0xFF63C65E),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Deploy Complete',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF63C65E),
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        );
      case _DemoAction.customExpanded:
        show(
          title: 'Workspace Notice',
          state: GooeyToastState.info,
          expandedChild: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Release 4.12.0',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF77A8FF),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Project-level schema checks completed. All migrations applied and indexed successfully. No conflicts detected.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Color(0xFFC0C5CB),
                ),
              ),
            ],
          ),
        );
      case _DemoAction.customBoth:
        show(
          title: 'Deployment',
          description: 'Build #441 is now live in production.',
          state: GooeyToastState.success,
          compactChild: Row(
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: const BoxDecoration(
                  color: Color(0x1A63C65E),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  size: 14,
                  color: Color(0xFF63C65E),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Deploy Complete',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF63C65E),
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          expandedChild: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Production / us-east-1',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF63C65E),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'All checks passed. Latency is within baseline and traffic is stable.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Color(0xFFC0C5CB),
                ),
              ),
            ],
          ),
        );
      case _DemoAction.flightPath:
        show(
          title: 'Booking Confirmed',
          state: GooeyToastState.success,
          compactChild: Row(
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: const BoxDecoration(
                  color: Color(0x1A63C65E),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: Color(0xFF42C853),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Booking Confirmed',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF42C853),
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          expandedChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: const [
                  Text(
                    'UNITED',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 3.2,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE8E8E8),
                    ),
                  ),
                  Spacer(),
                  Text(
                    'PNR EC2QW4',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF8C8C8C),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 62,
                child: Stack(
                  children: [
                    const Positioned(
                      left: 8,
                      bottom: 0,
                      child: Text(
                        'DEL',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEDEDED),
                        ),
                      ),
                    ),
                    const Positioned(
                      right: 8,
                      bottom: 0,
                      child: Text(
                        'SFO',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEDEDED),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 2,
                      child: Text(
                        '------------------------------',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(
                            0xFF42C853,
                          ).withValues(alpha: 0.55),
                          fontSize: 16,
                          letterSpacing: 1.8,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                    ),
                    Positioned(left: 56, bottom: 6, child: _flightDot()),
                    Positioned(right: 56, bottom: 6, child: _flightDot()),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF123E1C), Color(0xFF1E5F29)],
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4DDE5D),
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        );
      case _DemoAction.interactiveReply:
        const toastId = 'interactive-reply-toast';
        const idleTone = Color(0xFF8EA3FF);
        const successTone = Color(0xFF63C65E);
        const cancelTone = Color(0xFF9AA7BD);

        void showReplyComposer() {
          show(
            id: toastId,
            stateTag: 'reply:compose',
            title: 'Thread Reply',
            state: GooeyToastState.action,
            compactChild: _replyCompact(
              title: 'Thread Reply',
              tone: idleTone,
              icon: Icons.forum_rounded,
            ),
            expandedChild: _InteractiveReplyExpanded(
              onSend: (message) {
                transitionToState(
                  id: toastId,
                  stateTag: 'reply:sent:$message',
                  title: 'Message Sent',
                  state: GooeyToastState.success,
                  duration: const Duration(milliseconds: 2600),
                  compactChild: _replyCompact(
                    title: 'Message Sent',
                    tone: successTone,
                    icon: Icons.check_rounded,
                  ),
                  expandedChild: _ReplyResultExpanded(
                    title: 'Delivered to thread',
                    body: 'Your reply was sent successfully.\n"$message"',
                    tone: successTone,
                  ),
                );
              },
              onCancel: () {
                transitionToState(
                  id: toastId,
                  stateTag: 'reply:cancelled',
                  title: 'Reply Cancelled',
                  state: GooeyToastState.info,
                  duration: const Duration(milliseconds: 2000),
                  compactChild: _replyCompact(
                    title: 'Reply Cancelled',
                    tone: cancelTone,
                    icon: Icons.close_rounded,
                  ),
                  expandedChild: const _ReplyResultExpanded(
                    title: 'Draft discarded',
                    body:
                        'No message was sent. You can open the composer again any time.',
                    tone: cancelTone,
                  ),
                );
              },
            ),
          );
        }

        showReplyComposer();
      case _DemoAction.flightPromise:
        _showFlightPromiseFlow(show, transitionToState);
      case _DemoAction.customStateFlow:
        final id = _customFlowIdController.text.trim().isEmpty
            ? 'custom-flow-demo'
            : _customFlowIdController.text.trim();
        final steps = _customSteps.isEmpty
            ? <_CustomStateStep>[_buildStepFromInputs()]
            : List<_CustomStateStep>.from(_customSteps);
        if (_customFlowActiveId != id) {
          _customFlowCurrentIndex = -1;
        }
        bool shouldAdvance({
          GooeyToastExpansionPhase? phase,
          double? progress,
        }) {
          switch (_customFlowAdvanceMode) {
            case _FlowAdvanceMode.phaseClosed:
              return phase == GooeyToastExpansionPhase.closed;
            case _FlowAdvanceMode.progress:
              return (progress ?? 0) >= _customFlowProgressTrigger;
          }
        }

        void runFromIndex(int currentIndex, int token) {
          if (!mounted || token != _customFlowRunToken) return;
          if (currentIndex >= steps.length - 1) {
            setState(() => _customFlowRunning = false);
            return;
          }
          final previous = steps[currentIndex];
          final nextIndex = currentIndex + 1;
          final next = steps[nextIndex];
          var advanced = false;
          void advanceIfReady({
            GooeyToastExpansionPhase? phase,
            double? progress,
          }) {
            if (advanced || token != _customFlowRunToken || !mounted) return;
            if (!shouldAdvance(phase: phase, progress: progress)) return;
            advanced = true;
            setState(() => _customFlowCurrentIndex = nextIndex);
            runFromIndex(nextIndex, token);
          }

          transitionToState(
            id: id,
            stateTag: 'custom:$nextIndex:${next.state.name}',
            title: next.title,
            state: next.state,
            description: next.expanded ? next.description : null,
            duration: next.duration,
            compactGap: Duration(
              milliseconds: (previous.duration.inMilliseconds * 0.22)
                  .round()
                  .clamp(180, 600),
            ),
            nextCompactGap: const Duration(milliseconds: 120),
            persistUntilDismissed: next.persistUntilDismissed,
            onExpandedPhaseChanged: (phase) => advanceIfReady(phase: phase),
            onExpandedProgressChanged: (progress) =>
                advanceIfReady(progress: progress),
          );
        }

        if (_customFlowStartRequested) {
          _customFlowStartRequested = false;
          final token = ++_customFlowRunToken;
          setState(() {
            _customFlowActiveId = id;
            _customFlowCurrentIndex = 0;
            _customFlowRunning = true;
          });
          final first = steps.first;
          var advanced = false;
          void advanceFromFirst({
            GooeyToastExpansionPhase? phase,
            double? progress,
          }) {
            if (advanced || token != _customFlowRunToken || !mounted) return;
            if (!shouldAdvance(phase: phase, progress: progress)) return;
            advanced = true;
            runFromIndex(0, token);
          }

          show(
            id: id,
            stateTag: 'custom:0:${first.state.name}:expanded',
            title: first.title,
            state: first.state,
            description: first.expanded ? first.description : null,
            duration: first.duration,
            persistUntilDismissed: first.persistUntilDismissed,
            autopilot: first.expanded
                ? const GooeyAutopilot(
                    expandDelay: Duration.zero,
                    collapseDelay: Duration(milliseconds: 2200),
                  )
                : null,
            onExpansionPhaseChanged: (phase) => advanceFromFirst(phase: phase),
            onExpansionProgressChanged: (progress) =>
                advanceFromFirst(progress: progress),
          );
          if (!first.expanded) {
            runFromIndex(0, token);
          }
          return;
        }

        final nextIndex = (_customFlowCurrentIndex + 1).clamp(
          0,
          steps.length - 1,
        );
        if (_customFlowCurrentIndex < 0) {
          final step = steps[nextIndex];
          show(
            id: id,
            stateTag: 'custom:$nextIndex:${step.state.name}:expanded',
            title: step.title,
            state: step.state,
            description: step.expanded ? step.description : null,
            duration: step.duration,
            persistUntilDismissed: step.persistUntilDismissed,
            autopilot: step.expanded
                ? const GooeyAutopilot(
                    expandDelay: Duration.zero,
                    collapseDelay: Duration(milliseconds: 2200),
                  )
                : null,
          );
        } else {
          final previous = steps[_customFlowCurrentIndex];
          final next = steps[nextIndex];
          transitionToState(
            id: id,
            stateTag: 'custom:$nextIndex:${next.state.name}',
            title: next.title,
            state: next.state,
            description: next.expanded ? next.description : null,
            duration: next.duration,
            compactGap: Duration(
              milliseconds: (previous.duration.inMilliseconds * 0.22)
                  .round()
                  .clamp(180, 600),
            ),
            nextCompactGap: const Duration(milliseconds: 120),
            persistUntilDismissed: next.persistUntilDismissed,
          );
        }
        setState(() {
          _customFlowActiveId = id;
          _customFlowCurrentIndex = nextIndex;
        });
      case _DemoAction.blurCompare:
        showRenderVariantComparison();
      case _DemoAction.tabsListView:
        void spawnAt({
          required GooeyToastPosition position,
          required GooeyToastExpandDirection expandDirection,
          required String title,
        }) {
          final id = 'spawn-${DateTime.now().microsecondsSinceEpoch}';
          _controller.show(
            context: context,
            id: id,
            title: title,
            description: 'Triggered from tabs/list example.',
            state: GooeyToastState.info,
            position: position,
            expandDirection: expandDirection,
            animationStyle: _animationStyle,
            bodyAnimationStyle: _bodyAnimationStyle,
            shapeStyle: _shapeStyle,
            enableGooeyBlur: _enableGooeyBlur,
            pauseOnHover: _pauseOnHover,
            swipeToDismiss: swipeToDismiss,
            dismissDirections: dismissDirections,
            dismissDragThreshold: 68,
            newToastBehavior: _newToastBehavior,
            autopilot: _autopilotEnabled ? const GooeyAutopilot() : null,
          );
        }

        show(
          title: 'Inbox Dashboard',
          state: GooeyToastState.info,
          expandedChild: _TabsListExpanded(
            onTriggerTopRight: () => spawnAt(
              position: GooeyToastPosition.right,
              expandDirection: GooeyToastExpandDirection.bottom,
              title: 'Top-right spawned',
            ),
            onTriggerBottomCenter: () => spawnAt(
              position: GooeyToastPosition.center,
              expandDirection: GooeyToastExpandDirection.top,
              title: 'Bottom-center spawned',
            ),
          ),
        );
      case _DemoAction.positionTriggers:
        void spawnToast({
          required GooeyToastPosition position,
          required GooeyToastExpandDirection expandDirection,
          required String title,
          required GooeyToastState state,
        }) {
          final id = 'trigger-${DateTime.now().microsecondsSinceEpoch}';
          _controller.show(
            context: context,
            id: id,
            title: title,
            description: 'Position: ${position.name} / ${expandDirection.name}',
            state: state,
            position: position,
            expandDirection: expandDirection,
            animationStyle: _animationStyle,
            bodyAnimationStyle: _bodyAnimationStyle,
            shapeStyle: _shapeStyle,
            enableGooeyBlur: _enableGooeyBlur,
            pauseOnHover: _pauseOnHover,
            swipeToDismiss: swipeToDismiss,
            dismissDirections: dismissDirections,
            dismissDragThreshold: 68,
            newToastBehavior: _newToastBehavior,
            autopilot: _autopilotEnabled ? const GooeyAutopilot() : null,
          );
        }

        show(
          title: 'Trigger Board',
          state: GooeyToastState.action,
          expandedChild: _PositionTriggerExpanded(
            onTopLeft: () => spawnToast(
              position: GooeyToastPosition.left,
              expandDirection: GooeyToastExpandDirection.bottom,
              title: 'New sync started',
              state: GooeyToastState.success,
            ),
            onTopRight: () => spawnToast(
              position: GooeyToastPosition.right,
              expandDirection: GooeyToastExpandDirection.bottom,
              title: 'Warning detected',
              state: GooeyToastState.warning,
            ),
            onBottomCenter: () => spawnToast(
              position: GooeyToastPosition.center,
              expandDirection: GooeyToastExpandDirection.top,
              title: 'Bottom queue ready',
              state: GooeyToastState.info,
            ),
          ),
        );
    }
  }

  void _showFlightPromiseFlow(
    void Function({
      required String title,
      String? id,
      Object? stateTag,
      String? description,
      GooeyToastState state,
      Widget? icon,
      GooeyToastAction? action,
      Widget? compactChild,
      Widget? expandedChild,
      Duration? duration,
      GooeyAutopilot? autopilot,
      bool? persistUntilDismissed,
      ValueChanged<GooeyToastExpansionPhase>? onExpansionPhaseChanged,
      ValueChanged<double>? onExpansionProgressChanged,
    })
    show,
    Future<void> Function({
      required String id,
      required Object stateTag,
      required String title,
      required GooeyToastState state,
      String? description,
      Widget? compactChild,
      Widget? expandedChild,
      Duration? duration,
      Duration? compactGap,
      GooeyAutopilot? expandedAutopilot,
      bool? persistUntilDismissed,
      Duration? nextCompactGap,
      ValueChanged<GooeyToastExpansionPhase>? onExpandedPhaseChanged,
      ValueChanged<double>? onExpandedProgressChanged,
    })
    transitionToState,
  ) {
    for (final timer in _flowTimers) {
      timer.cancel();
    }
    _flowTimers.clear();

    const loadingState = _FlightToastModel(
      stateTag: 'flight-booking-pending',
      title: 'Booking In Progress',
      subtitle: 'Reserving seat and confirming fare class...',
      state: GooeyToastState.loading,
      icon: Icons.sync,
      tone: Color(0xFF77A8FF),
      fromCode: 'DEL',
      toCode: 'SFO',
      pnr: 'PNR -',
      cta: 'Preparing',
      duration: Duration(milliseconds: 2800),
      autopilot: null,
      showExpanded: false,
    );
    const successState = _FlightToastModel(
      stateTag: 'flight-booking-confirmed',
      title: 'Booking Confirmed',
      subtitle: 'Your itinerary is issued and synced to your account.',
      state: GooeyToastState.success,
      icon: Icons.check,
      tone: Color(0xFF42C853),
      fromCode: 'DEL',
      toCode: 'SFO',
      pnr: 'PNR EC2QW4',
      cta: 'View Details',
      duration: Duration(milliseconds: 3200),
      autopilot: GooeyAutopilot(
        expandDelay: Duration.zero,
        collapseDelay: Duration(milliseconds: 2200),
      ),
      showExpanded: true,
    );
    const gateCompactState = _FlightToastModel(
      stateTag: 'flight-gate-updated-compact',
      title: 'Gate Updated',
      subtitle: 'Departure gate changed to A12. Boarding starts in 35 min.',
      state: GooeyToastState.info,
      icon: Icons.info_outline,
      tone: Color(0xFF8EA3FF),
      fromCode: 'DEL',
      toCode: 'SFO',
      pnr: 'PNR EC2QW4',
      cta: 'Open Pass',
      duration: Duration(milliseconds: 3600),
      autopilot: null,
      showExpanded: false,
    );
    const gateExpandedState = _FlightToastModel(
      stateTag: 'flight-gate-updated-expanded',
      title: 'Gate Updated',
      subtitle: 'Departure gate changed to A12. Boarding starts in 35 min.',
      state: GooeyToastState.info,
      icon: Icons.info_outline,
      tone: Color(0xFF8EA3FF),
      fromCode: 'DEL',
      toCode: 'SFO',
      pnr: 'PNR EC2QW4',
      cta: 'Open Pass',
      duration: Duration(milliseconds: 3600),
      autopilot: GooeyAutopilot(
        expandDelay: Duration.zero,
        collapseDelay: Duration(milliseconds: 2600),
      ),
      showExpanded: true,
    );
    var didQueueGate = false;

    show(
      id: 'flight-booking-flow',
      stateTag: 'flight-booking-pending',
      title: loadingState.title,
      state: loadingState.state,
      duration: loadingState.duration,
      autopilot: null,
      compactChild: _flightCompact(
        title: loadingState.title,
        tone: loadingState.tone,
        icon: loadingState.icon,
      ),
      expandedChild: null,
    );
    _flowTimers.add(
      Timer(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        transitionToState(
          id: 'flight-booking-flow',
          stateTag: 'flight-booking-confirmed',
          title: successState.title,
          state: successState.state,
          duration: successState.duration,
          compactGap: const Duration(milliseconds: 240),
          nextCompactGap: const Duration(milliseconds: 130),
          compactChild: _flightCompact(
            title: successState.title,
            tone: successState.tone,
            icon: successState.icon,
          ),
          expandedChild: _flightExpanded(successState),
          expandedAutopilot: successState.autopilot ?? const GooeyAutopilot(),
          onExpandedPhaseChanged: (phase) {
            if (!mounted || didQueueGate) return;
            if (phase != GooeyToastExpansionPhase.closed) return;
            didQueueGate = true;
            transitionToState(
              id: 'flight-booking-flow',
              stateTag: 'flight-gate-updated',
              title: gateExpandedState.title,
              state: gateExpandedState.state,
              duration: gateExpandedState.duration,
              compactGap: const Duration(milliseconds: 240),
              nextCompactGap: const Duration(milliseconds: 130),
              compactChild: _flightCompact(
                title: gateCompactState.title,
                tone: gateCompactState.tone,
                icon: gateCompactState.icon,
              ),
              expandedChild: _flightExpanded(gateExpandedState),
              expandedAutopilot:
                  gateExpandedState.autopilot ?? const GooeyAutopilot(),
            );
          },
        );
      }),
    );
  }

  Widget _flightCompact({
    required String title,
    required Color tone,
    required IconData icon,
  }) {
    return Row(
      children: [
        Expanded(
          child: _AnimatedCompactLabel(title: title, tone: tone, icon: icon),
        ),
      ],
    );
  }

  Widget _flightExpanded(_FlightToastModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Text(
              'UNITED',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 3.2,
                fontWeight: FontWeight.w700,
                color: Color(0xFFE8E8E8),
              ),
            ),
            const Spacer(),
            Text(
              model.pnr,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8C8C8C),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 58,
          child: Stack(
            children: [
              Positioned(
                left: 8,
                bottom: 0,
                child: Text(
                  model.fromCode,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEDEDED),
                  ),
                ),
              ),
              Positioned(
                right: 8,
                bottom: 0,
                child: Text(
                  model.toCode,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEDEDED),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 1,
                child: Text(
                  '------------------------------',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: model.tone.withValues(alpha: 0.55),
                    fontSize: 16,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          model.subtitle,
          style: const TextStyle(
            fontSize: 14,
            height: 1.35,
            color: Color(0xFFC0C5CB),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 38,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: LinearGradient(
              colors: [
                model.tone.withValues(alpha: 0.22),
                model.tone.withValues(alpha: 0.34),
              ],
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            model.cta,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: model.tone,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _flightDot() {
    return Container(
      height: 34,
      width: 34,
      decoration: const BoxDecoration(
        color: Color(0x1F42C853),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.arrow_outward_rounded,
        size: 18,
        color: Color(0xFF42C853),
      ),
    );
  }

  Widget _replyCompact({
    required String title,
    required Color tone,
    required IconData icon,
  }) {
    return Row(
      children: [
        Expanded(
          child: _AnimatedCompactLabel(title: title, tone: tone, icon: icon),
        ),
      ],
    );
  }

  _CustomStateStep _buildStepFromInputs() {
    final title = _customTitleController.text.trim().isEmpty
        ? 'Untitled State'
        : _customTitleController.text.trim();
    final description = _customDescriptionController.text.trim();
    final rawMs = int.tryParse(_customDurationController.text.trim()) ?? 1800;
    final durationMs = rawMs.clamp(250, 15000);
    return _CustomStateStep(
      title: title,
      description: description,
      state: _customState,
      duration: Duration(milliseconds: durationMs),
      expanded: _customStepExpanded && description.isNotEmpty,
      persistUntilDismissed: _customStepPersistent,
    );
  }

  void _addCustomStep() {
    setState(() {
      _customSteps.add(_buildStepFromInputs());
    });
  }

  void _clearCustomSteps() {
    _customFlowRunToken++;
    setState(() {
      _customSteps.clear();
      _customFlowCurrentIndex = -1;
      _customFlowRunning = false;
    });
  }

  void _resetCustomFlow() {
    _customFlowRunToken++;
    setState(() {
      _customFlowCurrentIndex = -1;
      _customFlowRunning = false;
    });
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      filled: true,
      fillColor: const Color(0xFFE9E9E9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Color(0xFFD8D8D8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Color(0xFFD8D8D8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(11),
        borderSide: const BorderSide(color: Color(0xFFB5B5B5)),
      ),
      hintStyle: const TextStyle(
        fontSize: 12.5,
        color: Color(0xFF9A9A9A),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final compact = width < 1120;
            final ultra = width < 760;
            final chipHeight = ultra ? 34.0 : (compact ? 36.0 : 40.0);
            final chipFont = ultra ? 12.5 : (compact ? 13.5 : 14.5);
            final chipRadius = ultra ? 11.0 : 12.0;
            final chipSpacing = ultra ? 6.0 : 8.0;
            final sectionSpacing = ultra ? 12.0 : 14.0;
            final panelWidth = ultra ? width : (compact ? 980.0 : 1120.0);

            return Padding(
              padding: EdgeInsets.fromLTRB(
                ultra ? 12 : 18,
                ultra ? 12 : 18,
                ultra ? 12 : 18,
                ultra ? 10 : 14,
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ultra ? 8 : 0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _PlaygroundTitle(size: ultra ? 56 : 74),
                            SizedBox(height: ultra ? 8 : 12),
                            Text(
                              'Pick a position, set options, click any type to fire it live.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: ultra ? 18 : 19,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFA3A3A3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: panelWidth,
                      maxHeight: constraints.maxHeight * (ultra ? 0.64 : 0.56),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _ControlSection(
                            title: 'Position',
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: chipSpacing,
                              runSpacing: chipSpacing,
                              children: [
                                for (var i = 0; i < _presets.length; i++)
                                  _PlaygroundChip(
                                    label: _presets[i].label,
                                    selected: i == _selectedPresetIndex,
                                    onTap: () => setState(
                                      () => _selectedPresetIndex = i,
                                    ),
                                    minWidth: ultra ? 92 : 112,
                                    minHeight: chipHeight,
                                    fontSize: chipFont,
                                    radius: chipRadius,
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: sectionSpacing),
                          const _PlaygroundDivider(),
                          SizedBox(height: sectionSpacing),
                          _ControlSection(
                            title: 'Type',
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: chipSpacing,
                              runSpacing: chipSpacing,
                              children: [
                                for (final action in _actions)
                                  _PlaygroundChip(
                                    label: action.label,
                                    selected: _selectedAction == action,
                                    onTap: () => _triggerDemo(action),
                                    minWidth: ultra ? 82 : 94,
                                    minHeight: chipHeight,
                                    fontSize: chipFont,
                                    radius: chipRadius,
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: sectionSpacing),
                          _ControlSection(
                            title: 'Animation',
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: chipSpacing,
                              runSpacing: chipSpacing,
                              children: [
                                for (final style
                                    in GooeyToastAnimationStyle.values)
                                  _PlaygroundChip(
                                    label: style.label,
                                    selected: _animationStyle == style,
                                    onTap: () =>
                                        setState(() => _animationStyle = style),
                                    minWidth: ultra ? 80 : 88,
                                    minHeight: chipHeight,
                                    fontSize: chipFont,
                                    radius: chipRadius,
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: sectionSpacing),
                          _ControlSection(
                            title: 'Body Animation',
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: chipSpacing,
                              runSpacing: chipSpacing,
                              children: [
                                for (final style
                                    in GooeyToastBodyAnimationStyle.values)
                                  _PlaygroundChip(
                                    label: style.label,
                                    selected: _bodyAnimationStyle == style,
                                    onTap: () => setState(
                                      () => _bodyAnimationStyle = style,
                                    ),
                                    minWidth: ultra ? 98 : 118,
                                    minHeight: chipHeight,
                                    fontSize: chipFont,
                                    radius: chipRadius,
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: sectionSpacing),
                          _ControlSection(
                            title: 'Shape',
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: chipSpacing,
                              runSpacing: chipSpacing,
                              children: [
                                for (final style in GooeyToastShapeStyle.values)
                                  _PlaygroundChip(
                                    label: style.label,
                                    selected: _shapeStyle == style,
                                    onTap: () =>
                                        setState(() => _shapeStyle = style),
                                    minWidth: ultra ? 82 : 96,
                                    minHeight: chipHeight,
                                    fontSize: chipFont,
                                    radius: chipRadius,
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: sectionSpacing),
                          _ControlSection(
                            title: 'Render',
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: chipSpacing,
                              runSpacing: chipSpacing,
                              children: [
                                _PlaygroundChip(
                                  label: _enableGooeyBlur
                                      ? 'gooey blur · on'
                                      : 'gooey blur · off',
                                  selected: _enableGooeyBlur,
                                  onTap: () => setState(
                                    () => _enableGooeyBlur = !_enableGooeyBlur,
                                  ),
                                  minWidth: ultra ? 126 : 158,
                                  minHeight: chipHeight,
                                  fontSize: chipFont,
                                  radius: chipRadius,
                                ),
                                _PlaygroundChip(
                                  label: 'show both variants',
                                  selected: false,
                                  onTap: () =>
                                      _triggerDemo(_DemoAction.blurCompare),
                                  minWidth: ultra ? 130 : 168,
                                  minHeight: chipHeight,
                                  fontSize: chipFont,
                                  radius: chipRadius,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: sectionSpacing),
                          _ControlSection(
                            title: 'Behavior',
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: chipSpacing,
                                  runSpacing: chipSpacing,
                                  children: [
                                    _PlaygroundChip(
                                      label: _autopilotEnabled
                                          ? 'on · autopilot'
                                          : 'off · autopilot',
                                      selected: _autopilotEnabled,
                                      onTap: () => setState(
                                        () => _autopilotEnabled =
                                            !_autopilotEnabled,
                                      ),
                                      minWidth: ultra ? 130 : 154,
                                      minHeight: chipHeight,
                                      fontSize: chipFont,
                                      radius: chipRadius,
                                    ),
                                    _PlaygroundChip(
                                      label: _pauseOnHover
                                          ? 'on · pause-on-hover'
                                          : 'off · pause-on-hover',
                                      selected: _pauseOnHover,
                                      onTap: () => setState(
                                        () => _pauseOnHover = !_pauseOnHover,
                                      ),
                                      minWidth: ultra ? 150 : 182,
                                      minHeight: chipHeight,
                                      fontSize: chipFont,
                                      radius: chipRadius,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: chipSpacing,
                                  runSpacing: chipSpacing,
                                  children: [
                                    for (final mode
                                        in GooeyToastNewToastBehavior.values)
                                      _PlaygroundChip(
                                        label: mode.label,
                                        selected: _newToastBehavior == mode,
                                        onTap: () => setState(
                                          () => _newToastBehavior = mode,
                                        ),
                                        minWidth: ultra ? 132 : 160,
                                        minHeight: chipHeight,
                                        fontSize: chipFont,
                                        radius: chipRadius,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: sectionSpacing),
                          _ControlSection(
                            title: 'Dismiss',
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: chipSpacing,
                                  runSpacing: chipSpacing,
                                  children: [
                                    for (final behavior
                                        in _DismissBehavior.values)
                                      _PlaygroundChip(
                                        label: behavior.label,
                                        selected: _dismissBehavior == behavior,
                                        onTap: () => setState(
                                          () => _dismissBehavior = behavior,
                                        ),
                                        minWidth: ultra ? 80 : 94,
                                        minHeight: chipHeight,
                                        fontSize: chipFont,
                                        radius: chipRadius,
                                      ),
                                  ],
                                ),
                                if (_dismissBehavior == _DismissBehavior.custom)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Wrap(
                                      alignment: WrapAlignment.center,
                                      spacing: chipSpacing,
                                      runSpacing: chipSpacing,
                                      children: [
                                        for (final direction
                                            in GooeyToastSwipeDirection.values)
                                          _PlaygroundChip(
                                            label: direction.label,
                                            selected: _customDismissDirections
                                                .contains(direction),
                                            onTap: () => setState(() {
                                              if (_customDismissDirections
                                                  .contains(direction)) {
                                                _customDismissDirections.remove(
                                                  direction,
                                                );
                                              } else {
                                                _customDismissDirections.add(
                                                  direction,
                                                );
                                              }
                                            }),
                                            minWidth: ultra ? 66 : 74,
                                            minHeight: chipHeight,
                                            fontSize: chipFont,
                                            radius: chipRadius,
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: sectionSpacing),
                          const _PlaygroundDivider(),
                          SizedBox(height: sectionSpacing),
                          _ControlSection(
                            title: 'Custom State Machine',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: chipSpacing,
                                  runSpacing: chipSpacing,
                                  children: [
                                    SizedBox(
                                      width: ultra ? 176 : 220,
                                      child: TextField(
                                        controller: _customFlowIdController,
                                        decoration: _fieldDecoration('flow id'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: ultra ? 176 : 220,
                                      child: TextField(
                                        controller: _customTitleController,
                                        decoration: _fieldDecoration('title'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: ultra ? 176 : 280,
                                      child: TextField(
                                        controller:
                                            _customDescriptionController,
                                        decoration: _fieldDecoration(
                                          'description',
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: ultra ? 128 : 150,
                                      child: TextField(
                                        controller: _customDurationController,
                                        keyboardType: TextInputType.number,
                                        decoration: _fieldDecoration('ms'),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: chipSpacing,
                                  runSpacing: chipSpacing,
                                  children: [
                                    for (final state in GooeyToastState.values)
                                      _PlaygroundChip(
                                        label: state.name,
                                        selected: _customState == state,
                                        onTap: () => setState(
                                          () => _customState = state,
                                        ),
                                        minWidth: ultra ? 72 : 84,
                                        minHeight: chipHeight,
                                        fontSize: chipFont,
                                        radius: chipRadius,
                                      ),
                                    _PlaygroundChip(
                                      label: _customStepExpanded
                                          ? 'expanded'
                                          : 'compact',
                                      selected: _customStepExpanded,
                                      onTap: () => setState(
                                        () => _customStepExpanded =
                                            !_customStepExpanded,
                                      ),
                                      minWidth: ultra ? 88 : 108,
                                      minHeight: chipHeight,
                                      fontSize: chipFont,
                                      radius: chipRadius,
                                    ),
                                    _PlaygroundChip(
                                      label: _customStepPersistent
                                          ? 'persist'
                                          : 'auto dismiss',
                                      selected: _customStepPersistent,
                                      onTap: () => setState(
                                        () => _customStepPersistent =
                                            !_customStepPersistent,
                                      ),
                                      minWidth: ultra ? 108 : 132,
                                      minHeight: chipHeight,
                                      fontSize: chipFont,
                                      radius: chipRadius,
                                    ),
                                    _PlaygroundChip(
                                      label: 'Add Step',
                                      selected: false,
                                      onTap: _addCustomStep,
                                      minWidth: ultra ? 92 : 108,
                                      minHeight: chipHeight,
                                      fontSize: chipFont,
                                      radius: chipRadius,
                                    ),
                                    _PlaygroundChip(
                                      label: 'Next State',
                                      selected:
                                          _selectedAction ==
                                          _DemoAction.customStateFlow,
                                      onTap: () => _triggerDemo(
                                        _DemoAction.customStateFlow,
                                      ),
                                      minWidth: ultra ? 92 : 108,
                                      minHeight: chipHeight,
                                      fontSize: chipFont,
                                      radius: chipRadius,
                                    ),
                                    _PlaygroundChip(
                                      label: _customFlowRunning
                                          ? 'Flow Running'
                                          : 'Start Flow',
                                      selected: _customFlowRunning,
                                      onTap: () {
                                        if (_customFlowRunning) return;
                                        _customFlowStartRequested = true;
                                        _triggerDemo(
                                          _DemoAction.customStateFlow,
                                        );
                                      },
                                      minWidth: ultra ? 94 : 116,
                                      minHeight: chipHeight,
                                      fontSize: chipFont,
                                      radius: chipRadius,
                                    ),
                                    _PlaygroundChip(
                                      label: 'Reset Flow',
                                      selected: false,
                                      onTap: _resetCustomFlow,
                                      minWidth: ultra ? 98 : 116,
                                      minHeight: chipHeight,
                                      fontSize: chipFont,
                                      radius: chipRadius,
                                    ),
                                    _PlaygroundChip(
                                      label: 'Clear Steps',
                                      selected: false,
                                      onTap: _clearCustomSteps,
                                      minWidth: ultra ? 98 : 116,
                                      minHeight: chipHeight,
                                      fontSize: chipFont,
                                      radius: chipRadius,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: chipSpacing,
                                  runSpacing: chipSpacing,
                                  children: [
                                    for (final mode in _FlowAdvanceMode.values)
                                      _PlaygroundChip(
                                        label: mode.label,
                                        selected:
                                            _customFlowAdvanceMode == mode,
                                        onTap: () => setState(
                                          () => _customFlowAdvanceMode = mode,
                                        ),
                                        minWidth: ultra ? 100 : 122,
                                        minHeight: chipHeight,
                                        fontSize: chipFont,
                                        radius: chipRadius,
                                      ),
                                    _PlaygroundChip(
                                      label:
                                          'trigger ${(_customFlowProgressTrigger * 100).round()}%',
                                      selected:
                                          _customFlowAdvanceMode ==
                                          _FlowAdvanceMode.progress,
                                      onTap: () => setState(
                                        () => _customFlowProgressTrigger =
                                            _customFlowProgressTrigger >= 0.95
                                            ? 0.5
                                            : (_customFlowProgressTrigger +
                                                  0.1),
                                      ),
                                      minWidth: ultra ? 112 : 132,
                                      minHeight: chipHeight,
                                      fontSize: chipFont,
                                      radius: chipRadius,
                                    ),
                                    for (final preset
                                        in _MorphCurvePreset.values)
                                      _PlaygroundChip(
                                        label: preset.label,
                                        selected: _morphCurvePreset == preset,
                                        onTap: () => setState(
                                          () => _morphCurvePreset = preset,
                                        ),
                                        minWidth: ultra ? 86 : 104,
                                        minHeight: chipHeight,
                                        fontSize: chipFont,
                                        radius: chipRadius,
                                      ),
                                    _PlaygroundChip(
                                      label: 'morph ${_compactMorphMs}ms',
                                      selected: false,
                                      onTap: () => setState(
                                        () => _compactMorphMs =
                                            _compactMorphMs >= 420
                                            ? 160
                                            : _compactMorphMs + 40,
                                      ),
                                      minWidth: ultra ? 112 : 128,
                                      minHeight: chipHeight,
                                      fontSize: chipFont,
                                      radius: chipRadius,
                                    ),
                                    _PlaygroundChip(
                                      label:
                                          'slide ${_compactMorphSlide.toStringAsFixed(2)}',
                                      selected: false,
                                      onTap: () => setState(
                                        () => _compactMorphSlide =
                                            _compactMorphSlide >= 0.28
                                            ? 0.06
                                            : (_compactMorphSlide + 0.04),
                                      ),
                                      minWidth: ultra ? 112 : 126,
                                      minHeight: chipHeight,
                                      fontSize: chipFont,
                                      radius: chipRadius,
                                    ),
                                    _PlaygroundChip(
                                      label:
                                          'scale ${_compactMorphScaleFrom.toStringAsFixed(2)}',
                                      selected: false,
                                      onTap: () => setState(
                                        () => _compactMorphScaleFrom =
                                            _compactMorphScaleFrom <= 0.82
                                            ? 0.96
                                            : (_compactMorphScaleFrom - 0.04),
                                      ),
                                      minWidth: ultra ? 112 : 126,
                                      minHeight: chipHeight,
                                      fontSize: chipFont,
                                      radius: chipRadius,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Flow step: ${_customFlowCurrentIndex < 0 ? 'not started' : '${_customFlowCurrentIndex + 1}'}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF8F8F8F),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (_customSteps.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEDEDED),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFFD9D9D9),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        for (
                                          var i = 0;
                                          i < _customSteps.length;
                                          i++
                                        )
                                          Padding(
                                            padding: EdgeInsets.only(
                                              bottom:
                                                  i == _customSteps.length - 1
                                                  ? 0
                                                  : 6,
                                            ),
                                            child: Text(
                                              '${i + 1}. ${_customSteps[i].state.name} · ${_customSteps[i].title} · ${_customSteps[i].duration.inMilliseconds}ms'
                                              '${_customSteps[i].expanded ? ' · expanded' : ' · compact'}'
                                              '${_customSteps[i].persistUntilDismissed ? ' · persist' : ''}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF6F6F6F),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          SizedBox(height: sectionSpacing),
                          _ControlSection(
                            title: 'Active Toasts',
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (context, _) {
                                final active = _controller.activeToasts;
                                if (active.isEmpty) {
                                  return const Text(
                                    'No active toasts.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF9B9B9B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                }
                                return Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: chipSpacing,
                                  runSpacing: chipSpacing,
                                  children: [
                                    for (final toast in active)
                                      _PlaygroundChip(
                                        label:
                                            '${toast.id} · ${toast.state.name}${toast.persistUntilDismissed ? ' · persist' : ''}',
                                        selected: false,
                                        onTap: () =>
                                            _controller.dismiss(toast.id),
                                        minWidth: ultra ? 180 : 240,
                                        minHeight: chipHeight,
                                        fontSize: chipFont - 1,
                                        radius: chipRadius,
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ControlSection extends StatelessWidget {
  const _ControlSection({required this.title, required this.child});

  /// Section heading label.
  final String title;

  /// Section body content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8F8F8F),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 7),
        child,
      ],
    );
  }
}

class _PlaygroundTitle extends StatelessWidget {
  const _PlaygroundTitle({required this.size});

  /// Base heading font size.
  final double size;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Playground',
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.w700,
              height: 1,
              color: const Color(0xFF0A0A0A),
            ),
          ),
          TextSpan(
            text: '.',
            style: TextStyle(
              fontSize: size,
              fontWeight: FontWeight.w700,
              height: 1,
              color: const Color(0xFFC9C9C9),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaygroundChip extends StatelessWidget {
  const _PlaygroundChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.minWidth,
    required this.minHeight,
    required this.fontSize,
    required this.radius,
  });

  /// Visible chip label.
  final String label;

  /// Whether chip is selected.
  final bool selected;

  /// Tap callback.
  final VoidCallback onTap;

  /// Minimum width.
  final double minWidth;

  /// Minimum height.
  final double minHeight;

  /// Label font size.
  final double fontSize;

  /// Corner radius.
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth, minHeight: minHeight),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
        side: BorderSide(
          color: selected ? const Color(0xFF06080B) : const Color(0xFFE3E3E3),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        backgroundColor: const Color(0xFFE9E9E9),
        selectedColor: const Color(0xFF06080B),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        labelStyle: TextStyle(
          color: selected ? const Color(0xFFF2F2F2) : const Color(0xFFA1A1A1),
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          height: 1,
        ),
      ),
    );
  }
}

class _PlaygroundDivider extends StatelessWidget {
  const _PlaygroundDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFDCDCDC),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }
}

class _ViewportPreset {
  const _ViewportPreset({
    required this.label,
    required this.position,
    required this.expandDirection,
  });

  /// Preset label text.
  final String label;

  /// Preset horizontal toast position.
  final GooeyToastPosition position;

  /// Preset toast expansion direction.
  final GooeyToastExpandDirection expandDirection;
}

enum _DismissBehavior { auto, custom, off }

extension on _DismissBehavior {
  String get label {
    return switch (this) {
      _DismissBehavior.auto => 'auto',
      _DismissBehavior.custom => 'custom',
      _DismissBehavior.off => 'off',
    };
  }
}

extension on GooeyToastNewToastBehavior {
  String get label {
    return switch (this) {
      GooeyToastNewToastBehavior.stack => 'new toast · stack',
      GooeyToastNewToastBehavior.dismissPrevious =>
        'new toast · dismiss previous',
      GooeyToastNewToastBehavior.transition =>
        'new toast · transition existing',
    };
  }
}

enum _FlowAdvanceMode { phaseClosed, progress }

extension on _FlowAdvanceMode {
  String get label {
    return switch (this) {
      _FlowAdvanceMode.phaseClosed => 'advance · closed',
      _FlowAdvanceMode.progress => 'advance · progress',
    };
  }
}

enum _MorphCurvePreset { easeOut, emphasized, smooth, springy }

extension on _MorphCurvePreset {
  String get label {
    return switch (this) {
      _MorphCurvePreset.easeOut => 'curve · easeOut',
      _MorphCurvePreset.emphasized => 'curve · emphasized',
      _MorphCurvePreset.smooth => 'curve · smooth',
      _MorphCurvePreset.springy => 'curve · spring',
    };
  }

  Curve get curve {
    return switch (this) {
      _MorphCurvePreset.easeOut => Curves.easeOutCubic,
      _MorphCurvePreset.emphasized => Curves.easeInOutCubicEmphasized,
      _MorphCurvePreset.smooth => Curves.easeInOut,
      _MorphCurvePreset.springy => Curves.elasticOut,
    };
  }
}

enum _DemoAction {
  success,
  error,
  warning,
  info,
  action,
  icon,
  promise,
  customCompact,
  customExpanded,
  customBoth,
  flightPath,
  interactiveReply,
  flightPromise,
  customStateFlow,
  blurCompare,
  tabsListView,
  positionTriggers,
}

extension on _DemoAction {
  String get label {
    return switch (this) {
      _DemoAction.success => 'Success',
      _DemoAction.error => 'Error',
      _DemoAction.warning => 'Warning',
      _DemoAction.info => 'Info',
      _DemoAction.action => 'Action',
      _DemoAction.icon => 'Icon',
      _DemoAction.promise => 'Promise',
      _DemoAction.customCompact => 'Custom Compact',
      _DemoAction.customExpanded => 'Custom Expanded',
      _DemoAction.customBoth => 'Custom Both',
      _DemoAction.flightPath => 'Flight Path',
      _DemoAction.interactiveReply => 'Interactive Reply',
      _DemoAction.flightPromise => 'Flight Promise',
      _DemoAction.customStateFlow => 'Custom States',
      _DemoAction.blurCompare => 'Blur Compare',
      _DemoAction.tabsListView => 'Tabs + ListView',
      _DemoAction.positionTriggers => 'Position Triggers',
    };
  }
}

class _FlightToastModel {
  const _FlightToastModel({
    required this.stateTag,
    required this.title,
    required this.subtitle,
    required this.state,
    required this.icon,
    required this.tone,
    required this.fromCode,
    required this.toCode,
    required this.pnr,
    required this.cta,
    this.showExpanded = true,
    this.duration,
    this.autopilot = const GooeyAutopilot(),
  });

  /// State tag used for compact morph updates.
  final Object stateTag;

  /// Compact title text.
  final String title;

  /// Expanded description text.
  final String subtitle;

  /// Semantic toast state.
  final GooeyToastState state;

  /// Leading compact icon.
  final IconData icon;

  /// Accent tone.
  final Color tone;

  /// Origin code.
  final String fromCode;

  /// Destination code.
  final String toCode;

  /// Booking reference.
  final String pnr;

  /// CTA label.
  final String cta;

  /// Whether to render expanded content.
  final bool showExpanded;

  /// Optional override duration.
  final Duration? duration;

  /// Optional autopilot policy.
  final GooeyAutopilot? autopilot;
}

class _CustomStateStep {
  const _CustomStateStep({
    required this.title,
    required this.description,
    required this.state,
    required this.duration,
    required this.expanded,
    required this.persistUntilDismissed,
  });

  /// Step title.
  final String title;

  /// Step description text.
  final String description;

  /// Step semantic state.
  final GooeyToastState state;

  /// Step duration.
  final Duration duration;

  /// Whether this step opens expanded.
  final bool expanded;

  /// Whether this step persists until manual dismiss.
  final bool persistUntilDismissed;
}

class _InteractiveReplyExpanded extends StatefulWidget {
  const _InteractiveReplyExpanded({
    required this.onSend,
    required this.onCancel,
  });

  /// Callback fired when user taps send.
  final ValueChanged<String> onSend;

  /// Callback fired when user cancels composing.
  final VoidCallback onCancel;

  @override
  State<_InteractiveReplyExpanded> createState() =>
      _InteractiveReplyExpandedState();
}

class _InteractiveReplyExpandedState extends State<_InteractiveReplyExpanded> {
  bool _composing = false;

  /// Form key used for reply validation.
  final _formKey = GlobalKey<FormState>();

  /// Text controller for reply input.
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(
      fontSize: 14,
      height: 1.35,
      color: Color(0xFFC0C5CB),
    );
    final tone = const Color(0xFF8EA3FF);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Click reply to respond from this thread.',
          style: bodyStyle,
        ),
        const SizedBox(height: 10),
        if (_composing)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _controller,
                  autofocus: true,
                  minLines: 2,
                  maxLines: 3,
                  style: const TextStyle(
                    color: Color(0xFFE8ECFF),
                    fontSize: 13,
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) {
                      return 'Reply cannot be empty.';
                    }
                    if (text.length < 3) {
                      return 'Reply must be at least 3 characters.';
                    }
                    if (text.length > 160) {
                      return 'Reply must be 160 characters or less.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Type your reply...',
                    hintStyle: TextStyle(
                      color: tone.withValues(alpha: 0.55),
                      fontSize: 12.5,
                    ),
                    errorStyle: TextStyle(
                      color: const Color(0xFFFF8C8C).withValues(alpha: 0.95),
                      fontSize: 11,
                    ),
                    filled: true,
                    fillColor: const Color(0x26182446),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: tone.withValues(alpha: 0.35),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: tone.withValues(alpha: 0.26),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: tone.withValues(alpha: 0.6),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFFF8C8C)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFFF8C8C)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      _controller.clear();
                      setState(() => _composing = false);
                      widget.onCancel();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: tone.withValues(alpha: 0.9)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      final isValid =
                          _formKey.currentState?.validate() ?? false;
                      if (!isValid) return;
                      final message = _controller.text.trim();
                      _controller.clear();
                      setState(() => _composing = false);
                      widget.onSend(message);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: tone.withValues(alpha: 0.28),
                      foregroundColor: tone,
                    ),
                    child: const Text('Send'),
                  ),
                ],
              ),
            ],
          )
        else
          TextButton(
            onPressed: () => setState(() => _composing = true),
            style: TextButton.styleFrom(
              minimumSize: const Size(0, 28),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              shape: const StadiumBorder(),
              foregroundColor: tone,
              backgroundColor: tone.withValues(alpha: 0.15),
            ),
            child: const Text(
              'Reply',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
      ],
    );
  }
}

class _TabsListExpanded extends StatelessWidget {
  const _TabsListExpanded({
    required this.onTriggerTopRight,
    required this.onTriggerBottomCenter,
  });

  /// Triggers top-right toast example.
  final VoidCallback onTriggerTopRight;

  /// Triggers bottom-center toast example.
  final VoidCallback onTriggerBottomCenter;

  @override
  Widget build(BuildContext context) {
    const tone = Color(0xFF8EA3FF);
    return DefaultTabController(
      length: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tabs + ListView example inside expanded toast',
            style: TextStyle(fontSize: 12, color: Color(0xFF9FB0C6)),
          ),
          const SizedBox(height: 10),
          TabBar(
            isScrollable: true,
            labelPadding: const EdgeInsets.symmetric(horizontal: 10),
            dividerColor: Colors.transparent,
            tabAlignment: TabAlignment.start,
            labelColor: tone,
            unselectedLabelColor: const Color(0xFF8A93A3),
            indicatorColor: tone,
            tabs: const [
              Tab(text: 'Tasks'),
              Tab(text: 'Feeds'),
              Tab(text: 'Actions'),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 145,
            child: TabBarView(
              children: [
                ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Task #${index + 1}',
                        style: const TextStyle(
                          color: Color(0xFFE4E8F0),
                          fontSize: 13,
                        ),
                      ),
                      subtitle: const Text(
                        'Ready for processing',
                        style: TextStyle(
                          color: Color(0xFF8D95A3),
                          fontSize: 11,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF8EA3FF),
                        size: 18,
                      ),
                    );
                  },
                ),
                ListView(
                  children: const [
                    _MiniFeedRow(
                      icon: Icons.update_rounded,
                      text: 'Build #902 finished',
                    ),
                    _MiniFeedRow(
                      icon: Icons.bolt_rounded,
                      text: 'Cache warmup completed',
                    ),
                    _MiniFeedRow(
                      icon: Icons.shield_rounded,
                      text: 'Security scan passed',
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    TextButton(
                      onPressed: onTriggerTopRight,
                      child: const Text('Trigger top-right'),
                    ),
                    TextButton(
                      onPressed: onTriggerBottomCenter,
                      child: const Text('Trigger bottom-center'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionTriggerExpanded extends StatelessWidget {
  const _PositionTriggerExpanded({
    required this.onTopLeft,
    required this.onTopRight,
    required this.onBottomCenter,
  });

  /// Top-left trigger callback.
  final VoidCallback onTopLeft;

  /// Top-right trigger callback.
  final VoidCallback onTopRight;

  /// Bottom-center trigger callback.
  final VoidCallback onBottomCenter;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Trigger another Gooey Toast at different positions:',
          style: TextStyle(fontSize: 13, color: Color(0xFFC0C5CB)),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton(onPressed: onTopLeft, child: const Text('Top-left')),
            OutlinedButton(
              onPressed: onTopRight,
              child: const Text('Top-right'),
            ),
            OutlinedButton(
              onPressed: onBottomCenter,
              child: const Text('Bottom-center'),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniFeedRow extends StatelessWidget {
  const _MiniFeedRow({required this.icon, required this.text});

  /// Leading row icon.
  final IconData icon;

  /// Feed row text.
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF8EA3FF)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12.5, color: Color(0xFFC0C5CB)),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedCompactLabel extends StatefulWidget {
  const _AnimatedCompactLabel({
    required this.title,
    required this.tone,
    required this.icon,
  });

  /// Compact title.
  final String title;

  /// Compact accent tone.
  final Color tone;

  /// Compact leading icon.
  final IconData icon;

  @override
  State<_AnimatedCompactLabel> createState() => _AnimatedCompactLabelState();
}

class _AnimatedCompactLabelState extends State<_AnimatedCompactLabel>
    with SingleTickerProviderStateMixin {
  /// Morph animation controller.
  late final AnimationController _controller;

  /// Curved animation progress.
  late final Animation<double> _progress;

  /// Previous title used for animated transition.
  String? _prevTitle;

  /// Previous tone used for animated transition.
  Color? _prevTone;

  /// Previous icon used for animated transition.
  IconData? _prevIcon;

  /// Whether previous frame should be rendered.
  bool _hasPrev = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 190),
    );
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          setState(() => _hasPrev = false);
        }
      });
    _controller.value = 1;
  }

  @override
  void didUpdateWidget(covariant _AnimatedCompactLabel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final changed =
        oldWidget.title != widget.title ||
        oldWidget.tone != widget.tone ||
        oldWidget.icon != widget.icon;
    if (!changed) return;
    _prevTitle = oldWidget.title;
    _prevTone = oldWidget.tone;
    _prevIcon = oldWidget.icon;
    _hasPrev = true;
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progress,
      builder: (context, _) {
        final t = _progress.value;
        final previousOpacity = _hasPrev ? (1 - t) : 0.0;
        final currentOpacity = _hasPrev ? t : 1.0;
        final previousYOffset = _hasPrev ? (-2.0 * t) : 0.0;
        final currentYOffset = _hasPrev ? (2.0 * (1 - t)) : 0.0;
        return Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_hasPrev && _prevTone != null && _prevIcon != null)
                    Opacity(
                      opacity: previousOpacity,
                      child: _compactIcon(
                        tone: _prevTone!,
                        icon: _prevIcon!,
                        scale: 0.95 + 0.05 * previousOpacity,
                      ),
                    ),
                  Opacity(
                    opacity: currentOpacity,
                    child: _compactIcon(
                      tone: widget.tone,
                      icon: widget.icon,
                      scale: 0.95 + 0.05 * currentOpacity,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Stack(
                children: [
                  if (_hasPrev && _prevTitle != null && _prevTone != null)
                    Opacity(
                      opacity: previousOpacity,
                      child: Transform.translate(
                        offset: Offset(0, previousYOffset),
                        child: _compactText(_prevTitle!, _prevTone!),
                      ),
                    ),
                  Opacity(
                    opacity: currentOpacity,
                    child: Transform.translate(
                      offset: Offset(0, currentYOffset),
                      child: _compactText(widget.title, widget.tone),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _compactIcon({
    required Color tone,
    required IconData icon,
    required double scale,
  }) {
    return Transform.scale(
      scale: scale,
      child: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
          color: tone.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 15, color: tone),
      ),
    );
  }

  Widget _compactText(String title, Color tone) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: tone,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReplyResultExpanded extends StatelessWidget {
  const _ReplyResultExpanded({
    required this.title,
    required this.body,
    required this.tone,
  });

  /// Result title.
  final String title;

  /// Result body message.
  final String body;

  /// Accent tone for title/chips.
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: tone,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: const TextStyle(
            fontSize: 14,
            height: 1.35,
            color: Color(0xFFC0C5CB),
          ),
        ),
      ],
    );
  }
}

extension on GooeyToastAnimationStyle {
  String get label {
    return switch (this) {
      GooeyToastAnimationStyle.sileo => 'sileo',
      GooeyToastAnimationStyle.smooth => 'smooth',
      GooeyToastAnimationStyle.snappy => 'snappy',
      GooeyToastAnimationStyle.bouncy => 'bouncy',
      GooeyToastAnimationStyle.fluid => 'fluid',
      GooeyToastAnimationStyle.springEasing => 'spring-easing',
    };
  }
}

extension on GooeyToastShapeStyle {
  String get label {
    return switch (this) {
      GooeyToastShapeStyle.defaultShape => 'default',
      GooeyToastShapeStyle.soft => 'soft',
      GooeyToastShapeStyle.sharp => 'sharp',
      GooeyToastShapeStyle.capsule => 'capsule',
    };
  }
}

extension on GooeyToastBodyAnimationStyle {
  String get label {
    return switch (this) {
      GooeyToastBodyAnimationStyle.fade => 'fade',
      GooeyToastBodyAnimationStyle.fadeSlide => 'fade-slide',
      GooeyToastBodyAnimationStyle.fadeScale => 'fade-scale',
      GooeyToastBodyAnimationStyle.none => 'none',
    };
  }
}

extension on GooeyToastSwipeDirection {
  String get label {
    return switch (this) {
      GooeyToastSwipeDirection.up => 'up',
      GooeyToastSwipeDirection.down => 'down',
      GooeyToastSwipeDirection.left => 'left',
      GooeyToastSwipeDirection.right => 'right',
    };
  }
}
