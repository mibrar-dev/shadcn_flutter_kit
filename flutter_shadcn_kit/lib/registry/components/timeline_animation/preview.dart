// Gallery preview for the `timeline_animation` component.
//
// Widgets-only: an [AnimationController] drives a typed keyframe timeline
// (double -> color -> offset) and the timeline's duration/segment values are
// printed underneath.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import 'timeline_animation.dart';

/// Preview entry point used by the docs gallery.
class TimelineAnimationPreview extends StatefulWidget {
  /// Creates the preview.
  const TimelineAnimationPreview({super.key});

  @override
  State<TimelineAnimationPreview> createState() =>
      _TimelineAnimationPreviewState();
}

class _TimelineAnimationPreviewState extends State<TimelineAnimationPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final TimelineAnimation<double> _sizeTimeline;
  late final TimelineAnimation<Color?> _colorTimeline;

  @override
  void initState() {
    super.initState();
    _sizeTimeline = TimelineAnimation<double>(
      keyframes: <Keyframe<double>>[
        const AbsoluteKeyframe<double>(Duration(milliseconds: 500), 24.0, 72.0),
        const StillKeyframe<double>(Duration(milliseconds: 300)),
        const RelativeKeyframe<double>(Duration(milliseconds: 700), 24.0),
      ],
    );
    _colorTimeline = TimelineAnimation<Color?>(
      keyframes: <Keyframe<Color?>>[
        const AbsoluteKeyframe<Color?>(
          Duration(milliseconds: 800),
          Color(0xFF2563EB),
          Color(0xFF16A34A),
        ),
        const RelativeKeyframe<Color?>(
          Duration(milliseconds: 700),
          Color(0xFF2563EB),
        ),
      ],
      lerp: Transformers.typeColor,
    );
    _controller = AnimationController(
      vsync: this,
      duration: _sizeTimeline.totalDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              final double size = _sizeTimeline.transform(_controller.value);
              final Color? color = _colorTimeline.transform(_controller.value);
              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            },
          ),
          const Gap(24),
          Text(
            'total ${_sizeTimeline.totalDuration.inMilliseconds}ms · '
            'segments ${_sizeTimeline.keyframes.length} · '
            'int lerp → ${TimelineAnimation<int>(keyframes: <Keyframe<int>>[const AbsoluteKeyframe<int>(Duration(milliseconds: 400), 0, 10)]).transform(0.5)}',
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
