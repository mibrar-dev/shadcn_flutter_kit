// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../shared/primitives/form_control.dart';
import '../../../../../shared/primitives/slider_value.dart';
import '../../slider.dart';
import 'shad_slider_models.dart';
import 'upstream_slider_controller.dart';
import 'upstream_slider_intents.dart';
import 'upstream_slider_value_indicator.dart';

/// Reactive slider with automatic state management and controller support.
///
/// This is the upstream-compatible slider API, implemented as a thin adapter
/// over the registry [Slider] preset engine (which is retained unchanged).
/// It accepts upstream [SliderValue] single/range values (via [controller] or
/// [initialValue]/[onChanged]) and maps them onto [Slider.single]/[Slider.range]:
///
/// - [divisions] maps to `ShadSnap.steps(divisions)`.
/// - [valueIndicatorBuilder] maps to the registry drag popover (shown while
///   dragging).
/// - [IncreaseSliderValue]/[DecreaseSliderValue] intents step the value by
///   [increaseStep]/[decreaseStep] (falling back to one [divisions] step, or
///   1/100th of the domain).
///
/// Differences from upstream (documented adaptations):
/// - [hintValue] is accepted and stored but not rendered; the registry track
///   has no hint marker.
/// - [onChangeStart]/[onChangeEnd] fire around programmatic intent steps.
///   The registry preset engine reports only value changes for pointer
///   gestures, so those callbacks do not fire for drag/tap gestures.
///
/// Upstream parity: ported from `slider.dart` upstream (`ControlledSlider`).
class ControlledSlider extends StatelessWidget
    with ControlledComponent<SliderValue> {
  @override
  final SliderValue initialValue;
  @override
  final ValueChanged<SliderValue>? onChanged;
  @override
  final SliderController? controller;
  @override
  final bool enabled;

  /// Callback invoked when the user starts changing the slider value.
  ///
  /// Fires around programmatic [IncreaseSliderValue]/[DecreaseSliderValue]
  /// steps. Not fired for pointer gestures (see class docs).
  final ValueChanged<SliderValue>? onChangeStart;

  /// Callback invoked when the user finishes changing the slider value.
  ///
  /// Fires around programmatic [IncreaseSliderValue]/[DecreaseSliderValue]
  /// steps. Not fired for pointer gestures (see class docs).
  final ValueChanged<SliderValue>? onChangeEnd;

  /// The minimum value the slider can represent. Must be less than [max].
  final double min;

  /// The maximum value the slider can represent. Must be greater than [min].
  final double max;

  /// The number of discrete divisions the slider range is divided into.
  ///
  /// If `null`, the slider is continuous. If non-null (and > 0), values snap
  /// via `ShadSnap.steps(divisions)`.
  final int? divisions;

  /// An optional hint value displayed on the slider track upstream.
  ///
  /// Accepted and stored for API compatibility but not rendered by the
  /// registry preset engine.
  final SliderValue? hintValue;

  /// The step size for [IncreaseSliderValue] actions.
  ///
  /// If `null`, one [divisions] step (or 1/100th of the domain) is used.
  final double? increaseStep;

  /// The step size for [DecreaseSliderValue] actions.
  ///
  /// If `null`, one [divisions] step (or 1/100th of the domain) is used.
  final double? decreaseStep;

  /// Optional builder for a bubble shown above a thumb while it is being
  /// dragged, displaying the thumb's current value. See
  /// [SliderValueIndicator].
  final SliderValueIndicatorBuilder? valueIndicatorBuilder;

  /// Creates a [ControlledSlider].
  ///
  /// Parameters match the upstream `ControlledSlider` API; rendering is
  /// delegated to the registry [Slider] preset engine.
  const ControlledSlider({
    super.key,
    this.controller,
    this.initialValue = const SliderValue.single(0),
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.hintValue,
    this.increaseStep,
    this.decreaseStep,
    this.enabled = true,
    this.valueIndicatorBuilder,
  }) : assert(min <= max);

  double _stepFor(bool increase) {
    final span = max - min;
    if (span <= 0) return 0;
    final explicit = increase ? increaseStep : decreaseStep;
    if (explicit != null) return explicit;
    if (divisions != null && divisions! > 0) return span / divisions!;
    return span / 100;
  }

  SliderValue _stepped(SliderValue current, bool increase) {
    final delta = (increase ? 1 : -1) * _stepFor(increase);
    if (current.isRanged) {
      final width = current.end - current.start;
      var start = (current.start + delta).clamp(min, max - width);
      // Clamp keeps the range width stable inside [min, max].
      start = start.clamp(min, max).toDouble();
      final end = (start + width).clamp(min, max).toDouble();
      start = (end - width).clamp(min, max).toDouble();
      return SliderValue.ranged(start, end);
    }
    return SliderValue.single((current.value + delta).clamp(min, max));
  }

  void _invokeStep(ControlledComponentData<SliderValue> data, bool increase) {
    if (!data.enabled) return;
    final previous = data.value;
    final next = _stepped(previous, increase);
    if (next == previous) return;
    onChangeStart?.call(previous);
    data.onChanged(next);
    onChangeEnd?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    return ControlledComponentAdapter<SliderValue>(
      controller: controller,
      initialValue: initialValue,
      onChanged: onChanged,
      enabled: enabled,
      builder: (context, data) {
        final value = data.value;
        final snap = divisions != null && divisions! > 0
            ? ShadSnap.steps(divisions!)
            : const ShadSnap.none();
        final indicator = valueIndicatorBuilder;
        final ShadPopoverBuilder? dragPopoverBuilder = indicator == null
            ? null
            : (context, popover) => indicator(context, popover.value);
        Widget inner;
        if (value.isRanged) {
          inner = Slider.range(
            rangeValue: ShadRangeValue(value.start, value.end),
            onChanged: (range) {
              data.onChanged(SliderValue.ranged(range.start, range.end));
            },
            min: min,
            max: max,
            enabled: data.enabled,
            snap: snap,
            dragPopoverBuilder: dragPopoverBuilder,
          );
        } else {
          inner = Slider.single(
            value: value.value,
            onChanged: (single) {
              data.onChanged(SliderValue.single(single));
            },
            min: min,
            max: max,
            enabled: data.enabled,
            snap: snap,
            dragPopoverBuilder: dragPopoverBuilder,
          );
        }
        return Actions(
          actions: {
            IncreaseSliderValue: CallbackAction<IncreaseSliderValue>(
              onInvoke: (intent) {
                _invokeStep(data, true);
                return null;
              },
            ),
            DecreaseSliderValue: CallbackAction<DecreaseSliderValue>(
              onInvoke: (intent) {
                _invokeStep(data, false);
                return null;
              },
            ),
          },
          child: inner,
        );
      },
    );
  }
}
