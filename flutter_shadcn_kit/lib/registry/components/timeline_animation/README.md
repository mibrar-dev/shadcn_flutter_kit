# Timeline animation

Typed keyframe timeline for `package:flutter/widgets.dart`. Feed it an
`AnimationController` and it maps the controller's `0..1` progress onto typed
values segment by segment.

It is **not** a duplicate of the animation primitives:

| Piece | Job |
|---|---|
| `primitives/animation.dart` | repeat one scalar range / map a controller |
| `primitives/animation_queue.dart` | play queued scalar tweens in order |
| `timeline_animation` (this) | typed keyframe sequences: absolute, relative and hold segments |

## When to use

- Choreographing multi-step widget animation (size, colour, offset) from one
  controller.
- Sequences where one segment continues from the previous segment's end value.

## Snippets

```dart
final timeline = TimelineAnimation<double>(keyframes: [
  AbsoluteKeyframe(const Duration(milliseconds: 200), 0.0, 1.0),
  StillKeyframe(const Duration(milliseconds: 100)),
  RelativeKeyframe(const Duration(milliseconds: 300), 0.0),
]);

// Drive it from any controller:
final value = timeline.transform(controller.value);
final view = timeline.drive(controller); // Animatable<double>
```

Colours and other nullable types supply their interpolator:

```dart
final color = TimelineAnimation<Color?>(
  lerp: Transformers.typeColor,
  keyframes: [
    AbsoluteKeyframe(const Duration(milliseconds: 400), const Color(0xFF000000), const Color(0xFFFFFFFF)),
  ],
);
```

## API

| Member | Notes |
|---|---|
| `AbsoluteKeyframe(duration, from, to)` | explicit start/end |
| `RelativeKeyframe(duration, target)` | starts at the previous segment's end |
| `StillKeyframe(duration, [value])` | holds `value`, or the previous end when omitted |
| `TimelineAnimation(lerp:, keyframes:)` | `keyframes` non-empty, every duration > 0 |
| `transform(t)` | clamped to `0..1`; returns the value at that progress |
| `drive(controller)` / `withTotalDuration(d)` | re-bases the timeline onto another window |
| `timelineMaxDuration(timelines)` | longest total duration of a set |
| `Transformers.typeInt/typeDouble/typeColor/…` | `PropertyLerp` helpers |

## Behaviour notes

- `defaultLerp` rounds `int` endpoints and lerps any other `num`; other types
  need an explicit `lerp` (it throws instead of crashing with a cast error).
- A `StillKeyframe` that is the first segment and carries no value throws a
  `StateError` in every build mode.
- `transform` clamps instead of asserting, so a controller whose duration does
  not match `totalDuration` cannot run past the timeline.
