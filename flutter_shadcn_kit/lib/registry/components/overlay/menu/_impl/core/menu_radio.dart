// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../menu.dart';

/// MenuRadio defines a reusable type for this registry module.
class MenuRadio<T> extends StatelessWidget {
  /// The value this radio button represents.
  final T value;

  /// Content widget displayed for this option.
  final Widget child;

  /// Optional trailing widget (e.g., keyboard shortcut).
  final Widget? trailing;

  /// Focus node for keyboard navigation.
  final FocusNode? focusNode;

  /// Whether this radio button is enabled.
  final bool enabled;

  /// Whether selecting this radio closes the menu automatically.
  final bool autoClose;

  /// Creates a radio button menu item.
  ///
  /// Must be a child of [MenuRadioGroup].
  ///
  /// Parameters:
  /// - [value] (T, required): Value for this option
  /// - [child] (Widget, required): Display content
  /// - [trailing] (Widget?): Optional trailing widget
  /// - [focusNode] (FocusNode?): Focus node for navigation
  /// - [enabled] (bool): Whether enabled, defaults to true
  /// - [autoClose] (bool): Whether to auto-close menu, defaults to true
  const MenuRadio({
    super.key,
    required this.value,
    required this.child,
    this.trailing,
    this.focusNode,
    this.enabled = true,
    this.autoClose = true,
  });

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final radioGroup = Data.maybeOf<MenuRadioGroup<T>>(context);
    assert(radioGroup != null, 'MenuRadio must be a child of MenuRadioGroup');
    return Data<MenuRadioGroup<T>>.boundary(
      child: MenuButton(
        leading: radioGroup!.value == value
            ? SizedBox(
                width: 16 * scaling,
                height: 16 * scaling,
                child: const Icon(RadixIcons.dotFilled).iconSmall(),
              )
            : SizedBox(width: theme.density.baseContentPadding * scaling),
        onPressed: (context) {
          radioGroup.onChanged?.call(context, value);
        },
        enabled: enabled,
        focusNode: focusNode,
        autoClose: autoClose,
        trailing: trailing,
        child: child,
      ),
    );
  }
}

/// Visual divider between menu items.
///
/// Renders a horizontal or vertical line to separate groups of menu items.
/// Automatically adapts direction based on the parent menu's orientation.
///
/// Example:
/// ```dart
/// MenuGroup(
///   children: [
///     MenuButton(child: Text('Cut')),
///     MenuButton(child: Text('Copy')),
///     MenuDivider(), // Separator
///     MenuButton(child: Text('Paste')),
///   ],
/// )
/// ```
