/// A style helper function that returns the value from the widget, theme, or default value.
T styleValue<T>({T? widgetValue, T? themeValue, required T defaultValue}) {
  return widgetValue ?? themeValue ?? defaultValue;
}
