// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' as m;

import '../menu/menu.dart' as shadcn_menu;
import '../menubar/menubar.dart' as shadcn;

/// MenubarPreview defines a reusable type for this registry module.
class MenubarPreview extends m.StatelessWidget {
  const MenubarPreview({super.key});

  @override
  m.Widget build(m.BuildContext context) {
    return m.Scaffold(
      body: m.Center(
        child: shadcn.Menubar(
          border: true,
          children: [
            /// Creates a `shadcn_menu.MenuButton` instance.
            shadcn_menu.MenuButton(
              subMenu: [
                /// Creates a `shadcn_menu.MenuButton` instance.
                shadcn_menu.MenuButton(child: const m.Text('New')),

                /// Creates a `shadcn_menu.MenuButton` instance.
                shadcn_menu.MenuButton(child: const m.Text('Open')),

                /// Creates a `shadcn_menu.MenuDivider` instance.
                const shadcn_menu.MenuDivider(),

                /// Creates a `shadcn_menu.MenuButton` instance.
                shadcn_menu.MenuButton(child: const m.Text('Exit')),
              ],
              child: const m.Text('File'),
            ),

            /// Creates a `shadcn_menu.MenuButton` instance.
            shadcn_menu.MenuButton(
              subMenu: [
                /// Creates a `shadcn_menu.MenuButton` instance.
                shadcn_menu.MenuButton(child: const m.Text('Cut')),

                /// Creates a `shadcn_menu.MenuButton` instance.
                shadcn_menu.MenuButton(child: const m.Text('Copy')),

                /// Creates a `shadcn_menu.MenuButton` instance.
                shadcn_menu.MenuButton(child: const m.Text('Paste')),
              ],
              child: const m.Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }
}
