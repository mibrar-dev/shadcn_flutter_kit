import 'dart:async';

import 'package:docs/shadcn_ui.dart';
import 'package:docs/ui/shadcn/components/navigation/tabs/tabs.dart'
    as shadcn_tabs;

final ValueNotifier<_GooeyGlobalSettings> _gooeyDocsSettings =
    ValueNotifier<_GooeyGlobalSettings>(
  const _GooeyGlobalSettings(
    preset: _EdgePreset.topLeft,
    animationStyle: GooeyToastAnimationStyle.smooth,
    bodyAnimationStyle: GooeyToastBodyAnimationStyle.fade,
    shapeStyle: GooeyToastShapeStyle.sharp,
    width: 360,
    roundness: 16,
    duration: Duration(seconds: 5),
    autopilot: GooeyAutopilot(
      expandDelay: Duration(milliseconds: 180),
      collapseDelay: Duration(milliseconds: 3200),
    ),
    compactMorph: GooeyCompactMorph(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOutCubicEmphasized,
      slideOffset: Offset(0, 0.10),
      scaleFrom: 0.80,
    ),
    autopilotEnabled: true,
    pauseOnHover: true,
    swipeToDismiss: true,
    persistUntilDismissed: false,
    newToastBehavior: GooeyToastNewToastBehavior.dismissPrevious,
  ),
);

String _toastIdForBehavior({
  required String baseId,
  required GooeyToastNewToastBehavior behavior,
  required Object stateTag,
}) {
  switch (behavior) {
    case GooeyToastNewToastBehavior.transition:
      return baseId;
    case GooeyToastNewToastBehavior.stack:
    case GooeyToastNewToastBehavior.dismissPrevious:
      return '$baseId-$stateTag';
  }
}

String _behaviorLabel(GooeyToastNewToastBehavior behavior) {
  switch (behavior) {
    case GooeyToastNewToastBehavior.stack:
      return 'stack';
    case GooeyToastNewToastBehavior.dismissPrevious:
      return 'dismiss previous';
    case GooeyToastNewToastBehavior.transition:
      return 'transition';
  }
}

/// Playground controls for variant, position, animation and shape.
class GooeyToastExample1 extends StatefulWidget {
  const GooeyToastExample1({super.key});

  @override
  State<GooeyToastExample1> createState() => _GooeyToastExample1State();
}

