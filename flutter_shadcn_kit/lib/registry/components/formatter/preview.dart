// Gallery preview for the `formatter` component: the input formatters
// exercised on live editable text, light and dark.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'formatter.dart';

/// Renders the formatter gallery.
class FormatterPreview extends StatelessWidget {
  /// Creates the preview.
  const FormatterPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('integerOnly (0–100)'),
                Gap(theme.spacing.xs),
                _Line(
                  formatters: <TextInputFormatter>[
                    TextInputFormatters.integerOnly(min: 0, max: 100),
                  ],
                ),
                Gap(theme.spacing.md),
                const Text('hex (# prefixed)'),
                Gap(theme.spacing.xs),
                _Line(
                  formatters: <TextInputFormatter>[
                    TextInputFormatters.hex(hashPrefix: true),
                  ],
                ),
                Gap(theme.spacing.md),
                const Text('time (length 2)'),
                Gap(theme.spacing.xs),
                _Line(
                  formatters: <TextInputFormatter>[
                    TextInputFormatters.time(length: 2),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Line extends StatefulWidget {
  const _Line({required this.formatters});

  final List<TextInputFormatter> formatters;

  @override
  State<_Line> createState() => _LineState();
}

class _LineState extends State<_Line> {
  final TextEditingController _controller = TextEditingController();
  late final FocusNode _focusNode = FocusNode(debugLabel: 'FormatterPreview');

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: EditableText(
        controller: _controller,
        focusNode: _focusNode,
        style: TextStyle(color: theme.colors.foreground, fontSize: 14),
        cursorColor: theme.colors.foreground,
        backgroundCursorColor: const Color(0x00000000),
        inputFormatters: widget.formatters,
      ),
    );
  }
}
