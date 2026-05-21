// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../select.dart';

/// A button widget representing a selectable item in a dropdown menu.
///
/// Used within select dropdowns to create clickable option items.
class SelectItemButton<T> extends StatelessWidget {
  /// The value this item represents.
  final T value;

  /// The child widget to display as the item content.
  final Widget child;

  /// The button style for this item.
  final AbstractButtonStyle style;

  /// Whether this item is enabled.
  final bool? enabled;

  /// Creates a select item button.
  const SelectItemButton({
    super.key,
    required this.value,
    required this.child,
    this.enabled,
    this.style = const ButtonStyle.ghost(),
  });

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final data = Data.maybeOf<SelectPopupHandle>(context);
    bool isSelected = data?.isSelected(value) ?? false;
    bool hasSelection = data?.hasSelection ?? false;
    return Actions(
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (intent) {
            data?.selectItem(value, !isSelected);
            return null;
          },
        ),
      },
      child: SubFocus(
        builder: (context, subFocusState) {
          return WidgetStatesProvider(
            states: {if (subFocusState.isFocused) WidgetState.hovered},
            child: Button(
              enabled: enabled,
              disableTransition: true,
              alignment: AlignmentDirectional.centerStart,
              onPressed: () {
                data?.selectItem(value, !isSelected);
              },
              style: style.copyWith(
                padding: (context, states, value) => EdgeInsets.symmetric(
                  vertical: 8 * scaling,
                  horizontal: 8 * scaling,
                ),
                mouseCursor: (context, states, value) {
                  return SystemMouseCursors.basic;
                },
              ),
              trailing: isSelected
                  ? const Icon(LucideIcons.check).iconSmall()
                  : hasSelection
                  ? SizedBox(width: theme.density.baseContentPadding * scaling)
                  : null,
              child: child.normal(),
            ),
          );
        },
      ),
    );
  }
}
