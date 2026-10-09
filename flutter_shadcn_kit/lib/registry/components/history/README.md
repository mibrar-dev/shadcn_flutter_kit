# history

Recent-colour storage (`ColorHistoryStorage` + `RecentColorsScope`) and the
`ColorHistoryGrid` swatch grid that renders it. Wire the storage through
`RecentColorsScope`; grids read it with `ColorHistoryStorage.of(context)`.

```dart
RecentColorsScope(
  maxRecentColors: 50,
  child: Builder(builder: (context) {
    return ColorHistoryGrid(
      storage: ColorHistoryStorage.of(context),
      onColorPicked: (color) { /* ... */ },
    );
  }),
)
```
