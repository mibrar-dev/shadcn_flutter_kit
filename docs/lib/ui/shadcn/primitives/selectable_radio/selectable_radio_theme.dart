// Theme data for the selectable item shapes shared by the single-select
// components: the [RadioIndicatorStyle] circle slice and the
// [SelectableRadioTheme] row container.
//
// Owned here (layer 2) so `radio_group`, and later `select`, `menu` and
// `tabs`, all resolve the same rows. User-owned overrides for a given
// component live in that component's `<name>_theme.dart`.

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// Default indicator side: shadcn `size-4`.
const double radioDefaultIndicatorSize = 16;

/// Duration of the indicator colour and dot animations.
const Duration radioDefaultDuration = Duration(milliseconds: 120);

/// Fallback label text style (shadcn `text-sm` = 14).
const TextStyle radioDefaultTextStyle = TextStyle(fontSize: 14);

/// The circle: its outline, fill and dot.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class RadioIndicatorStyle implements Mergeable<RadioIndicatorStyle> {
  /// Creates an indicator style slice.
  const RadioIndicatorStyle({
    this.borderColor,
    this.borderWidth,
    this.background,
    this.dotColor,
    this.dotSize,
    this.size,
    this.duration,
  });

  /// Per-state outline colour of the circle.
  final StateValue<ThemedColor>? borderColor;

  /// Outline width; null draws no border.
  final double? borderWidth;

  /// Per-state fill of the circle.
  final StateValue<ThemedColor>? background;

  /// Colour of the inner dot drawn while selected.
  final ThemedColor? dotColor;

  /// Diameter of the inner dot; null resolves half the [size].
  final double? dotSize;

  /// Circle side; null resolves [radioDefaultIndicatorSize].
  final double? size;

  /// Animation duration; null resolves [radioDefaultDuration].
  final Duration? duration;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  RadioIndicatorStyle merge(RadioIndicatorStyle? fallback) {
    if (fallback == null) {
      return this;
    }
    return RadioIndicatorStyle(
      borderColor:
          borderColor?.merge(fallback.borderColor) ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      background: background?.merge(fallback.background) ?? fallback.background,
      dotColor: dotColor ?? fallback.dotColor,
      dotSize: dotSize ?? fallback.dotSize,
      size: size ?? fallback.size,
      duration: duration ?? fallback.duration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is RadioIndicatorStyle &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.background == background &&
        other.dotColor == dotColor &&
        other.dotSize == dotSize &&
        other.size == size &&
        other.duration == duration;
  }

  @override
  int get hashCode => Object.hash(
    borderColor,
    borderWidth,
    background,
    dotColor,
    dotSize,
    size,
    duration,
  );
}

/// Row styling shared by every selectable item.
class SelectableRadioTheme extends ComponentThemeData
    implements Mergeable<SelectableRadioTheme> {
  /// Creates a selectable-row theme.
  const SelectableRadioTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.unselected,
    this.selected,
    this.indicator,
    this.gap,
    this.itemPadding,
    this.labelStyle,
  });

  /// Indicator style while the item is not selected.
  final RadioIndicatorStyle? unselected;

  /// Indicator style while the item is selected.
  final RadioIndicatorStyle? selected;

  /// Shared indicator style; a value row wins over it.
  final RadioIndicatorStyle? indicator;

  /// Space between the indicator and the label; null resolves 8.
  final double? gap;

  /// Padding around the row; null resolves 2 all round.
  final EdgeInsetsGeometry? itemPadding;

  /// Label text style; its colour falls back to `foreground`.
  final TextStyle? labelStyle;

  /// The indicator slice for [value], or null when this leg leaves it unset.
  RadioIndicatorStyle? forValue(bool value) => value ? selected : unselected;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  SelectableRadioTheme merge(SelectableRadioTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return SelectableRadioTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      unselected: unselected?.merge(fallback.unselected) ?? fallback.unselected,
      selected: selected?.merge(fallback.selected) ?? fallback.selected,
      indicator: indicator?.merge(fallback.indicator) ?? fallback.indicator,
      gap: gap ?? fallback.gap,
      itemPadding: itemPadding ?? fallback.itemPadding,
      labelStyle: labelStyle == null
          ? fallback.labelStyle
          : (fallback.labelStyle?.merge(labelStyle) ?? labelStyle),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SelectableRadioTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.unselected == unselected &&
        other.selected == selected &&
        other.indicator == indicator &&
        other.gap == gap &&
        other.itemPadding == itemPadding &&
        other.labelStyle == labelStyle;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    unselected,
    selected,
    indicator,
    gap,
    itemPadding,
    labelStyle,
  );
}

