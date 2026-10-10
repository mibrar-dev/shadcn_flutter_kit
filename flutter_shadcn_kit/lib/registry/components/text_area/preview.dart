// Widgets-only preview gallery for the `text_area` component.
//
// Shows the default three-line field, a grown field, a placeholder, a
// validating field and dark tokens.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'text_area.dart';

/// Preview entry point used by the docs gallery.
class TextAreaPreview extends StatefulWidget {
  /// Creates the preview.
  const TextAreaPreview({super.key});

  @override
  State<TextAreaPreview> createState() => _TextAreaPreviewState();
}

class _TextAreaPreviewState extends State<TextAreaPreview> {
  String _code = 'abc';

  @override
  Widget build(BuildContext context) {
    return ShadcnTheme(
      data: const ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _label('default (3 lines)', colors),
              SizedBox(height: ShadcnTheme.of(context).spacing.sm),
              const TextArea(initialValue: 'Hello, World!'),
              SizedBox(height: ShadcnTheme.of(context).spacing.lg),
              _label('placeholder, six lines', colors),
              SizedBox(height: ShadcnTheme.of(context).spacing.sm),
              const TextArea(
                placeholder: Text('Type your message here...'),
                minLines: 6,
              ),
              SizedBox(height: ShadcnTheme.of(context).spacing.lg),
              _label('grows with the content', colors),
              SizedBox(height: ShadcnTheme.of(context).spacing.sm),
              TextArea(
                hintText: 'No cap: paste a long paragraph',
                minLines: 2,
                maxLines: 8,
              ),
              SizedBox(height: ShadcnTheme.of(context).spacing.lg),
              _label('validation', colors),
              SizedBox(height: ShadcnTheme.of(context).spacing.sm),
              TextArea(
                initialValue: 'abc',
                minLines: 2,
                validator: (String? value) =>
                    (value ?? '').length < 8 ? 'At least 8 characters' : null,
                onChanged: (String value) => setState(() => _code = value),
              ),
              SizedBox(height: ShadcnTheme.of(context).spacing.sm),
              Text(
                'typed: ${_code.isEmpty ? '(empty)' : _code}',
                style: TextStyle(color: colors.mutedForeground),
              ),
              SizedBox(height: ShadcnTheme.of(context).spacing.lg),
              _label('disabled', colors),
              SizedBox(height: ShadcnTheme.of(context).spacing.sm),
              const TextArea(initialValue: 'Disabled', enabled: false),
              SizedBox(height: ShadcnTheme.of(context).spacing.lg),
              _label('dark tokens', colors),
              SizedBox(height: ShadcnTheme.of(context).spacing.sm),
              ShadcnTheme(
                data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
                child: const TextArea(
                  placeholder: Text('Dark surface'),
                  minLines: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text, ShadcnColors colors) =>
      Text(text, style: TextStyle(color: colors.mutedForeground));
}
