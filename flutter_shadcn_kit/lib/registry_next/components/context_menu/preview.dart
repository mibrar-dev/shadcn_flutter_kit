// Gallery preview of the context menu: a panel that opens a menu on
// right-click (long-press on touch platforms).

import 'package:flutter/widgets.dart';

import '../menu/menu.dart';
import '../../theme/theme.dart';
import 'context_menu.dart';

/// Gallery preview of [ContextMenu].
class ContextMenuPreview extends StatelessWidget {
  /// Creates the preview.
  const ContextMenuPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
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
            enabled: false,
            child: const Text('Inspect'),
            onPressed: (_) {},
          ),
        ],
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            border: Border.all(color: ambient.colors.border),
            borderRadius: ambient.borderRadiusMd,
          ),
          child: const Text('Right-click anywhere on this card'),
        ),
      ),
    );
  }
}
