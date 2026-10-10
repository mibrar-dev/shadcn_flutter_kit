// Named examples for the `navigation_menu` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle. Each example carries its own bounded width because
// the menu popover measures against an infinite max width.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import 'navigation_menu.dart';

/// A menu bar with plain, dropdown and popover items.
Widget _bar(BuildContext context) {
  // Intrinsic width: a fixed box clipped the bar under real text metrics.
  return const FittedBox(
    fit: BoxFit.scaleDown,
    child: NavigationMenu(
      children: <Widget>[
        NavigationMenuItem(onPressed: _noop, child: Text('Home')),
        NavigationMenuItem(
          content: NavigationMenuContentList(
            children: <Widget>[
              NavigationMenuContent(
                title: Text('Web Apps'),
                content: Text('Ship in the browser'),
              ),
              NavigationMenuContent(
                title: Text('Mobile Apps'),
                content: Text('Ship on the go'),
              ),
            ],
          ),
          child: Text('Products'),
        ),
        NavigationMenuItem(
          content: Text('Company info here'),
          child: Text('About'),
        ),
      ],
    ),
  );
}

/// A standalone two-column content list.
Widget _contentList(BuildContext context) {
  return const SizedBox(
    width: 340,
    child: NavigationMenuContentList(
      crossAxisCount: 2,
      children: <Widget>[
        NavigationMenuContent(
          title: Text('Dashboard'),
          content: Text('Analytics and insights'),
        ),
        NavigationMenuContent(
          title: Text('Settings'),
          content: Text('Preferences'),
        ),
        NavigationMenuContent(
          title: Text('Billing'),
          content: Text('Plans and invoices'),
        ),
      ],
    ),
  );
}

void _noop() {}

/// Named docs examples for `navigation_menu`; the first entry is the default.
const List<ComponentPreview> navigationMenuPreviews = <ComponentPreview>[
  ComponentPreview('Bar', _bar),
  ComponentPreview('Content list', _contentList),
];
