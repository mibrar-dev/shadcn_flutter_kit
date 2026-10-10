// Named examples for the `menubar` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Only the bar
// renders (submenus open on tap), so the examples shrink-wrap with no extra
// scaffolding.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../menu/menu.dart';
import 'menubar.dart';

/// File / Edit / View triggers, each with a submenu of menu rows.
Widget _default(BuildContext context) {
  return Menubar(
    children: <Widget>[
      MenuButton(
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
        child: const Text('File'),
      ),
      MenuButton(
        subMenu: <Widget>[
          MenuButton(child: const Text('Cut'), onPressed: (_) {}),
          MenuButton(child: const Text('Copy'), onPressed: (_) {}),
        ],
        child: const Text('Edit'),
      ),
      MenuButton(
        subMenu: <Widget>[
          const MenuLabel(child: Text('Zoom')),
          MenuButton(child: const Text('100%'), onPressed: (_) {}),
          MenuButton(child: const Text('150%'), onPressed: (_) {}),
        ],
        child: const Text('View'),
      ),
    ],
  );
}

/// A nested submenu under the View trigger.
Widget _withSubmenu(BuildContext context) {
  return Menubar(
    children: <Widget>[
      MenuButton(
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
        child: const Text('View'),
      ),
    ],
  );
}

/// Named docs examples for `menubar`; the first entry is the default.
const List<ComponentPreview> menubarPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('With submenu', _withSubmenu),
];