class _GooeyToastExample1State extends State<GooeyToastExample1> {
  final GooeyToastController _controller = GooeyToastController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<_GooeyGlobalSettings>(
      valueListenable: _gooeyDocsSettings,
      builder: (context, settings, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preview Variants',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Gap(8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final variant in _PreviewVariant.values)
                  OutlineButton(
                    onPressed: () => _showVariant(context, settings, variant),
                    child: Text(variant.label),
                  ),
              ],
            ),
            const Gap(12),
            const Text(
              'Position',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Gap(8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final preset in _EdgePreset.values)
                  SelectedButton(
                    value: settings.preset == preset,
                    onChanged: (value) {
                      if (!value) return;
                      _gooeyDocsSettings.value =
                          settings.copyWith(preset: preset);
                    },
                    style: const ButtonStyle.outline(),
                    selectedStyle: const ButtonStyle.primary(),
                    child: Text(preset.label),
                  ),
              ],
            ),
            const Gap(12),
            const Text(
              'Animation',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Gap(8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final style in GooeyToastAnimationStyle.values)
                  SelectedButton(
                    value: settings.animationStyle == style,
                    onChanged: (value) {
                      if (!value) return;
                      _gooeyDocsSettings.value =
                          settings.copyWith(animationStyle: style);
                    },
                    style: const ButtonStyle.outline(),
                    selectedStyle: const ButtonStyle.primary(),
                    child: Text(style.name),
                  ),
              ],
            ),
            const Gap(12),
            const Text(
              'Body Animation',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Gap(8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final style in GooeyToastBodyAnimationStyle.values)
                  SelectedButton(
                    value: settings.bodyAnimationStyle == style,
                    onChanged: (value) {
                      if (!value) return;
                      _gooeyDocsSettings.value = settings.copyWith(
                        bodyAnimationStyle: style,
                      );
                    },
                    style: const ButtonStyle.outline(),
                    selectedStyle: const ButtonStyle.primary(),
                    child: Text(style.name),
                  ),
              ],
            ),
            const Gap(12),
            const Text(
              'Edge Shape',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Gap(8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final style in GooeyToastShapeStyle.values)
                  SelectedButton(
                    value: settings.shapeStyle == style,
                    onChanged: (value) {
                      if (!value) return;
                      _gooeyDocsSettings.value =
                          settings.copyWith(shapeStyle: style);
                    },
                    style: const ButtonStyle.outline(),
                    selectedStyle: const ButtonStyle.primary(),
                    child: Text(style.name),
                  ),
              ],
            ),
            const Gap(12),
            const Text(
              'Behavior',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Gap(8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SelectedButton(
                  value: settings.autopilotEnabled,
                  onChanged: (value) {
                    _gooeyDocsSettings.value = settings.copyWith(
                      autopilotEnabled: value,
                    );
                  },
                  style: const ButtonStyle.outline(),
                  selectedStyle: const ButtonStyle.primary(),
                  child: Text(
                    settings.autopilotEnabled
                        ? 'autopilot · on'
                        : 'autopilot · off',
                  ),
                ),
                SelectedButton(
                  value: settings.pauseOnHover,
                  onChanged: (value) {
                    _gooeyDocsSettings.value = settings.copyWith(
                      pauseOnHover: value,
                    );
                  },
                  style: const ButtonStyle.outline(),
                  selectedStyle: const ButtonStyle.primary(),
                  child: Text(
                    settings.pauseOnHover
                        ? 'pause-on-hover · on'
                        : 'pause-on-hover · off',
                  ),
                ),
                SelectedButton(
                  value: settings.swipeToDismiss,
                  onChanged: (value) {
                    _gooeyDocsSettings.value = settings.copyWith(
                      swipeToDismiss: value,
                    );
                  },
                  style: const ButtonStyle.outline(),
                  selectedStyle: const ButtonStyle.primary(),
                  child: Text(
                    settings.swipeToDismiss
                        ? 'swipe-dismiss · on'
                        : 'swipe-dismiss · off',
                  ),
                ),
                SelectedButton(
                  value: settings.persistUntilDismissed,
                  onChanged: (value) {
                    _gooeyDocsSettings.value = settings.copyWith(
                      persistUntilDismissed: value,
                    );
                  },
                  style: const ButtonStyle.outline(),
                  selectedStyle: const ButtonStyle.primary(),
                  child: Text(
                    settings.persistUntilDismissed
                        ? 'persist · on'
                        : 'persist · off',
                  ),
                ),
              ],
            ),
            const Gap(8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final behavior in GooeyToastNewToastBehavior.values)
                  SelectedButton(
                    value: settings.newToastBehavior == behavior,
                    onChanged: (value) {
                      if (!value) return;
                      _gooeyDocsSettings.value = settings.copyWith(
                        newToastBehavior: behavior,
                      );
                    },
                    style: const ButtonStyle.outline(),
                    selectedStyle: const ButtonStyle.primary(),
                    child: Text(_behaviorLabel(behavior)),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showVariant(
    BuildContext context,
    _GooeyGlobalSettings settings,
    _PreviewVariant variant,
  ) {
    switch (variant) {
      case _PreviewVariant.success:
        _show(
          context,
          settings,
          id: 'docs-gooey-success',
          title: 'Success',
          description: 'Workspace settings were saved.',
          state: GooeyToastState.success,
        );
      case _PreviewVariant.error:
        _show(
          context,
          settings,
          id: 'docs-gooey-error',
          title: 'Error',
          description: 'Failed to sync your workspace.',
          state: GooeyToastState.error,
        );
      case _PreviewVariant.warning:
        _show(
          context,
          settings,
          id: 'docs-gooey-warning',
          title: 'Storage Warning',
          description: 'You are running out of storage space.',
          state: GooeyToastState.warning,
        );
      case _PreviewVariant.info:
        _show(
          context,
          settings,
          id: 'docs-gooey-info',
          title: 'Heads up',
          description: 'A new update is available.',
          state: GooeyToastState.info,
        );
      case _PreviewVariant.action:
        _show(
          context,
          settings,
          id: 'docs-gooey-action',
          title: 'Action Required',
          description: 'Review and confirm this request.',
          state: GooeyToastState.action,
          action: GooeyToastAction(
            label: 'Confirm',
            onPressed: () {
              _show(
                context,
                settings,
                id: 'docs-gooey-action',
                title: 'Confirmed',
                description: 'Request has been approved.',
                state: GooeyToastState.success,
              );
            },
          ),
        );
      case _PreviewVariant.loading:
        _show(
          context,
          settings,
          id: 'docs-gooey-loading',
          title: 'Processing',
          description: 'Please wait while we process your request.',
          state: GooeyToastState.loading,
        );
      case _PreviewVariant.promise:
        _show(
          context,
          settings,
          id: 'docs-gooey-promise',
          title: 'Uploading',
          description: 'Sending file to workspace...',
          state: GooeyToastState.loading,
        );
        Timer(const Duration(milliseconds: 1300), () {
          if (!mounted) return;
          _show(
            context,
            settings,
            id: 'docs-gooey-promise',
            title: 'Upload Complete',
            description: 'Your file is ready.',
            state: GooeyToastState.success,
          );
        });
      case _PreviewVariant.custom:
        _show(
          context,
          settings,
          id: 'docs-gooey-custom',
          title: 'Ops Control Center',
          description: null,
          state: GooeyToastState.info,
          expandedChild: _OpsCenterExpanded(
            textColor: _resolveToastContentColor(context),
            onTrigger: () {
              _show(
                context,
                settings.copyWith(preset: settings.preset.alternate),
                id: 'docs-gooey-custom-next',
                title: 'Escalation Routed',
                description: 'Ops incident routed to on-call engineering.',
                state: GooeyToastState.success,
              );
            },
          ),
        );
    }
  }

  void _show(
    BuildContext context,
    _GooeyGlobalSettings settings, {
    required String id,
    required String title,
    required GooeyToastState state,
    String? description,
    GooeyToastAction? action,
    Widget? expandedChild,
  }) {
    final stateTag = '$id-${DateTime.now().millisecondsSinceEpoch}';
    final toastId = _toastIdForBehavior(
      baseId: id,
      behavior: settings.newToastBehavior,
      stateTag: stateTag,
    );
    _controller.show(
      context: context,
      id: toastId,
      stateTag: stateTag,
      title: title,
      description: description,
      state: state,
      position: settings.preset.position,
      expandDirection: settings.preset.expandDirection,
      width: settings.width,
      fill: _resolveToastSurface(context),
      roundness: settings.roundness,
      duration: settings.duration,
      autopilot: settings.autopilotEnabled ? settings.autopilot : null,
      animationStyle: settings.animationStyle,
      shapeStyle: settings.shapeStyle,
      bodyAnimationStyle: settings.bodyAnimationStyle,
      enableGooeyBlur: true,
      pauseOnHover: settings.pauseOnHover,
      swipeToDismiss: settings.swipeToDismiss,
      persistUntilDismissed: settings.persistUntilDismissed,
      newToastBehavior: settings.newToastBehavior,
      compactMorph: settings.compactMorph,
      action: action,
      expandedChild: expandedChild,
    );
  }
}

