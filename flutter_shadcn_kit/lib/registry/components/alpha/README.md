# alpha

Checkerboard transparency painter.

Paints the light/dark square grid that sits behind translucent colours in
colour wells, pickers, and sliders.

## Usage

```dart
CustomPaint(
  painter: AlphaPainter(),
  size: const Size(220, 48),
)
```

Set `primary`, `secondary`, and `squareSize` to restyle. Fixed colours by
design — wrap with `ColorFiltered` for tints.
