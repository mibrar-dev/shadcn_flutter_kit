// Named examples for the `context_menu` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import '../menu/menu.dart';
import 'context_menu.dart';

/// The right-click surface.
class _ContextMenuSurface extends StatelessWidget {
  const _ContextMenuSurface({this.withSubmenu = false});

  final bool withSubmenu;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Center(
      child: ContextMenu(
        items: <Widget>[
          MenuButton(child: const Text('Back'), onPressed: (_) {}),
          MenuButton(child: const Text('Reload'), onPressed: (_) {}),
          MenuButton(
            trailing: const MenuShortcut(shortcut: '⌘C'),
            child: const Text('Copy link'),
            onPressed: (_) {},
          ),
          const MenuSeparator(),
          MenuButton(
            trailing: const Text('>'),
            enabled: withSubmenu,
            child: const Text('More tools'),
            onPressed: (_) {},
          ),
          MenuButton(
            enabled: false,
            child: const Text('Inspect'),
            onPressed: (_) {},
          ),
        ],
        child: Container(
          width: 220,
          padding: EdgeInsetsDensity.pxAll(32),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colors.border),
            borderRadius: theme.borderRadiusMd,
          ),
          child: Text(
            withSubmenu
                ? 'Right-click: the submenu row is enabled'
                : 'Right-click anywhere on this card',
            style: TextStyle(color: theme.colors.mutedForeground),
          ),
        ),
      ),
    );
  }
}

/// The default context menu surface.
Widget _contextMenuDefault(BuildContext context) => const _ContextMenuSurface();

/// A surface whose menu row opens a submenu.
Widget _contextMenuWithSubmenu(BuildContext context) =>
    const _ContextMenuSurface(withSubmenu: true);

/// Named docs examples for `context_menu`; the first entry is the default.
const List<ComponentPreview> contextMenuPreviews = <ComponentPreview>[
  ComponentPreview('Default', _contextMenuDefault),
  ComponentPreview('With submenu', _contextMenuWithSubmenu),
];
