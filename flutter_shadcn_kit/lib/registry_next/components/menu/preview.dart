// Widgets-only preview gallery for the `menu` component.

import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'menu.dart';

/// Preview entry point used by the docs gallery.
class MenuPreview extends StatelessWidget {
  /// Creates the preview.
  const MenuPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnTheme(
      data: const ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ColoredBox(
          color: ShadcnTheme.of(context).colors.background,
          child: const SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Menu rows'),
                SizedBox(height: 8),
                MenuPopup(children: <Widget>[_Rows()]),
                SizedBox(height: 24),
                Text('Menubar bar (horizontal group)'),
                SizedBox(height: 8),
                _Bar(),
                SizedBox(height: 24),
                Text('Checkbox, radio, label, shortcut'),
                SizedBox(height: 8),
                MenuPopup(children: <Widget>[_ValueRows()]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Static rows (no overlay needed for the gallery).
class _Rows extends StatelessWidget {
  const _Rows();

  @override
  Widget build(BuildContext context) {
    return MenuGroup(
      autofocus: false,
      builder: (context, children) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
      children: <Widget>[
        MenuButton(child: Text('Cut'), onPressed: (_) {}),
        MenuButton(child: Text('Copy'), onPressed: (_) {}),
        MenuButton(child: Text('Paste'), onPressed: (_) {}),
        MenuSeparator(),
        MenuButton(
          child: Text('Share'),
          subMenu: <Widget>[
            MenuButton(child: Text('Email'), onPressed: (_) {}),
            MenuButton(child: Text('Link'), onPressed: (_) {}),
          ],
          onPressed: (_) {},
        ),
        MenuButton(enabled: false, child: Text('Delete'), onPressed: null),
      ],
    );
  }
}

/// Checkable, radio and static rows.
class _ValueRows extends StatelessWidget {
  const _ValueRows();

  @override
  Widget build(BuildContext context) {
    return MenuGroup(
      autofocus: false,
      children: <Widget>[
        const MenuLabel(child: Text('Options')),
        const MenuCheckboxItem(
          value: true,
          onChanged: null,
          trailing: MenuShortcut(shortcut: '⌘T'),
          child: Text('Toolbar'),
        ),
        MenuRadioGroup<String>(
          value: 'a',
          onChanged: null,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MenuRadioItem<String>(value: 'a', child: Text('Left')),
              MenuRadioItem<String>(value: 'b', child: Text('Right')),
            ],
          ),
        ),
      ],
    );
  }
}

/// A horizontal menubar-style group.
class _Bar extends StatelessWidget {
  const _Bar();

  @override
  Widget build(BuildContext context) {
    return MenuGroup(
      autofocus: false,
      direction: Axis.horizontal,
      builder: (context, children) =>
          Row(mainAxisSize: MainAxisSize.min, children: children),
      children: <MenuItem>[
        MenuButton(child: Text('File'), onPressed: (_) {}),
        MenuButton(child: Text('Edit'), onPressed: (_) {}),
        MenuButton(child: Text('View'), onPressed: (_) {}),
      ],
    );
  }
}
