// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _ContextMenuPreviewState defines a reusable type for this registry module.
class _ContextMenuPreviewState extends State<ContextMenuPreview> {
  /// Stores `showBookmarks` state/configuration for this implementation.
  bool showBookmarks = false;

  /// Stores `showFullUrls` state/configuration for this implementation.
  bool showFullUrls = true;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: ContextMenu(
          items: [
            /// Creates a `MenuButton` instance.
            const MenuButton(
              trailing: MenuShortcut(
                activator: SingleActivator(
                  LogicalKeyboardKey.bracketLeft,
                  control: true,
                ),
              ),
              child: Text('Back'),
            ),

            /// Creates a `MenuButton` instance.
            const MenuButton(
              trailing: MenuShortcut(
                activator: SingleActivator(
                  LogicalKeyboardKey.bracketRight,
                  control: true,
                ),
              ),
              enabled: false,
              child: Text('Forward'),
            ),

            /// Creates a `MenuButton` instance.
            const MenuButton(
              trailing: MenuShortcut(
                activator: SingleActivator(
                  LogicalKeyboardKey.keyR,
                  control: true,
                ),
              ),
              child: Text('Reload'),
            ),

            /// Creates a `MenuButton` instance.
            MenuButton(
              subMenu: [
                /// Creates a `MenuButton` instance.
                const MenuButton(child: Text('Option 1')),

                /// Creates a `MenuButton` instance.
                const MenuButton(child: Text('Option 2')),
              ],
              trailing: const Icon(Icons.chevron_right),
              child: const Text('More Tools'),
            ),

            /// Creates a `MenuDivider` instance.
            const MenuDivider(),

            /// Creates a `MenuCheckbox` instance.
            MenuCheckbox(
              value: showBookmarks,
              autoClose: false,
              onChanged: (context, value) {
                /// Creates a `setState` instance.
                setState(() {
                  showBookmarks = value;
                });
              },
              child: const Text('Show bookmarks bar'),
            ),

            /// Creates a `MenuCheckbox` instance.
            MenuCheckbox(
              value: showFullUrls,
              autoClose: false,
              onChanged: (context, value) {
                /// Creates a `setState` instance.
                setState(() {
                  showFullUrls = value;
                });
              },
              child: const Text('Show full URLs'),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.dividerColor,
                style: BorderStyle.solid,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Right-click here',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
