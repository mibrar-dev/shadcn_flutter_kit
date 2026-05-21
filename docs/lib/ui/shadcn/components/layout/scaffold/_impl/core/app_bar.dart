// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../scaffold.dart';

/// AppBar defines a reusable type for this registry module.
class AppBar extends StatefulWidget {
  /// List of widgets to display in the trailing (right) area of the app bar.
  ///
  /// Typically contains action buttons, menus, or other interactive elements.
  /// Items are arranged horizontally with appropriate spacing based on the
  /// [trailingGap] setting.
  final List<Widget> trailing;

  /// List of widgets to display in the leading (left) area of the app bar.
  ///
  /// Commonly includes back buttons, menu buttons, or branding elements.
  /// Items are arranged horizontally with spacing controlled by [leadingGap].
  final List<Widget> leading;

  /// Optional main content widget displayed in the center area.
  ///
  /// When provided, this widget takes precedence over [title], [header],
  /// and [subtitle] for the central content area. Useful for custom layouts.
  final Widget? child;

  /// Primary title text or widget for the app bar.
  ///
  /// Displayed prominently in the center area when [child] is not provided.
  /// Should clearly identify the current screen or application section.
  final Widget? title;

  /// Optional small widget placed above the title.
  ///
  /// Provides additional context or branding above the main title.
  /// Typically used for breadcrumbs, status indicators, or secondary labels.
  final Widget? header;

  /// Optional small widget placed below the title.
  ///
  /// Provides supplementary information below the main title.
  /// Commonly used for descriptions, status text, or secondary navigation.
  final Widget? subtitle;

  /// Whether the trailing area should expand to fill available space.
  ///
  /// When true, the trailing area expands instead of the main content area,
  /// useful for toolbars or action-heavy interfaces where trailing content
  /// needs maximum space allocation.
  final bool trailingExpanded;

  /// Alignment of content within the app bar.
  ///
  /// Controls how the central content (title, header, subtitle, or child)
  /// is positioned within its available space. Default centers the content.
  final AlignmentGeometry alignment;

  /// Background color for the app bar surface.
  ///
  /// When null, uses the theme's default app bar background color.
  /// The background provides visual separation from underlying content.
  final Color? backgroundColor;

  /// Spacing between leading widgets.
  ///
  /// Controls the horizontal gap between adjacent widgets in the leading area.
  /// When null, uses theme-appropriate default spacing.
  final double? leadingGap;

  /// Spacing between trailing widgets.
  ///
  /// Controls the horizontal gap between adjacent widgets in the trailing area.
  /// When null, uses theme-appropriate default spacing.
  final double? trailingGap;

  /// Internal padding applied within the app bar.
  ///
  /// Provides space around all app bar content, creating breathing room
  /// from the edges and ensuring proper spacing from screen boundaries.
  final EdgeInsetsGeometry? padding;

  /// Fixed height for the app bar.
  ///
  /// When specified, constrains the app bar to this exact height.
  /// When null, the app bar sizes itself based on content and theme defaults.
  final double? height;

  /// Whether to account for system safe areas (status bar, notch).
  ///
  /// When true, automatically adds padding to avoid system UI intrusions.
  /// Typically enabled for top-level app bars in full-screen contexts.
  final bool useSafeArea;

  /// Blur intensity for surface background effects.
  ///
  /// Controls backdrop blur effects behind the app bar surface.
  /// Higher values create more pronounced blur effects.
  final double? surfaceBlur;

  /// Opacity level for surface background effects.
  ///
  /// Controls transparency of background blur and overlay effects.
  /// Values range from 0.0 (transparent) to 1.0 (opaque).
  final double? surfaceOpacity;

  /// Creates an [AppBar] with the specified content and configuration.
  ///
  /// All parameters are optional with sensible defaults. The app bar
  /// automatically handles layout, spacing, and theming while providing
  /// extensive customization options for complex interface requirements.
  ///
  /// Content can be provided through individual title/header/subtitle parameters
  /// or by using the [child] parameter for complete custom layouts. Leading
  /// and trailing areas support multiple widgets with automatic spacing.
  ///
  /// Parameters:
  /// - [leading] (`List<Widget>`, default: []): Leading area widgets (left side)
  /// - [trailing] (`List<Widget>`, default: []): Trailing area widgets (right side)
  /// - [title] (Widget?, optional): Primary title content
  /// - [header] (Widget?, optional): Secondary content above title
  /// - [subtitle] (Widget?, optional): Secondary content below title
  /// - [child] (Widget?, optional): Custom content (overrides title components)
  /// - [alignment] (AlignmentGeometry, default: center): Content alignment
  /// - [trailingExpanded] (bool, default: false): Whether trailing area expands
  /// - [useSafeArea] (bool, default: depends on context): Handle system intrusions
  ///
  /// Example:
  /// ```dart
  /// AppBar(
  ///   leading: [BackButton()],
  ///   title: Text('Settings'),
  ///   trailing: [
  ///     IconButton(icon: Icon(Icons.help), onPressed: _showHelp),
  ///     PopupMenuButton(items: menuItems),
  ///   ],
  ///   backgroundColor: Theme.of(context).colorScheme.primaryContainer,
  /// )
  /// ```
  const AppBar({
    super.key,
    this.trailing = const [],
    this.leading = const [],
    this.title,
    this.header,
    this.subtitle,
    this.child,
    this.trailingExpanded = false,
    this.alignment = Alignment.center,
    this.padding,
    this.backgroundColor,
    this.leadingGap,
    this.trailingGap,
    this.height,
    this.surfaceBlur,
    this.surfaceOpacity,
    this.useSafeArea = true,
  }) : assert(
         child == null || title == null,
         'Cannot provide both child and title',
       );

  @override
  /// Executes `createState` behavior for this component/composite.
  State<AppBar> createState() => _AppBarState();
}
