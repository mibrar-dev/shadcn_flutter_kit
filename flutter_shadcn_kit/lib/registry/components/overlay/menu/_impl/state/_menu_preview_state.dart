// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _MenuPreviewState defines a reusable type for this registry module.
class _MenuPreviewState extends State<MenuPreview> {
  /// Stores `showHiddenFiles` state/configuration for this implementation.
  bool showHiddenFiles = false;

  /// Stores `sortBy` state/configuration for this implementation.
  String sortBy = 'name';

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MenuPopup(
          children: [
            /// Creates a `MenuLabel` instance.
            const MenuLabel(child: Text('File')),

            /// Creates a `MenuButton` instance.
            MenuButton(
              trailing: const MenuShortcut(
                activator: SingleActivator(
                  LogicalKeyboardKey.keyN,
                  control: true,
                ),
              ),
              child: const Text('New Window'),
            ),

            /// Creates a `MenuButton` instance.
            MenuButton(
              trailing: const MenuShortcut(
                activator: SingleActivator(
                  LogicalKeyboardKey.keyO,
                  control: true,
                ),
              ),
              child: const Text('Open File...'),
            ),

            /// Creates a `MenuDivider` instance.
            const MenuDivider(),

            /// Creates a `MenuCheckbox` instance.
            MenuCheckbox(
              value: showHiddenFiles,
              autoClose: false,
              onChanged: (context, value) {
                /// Creates a `setState` instance.
                setState(() {
                  showHiddenFiles = value;
                });
              },
              child: const Text('Show hidden files'),
            ),

            /// Creates a `MenuDivider` instance.
            const MenuDivider(),
            MenuRadioGroup<String>(
              value: sortBy,
              onChanged: (context, value) {
                /// Creates a `setState` instance.
                setState(() {
                  sortBy = value;
                });
              },
              children: const [
                /// Creates a `MenuRadio` instance.
                MenuRadio(value: 'name', child: Text('Sort by Name')),

                /// Creates a `MenuRadio` instance.
                MenuRadio(value: 'date', child: Text('Sort by Date')),

                /// Creates a `MenuRadio` instance.
                MenuRadio(value: 'size', child: Text('Sort by Size')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