/// Interactive reply demo (transition, not replacement).
class GooeyToastExample2 extends StatefulWidget {
  const GooeyToastExample2({super.key});

  @override
  State<GooeyToastExample2> createState() => _GooeyToastExample2State();
}

class _GooeyToastExample2State extends State<GooeyToastExample2> {
  final GooeyToastController _controller = GooeyToastController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: () {
        final settings = _gooeyDocsSettings.value;
        final composeStateTag =
            'reply:compose:${DateTime.now().millisecondsSinceEpoch}';
        final toastId = _toastIdForBehavior(
          baseId: 'docs-gooey-reply',
          behavior: settings.newToastBehavior,
          stateTag: composeStateTag,
        );
        _controller.show(
          context: context,
          id: toastId,
          stateTag: composeStateTag,
          title: 'Thread Reply',
          state: GooeyToastState.action,
          compactChild: _flightCompact(
            title: 'Thread Reply',
            tone: const Color(0xFF8EA3FF),
            icon: Icons.forum_rounded,
          ),
          position: settings.preset.position,
          expandDirection: settings.preset.expandDirection,
          width: settings.width,
          fill: _resolveToastSurface(context),
          roundness: settings.roundness,
          duration: settings.duration,
          autopilot: settings.autopilotEnabled ? settings.autopilot : null,
          animationStyle: settings.animationStyle,
          shapeStyle: settings.shapeStyle,
          bodyAnimationStyle: settings.bodyAnimationStyle,
          enableGooeyBlur: true,
          pauseOnHover: settings.pauseOnHover,
          swipeToDismiss: settings.swipeToDismiss,
          persistUntilDismissed: settings.persistUntilDismissed,
          newToastBehavior: settings.newToastBehavior,
          compactMorph: settings.compactMorph,
          expandedChild: _InteractiveReplyExpanded(
            textColor: _resolveToastContentColor(context),
            onSend: (message) {
              final sentStateTag =
                  'reply:sent:$message:${DateTime.now().millisecondsSinceEpoch}';
              if (settings.newToastBehavior ==
                  GooeyToastNewToastBehavior.transition) {
                _controller.transitionAfterClosed(
                  context: context,
                  id: toastId,
                  currentTitle: 'Thread Reply',
                  currentState: GooeyToastState.action,
                  currentDuration: settings.duration,
                  nextTitle: 'Message Sent',
                  nextState: GooeyToastState.success,
                  nextStateTag: sentStateTag,
                  nextDescription:
                      'Your reply was sent successfully. "$message"',
                  nextDuration: settings.duration,
                  position: settings.preset.position,
                  expandDirection: settings.preset.expandDirection,
                  width: settings.width,
                  fill: _resolveToastSurface(context),
                  roundness: settings.roundness,
                  animationStyle: settings.animationStyle,
                  shapeStyle: settings.shapeStyle,
                  bodyAnimationStyle: settings.bodyAnimationStyle,
                  enableGooeyBlur: true,
                  pauseOnHover: settings.pauseOnHover,
                  swipeToDismiss: settings.swipeToDismiss,
                  persistUntilDismissed: settings.persistUntilDismissed,
                  newToastBehavior: settings.newToastBehavior,
                  compactMorph: settings.compactMorph,
                );
                return;
              }
              final sentId = _toastIdForBehavior(
                baseId: 'docs-gooey-reply',
                behavior: settings.newToastBehavior,
                stateTag: sentStateTag,
              );
              _controller.show(
                context: context,
                id: sentId,
                stateTag: sentStateTag,
                title: 'Message Sent',
                description: 'Your reply was sent successfully. "$message"',
                state: GooeyToastState.success,
                position: settings.preset.position,
                expandDirection: settings.preset.expandDirection,
                width: settings.width,
                fill: _resolveToastSurface(context),
                roundness: settings.roundness,
                duration: settings.duration,
                autopilot:
                    settings.autopilotEnabled ? settings.autopilot : null,
                animationStyle: settings.animationStyle,
                shapeStyle: settings.shapeStyle,
                bodyAnimationStyle: settings.bodyAnimationStyle,
                enableGooeyBlur: true,
                pauseOnHover: settings.pauseOnHover,
                swipeToDismiss: settings.swipeToDismiss,
                persistUntilDismissed: settings.persistUntilDismissed,
                newToastBehavior: settings.newToastBehavior,
                compactMorph: settings.compactMorph,
              );
            },
          ),
        );
      },
      child: const Text('Interactive Reply Demo'),
    );
  }
}

