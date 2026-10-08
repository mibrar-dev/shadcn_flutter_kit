// Unit and widget tests for the `timeline_animation` component.
//
// Covers: segment sequencing (absolute/relative/hold), the four documented
// behaviour fixes (int lerp, unsupported-type lerp, positive durations,
// clamped transform), controller driving through `drive`/`withTotalDuration`,
// and the `timelineMaxDuration` helper.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/timeline_animation/timeline_animation.dart';
import 'package:flutter_test/flutter_test.dart';

TimelineAnimation<double> _doubleTimeline() {
  return TimelineAnimation<double>(
    keyframes: <Keyframe<double>>[
      const AbsoluteKeyframe<double>(Duration(milliseconds: 400), 0.0, 10.0),
      const StillKeyframe<double>(Duration(milliseconds: 200)),
      const RelativeKeyframe<double>(Duration(milliseconds: 400), 0.0),
    ],
  );
}

void main() {
  test('absolute segment maps its own time window', () {
    final TimelineAnimation<double> timeline = TimelineAnimation<double>(
      keyframes: <Keyframe<double>>[
        const AbsoluteKeyframe<double>(
          Duration(milliseconds: 1000),
          0.0,
          100.0,
        ),
      ],
    );
    expect(timeline.totalDuration, const Duration(seconds: 1));
    expect(timeline.transform(0), 0);
    expect(timeline.transform(0.25), 25);
    expect(timeline.transform(1), 100);
  });

  test('relative segment continues from the previous end value', () {
    final TimelineAnimation<double> timeline = _doubleTimeline();
    // 0..400ms absolute 0 -> 10, 400..600ms hold, 600..1000ms 10 -> 0.
    expect(timeline.transform(0), 0);
    expect(timeline.transform(0.2), 5);
    expect(timeline.transform(0.5), 10);
    expect(timeline.transform(0.8), closeTo(5, 1e-9));
    expect(timeline.transform(1), 0);
  });

  test('still keyframe holds an explicit value', () {
    final TimelineAnimation<double> timeline = TimelineAnimation<double>(
      keyframes: <Keyframe<double>>[
        const StillKeyframe<double>(Duration(milliseconds: 500), 3.0),
        const AbsoluteKeyframe<double>(Duration(milliseconds: 500), 3.0, 9.0),
      ],
    );
    expect(timeline.transform(0), 3.0);
    expect(timeline.transform(0.4), 3.0);
    expect(timeline.transform(1), 9.0);
  });

  test('still keyframe without a value as first segment throws', () {
    final TimelineAnimation<double> timeline = TimelineAnimation<double>(
      keyframes: <Keyframe<double>>[
        const StillKeyframe<double>(Duration(milliseconds: 100)),
        const AbsoluteKeyframe<double>(Duration(milliseconds: 100), 0.0, 1.0),
      ],
    );
    // Not assert-only: it must throw in every build mode.
    expect(() => timeline.transform(0), throwsStateError);
  });

  test('regression: int keyframes round instead of crashing', () {
    final TimelineAnimation<int> timeline = TimelineAnimation<int>(
      keyframes: <Keyframe<int>>[
        const AbsoluteKeyframe<int>(Duration(milliseconds: 1000), 0, 10),
      ],
    );
    // The old dynamic `a + (b - a) * t as T` threw a TypeError here.
    expect(timeline.transform(0.5), 5);
    expect(timeline.transform(0.55), 6);
    expect(timeline.transform(1), 10);
  });

  test('regression: unsupported lerp throws a typed error', () {
    final TimelineAnimation<String> timeline = TimelineAnimation<String>(
      keyframes: <Keyframe<String>>[
        const AbsoluteKeyframe<String>(Duration(milliseconds: 100), 'a', 'b'),
      ],
    );
    expect(() => timeline.transform(0.5), throwsArgumentError);
  });

  test('regression: empty and zero-duration timelines are rejected', () {
    expect(
      () => TimelineAnimation<double>(keyframes: const <Keyframe<double>>[]),
      throwsArgumentError,
    );
    expect(
      () => TimelineAnimation<double>(
        keyframes: <Keyframe<double>>[
          // The old check used inMilliseconds > 0, so this valid segment was
          // only rejected by a debug assert.
          const AbsoluteKeyframe<double>(Duration(microseconds: 500), 0.0, 1.0),
        ],
      ),
      returnsNormally,
    );
    expect(
      () => TimelineAnimation<double>(
        keyframes: <Keyframe<double>>[
          const AbsoluteKeyframe<double>(Duration.zero, 0.0, 1.0),
        ],
      ),
      throwsArgumentError,
    );
  });

  test('regression: transform clamps outside 0..1', () {
    final TimelineAnimation<double> timeline = _doubleTimeline();
    expect(timeline.transform(-0.5), 0);
    expect(timeline.transform(1.5), 0);
  });

  test('withTotalDuration maps an explicit window', () {
    final TimelineAnimation<double> timeline = _doubleTimeline();
    final TimelineAnimatable<double> fast = timeline.withTotalDuration(
      const Duration(milliseconds: 500),
    );
    expect(fast.duration, const Duration(milliseconds: 500));
    // The whole 1000ms timeline plays inside half of the window.
    expect(fast.transform(0.5), 0);
    expect(fast.transform(1), 0);

    final TimelineAnimatable<double> slow = timeline.withTotalDuration(
      const Duration(milliseconds: 2000),
    );
    // The window ends half-way through the timeline (hold segment).
    expect(slow.transform(1), 10);
    expect(slow.transform(0.5), closeTo(6.25, 1e-9));
  });

  test('timelineMaxDuration picks the longest timeline', () {
    final TimelineAnimation<double> short = TimelineAnimation<double>(
      keyframes: <Keyframe<double>>[
        const AbsoluteKeyframe<double>(Duration(milliseconds: 100), 0, 1),
      ],
    );
    final TimelineAnimation<double> long = _doubleTimeline();
    expect(
      timelineMaxDuration(<TimelineAnimation<Object?>>[short, long]),
      const Duration(milliseconds: 1000),
    );
    expect(timelineMaxDuration(<TimelineAnimation<Object?>>[]), Duration.zero);
  });

  test('Transformers supply nullable interpolators', () {
    expect(Transformers.typeInt(0, 10, 0.5), 5);
    expect(Transformers.typeDouble(0, 1, 0.25), 0.25);
    final Color mid = Transformers.typeColor(
      const Color(0xFF000000),
      const Color(0xFFFFFFFF),
      0.5,
    )!;
    expect(mid.red, closeTo(128, 1));
    expect(mid.green, closeTo(128, 1));
    expect(mid.blue, closeTo(128, 1));
    expect(mid.alpha, 255);
    expect(Transformers.typeInt(null, 1, 0.5), isNull);
    expect(
      Transformers.typeOffset(Offset.zero, const Offset(10, 10), 0.5),
      const Offset(5, 5),
    );
    expect(
      Transformers.typeSize(Size.zero, const Size(8, 4), 0.5),
      const Size(4, 2),
    );
    expect(
      Transformers.typeRect(Rect.zero, const Rect.fromLTWH(0, 0, 8, 8), 0.5),
      const Rect.fromLTWH(0, 0, 4, 4),
    );
  });

  testWidgets('timeline drives a widget build through a real controller', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: _TimelineHost(),
      ),
    );
    expect(find.text('0.0'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('5.0'), findsOneWidget);
  });
}

class _TimelineHost extends StatefulWidget {
  const _TimelineHost();

  @override
  State<_TimelineHost> createState() => _TimelineHostState();
}

class _TimelineHostState extends State<_TimelineHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final TimelineAnimation<double> _timeline;

  @override
  void initState() {
    super.initState();
    _timeline = TimelineAnimation<double>(
      keyframes: <Keyframe<double>>[
        const AbsoluteKeyframe<double>(Duration(seconds: 1), 0.0, 10.0),
      ],
    );
    _controller = AnimationController(vsync: this)
      ..duration = _timeline.totalDuration
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TimelineAnimatable<double> view = _timeline.drive(_controller);
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Text(view.transform(_controller.value).toStringAsFixed(1));
      },
    );
  }
}
