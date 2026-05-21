// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../refresh_trigger.dart';

/// _DefaultRefreshIndicatorState defines a reusable type for this registry module.
class _DefaultRefreshIndicatorState extends State<DefaultRefreshIndicator> {
  /// Executes `buildRefreshingContent` behavior for this component/composite.
  Widget buildRefreshingContent(BuildContext context) {
    final localizations = ShadcnLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Creates a `Flexible` instance.
        Flexible(child: Text(localizations.refreshTriggerRefreshing)),

        /// Creates a `CircularProgressIndicator` instance.
        const CircularProgressIndicator(),
      ],
    ).gap(8);
  }

  /// Executes `buildCompletedContent` behavior for this component/composite.
  Widget buildCompletedContent(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = ShadcnLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Creates a `Flexible` instance.
        Flexible(child: Text(localizations.refreshTriggerComplete)),

        /// Creates a `SizedBox` instance.
        SizedBox(
          width: 12.0 * theme.scaling,
          height: 8.0 * theme.scaling,
          child: AnimatedValueBuilder(
            initialValue: 0.0,
            value: 1.0,
            duration: const Duration(milliseconds: 300),
            curve: const Interval(0.5, 1.0),
            builder: (context, value, _) {
              return CustomPaint(
                painter: AnimatedCheckPainter(
                  progress: value,
                  color: theme.colorScheme.foreground,
                  strokeWidth: 1.5 * theme.scaling,
                ),
              );
            },
          ),
        ),
      ],
    ).gap(8);
  }

  /// Executes `buildPullingContent` behavior for this component/composite.
  Widget buildPullingContent(BuildContext context) {
    final localizations = ShadcnLocalizations.of(context);
    return AnimatedBuilder(
      animation: widget.stage.extent,
      builder: (context, child) {
        /// Stores `angle` state/configuration for this implementation.
        double angle;
        if (widget.stage.direction == Axis.vertical) {
          // 0 -> 1 (0 -> 180)
          angle = -pi * widget.stage.extentValue.clamp(0, 1);
        } else {
          // 0 -> 1 (90 -> 270)
          angle = -pi / 2 + -pi * widget.stage.extentValue.clamp(0, 1);
        }
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Creates a `Transform.rotate` instance.
            Transform.rotate(
              angle: angle,
              child: const Icon(Icons.arrow_downward),
            ),

            /// Creates a `Flexible` instance.
            Flexible(
              child: Text(
                widget.stage.extentValue < 1
                    ? localizations.refreshTriggerPull
                    : localizations.refreshTriggerRelease,
              ),
            ),

            /// Creates a `Transform.rotate` instance.
            Transform.rotate(
              angle: angle,
              child: const Icon(Icons.arrow_downward),
            ),
          ],
        ).gap(8);
      },
    );
  }

  /// Executes `buildIdleContent` behavior for this component/composite.
  Widget buildIdleContent(BuildContext context) {
    final localizations = ShadcnLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Flexible(child: Text(localizations.refreshTriggerPull))],
    ).gap(8);
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    /// Stores `child` state/configuration for this implementation.
    Widget child;
    switch (widget.stage.stage) {
      case TriggerStage.refreshing:
        child = buildRefreshingContent(context);
        break;
      case TriggerStage.completed:
        child = buildCompletedContent(context);
        break;
      case TriggerStage.pulling:
        child = buildPullingContent(context);
        break;
      case TriggerStage.idle:
        child = buildIdleContent(context);
        break;
    }
    final theme = Theme.of(context);
    return Center(
      child: SurfaceCard(
        padding: widget.stage.stage == TriggerStage.pulling
            ? EdgeInsets.all(theme.density.baseGap * theme.scaling * 0.5)
            : EdgeInsets.symmetric(
                    horizontal: theme.density.baseContentPadding * 0.75,
                    vertical: theme.density.baseGap * 0.5,
                  ) *
                  theme.scaling,
        borderRadius: theme.borderRadiusXl,
        child: AnimatedSwitcher(
          duration: kDefaultDuration,
          child: KeyedSubtree(key: ValueKey(widget.stage.stage), child: child),
        ),
      ),
    );
  }
}