/// Booking flow copied from preview structure: 3 transitions in one slot.
class GooeyToastExample3 extends StatefulWidget {
  const GooeyToastExample3({super.key});

  @override
  State<GooeyToastExample3> createState() => _GooeyToastExample3State();
}

class _GooeyToastExample3State extends State<GooeyToastExample3> {
  final GooeyToastController _controller = GooeyToastController();
  final List<Timer> _flowTimers = <Timer>[];

  @override
  void dispose() {
    for (final timer in _flowTimers) {
      timer.cancel();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: () => _showFlightBookingFlow(context),
      child: const Text('Booking Multi-State Demo'),
    );
  }

  void _showFlightBookingFlow(BuildContext context) {
    for (final timer in _flowTimers) {
      timer.cancel();
    }
    _flowTimers.clear();

    final settings = _gooeyDocsSettings.value;
    const flowBaseId = 'flight-booking-flow';

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

    final loadingToastId = _toastIdForBehavior(
      baseId: flowBaseId,
      behavior: settings.newToastBehavior,
      stateTag: loadingState.stateTag,
    );

    _controller.show(
      context: context,
      id: loadingToastId,
      stateTag: loadingState.stateTag,
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
      position: settings.preset.position,
      expandDirection: settings.preset.expandDirection,
      width: settings.width,
      fill: _resolveToastSurface(context),
      roundness: settings.roundness,
      animationStyle: settings.animationStyle,
      shapeStyle: settings.shapeStyle,
      bodyAnimationStyle: settings.bodyAnimationStyle,
      enableGooeyBlur: true,
      pauseOnHover: settings.pauseOnHover,
      swipeToDismiss: settings.swipeToDismiss,
      persistUntilDismissed: settings.persistUntilDismissed,
      newToastBehavior: settings.newToastBehavior,
      compactMorph: settings.compactMorph,
    );

    _flowTimers.add(
      Timer(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        if (settings.newToastBehavior ==
            GooeyToastNewToastBehavior.transition) {
          _controller.transitionAfterClosed(
            context: context,
            id: loadingToastId,
            currentTitle: loadingState.title,
            currentState: loadingState.state,
            currentCompactChild: _flightCompact(
              title: loadingState.title,
              tone: loadingState.tone,
              icon: loadingState.icon,
            ),
            currentDuration: loadingState.duration,
            nextStateTag: successState.stateTag,
            nextTitle: successState.title,
            nextState: successState.state,
            nextCompactChild: _flightCompact(
              title: successState.title,
              tone: successState.tone,
              icon: successState.icon,
            ),
            nextExpandedChild: _flightExpanded(context, successState),
            nextDuration: successState.duration,
            nextCompactGap: const Duration(milliseconds: 130),
            nextExpandedAutopilot:
                successState.autopilot ?? const GooeyAutopilot(),
            position: settings.preset.position,
            expandDirection: settings.preset.expandDirection,
            width: settings.width,
            fill: _resolveToastSurface(context),
            roundness: settings.roundness,
            animationStyle: settings.animationStyle,
            shapeStyle: settings.shapeStyle,
            bodyAnimationStyle: settings.bodyAnimationStyle,
            enableGooeyBlur: true,
            pauseOnHover: settings.pauseOnHover,
            swipeToDismiss: settings.swipeToDismiss,
            persistUntilDismissed: settings.persistUntilDismissed,
            newToastBehavior: settings.newToastBehavior,
            compactMorph: settings.compactMorph,
          );
          return;
        }
        _controller.show(
          context: context,
          id: _toastIdForBehavior(
            baseId: flowBaseId,
            behavior: settings.newToastBehavior,
            stateTag: successState.stateTag,
          ),
          stateTag: successState.stateTag,
          title: successState.title,
          state: successState.state,
          duration: successState.duration,
          autopilot: successState.autopilot,
          compactChild: _flightCompact(
            title: successState.title,
            tone: successState.tone,
            icon: successState.icon,
          ),
          expandedChild: _flightExpanded(context, successState),
          position: settings.preset.position,
          expandDirection: settings.preset.expandDirection,
          width: settings.width,
          fill: _resolveToastSurface(context),
          roundness: settings.roundness,
          animationStyle: settings.animationStyle,
          shapeStyle: settings.shapeStyle,
          bodyAnimationStyle: settings.bodyAnimationStyle,
          enableGooeyBlur: true,
          pauseOnHover: settings.pauseOnHover,
          swipeToDismiss: settings.swipeToDismiss,
          persistUntilDismissed: settings.persistUntilDismissed,
          newToastBehavior: settings.newToastBehavior,
          compactMorph: settings.compactMorph,
        );
      }),
    );

