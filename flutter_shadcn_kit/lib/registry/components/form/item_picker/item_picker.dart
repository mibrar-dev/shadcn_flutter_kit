// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';

import '../../layout/basic/basic.dart';
import '../../control/button/button.dart';
import '../../layout/card/card.dart';
import '../../overlay/dialog/dialog.dart';
import '../form_field/form_field.dart';
import '../../../shared/primitives/overlay.dart';
import '../../../shared/primitives/text.dart';
import '../../../shared/theme/theme.dart';

part '_impl/core/_internal_item_picker.dart';
part '_impl/state/_item_picker_dialog_state.dart';
part '_impl/core/grid_item_picker_layout.dart';
part '_impl/utils/item_builder.dart';
part '_impl/utils/item_child_delegate.dart';
part '_impl/core/item_list.dart';
part '_impl/core/item_picker_data.dart';
part '_impl/core/item_picker_dialog.dart';
part '_impl/core/item_picker_layout.dart';
part '_impl/core/item_picker_option.dart';
part '_impl/core/list_item_picker_layout.dart';

/// A widget for selecting items from a collection using various presentation modes.
///
/// This widget provides a flexible item selection interface that can display
/// items in different layouts (grid, list) and presentation modes (dialog, popover).
/// It's suitable for scenarios where users need to pick from a predefined set
/// of items like colors, icons, templates, or any custom objects.
///
/// The ItemPicker uses a delegate pattern to provide items, allowing for both
/// static lists and dynamic item generation. Items are displayed using a
/// custom builder function that determines how each item appears in the picker.
///
/// Example:
/// ```dart
/// ItemPicker<Color>(
///   items: ItemList([Colors.red, Colors.green, Colors.blue]),
///   value: Colors.red,
///   builder: (context, color, isSelected) {
///     return Container(
///       width: 40,
///       height: 40,
///       decoration: BoxDecoration(
///         color: color,
///         shape: BoxShape.circle,
///         border: isSelected ? Border.all(width: 2) : null,
///       ),
///     );
///   },
///   onChanged: (color) => print('Selected color: $color'),
/// );
/// ```
class ItemPicker<T> extends StatelessWidget {
  /// Delegate providing the collection of items to display for selection.
  ///
  /// This delegate abstracts the item source, supporting both static lists
  /// through [ItemList] and dynamic generation through [ItemBuilder].
  final ItemChildDelegate<T> items;

  /// Builder function that creates the visual representation of each item.
  ///
  /// Called for each item to create its visual representation in the picker.
  /// The builder receives the item value and selection state, allowing
  /// customized appearance based on the current selection.
  final ItemPickerBuilder<T> builder;

  /// The currently selected item, if any.
  ///
  /// When null, no item is selected. The picker highlights this item
  /// visually to indicate the current selection state.
  final T? value;

  /// Callback invoked when the user selects a different item.
  ///
  /// Called when the user taps on an item in the picker. The callback
  /// receives the selected item, or null if the selection is cleared.
  final ValueChanged<T?>? onChanged;

  /// Layout style for arranging items in the picker interface.
  ///
  /// Determines how items are arranged within the picker container,
  /// such as grid or list layout. Defaults to grid layout.
  final ItemPickerLayout? layout;

  /// Widget displayed when no item is currently selected.
  ///
  /// Shown in the picker trigger button when [value] is null.
  /// Provides visual feedback that no selection has been made yet.
  final Widget? placeholder;

  /// Optional title widget for the picker interface.
  ///
  /// Displayed at the top of the picker when shown in dialog mode,
  /// providing context about what the user is selecting.
  final Widget? title;

  /// Presentation mode for the item picker interface.
  ///
  /// Controls whether the picker appears as a modal dialog or a popover
  /// dropdown. Defaults to dialog mode for better item visibility.
  final PromptMode? mode;

