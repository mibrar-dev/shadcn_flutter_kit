# Star Rating

An interactive star rating with half-star steps, keyboard stepping, drag
preview and form participation. `StarRating` shows `max.ceil()` stars and
fills them fractionally.

## When to use

- Collecting a rating (`onChanged` / controller).
- Showing a read-only rating (omit `onChanged`, pass `value`).

## Snippets

```dart
double rating = 0;

StarRating(
  value: rating,
  onChanged: (value) => setState(() => rating = value),
);
```

Half stars and a bigger row:

```dart
const StarRating(value: 3.5, step: 0.5);
const StarRating(
  value: 4,
  onChanged: onRating,
  theme: StarRatingStyle(size: 30, spacing: 8),
);
```

Controller mode:

```dart
final StarRatingController controller = StarRatingController(2);

StarRating(controller: controller);
```

## API

| Member | Type | Default | Notes |
|---|---|---|---|
| `value` | `double?` | null | controlled mode |
| `controller` | `StarRatingController?` | null | controller mode (exclusive with `value`/`onChanged`) |
| `onChanged` | `ValueChanged<double>?` | null | null = read-only row |
| `enabled` | `bool?` | null | null = interactive when controlled/controller-driven |
| `step` | `double` | `0.5` | snapping increment |
| `max` | `double` | `5` | stars shown = `max.ceil()` |
| `direction` | `Axis` | horizontal | vertical stacks the stars |
| `focusNode` / `autofocus` | | | keyboard focus |
| `onHover` / `onFocusChange` | | | state callbacks |
| `theme` | `StarRatingStyle?` | null | widget leg of the resolver |

Interaction: click/tap selects, dragging across the row updates the value as
the pointer moves, arrow keys step by `step`, and the row exposes slider
semantics with increase/decrease actions.

## Theme resolution

`widget StarRatingStyle > ComponentTheme<StarRatingTheme> in tree > app
overrides (ComponentThemes) > starRatingDefaults`, per field. Fields: colours
(`ThemedColor`), `size`, `spacing`, `points`, `pointRounding`,
`valleyRounding`, `squash`, `innerRadiusRatio`, `rotation` (degrees).

## Differences from the old `star_rating`

- `package:flutter/material.dart` is gone; the stars paint with `StarBorder`
  from `package:flutter/painting.dart` and the hard-coded `Colors.white`
  background is deleted (the mask needs coverage, not a colour).
- `ControlledStarRating` folded into `StarRating` (controller mode); the
  `StarRatingTheme` container resolves all four legs instead of
  `widget.theme ?? tree`.
- **Fixed:** an old tap called `onChanged` twice (on tap-down and again on
  tap-up); the new row commits once on tap-up and once per drag release.
- **Fixed:** the display value and the committed value are clamped to
  `[0, max]` and snapped to `step` (the old row could show values past `max`
  and committed unsnapped hover values).
- **Fixed:** the disabled cursor is the system arrow (the old one used
  `SystemMouseCursors.forbidden`).
- **Fixed:** a horizontal row maps pointer positions through the text
  direction, so RTL rows fill from the right.
- `rotation` is documented in degrees (it always reached `StarBorder`, which
  takes degrees, while the old doc claimed radians).
- The old hover preview that could stick after the pointer left is replaced by
  live drag updates; `StarRatingController` keeps its name.
