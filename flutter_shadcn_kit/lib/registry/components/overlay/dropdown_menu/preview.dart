// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' as m;

import '../../control/button/button.dart';
import '../dropdown_menu/dropdown_menu.dart' as shadcn;
import '../menu/menu.dart' as shadcn_menu;

/// DropdownMenuPreview defines a reusable type for this registry module.
class DropdownMenuPreview extends m.StatelessWidget {
  const DropdownMenuPreview({super.key});

  @override
  m.Widget build(m.BuildContext context) {
    return m.Scaffold(
      body: m.Center(
        child: OutlineButton(
          onPressed: () {
            /// Creates a `shadcn.showDropdown` instance.
            shadcn.showDropdown(
              context: context,
              builder: (context) {
                return const shadcn.DropdownMenu(
                  children: [
                    /// Creates a `shadcn_menu.MenuLabel` instance.
                    shadcn_menu.MenuLabel(child: m.Text('My Account')),

                    /// Creates a `shadcn_menu.MenuDivider` instance.
                    shadcn_menu.MenuDivider(),

                    /// Creates a `shadcn_menu.MenuButton` instance.
                    shadcn_menu.MenuButton(child: m.Text('Profile')),

                    /// Creates a `shadcn_menu.MenuButton` instance.
                    shadcn_menu.MenuButton(child: m.Text('Billing')),

                    /// Creates a `shadcn_menu.MenuButton` instance.
                    shadcn_menu.MenuButton(child: m.Text('Settings')),

                    /// Creates a `shadcn_menu.MenuButton` instance.
                    shadcn_menu.MenuButton(child: m.Text('Keyboard shortcuts')),

                    /// Creates a `shadcn_menu.MenuDivider` instance.
                    shadcn_menu.MenuDivider(),

                    /// Creates a `shadcn_menu.MenuButton` instance.
                    shadcn_menu.MenuButton(child: m.Text('Team')),

                    /// Creates a `shadcn_menu.MenuButton` instance.
                    shadcn_menu.MenuButton(
                      subMenu: [
                        /// Creates a `shadcn_menu.MenuButton` instance.
                        shadcn_menu.MenuButton(child: m.Text('Email')),

                        /// Creates a `shadcn_menu.MenuButton` instance.
                        shadcn_menu.MenuButton(child: m.Text('Message')),

                        /// Creates a `shadcn_menu.MenuDivider` instance.
                        shadcn_menu.MenuDivider(),

                        /// Creates a `shadcn_menu.MenuButton` instance.
                        shadcn_menu.MenuButton(child: m.Text('More...')),
                      ],
                      child: m.Text('Invite users'),
                    ),

                    /// Creates a `shadcn_menu.MenuButton` instance.
                    shadcn_menu.MenuButton(child: m.Text('New Team')),

                    /// Creates a `shadcn_menu.MenuDivider` instance.
                    shadcn_menu.MenuDivider(),

                    /// Creates a `shadcn_menu.MenuButton` instance.
                    shadcn_menu.MenuButton(child: m.Text('GitHub')),

                    /// Creates a `shadcn_menu.MenuButton` instance.
                    shadcn_menu.MenuButton(child: m.Text('Support')),

                    /// Creates a `shadcn_menu.MenuDivider` instance.
                    shadcn_menu.MenuDivider(),

                    /// Creates a `shadcn_menu.MenuButton` instance.
                    shadcn_menu.MenuButton(child: m.Text('Log out')),
                  ],
                );
              },
            );
          },
          child: const m.Text('Open Menu'),
        ),
      ),
    );
  }
}
