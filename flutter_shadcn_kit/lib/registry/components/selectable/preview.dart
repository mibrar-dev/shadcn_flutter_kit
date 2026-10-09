// Gallery preview for the `selectable` component.
//
// Widgets-only, like the component itself. Shows plain and rich text,
// cursors, disabled selection, a scoped theme leg and dark tokens.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'selectable.dart';

/// Preview entry point used by the docs gallery.
class SelectablePreview extends StatelessWidget {
  /// Creates the preview.
  const SelectablePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShadcnTheme(
      data: ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _SelectablePreviewBody(),
      ),
    );
  }
}

class _SelectablePreviewBody extends StatelessWidget {
  const _SelectablePreviewBody();

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: Center(
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SelectableText(
                'Select this text to see the custom selection styling.',
              ),
              const SizedBox(height: 16),
              SelectableText.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Rich '),
                    TextSpan(
                      text: 'bold',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' and normal text.'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const SelectableText(
                'Selection disabled.',
                enableInteractiveSelection: false,
              ),
              const SizedBox(height: 16),
              ComponentTheme<SelectableTextTheme>(
                data: const SelectableTextTheme(
                  cursorWidth: 3,
                  cursorColor: ThemedColor.ref(ColorRef.mutedForeground),
                ),
                child: const SelectableText('Custom caret theme.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
