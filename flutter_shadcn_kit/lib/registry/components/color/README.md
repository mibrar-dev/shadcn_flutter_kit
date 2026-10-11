# color

`ColorDerivative` is the public surface: the colour model shared by the
colour components (`color_field`, `color_picker`, `color_input`, `hsv`, `hsl`,
`eye_dropper`). Edits can be made in any of the RGB/HSV/HSL views; the
derivative keeps the space it was created in, so HSV sliders don't silently
round-trip through HSL.

A derivative is created through one of the static factories — the class itself
is abstract and has no public unnamed constructor, so there is nothing to
instantiate directly:

```dart
ColorDerivative? fromHex = ColorDerivative.fromHex('#0080FF');
final ColorDerivative fromColor = ColorDerivative.fromColor(const Color(0xFF0080FF));
final ColorDerivative fromHSV = ColorDerivative.fromHSV(const HSVColor.fromAHSV(1, 210, 1, 1));
final ColorDerivative fromHSL = ColorDerivative.fromHSL(const HSLColor.fromAHSL(1, 0.58, 0.5, 0.5));
```

`fromHex` parses `#RGB`, `#RRGGBB` and `#AARRGGBB` through
`primitives/color_math.dart` and returns null for anything else. Hex formatting
(`colorToHex`) stays in `theme/color_utils.dart`.

## API

| Member | Returns | Notes |
|---|---|---|
| `fromColor(Color)` | `ColorDerivative` | HSV space |
| `fromHex(String)` | `ColorDerivative?` | null when the text is not a hex colour |
| `fromHSV(HSVColor)` | `ColorDerivative` | const factory |
| `fromHSL(HSLColor)` | `ColorDerivative` | const factory |
| `changeToColor(Color)` | `ColorDerivative` | `Color` edit re-expressed in this colour's space |
| `changeToColorRed/Green/Blue(double)` | `ColorDerivative` | 0–255 RGB channel edits |
| `changeToHSV` / `changeToHSL` | `ColorDerivative` | space conversion |
| `changeToHSVHue/Saturation/Value/Alpha` | `ColorDerivative` | HSV channel edits |
| `changeToHSLHue/Saturation/Lightness` | `ColorDerivative` | HSL channel edits |
| `changeToOpacity(double)` | `ColorDerivative` | alpha edit |
| `transform(ColorDerivative)` | `ColorDerivative` | re-expresses `old` in this space |
| `toColor()` | `Color` | rendered colour |
| `toHSVColor()` / `toHSLColor()` | `HSVColor` / `HSLColor` | the other spaces |
| `opacity`, `hslHue/hslSat/hslVal`, `hsvHue/hsvSat/hsvVal`, `red/green/blue` | `double` / `int` | channel reads |

A colour edit never changes the space; `transform` converts the representation
without changing the rendered colour:

```dart
final derivative = ColorDerivative.fromColor(const Color(0xFF0080FF));
final muted = derivative.changeToHSVSaturation(0.5);
final shifted = muted.changeToHSLHue(280);
final hex = colorToHex(shifted.toColor()); // theme/color_utils.dart
```

Equality compares at 8-bit-per-channel resolution, so two derivatives that
differ only by float noise from the RGB round trip (also for achromatic hues,
where hue diverges) compare equal.

The old gradient-model family (`ColorGradient` and friends) was deleted — it
had no consumers outside the old `color` folder.
