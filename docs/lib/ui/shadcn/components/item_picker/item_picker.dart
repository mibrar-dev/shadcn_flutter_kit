// The `item_picker` component: [ItemPicker], [ItemPickerDialog],
// [ItemPickerOption], layouts, delegates and prompt helpers.
//
// Ported from `components/form/item_picker` (no `form` dep, no
// backdrop/container, `Button` options, no `ItemBuilder`).

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../primitives/form_core/object_form_field.dart';
import '../../primitives/layout.dart';
import '../../primitives/overlay.dart';
import '../../primitives/popover.dart';
import '../../primitives/text/text_extension.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import '../card/card.dart';
import '../dialog/dialog.dart';
import 'item_picker_style.dart';

export 'item_picker_style.dart';

/// Builds one item visual (wrap in [ItemPickerOption] for selection chrome).
typedef ItemPickerBuilder<T> = Widget Function(BuildContext context, T item);

/// Source of the items an item picker shows.
abstract class ItemChildDelegate<T> {
  const ItemChildDelegate();

  /// Total number of items, or null if infinite or unknown.
  int? get itemCount;

  /// Item at [index], or null if unavailable.
  T? operator [](int index);
}

/// Delegate over a fixed list of items.
class ItemList<T> extends ItemChildDelegate<T> {
  const ItemList(this.items);

  final List<T> items;

  @override
  int get itemCount => items.length;

  @override
  T operator [](int index) => items[index];
}

/// How an item picker arranges its items.
abstract class ItemPickerLayout {
  /// Vertical scrolling list.
  static const ListItemPickerLayout list = ListItemPickerLayout();

  /// Scrollable grid, 4 columns by default.
  static const GridItemPickerLayout grid = GridItemPickerLayout();

  const ItemPickerLayout();

  Widget build<T>(
    BuildContext context,
    ItemChildDelegate<T> items,
    ItemPickerBuilder<T> builder,
  );
}

/// Grid arrangement of picker items.
class GridItemPickerLayout extends ItemPickerLayout {
  const GridItemPickerLayout({this.crossAxisCount = 4});

  final int crossAxisCount;

  @override
  Widget build<T>(
    BuildContext context,
    ItemChildDelegate<T> items,
    ItemPickerBuilder<T> builder,
  ) {
    final ItemPickerTheme style =
        resolveComponentStyle<ItemPickerTheme, ItemPickerTheme>(
          context,
          select: (t) => t,
          defaults: itemPickerDefaults,
        );
    final double gap = style.spacing ?? 4;
    return _stripPadding(
      context: context,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: gap,
          crossAxisSpacing: gap,
        ),
        padding: MediaQuery.paddingOf(context),
        itemCount: items.itemCount,
        itemBuilder: (context, index) {
          final T? item = items[index];
          if (item == null) return null;
          return builder(context, item);
        },
      ),
    );
  }
}

/// Vertical list arrangement of picker items.
class ListItemPickerLayout extends ItemPickerLayout {
  const ListItemPickerLayout();

  @override
  Widget build<T>(
    BuildContext context,
    ItemChildDelegate<T> items,
    ItemPickerBuilder<T> builder,
  ) {
    return _stripPadding(
      context: context,
      child: ListView.builder(
        shrinkWrap: true,
        padding: MediaQuery.paddingOf(context),
        itemCount: items.itemCount,
        itemBuilder: (context, index) {
          final T? item = items[index];
          if (item == null) return null;
          return builder(context, item);
        },
      ),
    );
  }
}

/// Strips ambient padding around scrollable picker bodies.
Widget _stripPadding({required BuildContext context, required Widget child}) {
  return MediaQuery.removePadding(
    context: context,
    removeTop: true,
    removeBottom: true,
    removeLeft: true,
    removeRight: true,
    child: child,
  );
}

/// Selection scope a layout reads.
class ItemPickerData {
  const ItemPickerData({this.value, this.onChanged});

  final Object? value;
  final ValueChanged<Object?>? onChanged;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ItemPickerData &&
        other.value == value &&
        other.onChanged == onChanged;
  }

  @override
  int get hashCode => Object.hash(value, onChanged);
}

/// Body of an item picker: optional title plus the themed items box.
class ItemPickerDialog<T> extends StatelessWidget {
  const ItemPickerDialog({
    super.key,
    required this.items,
    required this.builder,
    this.value,
    this.onChanged,
    this.layout = ItemPickerLayout.grid,
    this.title,
    this.constraints,
    this.theme,
  });

  final ItemChildDelegate<T> items;
  final ItemPickerBuilder<T> builder;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final ItemPickerLayout layout;
  final Widget? title;
  final BoxConstraints? constraints;

