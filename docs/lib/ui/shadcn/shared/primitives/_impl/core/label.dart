// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../basic.dart';

/// Label defines a reusable type for this registry module.
class Label extends StatelessWidget {
  /// Optional leading widget displayed before the label.
  final Widget? leading;

  /// The main label content.
  final Widget child;

  /// Optional trailing widget displayed after the label.
  final Widget? trailing;

  /// Creates a [Label].
  ///
  /// Parameters:
  /// - [child] (`Widget`, required): Main label content.
  /// - [leading] (`Widget?`, optional): Leading widget.
  /// - [trailing] (`Widget?`, optional): Trailing widget.
  const Label({super.key, this.leading, required this.child, this.trailing});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    return IntrinsicWidth(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) leading!,
          if (leading != null) SizedBox(width: 8 * scaling),

          /// Creates a `Expanded` instance.
          Expanded(child: child),
          if (trailing != null) SizedBox(width: 8 * scaling),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
