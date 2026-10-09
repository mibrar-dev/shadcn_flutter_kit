// Gallery preview of the menubar: File / Edit / View triggers, each with a
// submenu of menu rows.

import 'package:flutter/widgets.dart';

import '../menu/menu.dart';
import 'menubar.dart';

/// Gallery preview of [Menubar].
class MenubarPreview extends StatelessWidget {
  /// Creates the preview.
  const MenubarPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Menubar(
        children: <Widget>[
          MenuButton(
            child: const Text('File'),
            subMenu: <Widget>[
              MenuButton(child: const Text('New'), onPressed: (_) {}),
              MenuButton(child: const Text('Open'), onPressed: (_) {}),
              const MenuSeparator(),
              MenuButton(
                trailing: const MenuShortcut(shortcut: '⌘S'),
                child: const Text('Save'),
                onPressed: (_) {},
              ),
            ],
          ),
          MenuButton(
            child: const Text('Edit'),
            subMenu: <Widget>[
              MenuButton(
                trailing: const MenuShortcut(shortcut: '⌘X'),
                child: const Text('Cut'),
                onPressed: (_) {},
              ),
              MenuButton(
                trailing: const MenuShortcut(shortcut: '⌘C'),
                child: const Text('Copy'),
                onPressed: (_) {},
              ),
              MenuButton(
                trailing: const MenuShortcut(shortcut: '⌘V'),
                child: const Text('Paste'),
                enabled: false,
                onPressed: (_) {},
              ),
            ],
          ),
          MenuButton(
            child: const Text('View'),
            subMenu: <Widget>[
              const MenuLabel(child: Text('Zoom')),
              MenuSub(
                trigger: const Text('Zoom level'),
                children: <Widget>[
                  MenuButton(child: const Text('100%'), onPressed: (_) {}),
                  MenuButton(child: const Text('150%'), onPressed: (_) {}),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