    _flowTimers.add(
      Timer(const Duration(milliseconds: 4200), () {
        if (!mounted) return;
        if (settings.newToastBehavior ==
            GooeyToastNewToastBehavior.transition) {
          _controller.transitionAfterClosed(
            context: context,
            id: loadingToastId,
            currentTitle: successState.title,
            currentState: successState.state,
            currentCompactChild: _flightCompact(
              title: successState.title,
              tone: successState.tone,
              icon: successState.icon,
            ),
            currentDuration: successState.duration,
            nextStateTag: gateExpandedState.stateTag,
            nextTitle: gateExpandedState.title,
            nextState: gateExpandedState.state,
            nextCompactChild: _flightCompact(
              title: gateCompactState.title,
              tone: gateCompactState.tone,
              icon: gateCompactState.icon,
            ),
            nextExpandedChild: _flightExpanded(context, gateExpandedState),
            nextDuration: gateExpandedState.duration,
            nextCompactGap: const Duration(milliseconds: 130),
            nextExpandedAutopilot:
                gateExpandedState.autopilot ?? const GooeyAutopilot(),
            position: settings.preset.position,
            expandDirection: settings.preset.expandDirection,
            width: settings.width,
            fill: _resolveToastSurface(context),
            roundness: settings.roundness,
            animationStyle: settings.animationStyle,
            shapeStyle: settings.shapeStyle,
            bodyAnimationStyle: settings.bodyAnimationStyle,
            enableGooeyBlur: true,
            pauseOnHover: settings.pauseOnHover,
            swipeToDismiss: settings.swipeToDismiss,
            persistUntilDismissed: settings.persistUntilDismissed,
            newToastBehavior: settings.newToastBehavior,
            compactMorph: settings.compactMorph,
          );
          return;
        }
        _controller.show(
          context: context,
          id: _toastIdForBehavior(
            baseId: flowBaseId,
            behavior: settings.newToastBehavior,
            stateTag: gateExpandedState.stateTag,
          ),
          stateTag: gateExpandedState.stateTag,
          title: gateExpandedState.title,
          state: gateExpandedState.state,
          duration: gateExpandedState.duration,
          autopilot: gateExpandedState.autopilot,
          compactChild: _flightCompact(
            title: gateCompactState.title,
            tone: gateCompactState.tone,
            icon: gateCompactState.icon,
          ),
          expandedChild: _flightExpanded(context, gateExpandedState),
          position: settings.preset.position,
          expandDirection: settings.preset.expandDirection,
          width: settings.width,
          fill: _resolveToastSurface(context),
          roundness: settings.roundness,
          animationStyle: settings.animationStyle,
          shapeStyle: settings.shapeStyle,
          bodyAnimationStyle: settings.bodyAnimationStyle,
          enableGooeyBlur: true,
          pauseOnHover: settings.pauseOnHover,
          swipeToDismiss: settings.swipeToDismiss,
          persistUntilDismissed: settings.persistUntilDismissed,
          newToastBehavior: settings.newToastBehavior,
          compactMorph: settings.compactMorph,
        );
      }),
    );
  }
}

/// Real-life tabs/list scenario.
class GooeyToastExample4 extends StatelessWidget {
  const GooeyToastExample4({super.key});

  @override
  Widget build(BuildContext context) {
    return _TabsListDemoButton();
  }
}

