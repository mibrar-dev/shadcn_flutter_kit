// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../menu.dart';

/// MenuLabel defines a reusable type for this registry module.
class MenuLabel extends StatelessWidget implements MenuItem {
  /// Content widget displayed in the label.
  final Widget child;

  /// Optional trailing widget.
  final Widget? trailing;

  /// Optional leading widget (e.g., icon).
  final Widget? leading;

  /// Creates a menu label.
  ///
  /// Parameters:
  /// - [child] (Widget, required): Main content
  /// - [trailing] (Widget?): Trailing widget
  /// - [leading] (Widget?): Leading icon or widget
  const MenuLabel({
    super.key,
    required this.child,
    this.trailing,
    this.leading,
  });

  @override
  /// Stores `hasLeading` state/configuration for this implementation.
  bool get hasLeading => leading != null;

  @override
  /// Stores `popoverController` state/configuration for this implementation.
  PopoverController? get popoverController => null;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final menuGroupData = Data.maybeOf<MenuGroupData>(context);
    assert(menuGroupData != null, 'MenuLabel must be a child of MenuGroup');
    return Padding(
      padding:
          /// Creates a `EdgeInsets.only` instance.
          EdgeInsets.only(
                left: theme.density.baseGap,
                top: theme.density.baseGap * 0.75,
                right: theme.density.baseGap * 0.75,
                bottom: theme.density.baseGap * 0.75,
              ) *
              scaling +
          menuGroupData!.itemPadding,
      child: Basic(
        contentSpacing: 8 * scaling,
        leading: leading == null && menuGroupData.hasLeading
            ? SizedBox(width: theme.density.baseContentPadding * scaling)
            : leading == null
            ? null
            : SizedBox(
                width: 16 * scaling,
                height: 16 * scaling,
                child: leading!.iconSmall(),
              ),
        trailing: trailing,
        content: child.semiBold(),
        trailingAlignment: Alignment.center,
        leadingAlignment: Alignment.center,
        contentAlignment: menuGroupData.direction == Axis.vertical
            ? AlignmentDirectional.centerStart
            : Alignment.center,
      ),
    );
  }
}

/// Checkbox menu item with checked/unchecked state.
///
/// Displays a checkmark when selected. Used for togglable menu options.
///
/// Example:
/// ```dart
/// MenuCheckbox(
///   value: showToolbar,
///   onChanged: (context, value) => setState(() => showToolbar = value),
///   child: Text('Show Toolbar'),
/// )
/// ```
