// Gallery preview of the dropdown menu surface: a 220px menu with three
// rows and a separator. `showShadcnDropdown` anchors the same surface below
// any widget.

import 'package:flutter/widgets.dart';

import '../menu/menu.dart';
import 'dropdown_menu.dart';

/// Gallery preview of [DropdownMenu].
class DropdownMenuPreview extends StatelessWidget {
  /// Creates the preview.
  const DropdownMenuPreview({super.key});

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
            MenuButton(
              trailing: const MenuShortcut(shortcut: '⌘Q'),
              child: const Text('Sign out'),
              onPressed: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}