  /// Widget-leg theme override, merged over the other legs.
  final ItemPickerTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final ItemPickerTheme style =
        resolveComponentStyle<ItemPickerTheme, ItemPickerTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: itemPickerDefaults,
        );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: title!.large().semiBold(),
          ),
        ConstrainedBox(
          constraints:
              constraints ?? style.constraints ?? const BoxConstraints(),
          child: Padding(
            padding: resolveEdgeInsets(
              style.padding ?? EdgeInsets.zero,
              ambient.density.baseContentPadding * ambient.scaling,
            ),
            child: Data<ItemPickerData>.inherit(
              data: ItemPickerData(
                value: value,
                onChanged: onChanged == null
                    ? null
                    : (Object? next) => onChanged!(next as T?),
              ),
              child: layout.build(context, items, builder),
            ),
          ),
        ),
      ],
    );
  }
}

/// Selectable option: ghost button in a dialog, stacked visual elsewhere.
class ItemPickerOption<T> extends StatelessWidget {
  const ItemPickerOption({
    super.key,
    required this.value,
    required this.child,
    this.label,
    this.style,
    this.selectedStyle,
  });

  /// Value selecting this option reports.
  final T value;

  /// Item visual.
  final Widget child;

  /// Optional caption.
  final Widget? label;

  /// Button style when unselected (default: ghost row).
  final ButtonVariantStyle? style;

  /// Button style when selected (default: primary row).
  final ButtonVariantStyle? selectedStyle;

  @override
  Widget build(BuildContext context) {
    final ItemPickerData? data = Data.maybeOf<ItemPickerData>(context);
    if (data == null) {
      if (label == null) return child;
      return Basic(leading: child, title: label);
    }
    final ButtonVariantStyle? row = data.value == value
        ? (selectedStyle ?? buttonDefaults.forVariant(ButtonVariant.primary))
        : (style ?? buttonDefaults.forVariant(ButtonVariant.ghost));
    return Button(
      variant: ButtonVariant.ghost,
      theme: row,
      onPressed: data.onChanged == null ? null : () => data.onChanged!(value),
      leading: label == null ? null : child,
      child: label == null ? child : label!,
    );
  }
}

/// Field editing a value by picking one item; a tap selects and closes.
class ItemPicker<T> extends StatelessWidget {
  const ItemPicker({
    super.key,
    required this.items,
    required this.builder,
    this.value,
    this.onChanged,
    this.layout = ItemPickerLayout.grid,
    this.placeholder,
    this.title,
    this.mode = PromptMode.dialog,
    this.constraints,
    this.theme,
  });

  final ItemChildDelegate<T> items;
  final ItemPickerBuilder<T> builder;
  final T? value;

  /// Called with the next value; null disables the field.
  final ValueChanged<T?>? onChanged;

  final ItemPickerLayout layout;
  final Widget? placeholder;

  /// Heading of the dialog prompt.
  final Widget? title;

  /// Dialog or popover presentation.
  final PromptMode mode;

  final BoxConstraints? constraints;

  /// Widget-leg theme override, merged over the other legs.
  final ItemPickerTheme? theme;

  @override
  Widget build(BuildContext context) {
    return ObjectFormField<T>(
      value: value,
      onChanged: onChanged,
      placeholder: placeholder ?? const SizedBox.shrink(),
      builder: builder,
      mode: mode,
      dialogTitle: title,
      immediateValueChange: true,
      editorBuilder: (context, handler) {
        return ItemPickerDialog<T>(
          items: items,
          builder: builder,
          layout: layout,
          constraints: constraints,
          theme: theme,
          value: handler.value,
          onChanged: (T? next) {
            handler.value = next;
            handler.close();
          },
        );
      },
    );
  }
}

/// Shows an item picker in an anchored popover; completes with the pick.
Future<T?> showItemPicker<T>(
  BuildContext context, {
  required ItemChildDelegate<T> items,
  required ItemPickerBuilder<T> builder,
  T? initialValue,
  ItemPickerLayout layout = ItemPickerLayout.grid,
  AlignmentGeometry? alignment,
  AlignmentGeometry? anchorAlignment,
  Offset? offset,
  Widget? title,
}) {
  return showPopover<T>(
    context: context,
    alignment: alignment ?? Alignment.topCenter,
    anchorAlignment: anchorAlignment ?? Alignment.bottomCenter,
    offset: offset ?? const Offset(0, 4),
    builder: (context) {
      return Card(
        padding: EdgeInsets.zero,
        child: ItemPickerDialog<T>(
          items: items,
          builder: builder,
          layout: layout,
          title: title,
          value: initialValue,
          onChanged: (T? next) => closeOverlay<T>(context, next),
        ),
      );
    },
  ).future;
}

/// Shows an item picker in a modal dialog; completes with the pick.
Future<T?> showItemPickerDialog<T>(
  BuildContext context, {
  required ItemChildDelegate<T> items,
  required ItemPickerBuilder<T> builder,
  ItemPickerLayout layout = ItemPickerLayout.grid,
  T? initialValue,
  Widget? title,
}) {
  return showShadcnDialog<T>(
    context: context,
    builder: (context) {
      return ItemPickerDialog<T>(
        items: items,
        builder: builder,
        layout: layout,
        title: title,
        value: initialValue,
        onChanged: (T? next) => Navigator.of(context).pop(next),
      );
    },
  );
}
