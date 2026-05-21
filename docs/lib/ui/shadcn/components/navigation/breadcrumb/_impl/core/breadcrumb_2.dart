// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../breadcrumb.dart';

/// Breadcrumb defines a reusable type for this registry module.
class Breadcrumb extends StatelessWidget {
  /// Arrow separator (>).
  static const Widget arrowSeparator = _ArrowSeparator();

  /// Slash separator (/).
  static const Widget slashSeparator = _SlashSeparator();

  /// The breadcrumb items rendered from root to current location.
  final List<Widget> children;

  /// Separator inserted between items.
  final Widget? separator;

  /// Padding around the breadcrumb strip.
  final EdgeInsetsGeometry? padding;

  /// Creates a breadcrumb navigation row.
  const Breadcrumb({
    super.key,
    required this.children,
    this.separator,
    this.padding,
  });

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final compTheme = ComponentTheme.maybeOf<BreadcrumbTheme>(context);

    /// Stores `sep` state/configuration for this implementation.
    final sep = separator ?? compTheme?.separator ?? Breadcrumb.arrowSeparator;
    final pad = styleValue(
      widgetValue: padding,
      themeValue: compTheme?.padding,
      defaultValue: EdgeInsets.zero,
    );
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(
        context,
      ).copyWith(scrollbars: false, dragDevices: {PointerDeviceKind.touch}),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: pad,
          child: Row(
            children: [
              if (children.length == 1) children[0].medium().foreground(),
              if (children.length > 1)
                for (var i = 0; i < children.length; i++)
                  if (i == children.length - 1)
                    children[i].medium().foreground()
                  else
                    /// Creates a `Row` instance.
                    Row(children: [children[i].medium(), sep]),
            ],
          ).small(),
        ),
      ),
    );
  }
}
