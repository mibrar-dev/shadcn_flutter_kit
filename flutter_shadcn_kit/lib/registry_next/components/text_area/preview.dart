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
              const SizedBox(height: 8),
              const TextArea(initialValue: 'Hello, World!'),
              const SizedBox(height: 16),
              _label('placeholder, six lines', colors),
              const SizedBox(height: 8),
              const TextArea(
                placeholder: Text('Type your message here...'),
                minLines: 6,
              ),
              const SizedBox(height: 16),
              _label('grows with the content', colors),
              const SizedBox(height: 8),
              TextArea(
                hintText: 'No cap: paste a long paragraph',
                minLines: 2,
                maxLines: 8,
              ),
              const SizedBox(height: 16),
              _label('validation', colors),
              const SizedBox(height: 8),
              TextArea(
                initialValue: 'abc',
                minLines: 2,
                validator: (String? value) =>
                    (value ?? '').length < 8 ? 'At least 8 characters' : null,
                onChanged: (String value) => setState(() => _code = value),
              ),
              const SizedBox(height: 8),
              Text(
                'typed: ${_code.isEmpty ? '(empty)' : _code}',
                style: TextStyle(color: colors.mutedForeground),
              ),
              const SizedBox(height: 16),
              _label('disabled', colors),
              const SizedBox(height: 8),
              const TextArea(initialValue: 'Disabled', enabled: false),
              const SizedBox(height: 16),
              _label('dark tokens', colors),
              const SizedBox(height: 8),
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
