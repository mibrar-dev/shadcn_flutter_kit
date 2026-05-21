// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../item_picker.dart';

/// _InternalItemPicker represents a form-related type in the registry.
class _InternalItemPicker<T> extends StatelessWidget {
  /// Field storing `items` for this form implementation.
  final ItemChildDelegate<T> items;

  /// Field storing `builder` for this form implementation.
  final ItemPickerBuilder<T> builder;

  /// Current value stored for `initialValue`.
  final T? initialValue;

  /// Field storing `layout` for this form implementation.
  final ItemPickerLayout layout;

  /// Field storing `title` for this form implementation.
  final Widget? title;

  /// Field storing `constraints` for this form implementation.
  final BoxConstraints? constraints;

  /// Callback invoked for `onChanged` events.
  final ValueChanged<T?> onChanged;

  /// Constructs `_InternalItemPicker` with the provided parameters.
  const _InternalItemPicker({
    super.key,
    required this.items,
    required this.builder,
    required this.initialValue,
    required this.layout,
    this.title,
    this.constraints,
    required this.onChanged,
  });

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = MediaQuery.paddingOf(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding:
                EdgeInsets.all(
                  theme.density.baseContentPadding * theme.scaling,
                ) +
                EdgeInsets.only(top: padding.top),
            child: title?.large.semiBold,
          ),
        ConstrainedBox(
          constraints:
              constraints ??
              BoxConstraints(
                maxWidth: 320 * theme.scaling,
                maxHeight: 320 * theme.scaling,
              ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              padding: title != null
                  ? padding.copyWith(top: 0) +
                        const EdgeInsets.only(
                              bottom: 8.0,
                              left: 8.0,
                              right: 8.0,
                            ) *
                            theme.scaling
                  : padding +
                        EdgeInsets.all(theme.density.baseGap * theme.scaling),
            ),
            child: ItemPickerDialog<T>(
              items: items,
              builder: builder,
              layout: layout,
              value: initialValue,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
