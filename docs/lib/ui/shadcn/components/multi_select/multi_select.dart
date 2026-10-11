// The `multi_select` component: a multi-selection dropdown built on the
// `select` component. The popup stays open while several values are toggled
// (checkbox rows), and the trigger shows the selection as removable chips.
//
// A sibling component rather than a second class in `select` because the
// popup rows need `menu`/`chip` (layer 3) and the two-file folder budget of
// `select` cannot hold the family; the re-architecture plan gives different
// behaviour its own small component (toggle vs button, dropdown vs menubar).

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/select_popup.dart';
import '../../theme/theme.dart';
import '../chip/chip.dart';
import '../menu/menu.dart';
import '../select/select.dart';

/// Multi-selection mapping: toggles [item] in [oldValue].
Iterable<T>? multiSelectHandler<T>(
  Iterable<T>? oldValue,
  Object? item,
  bool selected,
) {
  if (item is! T) {
    return oldValue;
  }
  final List<T> next = oldValue == null ? <T>[] : oldValue.toList();
  if (selected) {
    if (!next.contains(item)) {
      next.add(item);
    }
  } else {
    next.remove(item);
  }
  return next.isEmpty ? null : next;
}

/// Multi-selection test: the value contains the tested item.
bool multiSelectPredicate<T>(Iterable<T>? value, Object? test) =>
    value?.contains(test) ?? false;

/// A multi-selection dropdown.
///
/// [_itemBuilder] renders one selected value in the trigger (usually a
/// [MultiSelectChip]); the popup rows are [MultiSelectItem]s built from
/// [items] or the asynchronous [builder]. Picking a row toggles it and keeps
/// the popup open; a chip's remove control clears its value.
class MultiSelect<T> extends StatelessWidget {
  /// Creates a multi-selection dropdown.
  const MultiSelect({
    super.key,
    required this.itemBuilder,
    this.value,
    this.onChanged,
    this.enabled,
    this.placeholder,
    this.items,
    this.builder,
    this.searchPlaceholder,
    this.focusNode,
    this.expandIcon = const Icon(LucideIcons.chevronsUpDown),
    this.canUnselect = true,
    this.autoClose = false,
    this.popupConstraints,
    this.valueSelectionHandler,
    this.valueSelectionPredicate,
    this.theme,
  });

  /// Builds one selected value in the trigger (usually a `MultiSelectChip`).
  final SelectValueBuilder<T> itemBuilder;

  /// The selected values.
  final Iterable<T>? value;

  /// Called with the next selection; null disables the select.
  final ValueChanged<Iterable<T>?>? onChanged;

  /// Overrides the enabled state; null means `onChanged != null`.
  final bool? enabled;

  /// Shown in the trigger while no value is selected.
  final Widget? placeholder;

  /// The popup rows; ignored when [builder] is set.
  final FutureOr<List<Widget>>? items;

  /// Builds the popup rows for a search query; enables the search field.
  final SelectItemsBuilder? builder;

  /// Placeholder of the search field (shown when [builder] is set).
  final Widget? searchPlaceholder;

  /// Trigger focus node.
  final FocusNode? focusNode;

  /// Trigger trailing icon; null hides it.
  final Widget? expandIcon;

  /// Whether picking a selected item removes it. Default: true.
  final bool canUnselect;

  /// Whether picking an item closes the popup. Default: false, so several
  /// values can be toggled in a row.
  final bool autoClose;

  /// Popup size constraints; null resolves `SelectTheme.constraints`.
  final BoxConstraints? popupConstraints;

  /// Custom selection mapping; null toggles the item.
  final SelectValueSelectionHandler<Iterable<T>>? valueSelectionHandler;

  /// Custom selection test; null is `value.contains(test)`.
  final SelectValueSelectionPredicate<Iterable<T>>? valueSelectionPredicate;

  /// Widget-leg theme override, merged over the component/app/defaults legs.
  final SelectTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final Iterable<T>? selected = (value == null || value!.isEmpty)
        ? null
        : value;
    return Select<Iterable<T>>(
      value: selected,
      onChanged: onChanged,
      enabled: enabled,
      placeholder: placeholder,
      items: items,
      builder: builder,
      searchPlaceholder: searchPlaceholder,
      focusNode: focusNode,
      expandIcon: expandIcon,
      canUnselect: canUnselect,
      autoClose: autoClose,
      popupConstraints: popupConstraints,
      theme: theme,
      valueSelectionHandler: valueSelectionHandler ?? multiSelectHandler<T>,
      valueSelectionPredicate:
          valueSelectionPredicate ?? multiSelectPredicate<T>,
      itemBuilder: (context, values) => Wrap(
        spacing: ambient.spacing.xs,
        runSpacing: ambient.spacing.xs,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          for (final T item in values) itemBuilder(context, item),
        ],
      ),
    );
  }
}

/// A checkbox row for a [MultiSelect] popup: toggles its value and keeps the
/// popup open (the menu's `MenuCheckboxItem` bound to the select data).
class MultiSelectItem<T> extends StatelessWidget {
  /// Creates a multi-select checkbox row.
  const MultiSelectItem({
    super.key,
    required this.value,
    required this.child,
    this.enabled = true,
  });

  /// The value this row toggles.
  final T value;

  /// Row content.
  final Widget child;

  /// Whether the row can be toggled (on top of the select's own state).
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final SelectData? data = Data.maybeOf<SelectData>(context);
    final bool selected = data?.isSelected(value) ?? false;
    final SelectTheme style = resolveComponentStyle<SelectTheme, SelectTheme>(
      context,
      select: (t) => t,
      defaults: selectDefaults,
    );
    return MenuCheckboxItem(
      theme: MenuTheme(
        itemPadding: style.itemPadding ?? selectDefaultItemPadding,
      ),
      enabled: enabled && (data?.enabled ?? true),
      value: selected,
      onChanged: (context, next) => data?.onChanged(value, !selected),
      child: child,
    );
  }
}

/// A removable chip for a [MultiSelect] trigger: shows [child] and removes
/// [value] from the selection when its close control is pressed.
class MultiSelectChip<T> extends StatelessWidget {
  /// Creates a multi-select chip.
  const MultiSelectChip({
    super.key,
    required this.value,
    required this.child,
    this.enabled = true,
  });

  /// The value this chip represents.
  final T value;

  /// Chip content.
  final Widget child;

  /// Whether the remove control is shown (on top of the select's state).
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final SelectData? data = Data.maybeFind<SelectData>(context);
    final bool removable = enabled && (data?.enabled ?? true);
    return Chip(
      trailing: removable
          ? ChipButton(
              onPressed: () => data?.onChanged(value, false),
              child: const Icon(LucideIcons.x),
            )
          : null,
      child: child,
    );
  }
}