class _TabsListDemoButton extends StatefulWidget {
  @override
  State<_TabsListDemoButton> createState() => _TabsListDemoButtonState();
}

class _TabsListDemoButtonState extends State<_TabsListDemoButton> {
  final GooeyToastController _controller = GooeyToastController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      onPressed: () {
        final settings = _gooeyDocsSettings.value;
        final opsStateTag =
            'ops-center-${DateTime.now().millisecondsSinceEpoch}';
        _controller.show(
          context: context,
          id: _toastIdForBehavior(
            baseId: 'docs-gooey-ops-center',
            behavior: settings.newToastBehavior,
            stateTag: opsStateTag,
          ),
          stateTag: opsStateTag,
          title: 'Ops Control Center',
          state: GooeyToastState.info,
          position: settings.preset.position,
          expandDirection: settings.preset.expandDirection,
          width: settings.width,
          fill: _resolveToastSurface(context),
          roundness: settings.roundness,
          duration: settings.duration,
          autopilot: settings.autopilotEnabled ? settings.autopilot : null,
          animationStyle: settings.animationStyle,
          shapeStyle: settings.shapeStyle,
          bodyAnimationStyle: settings.bodyAnimationStyle,
          enableGooeyBlur: true,
          pauseOnHover: settings.pauseOnHover,
          swipeToDismiss: settings.swipeToDismiss,
          persistUntilDismissed: settings.persistUntilDismissed,
          newToastBehavior: settings.newToastBehavior,
          compactMorph: settings.compactMorph,
          expandedChild: _OpsCenterExpanded(
            textColor: _resolveToastContentColor(context),
            onTrigger: () {
              final routedStateTag =
                  'ops-routed-${DateTime.now().millisecondsSinceEpoch}';
              _controller.show(
                context: context,
                id: _toastIdForBehavior(
                  baseId: 'docs-gooey-ops-center-next',
                  behavior: settings.newToastBehavior,
                  stateTag: routedStateTag,
                ),
                stateTag: routedStateTag,
                title: 'Escalation Routed',
                description: 'SEV-2 incident assigned to backend on-call.',
                state: GooeyToastState.success,
                position: settings.preset.alternate.position,
                expandDirection: settings.preset.alternate.expandDirection,
                fill: _resolveToastSurface(context),
                animationStyle: settings.animationStyle,
                shapeStyle: settings.shapeStyle,
                bodyAnimationStyle: settings.bodyAnimationStyle,
                autopilot:
                    settings.autopilotEnabled ? settings.autopilot : null,
                pauseOnHover: settings.pauseOnHover,
                swipeToDismiss: settings.swipeToDismiss,
                persistUntilDismissed: settings.persistUntilDismissed,
                newToastBehavior: settings.newToastBehavior,
              );
            },
          ),
        );
      },
      child: const Text('Tabs + ListView Demo'),
    );
  }
}

class _OpsCenterExpanded extends StatefulWidget {
  const _OpsCenterExpanded({
    required this.onTrigger,
    required this.textColor,
  });

  final VoidCallback onTrigger;
  final Color textColor;

  @override
  State<_OpsCenterExpanded> createState() => _OpsCenterExpandedState();
}

