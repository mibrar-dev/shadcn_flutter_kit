// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../menu.dart';

/// MenuCheckbox defines a reusable type for this registry module.
class MenuCheckbox extends StatelessWidget implements MenuItem {
  /// Current checked state.
  final bool value;

  /// Callback when checkbox state changes.
  final ContextedValueChanged<bool>? onChanged;

  /// Content widget displayed for this option.
  final Widget child;

  /// Optional trailing widget (e.g., keyboard shortcut).
  final Widget? trailing;

  /// Whether this checkbox is enabled.
  final bool enabled;

  /// Whether checking this box closes the menu automatically.
  final bool autoClose;

  /// Creates a checkbox menu item.
  ///
  /// Parameters:
  /// - [value] (bool): Current checked state, defaults to false
  /// - [onChanged] (`ContextedValueChanged<bool>?`): State change callback
  /// - [child] (Widget, required): Display content
  /// - [trailing] (Widget?): Optional trailing widget
  /// - [enabled] (bool): Whether enabled, defaults to true
  /// - [autoClose] (bool): Whether to auto-close menu, defaults to true
  const MenuCheckbox({
    super.key,
    this.value = false,
    this.onChanged,
    required this.child,
    this.trailing,
    this.enabled = true,
    this.autoClose = true,
  });

  @override
  /// Stores `hasLeading` state/configuration for this implementation.
  bool get hasLeading => true;
  @override
  /// Stores `popoverController` state/configuration for this implementation.
  PopoverController? get popoverController => null;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    return MenuButton(
      leading: value
          ? SizedBox(
              width: 16 * scaling,
              height: 16 * scaling,
              child: const Icon(RadixIcons.check).iconSmall(),
            )
          : SizedBox(width: theme.density.baseContentPadding * scaling),
      onPressed: (context) {
        onChanged?.call(context, !value);
      },
      enabled: enabled,
      autoClose: autoClose,
      trailing: trailing,
      child: child,
    );
  }
}
