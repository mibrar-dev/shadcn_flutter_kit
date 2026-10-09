// Gallery preview for the `star_rating` component.

import 'package:flutter/widgets.dart';

import '../../primitives/text/text_extension.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'star_rating.dart';

/// Shows values, directions, a custom style and the disabled state.
class StarRatingPreview extends StatefulWidget {
  /// Creates the preview.
  const StarRatingPreview({super.key});

  @override
  State<StarRatingPreview> createState() => _StarRatingPreviewState();
}

class _StarRatingPreviewState extends State<StarRatingPreview> {
  double _value = 3.5;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: EdgeInsets.all(theme.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Interactive (step 0.5)').small.muted,
          StarRating(
            value: _value,
            onChanged: (value) => setState(() => _value = value),
          ),
          const SizedBox(height: 12),
          const Text('Read-only').small.muted,
          const StarRating(value: 4),
          const SizedBox(height: 12),
          const Text('Step 1').small.muted,
          const StarRating(value: 2, step: 1, onChanged: _ignore),
          const SizedBox(height: 12),
          const Text('Vertical').small.muted,
          const StarRating(
            value: 3,
            direction: Axis.vertical,
            onChanged: _ignore,
          ),
          const SizedBox(height: 12),
          const Text('Custom style').small.muted,
          const StarRating(
            value: 4.5,
            onChanged: _ignore,
            theme: StarRatingStyle(
              activeColor: ThemedColor.value(Color(0xFFF59E0B)),
              inactiveColor: ThemedColor.value(Color(0xFFE5E7EB)),
              size: 30,
              spacing: 8,
            ),
          ),
          const SizedBox(height: 12),
          const Text('Disabled').small.muted,
          const StarRating(value: 3, enabled: false),
        ],
      ),
    );
  }

  static void _ignore(double value) {}
}
