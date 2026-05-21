// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../menu.dart';

/// MenuDivider defines a reusable type for this registry module.
class MenuDivider extends StatelessWidget implements MenuItem {
  /// Creates a menu divider.
  const MenuDivider({super.key});
  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final menuGroupData = Data.maybeOf<MenuGroupData>(context);
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    return AnimatedPadding(
      duration: kDefaultDuration,
      padding:
          (menuGroupData == null || menuGroupData.direction == Axis.vertical
              ? EdgeInsets.symmetric(vertical: theme.density.baseGap * 0.5)
              : EdgeInsets.symmetric(horizontal: theme.density.baseGap * 0.5)) *
          scaling,
      child: menuGroupData == null || menuGroupData.direction == Axis.vertical
          ? Divider(
              height: 1 * scaling,
              thickness: 1 * scaling,
              indent: 0,
              endIndent: 0,
              color: theme.colorScheme.border,
            )
          : VerticalDivider(
              width: 1 * scaling,
              thickness: 1 * scaling,
              color: theme.colorScheme.border,
              indent: 0,
              endIndent: 0,
            ),
    );
  }

  @override
  /// Stores `hasLeading` state/configuration for this implementation.
  bool get hasLeading => false;

  @override
  /// Stores `popoverController` state/configuration for this implementation.
  PopoverController? get popoverController => null;
}

/// Spacing gap between menu items.
///
/// Creates empty vertical or horizontal space within a menu, based on
/// the menu's direction. Useful for visually grouping related items.