  /// Size constraints for the picker interface container.
  ///
  /// Controls the dimensions of the picker when displayed, allowing
  /// customization of the available space for item display.
  final BoxConstraints? constraints;

  /// Creates an [ItemPicker].
  ///
  /// The [items] delegate provides the selectable items, and the [builder]
  /// function determines how each item is visually represented. Various
  /// options control the picker's layout and presentation style.
  ///
  /// Parameters:
  /// - [items] (`ItemChildDelegate<T>`, required): Source of items for selection
  /// - [builder] (`ItemPickerBuilder<T>`, required): Function to build item representations
  /// - [value] (T?, optional): Currently selected item
  /// - [onChanged] (`ValueChanged<T?>?`, optional): Callback for selection changes
  /// - [layout] (ItemPickerLayout?, optional): Arrangement style for items
  /// - [placeholder] (Widget?, optional): Content shown when no item is selected
  /// - [title] (Widget?, optional): Title for the picker interface
  /// - [mode] (PromptMode?, optional): Presentation style (dialog or popover)
  /// - [constraints] (BoxConstraints?, optional): Size constraints for the picker
  ///
  /// Example:
  /// ```dart
  /// ItemPicker<IconData>(
  ///   items: ItemList([Icons.home, Icons.star, Icons.favorite]),
  ///   layout: ItemPickerLayout.grid,
  ///   mode: PromptMode.dialog,
  ///   builder: (context, icon, selected) => Icon(icon),
  ///   onChanged: (icon) => updateIcon(icon),
  /// );
  /// ```
  const ItemPicker({
    super.key,
    required this.items,
    required this.builder,
    this.value,
    this.onChanged,
    this.layout,
    this.placeholder,
    this.title,
    this.mode,
    this.constraints,
  });

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final layout = this.layout ?? ItemPickerLayout.grid;
    final mode = this.mode ?? PromptMode.dialog;
    final constraints = this.constraints;
    return ObjectFormField(
      value: value,
      placeholder: placeholder ?? const SizedBox.shrink(),
      builder: builder,
      dialogTitle: title,
      onChanged: onChanged,
      mode: mode,
      decorate: false,
      editorBuilder: (context, handler) {
        if (mode == PromptMode.dialog) {
          final theme = Theme.of(context);
          return ModalBackdrop(
            borderRadius: theme.borderRadiusXl,
            child: ModalContainer(
              borderRadius: theme.borderRadiusXl,
              padding: EdgeInsets.zero,
              child: _InternalItemPicker<T>(
                items: items,
                builder: builder,
                initialValue: handler.value,
                layout: layout,
                title: title,
                constraints: constraints,
                onChanged: (value) {
                  handler.value = value;
                  closeOverlay(context);
                },
              ),
            ),
          );
        } else {
          return SurfaceCard(
            padding: EdgeInsets.zero,
            child: _InternalItemPicker<T>(
              items: items,
              builder: builder,
              initialValue: handler.value,
              layout: layout,
              title: title,
              constraints: constraints,
              onChanged: (value) {
                handler.value = value;
              },
            ),
          );
        }
      },
    );
  }
}

/// A builder function that creates a widget for an item.
///
/// Parameters:
/// - [context] (`BuildContext`, required): The build context.
/// - [item] (`T`, required): The item to display.
///
/// Returns: A widget representing the item.
typedef ItemPickerBuilder<T> = Widget Function(BuildContext context, T item);

