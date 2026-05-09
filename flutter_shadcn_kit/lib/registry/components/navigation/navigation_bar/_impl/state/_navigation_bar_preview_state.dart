// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _NavigationBarPreviewState defines a reusable type for this registry module.
class _NavigationBarPreviewState extends State<NavigationBarPreview> {
  /// Stores `selected` state/configuration for this implementation.
  int selected = 0;

  /// Stores `alignment` state/configuration for this implementation.
  NavigationBarAlignment alignment = NavigationBarAlignment.spaceAround;

  /// Stores `expands` state/configuration for this implementation.
  bool expands = true;

  /// Stores `labelType` state/configuration for this implementation.
  NavigationLabelType labelType = NavigationLabelType.none;

  /// Stores `customButtonStyle` state/configuration for this implementation.
  bool customButtonStyle = true;

  /// Stores `expanded` state/configuration for this implementation.
  bool expanded = true;

  /// Executes `buildButton` behavior for this component/composite.
  NavigationItem buildButton(String label, IconData icon) {
    return NavigationItem(
      style: customButtonStyle
          ? const shadcn_button.ButtonStyle.muted(
              density: shadcn_button.ButtonDensity.icon,
            )
          : null,
      selectedStyle: customButtonStyle
          ? const shadcn_button.ButtonStyle.fixed(
              density: shadcn_button.ButtonDensity.icon,
            )
          : null,
      label: Text(label),
      child: Icon(icon),
    );
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return OutlinedContainer(
      width: 500,
      height: 400,
      child: shadcn_scaffold.Scaffold(
        footers: [
          /// Creates a `Divider` instance.
          const Divider(),

          /// Creates a `NavigationBar` instance.
          NavigationBar(
            alignment: alignment,
            labelType: labelType,
            expanded: expanded,
            expands: expands,
            onSelected: (index) {
              /// Creates a `setState` instance.
              setState(() {
                selected = index;
              });
            },
            index: selected,
            children: [
              /// Creates a `buildButton` instance.
              buildButton('Home', Icons.home_outlined),

              /// Creates a `buildButton` instance.
              buildButton('Explore', Icons.explore_outlined),

              /// Creates a `buildButton` instance.
              buildButton('Library', Icons.library_music_outlined),

              /// Creates a `buildButton` instance.
              buildButton('Profile', Icons.person_outline),

              /// Creates a `buildButton` instance.
              buildButton('App', Icons.apps_outlined),
            ],
          ),
        ],
        child: Container(
          color: Colors.primaries[Colors.primaries.length - selected - 1],
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 8,
              spacing: 8,
              children: [
                Select<NavigationBarAlignment>(
                  value: alignment,
                  itemBuilder:
                      (BuildContext context, NavigationBarAlignment item) {
                        return Text(item.name);
                      },
                  popupWidthConstraint: PopoverConstraint.anchorFixedSize,
                  onChanged: (value) {
                    if (value != null) {
                      /// Creates a `setState` instance.
                      setState(() {
                        alignment = value;
                      });
                    }
                  },
                  popup: SelectPopup(
                    items: SelectItemList(
                      children: [
                        for (var value in NavigationBarAlignment.values)
                          /// Creates a `SelectItemButton` instance.
                          SelectItemButton(
                            value: value,
                            child: Text(value.name),
                          ),
                      ],
                    ),
                  ).call,
                ),
                Select<NavigationLabelType>(
                  value: labelType,
                  itemBuilder:
                      (BuildContext context, NavigationLabelType item) {
                        return Text(item.name);
                      },
                  popupWidthConstraint: PopoverConstraint.anchorFixedSize,
                  onChanged: (value) {
                    if (value != null) {
                      /// Creates a `setState` instance.
                      setState(() {
                        labelType = value;
                      });
                    }
                  },
                  popup: SelectPopup(
                    items: SelectItemList(
                      children: [
                        for (var value in NavigationLabelType.values)
                          /// Creates a `SelectItemButton` instance.
                          SelectItemButton(
                            value: value,
                            child: Text(value.name),
                          ),
                      ],
                    ),
                  ).call,
                ),

                /// Creates a `Checkbox` instance.
                Checkbox(
                  state: expands
                      ? CheckboxState.checked
                      : CheckboxState.unchecked,
                  onChanged: (value) {
                    /// Creates a `setState` instance.
                    setState(() {
                      expands = value == CheckboxState.checked;
                    });
                  },
                  trailing: const Text('Expands'),
                ),

                /// Creates a `Checkbox` instance.
                Checkbox(
                  state: customButtonStyle
                      ? CheckboxState.checked
                      : CheckboxState.unchecked,
                  onChanged: (value) {
                    /// Creates a `setState` instance.
                    setState(() {
                      customButtonStyle = value == CheckboxState.checked;
                    });
                  },
                  trailing: const Text('Custom Button Style'),
                ),

                /// Creates a `Checkbox` instance.
                Checkbox(
                  state: expanded
                      ? CheckboxState.checked
                      : CheckboxState.unchecked,
                  onChanged: (value) {
                    /// Creates a `setState` instance.
                    setState(() {
                      expanded = value == CheckboxState.checked;
                    });
                  },
                  trailing: const Text('Expanded'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