class _OpsCenterExpandedState extends State<_OpsCenterExpanded> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: TextStyle(color: widget.textColor),
      child: SizedBox(
        height: 248,
        child: Column(
          children: [
            shadcn_tabs.Tabs(
              index: _tabIndex,
              onChanged: (next) => setState(() => _tabIndex = next),
              children: const [
                shadcn_tabs.TabItem(child: Text('Incidents')),
                shadcn_tabs.TabItem(child: Text('Runbook')),
                shadcn_tabs.TabItem(child: Text('Dispatch')),
              ],
            ),
            const Gap(8),
            Expanded(
              child: IndexedStack(
                index: _tabIndex,
                children: [
                  _opsIncidentList(),
                  _opsRunbook(),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Route active incident to escalation channel.',
                          style: TextStyle(
                            color: widget.textColor.withValues(alpha: 0.86),
                          ),
                        ),
                        const Gap(10),
                        PrimaryButton(
                          onPressed: widget.onTrigger,
                          child: const Text('Escalate To On-Call'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _opsIncidentList() {
    const incidents = <(String, String, String)>[
      ('SEV-2 API latency', 'eu-west-1', '09:42'),
      ('Payment retries spike', 'checkout', '09:37'),
      ('Token refresh errors', 'auth-core', '09:31'),
      ('Queue backlog above SLO', 'worker-bus', '09:19'),
    ];
    return ListView.separated(
      itemCount: incidents.length,
      itemBuilder: (context, index) {
        final (title, service, time) = incidents[index];
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  Text(
                    '$service · opened $time',
                    style: TextStyle(
                      fontSize: 12,
                      color: widget.textColor.withValues(alpha: 0.68),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: widget.textColor.withValues(alpha: 0.12),
              ),
              child: Text(
                index == 0 ? 'active' : 'watch',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: widget.textColor.withValues(alpha: 0.9),
                ),
              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) =>
          Divider(color: widget.textColor.withValues(alpha: 0.28)),
    );
  }

  Widget _opsRunbook() {
    final steps = <String>[
      '1. Enable degraded-mode cache for search endpoints.',
      '2. Scale worker-bus deployment to 2x replicas.',
      '3. Pause non-critical cron jobs for 15 minutes.',
      '4. Post status update in #incident-room.',
    ];
    return ListView.separated(
      itemCount: steps.length,
      itemBuilder: (context, index) => Text(
        steps[index],
        style: TextStyle(color: widget.textColor.withValues(alpha: 0.88)),
      ),
      separatorBuilder: (context, index) =>
          Divider(color: widget.textColor.withValues(alpha: 0.28)),
    );
  }
}

class _InteractiveReplyExpanded extends StatefulWidget {
  const _InteractiveReplyExpanded({
    required this.onSend,
    required this.textColor,
  });

  final ValueChanged<String> onSend;
  final Color textColor;

  @override
  State<_InteractiveReplyExpanded> createState() =>
      _InteractiveReplyExpandedState();
}

class _InteractiveReplyExpandedState extends State<_InteractiveReplyExpanded> {
  final TextEditingController _controller = TextEditingController();
  final TextFieldKey _replyKey = const TextFieldKey(#reply_message);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: TextStyle(color: widget.textColor),
      child: Form(
        onSubmit: (context, values) {
          final text = _controller.text.trim();
          if (text.isEmpty) return;
          _controller.clear();
          widget.onSend(text);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Click reply to respond from this thread.'),
            const Gap(8),
            FormField<String>(
              key: _replyKey,
              label: const Text('Reply'),
              validator: const LengthValidator(min: 3, max: 160),
              child: TextField(
                controller: _controller,
                placeholder: const Text('Type your reply...'),
              ),
            ),
            const Gap(8),
            Builder(
              builder: (formContext) {
                return PrimaryButton(
                  onPressed: () => formContext.submitForm(),
                  child: const Text('Send Reply'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
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

Widget _flightExpanded(BuildContext context, _FlightToastModel model) {
  final fill = _resolveToastSurface(context);
  final isDark = fill.computeLuminance() < 0.5;
  final headerColor =
      isDark ? const Color(0xFFE8E8E8) : const Color(0xFF0F172A);
  final pnrColor = isDark ? const Color(0xFF8C8C8C) : const Color(0xFF475569);
  final routeColor = isDark ? const Color(0xFFEDEDED) : const Color(0xFF0F172A);
  final subtitleColor =
      isDark ? const Color(0xFFC0C5CB) : const Color(0xFF334155);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        children: [
          Text(
            'UNITED',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 3.2,
              fontWeight: FontWeight.w700,
              color: headerColor,
            ),
          ),
          const Spacer(),
          Text(
            model.pnr,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: pnrColor,
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
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: routeColor,
                ),
              ),
            ),
            Positioned(
              right: 8,
              bottom: 0,
              child: Text(
                model.toCode,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: routeColor,
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
            const Positioned(left: 56, bottom: 6, child: _FlightDot()),
            const Positioned(right: 56, bottom: 6, child: _FlightDot()),
          ],
        ),
      ),
      const SizedBox(height: 6),
      Text(
        model.subtitle,
        style: TextStyle(
          fontSize: 14,
          height: 1.35,
          color: subtitleColor,
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

class _FlightDot extends StatelessWidget {
  const _FlightDot();

  @override
  Widget build(BuildContext context) {
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

  final Object stateTag;
  final String title;
  final String subtitle;
  final GooeyToastState state;
  final IconData icon;
  final Color tone;
  final String fromCode;
  final String toCode;
  final String pnr;
  final String cta;
  final bool showExpanded;
  final Duration? duration;
  final GooeyAutopilot? autopilot;
}

class _AnimatedCompactLabel extends StatefulWidget {
  const _AnimatedCompactLabel({
    required this.title,
    required this.tone,
    required this.icon,
  });

  final String title;
  final Color tone;
  final IconData icon;

  @override
  State<_AnimatedCompactLabel> createState() => _AnimatedCompactLabelState();
}

class _AnimatedCompactLabelState extends State<_AnimatedCompactLabel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;
  String? _prevTitle;
  Color? _prevTone;
  IconData? _prevIcon;
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
    final changed = oldWidget.title != widget.title ||
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

enum _PreviewVariant {
  success('success'),
  error('error'),
  warning('warning'),
  info('info'),
  action('action'),
  loading('loading'),
  promise('promise'),
  custom('custom');

  const _PreviewVariant(this.label);

  final String label;
}

enum _EdgePreset {
  topLeft(
    label: 'top-left',
    position: GooeyToastPosition.left,
    expandDirection: GooeyToastExpandDirection.bottom,
  ),
  topCenter(
    label: 'top-center',
    position: GooeyToastPosition.center,
    expandDirection: GooeyToastExpandDirection.bottom,
  ),
  topRight(
    label: 'top-right',
    position: GooeyToastPosition.right,
    expandDirection: GooeyToastExpandDirection.bottom,
  ),
  bottomLeft(
    label: 'bottom-left',
    position: GooeyToastPosition.left,
    expandDirection: GooeyToastExpandDirection.top,
  ),
  bottomCenter(
    label: 'bottom-center',
    position: GooeyToastPosition.center,
    expandDirection: GooeyToastExpandDirection.top,
  ),
  bottomRight(
    label: 'bottom-right',
    position: GooeyToastPosition.right,
    expandDirection: GooeyToastExpandDirection.top,
  );

  const _EdgePreset({
    required this.label,
    required this.position,
    required this.expandDirection,
  });

  final String label;
  final GooeyToastPosition position;
  final GooeyToastExpandDirection expandDirection;

  _EdgePreset get alternate {
    switch (this) {
      case _EdgePreset.topLeft:
        return _EdgePreset.topRight;
      case _EdgePreset.topCenter:
        return _EdgePreset.bottomCenter;
      case _EdgePreset.topRight:
        return _EdgePreset.bottomRight;
      case _EdgePreset.bottomLeft:
        return _EdgePreset.topLeft;
      case _EdgePreset.bottomCenter:
        return _EdgePreset.topCenter;
      case _EdgePreset.bottomRight:
        return _EdgePreset.bottomLeft;
    }
  }
}

class _GooeyGlobalSettings {
  const _GooeyGlobalSettings({
    required this.preset,
    required this.animationStyle,
    required this.bodyAnimationStyle,
    required this.shapeStyle,
    required this.width,
    required this.roundness,
    required this.duration,
    required this.autopilot,
    required this.compactMorph,
    required this.autopilotEnabled,
    required this.pauseOnHover,
    required this.swipeToDismiss,
    required this.persistUntilDismissed,
    required this.newToastBehavior,
  });

  final _EdgePreset preset;
  final GooeyToastAnimationStyle animationStyle;
  final GooeyToastBodyAnimationStyle bodyAnimationStyle;
  final GooeyToastShapeStyle shapeStyle;
  final double width;
  final double roundness;
  final Duration duration;
  final GooeyAutopilot autopilot;
  final GooeyCompactMorph compactMorph;
  final bool autopilotEnabled;
  final bool pauseOnHover;
  final bool swipeToDismiss;
  final bool persistUntilDismissed;
  final GooeyToastNewToastBehavior newToastBehavior;

  _GooeyGlobalSettings copyWith({
    _EdgePreset? preset,
    GooeyToastAnimationStyle? animationStyle,
    GooeyToastBodyAnimationStyle? bodyAnimationStyle,
    GooeyToastShapeStyle? shapeStyle,
    bool? autopilotEnabled,
    bool? pauseOnHover,
    bool? swipeToDismiss,
    bool? persistUntilDismissed,
    GooeyToastNewToastBehavior? newToastBehavior,
  }) {
    return _GooeyGlobalSettings(
      preset: preset ?? this.preset,
      animationStyle: animationStyle ?? this.animationStyle,
      bodyAnimationStyle: bodyAnimationStyle ?? this.bodyAnimationStyle,
      shapeStyle: shapeStyle ?? this.shapeStyle,
      width: width,
      roundness: roundness,
      duration: duration,
      autopilot: autopilot,
      compactMorph: compactMorph,
      autopilotEnabled: autopilotEnabled ?? this.autopilotEnabled,
      pauseOnHover: pauseOnHover ?? this.pauseOnHover,
      swipeToDismiss: swipeToDismiss ?? this.swipeToDismiss,
      persistUntilDismissed:
          persistUntilDismissed ?? this.persistUntilDismissed,
      newToastBehavior: newToastBehavior ?? this.newToastBehavior,
    );
  }
}

Color _resolveToastSurface(BuildContext context) {
  return resolveGooeyToastDocsSurface(Theme.of(context).brightness);
}

Color resolveGooeyToastDocsSurface(Brightness brightness) {
  return brightness == Brightness.light
      ? const Color(0xFF0D1117)
      : const Color(0xFFF8FAFC);
}

Color _resolveToastContentColor(BuildContext context) {
  final fill = _resolveToastSurface(context);
  final isDark = fill.computeLuminance() < 0.5;
  return isDark ? const Color(0xFFEAF0F8) : const Color(0xFF0F172A);
}
