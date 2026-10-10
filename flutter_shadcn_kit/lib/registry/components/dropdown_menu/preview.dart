// Named examples for the `dropdown_menu` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../menu/menu.dart';
import 'dropdown_menu.dart';

/// The menu surface, 220px wide like the docs page shows it.
class _DropdownMenuDropdown extends StatelessWidget {
  const _DropdownMenuDropdown({
    this.withShortcut = false,
    this.withCheckbox = false,
  });

  final bool withShortcut;
  final bool withCheckbox;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 220,
        child: DropdownMenu(
          children: <Widget>[
            MenuButton(child: const Text('Profile'), onPressed: (_) {}),
            MenuButton(child: const Text('Settings'), onPressed: (_) {}),
            const MenuSeparator(),
            if (withShortcut)
              MenuButton(
                trailing: const MenuShortcut(shortcut: '⌘Q'),
                child: const Text('Sign out'),
                onPressed: (_) {},
              )
            else
              MenuButton(child: const Text('Sign out'), onPressed: (_) {}),
            if (withCheckbox) ...<Widget>[
              const MenuSeparator(),
              MenuButton(
                trailing: const Text('on'),
                child: const Text('Show status bar'),
                onPressed: (_) {},
              ),
              MenuButton(
                trailing: const Text('off'),
                child: const Text('Show bookmarks bar'),
                onPressed: (_) {},
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The default menu.
Widget _dropdownMenuDefault(BuildContext context) =>
    const _DropdownMenuDropdown();

/// A menu with keyboard shortcuts.
Widget _dropdownMenuWithShortcut(BuildContext context) =>
    const _DropdownMenuDropdown(withShortcut: true);

/// A menu with checkbox-style rows.
Widget _dropdownMenuWithCheckboxItem(BuildContext context) =>
    const _DropdownMenuDropdown(withCheckbox: true);

/// Named docs examples for `dropdown_menu`; the first entry is the default.
const List<ComponentPreview> dropdownMenuPreviews = <ComponentPreview>[
  ComponentPreview('Default', _dropdownMenuDefault),
  ComponentPreview('With shortcut', _dropdownMenuWithShortcut),
  ComponentPreview('With checkbox item', _dropdownMenuWithCheckboxItem),
];
