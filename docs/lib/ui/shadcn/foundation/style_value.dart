/// Picks the first non-null style value: widget override, theme value, then
/// the default.
T styleValue<T>({T? widgetValue, T? themeValue, required T defaultValue}) {
  return widgetValue ?? themeValue ?? defaultValue;
}