// ---------------------------------------------------------------------------
// Defaults (tokens only).
//
// Disabled states are intentionally absent: every `StateValue` falls back to
// its `rest` entry and the whole item is dimmed once, by the widget.
// ---------------------------------------------------------------------------

/// shadcn unchecked: `border-input` outline, transparent fill.
const RadioIndicatorStyle _radioUnselected = RadioIndicatorStyle(
  borderColor: StateValue(
    rest: ThemedColor.ref(ColorRef.input),
    hovered: ThemedColor.ref(ColorRef.input),
  ),
  borderWidth: 1,
  dotSize: 8,
  size: radioDefaultIndicatorSize,
  duration: radioDefaultDuration,
);

/// shadcn checked: `border-primary` outline, `bg-primary` dot.
const RadioIndicatorStyle _radioSelected = RadioIndicatorStyle(
  borderColor: StateValue(
    rest: ThemedColor.ref(ColorRef.primary),
    hovered: ThemedColor.ref(ColorRef.primary),
  ),
  background: StateValue(
    rest: ThemedColor.ref(ColorRef.primary),
    hovered: ThemedColor.ref(ColorRef.primary),
  ),
  dotColor: ThemedColor.ref(ColorRef.primaryForeground),
  borderWidth: 1,
  dotSize: 8,
  size: radioDefaultIndicatorSize,
  duration: radioDefaultDuration,
);

/// Token-derived baseline values for a selectable row.
const SelectableRadioTheme selectableRadioDefaults = SelectableRadioTheme(
  unselected: _radioUnselected,
  selected: _radioSelected,
  gap: 8,
  // shadcn radio-group row `p-0.5`, density-scaled.
  itemPadding: EdgeInsetsDensity.pxAll(2),
  labelStyle: radioDefaultTextStyle,
);

/// The selection scope the items of one group read.
class SelectableData<T> {
  /// Creates the scope.
  const SelectableData({
    required this.selected,
    required this.enabled,
    this.onChanged,
  });

  /// The currently selected value.
  final T? selected;

  /// Whether the group accepts input.
  final bool enabled;

  /// Reports a new selection; null makes the scope read-only, which is what an
  /// item outside a group sees.
  final ValueChanged<T>? onChanged;

  /// Selects [value] when the group accepts input.
  void select(T value) {
    if (!enabled || value == selected) {
      return;
    }
    onChanged?.call(value);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SelectableData<T> &&
        other.selected == selected &&
        other.enabled == enabled &&
        other.onChanged == onChanged;
  }

  @override
  int get hashCode => Object.hash(selected, enabled, onChanged);
}

/// Provides one [SelectableData] to the items of a group.
///
/// Goes through `Data`, so an item resolves it with
/// `Data.maybeOf<SelectableData<T>>(context)`.
class SelectableDataScope<T> extends StatelessWidget {
  /// Creates the scope.
  const SelectableDataScope({
    super.key,
    required this.data,
    required this.child,
  });

  /// Wraps the items in the scope.
  final Widget child;

  /// The selection scope.
  final SelectableData<T> data;

  @override
  Widget build(BuildContext context) =>
      Data<SelectableData<T>>.inherit(data: data, child: child);
}
