// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_menu.dart';

/// NavigationMenu defines a reusable type for this registry module.
class NavigationMenu extends StatefulWidget {
  /// Opacity level for the popover surface background.
  ///
  /// Controls the transparency of the dropdown content's background.
  /// Values range from 0.0 (fully transparent) to 1.0 (fully opaque).
  /// If not specified, uses the theme's default surface opacity.
  final double? surfaceOpacity;

  /// Blur effect intensity for the popover surface.
  ///
  /// Controls the backdrop blur effect applied behind the dropdown content.
  /// Higher values create more blur. If not specified, uses the theme's
  /// default surface blur setting.
  final double? surfaceBlur;

  /// The list of menu items to display in the navigation menu.
  ///
  /// Each item should be a [NavigationMenuItem] that defines the
  /// menu's structure and behavior. Items can have content for
  /// dropdown functionality or simple press actions.
  final List<Widget> children;

  /// Creates a [NavigationMenu] with the specified items and appearance.
  ///
  /// The [children] parameter is required and should contain
  /// [NavigationMenuItem] widgets that define the menu structure.
  /// Appearance properties are optional and will use theme defaults.
  ///
  /// Parameters:
  /// - [surfaceOpacity] (double?, optional): Popover background opacity
  /// - [surfaceBlur] (double?, optional): Popover backdrop blur intensity
  /// - [children] (`List<Widget>`, required): Menu items to display
  ///
  /// Example:
  /// ```dart
  /// NavigationMenu(
  ///   surfaceOpacity: 0.9,
  ///   children: [
  ///     NavigationMenuItem(child: Text('Home'), onPressed: _goHome),
  ///     NavigationMenuItem(child: Text('About'), onPressed: _showAbout),
  ///   ],
  /// )
  /// ```
  const NavigationMenu({
    super.key,
    this.surfaceOpacity,
    this.surfaceBlur,
    required this.children,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<NavigationMenu> createState() => NavigationMenuState();
}
