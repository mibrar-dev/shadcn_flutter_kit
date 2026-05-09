// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../menu.dart';

/// MenuRadioGroup defines a reusable type for this registry module.
class MenuRadioGroup<T> extends StatelessWidget implements MenuItem {
  /// Currently selected value.
  final T? value;

  /// Callback when selection changes.
  final ContextedValueChanged<T>? onChanged;

  /// List of [MenuRadio] children.
  final List<Widget> children;

  /// Creates a radio group for menu items.
  ///
  /// Parameters:
  /// - [value] (T?): Currently selected value
  /// - [onChanged] (`ContextedValueChanged<T>?`): Selection change callback
  /// - [children] (`List<Widget>`): Radio button children
  const MenuRadioGroup({
    super.key,
    required this.value,
    required this.onChanged,
    required this.children,
  });

  @override
  /// Stores `hasLeading` state/configuration for this implementation.
  bool get hasLeading => children.isNotEmpty;

  @override
  /// Stores `popoverController` state/configuration for this implementation.
  PopoverController? get popoverController => null;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final menuGroupData = Data.maybeOf<MenuGroupData>(context);

    /// Creates a `assert` instance.
    assert(
      menuGroupData != null,
      'MenuRadioGroup must be a child of MenuGroup',
    );
    return Data<MenuRadioGroup<T>>.inherit(
      data: this,
      child: Flex(
        direction: menuGroupData!.direction,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

/// Individual radio button item within a [MenuRadioGroup].
///
/// Displays a radio button indicator when selected and integrates with
/// the parent radio group for selection management.