/// Shows an item picker in a popover overlay.
///
/// Displays a popover with items arranged according to the specified layout,
/// allowing the user to select one item. The popover closes when an item
/// is selected.
///
/// Parameters:
/// - [context] (`BuildContext`, required): The build context.
/// - [items] (`ItemChildDelegate<T>`, required): Delegate providing items.
/// - [builder] (`ItemPickerBuilder<T>`, required): Builds each item widget.
/// - [initialValue] (`T?`, optional): Initially selected item.
/// - [layout] (`ItemPickerLayout`, default: `GridItemPickerLayout()`): Layout strategy.
/// - [alignment] (`AlignmentGeometry?`, optional): Popover alignment.
/// - [anchorAlignment] (`AlignmentGeometry?`, optional): Anchor alignment.
/// - [constraints] (`BoxConstraints?`, optional): Size constraints for the popover.
/// - [offset] (`Offset?`, optional): Offset from anchor.
/// - [title] (`Widget?`, optional): Optional title widget.
///
/// Returns: A `Future<T?>` that completes with the selected item or null.
///
/// Example:
/// ```dart
/// final color = await showItemPicker<Color>(
///   context,
///   items: ItemList([Colors.red, Colors.green, Colors.blue]),
///   builder: (context, color) => ColorTile(color),
/// );
/// ```
Future<T?> showItemPicker<T>(
  BuildContext context, {
  required ItemChildDelegate<T> items,
  required ItemPickerBuilder<T> builder,
  T? initialValue,
  ItemPickerLayout layout = const GridItemPickerLayout(),
  AlignmentGeometry? alignment,
  AlignmentGeometry? anchorAlignment,
  BoxConstraints? constraints,
  Offset? offset,
  Widget? title,
}) {
  final theme = Theme.of(context);
  return showPopover<T>(
    context: context,
    alignment: alignment ?? AlignmentDirectional.topStart,
    anchorAlignment: anchorAlignment ?? AlignmentDirectional.bottomStart,
    offset: offset ?? Offset(0, 8.0 * theme.scaling),
    builder: (context) {
      return SurfaceCard(
        padding: EdgeInsets.zero,
        child: _InternalItemPicker<T>(
          items: items,
          builder: builder,
          initialValue: initialValue,
          layout: layout,
          title: title,
          constraints: constraints,
          onChanged: (value) {
            closeOverlay(context, value);
          },
        ),
      );
    },
  ).future;
}

/// Shows an item picker in a modal dialog.
///
/// Displays a modal dialog with items arranged according to the specified layout,
/// allowing the user to select one item. The dialog closes when an item is selected.
///
/// Parameters:
/// - [context] (`BuildContext`, required): The build context.
/// - [items] (`ItemChildDelegate<T>`, required): Delegate providing items.
/// - [builder] (`ItemPickerBuilder<T>`, required): Builds each item widget.
/// - [layout] (`ItemPickerLayout`, default: `GridItemPickerLayout()`): Layout strategy.
/// - [initialValue] (`T?`, optional): Initially selected item.
/// - [constraints] (`BoxConstraints?`, optional): Size constraints for the dialog.
/// - [title] (`Widget`, required): Dialog title widget.
///
/// Returns: A `Future<T?>` that completes with the selected item or null.
///
/// Example:
/// ```dart
/// final icon = await showItemPickerDialog<IconData>(
///   context,
///   title: Text('Choose Icon'),
///   items: ItemList([Icons.home, Icons.star, Icons.settings]),
///   builder: (context, icon) => Icon(icon),
/// );
/// ```
Future<T?> showItemPickerDialog<T>(
  BuildContext context, {
  required ItemChildDelegate<T> items,
  required ItemPickerBuilder<T> builder,
  ItemPickerLayout layout = const GridItemPickerLayout(),
  T? initialValue,
  BoxConstraints? constraints,
  required Widget title,
}) {
  return showDialog<T>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);
      return ModalBackdrop(
        borderRadius: theme.borderRadiusXl,
        child: ModalContainer(
          borderRadius: theme.borderRadiusXl,
          padding: EdgeInsets.zero,
          child: _InternalItemPicker<T>(
            items: items,
            builder: builder,
            initialValue: initialValue,
            layout: layout,
            title: title,
            constraints: constraints,
            onChanged: (value) {
              closeOverlay(context, value);
            },
          ),
        ),
      );
    },
  );
}
