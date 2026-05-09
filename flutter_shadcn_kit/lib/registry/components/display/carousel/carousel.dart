// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:math';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../../shared/theme/theme.dart';
import '../../../shared/utils/animation_queue.dart';
import '../../../shared/utils/style_value.dart';
import '../../../shared/utils/wrap_utils.dart';
import '../dot_indicator/dot_indicator.dart';

part '_impl/state/_carousel_state.dart';
part '_impl/core/_placed_carousel_item.dart';
part '_impl/core/carousel_alignment.dart';
part '_impl/core/carousel_fixed_constraint.dart';
part '_impl/core/carousel_fractional_constraint.dart';
part '_impl/core/carousel_transition.dart';
part '_impl/core/fading_carousel_transition.dart';
part '_impl/core/sliding_carousel_transition.dart';

part '_impl/state/carousel_controller.dart';
part '_impl/core/carousel_dot_indicator.dart';
part '_impl/core/carousel_layout.dart';
part '_impl/themes/base/carousel_theme.dart';

/// Interactive carousel widget with automatic transitions and customizable layouts.
class Carousel extends StatefulWidget {
  /// The carousel transition.
  final CarouselTransition transition;

  /// The item builder.
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// The duration of the carousel.
  final Duration? duration;

  /// The duration builder of the carousel.
  final Duration? Function(int index)? durationBuilder;

  /// The item count of the carousel.
  final int? itemCount;

  /// The carousel controller.
  final CarouselController? controller;

  /// The carousel alignment.
  final CarouselAlignment alignment;

  /// The carousel direction.
  final Axis direction;

  /// Whether the carousel should wrap.
  final bool wrap;

  /// Whether the carousel should pause on hover.
  final bool pauseOnHover;

  /// Whether the carousel should wait the item duration on start.
  final bool waitOnStart;

  /// The autoplay speed of the carousel.
  final Duration? autoplaySpeed;

  /// Whether the carousel should autoplay in reverse.
  final bool autoplayReverse;

  /// Whether the carousel is draggable.
  final bool draggable;

  /// Whether the carousel is reverse in layout direction.
  final bool reverse;

  /// The size constraint of the carousel.
  final CarouselSizeConstraint sizeConstraint;

  /// The speed of the carousel.
  final Duration speed;

  /// The curve of the carousel.
  final Curve curve;

  /// The index change callback.
  final ValueChanged<int>? onIndexChanged;

  /// Whether to disable overhead scrolling.
  final bool disableOverheadScrolling;

  /// Whether to disable dragging velocity.
  final bool disableDraggingVelocity;

  /// Creates a carousel.
  const Carousel({
    super.key,
    required this.itemBuilder,
    this.itemCount,
    this.controller,
    this.alignment = CarouselAlignment.center,
    this.direction = Axis.horizontal,
    this.wrap = true,
    this.pauseOnHover = true,
    this.autoplaySpeed,
    this.waitOnStart = false,
    this.draggable = true,
    this.reverse = false,
    this.autoplayReverse = false,
    this.sizeConstraint = const CarouselFractionalConstraint(1),
    this.speed = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
    this.duration,
    this.durationBuilder,
    this.onIndexChanged,
    this.disableOverheadScrolling = true,
    this.disableDraggingVelocity = false,
    required this.transition,
  }) : assert(
         wrap || itemCount != null,
         'itemCount must be provided if wrap is false',
       );

  /// Creates the State object used by this carousel widget.
  @override
  State<Carousel> createState() => _CarouselState();
}
