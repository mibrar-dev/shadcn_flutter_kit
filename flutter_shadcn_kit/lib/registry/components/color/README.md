# color

`ColorDerivative`: the colour model shared by the colour components
(`color_field`, `color_picker`, `color_input`, `hsv`, `hsl`, `eye_dropper`).

Edits can be made in any of the RGB/HSV/HSL views; the derivative keeps the
space it was created in, so HSV sliders don't silently round-trip through HSL.

```dart
final derivative = ColorDerivative.fromColor(const Color(0xFF0080FF));
final muted = derivative.changeToHSVSaturation(0.5);
final shifted = derivative.changeToHSLHue(280);
final hex = colorToHex(muted.toColor()); // theme/color_utils.dart
```

`ColorDerivative.fromHex` parses `#RGB`/`#RRGGBB`/`#AARRGGBB` via
`primitives/color_math.dart`. Hex formatting (`colorToHex`) stays in
`theme/color_utils.dart`.

The old gradient-model family (`ColorGradient` and friends) was deleted — it
had no consumers outside the old `color` folder.
