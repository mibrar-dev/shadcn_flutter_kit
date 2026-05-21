// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../stepper.dart';

/// _StepVariantLine defines a reusable type for this registry module.
class _StepVariantLine extends StepVariant {
  const _StepVariantLine();

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context, StepProperties properties) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;

    /// Stores `steps` state/configuration for this implementation.
    final steps = properties.steps;
    if (properties.direction == Axis.horizontal) {
      /// Stores `children` state/configuration for this implementation.
      List<Widget> children = [];
      for (int i = 0; i < steps.length; i++) {
        /// Creates a `children.add` instance.
        children.add(
          /// Creates a `Expanded` instance.
          Expanded(
            child: Data.inherit(
              data: StepNumberData(stepIndex: i),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Creates a `AnimatedBuilder` instance.
                  AnimatedBuilder(
                    animation: properties.state,
                    builder: (context, child) {
                      return Divider(
                        thickness: 3 * scaling,
                        color:
                            properties.hasFailure &&
                                properties.state.value.currentStep <= i
                            ? theme.colorScheme.destructive
                            : properties.state.value.currentStep >= i
                            ? theme.colorScheme.primary
                            : theme.colorScheme.border,
                      );
                    },
                  ),

                  /// Creates a `DensityGap` instance.
                  DensityGap(gapSm),
                  properties.size.wrapper(context, steps[i].title),
                ],
              ),
            ),
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Creates a `IntrinsicHeight` instance.
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ).gap(16 * scaling),
          ),

          /// Creates a `AnimatedBuilder` instance.
          AnimatedBuilder(
            animation: properties.state,
            builder: (context, child) {
              /// Stores `current` state/configuration for this implementation.
              var current = properties.state.value.currentStep;
              return Flexible(
                child: IndexedStack(
                  index: current < 0 || current >= properties.steps.length
                      ? properties
                            .steps
                            .length // will show the placeholder
                      : current,
                  children: [
                    for (int i = 0; i < properties.steps.length; i++)
                      properties[i]?.contentBuilder?.call(context) ??
                          /// Creates a `SizedBox` instance.
                          const SizedBox(),

                    /// Creates a `SizedBox` instance.
                    const SizedBox(), // for placeholder
                  ],
                ),
              );
            },
          ),
        ],
      );
    } else {
      /// Stores `children` state/configuration for this implementation.
      List<Widget> children = [];
      for (int i = 0; i < properties.steps.length; i++) {
        /// Creates a `children.add` instance.
        children.add(
          /// Creates a `Data.inherit` instance.
          Data.inherit(
            data: StepNumberData(stepIndex: i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// Creates a `IntrinsicHeight` instance.
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /// Creates a `AnimatedBuilder` instance.
                      AnimatedBuilder(
                        animation: properties.state,
                        builder: (context, child) {
                          return VerticalDivider(
                            thickness: 3 * scaling,
                            color:
                                properties.hasFailure &&
                                    properties.state.value.currentStep <= i
                                ? theme.colorScheme.destructive
                                : properties.state.value.currentStep >= i
                                ? theme.colorScheme.primary
                                : theme.colorScheme.border,
                          );
                        },
                      ),

                      /// Creates a `DensityGap` instance.
                      DensityGap(gapLg),
                      properties.size
                          .wrapper(context, properties.steps[i].title)
                          .withPadding(vertical: 8 * scaling),
                    ],
                  ),
                ),

                /// Creates a `ConstrainedBox` instance.
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 16 * scaling),
                  child: AnimatedBuilder(
                    animation: properties.state,
                    child: properties.steps[i].contentBuilder?.call(context),
                    builder: (context, child) {
                      return AnimatedCrossFade(
                        firstChild: Container(height: 0),
                        secondChild: Container(child: child!),
                        firstCurve: const Interval(
                          0.0,
                          0.6,
                          curve: Curves.fastOutSlowIn,
                        ),
                        secondCurve: const Interval(
                          0.4,
                          1.0,
                          curve: Curves.fastOutSlowIn,
                        ),
                        sizeCurve: Curves.fastOutSlowIn,
                        crossFadeState: properties.state.value.currentStep == i
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: kDefaultDuration,
                      );
                    },
                  ),
                ),

                /// Creates a `AnimatedBuilder` instance.
                AnimatedBuilder(
                  animation: properties.state,
                  builder: (context, child) {
                    if (i == properties.steps.length - 1) {
                      return const SizedBox();
                    }
                    return SizedBox(height: theme.density.baseGap * scaling);
                  },
                ),
              ],
            ),
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }
  }
}
