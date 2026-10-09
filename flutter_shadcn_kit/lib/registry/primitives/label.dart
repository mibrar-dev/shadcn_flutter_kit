// `Label`: leading + child + trailing row.
//
// Ported from `shared/primitives/_impl/core/label.dart`.

import 'package:flutter/widgets.dart';

import '../theme/theme.dart';

/// A horizontal label with optional [leading] and [trailing] widgets.
class Label extends StatelessWidget {
  /// Optional leading widget.
  final Widget? leading;

  /// The label content.
  final Widget child;

  /// Optional trailing widget.
  final Widget? trailing;

  /// Creates a [Label].
  const Label({super.key, this.leading, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    final scaling = ShadcnTheme.of(context).scaling;
    return IntrinsicWidth(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) ...[leading!, SizedBox(width: 8 * scaling)],
          Expanded(child: child),
          if (trailing != null) ...[SizedBox(width: 8 * scaling), trailing!],
        ],
      ),
    );
  }
}
