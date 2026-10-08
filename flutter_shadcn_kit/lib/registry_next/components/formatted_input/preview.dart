// Gallery preview for the `formatted_input` component: a phone field, a date
// field, the controlled mode, the disabled state and a validation error.
// Widgets-only; the docs app embeds [FormattedInputPreview] directly.

import 'package:flutter/widgets.dart';

import '../../components/icon/icon.dart';
import '../../primitives/form_core/form_core.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'formatted_input.dart';

/// A `(555) 123-4567` phone field in controlled mode.
class PhonePreview extends StatefulWidget {
  /// Creates the preview.
  const PhonePreview({super.key});

  @override
  State<PhonePreview> createState() => _PhonePreviewState();
}

class _PhonePreviewState extends State<PhonePreview> {
  SegmentedValue? _value;

  @override
  Widget build(BuildContext context) {
    return FormattedInput(
      leading: const Icon(LucideIcons.phone).iconSmall(),
      value: _value,
      onChanged: (SegmentedValue value) => setState(() => _value = value),
      initialValue: const SegmentedValue(<SegmentPart>[
        SegmentPart.editable(length: 3, width: 32, placeholder: Text('555')),
        SegmentPart.separator(' ('),
        SegmentPart.editable(length: 3, width: 32, placeholder: Text('123')),
        SegmentPart.separator(') '),
        SegmentPart.editable(length: 4, width: 36, placeholder: Text('4567')),
      ]),
    );
  }
}

/// The same field driven by a [FormattedInputController].
class PhoneControllerPreview extends StatefulWidget {
  /// Creates the preview.
  const PhoneControllerPreview({super.key});

  @override
  State<PhoneControllerPreview> createState() => _PhoneControllerPreviewState();
}

class _PhoneControllerPreviewState extends State<PhoneControllerPreview> {
  final FormattedInputController _controller = FormattedInputController(
    const SegmentedValue(<SegmentPart>[
      SegmentPart.editable(value: '555', length: 3, width: 32),
      SegmentPart.separator('-'),
      SegmentPart.editable(value: '0100', length: 4, width: 36),
    ]),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FormattedInput(controller: _controller),
        const Gap(8),
        Text(_controller.value.text),
      ],
    );
  }
}

/// A field that reports a validation error while incomplete.
class DatePreview extends StatelessWidget {
  /// Creates the preview.
  const DatePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return FormattedInput(
      initialValue: const SegmentedValue(<SegmentPart>[
        SegmentPart.editable(length: 2, width: 28, placeholder: Text('MM')),
        SegmentPart.separator('/'),
        SegmentPart.editable(length: 2, width: 28, placeholder: Text('DD')),
        SegmentPart.separator('/'),
        SegmentPart.editable(length: 4, width: 36, placeholder: Text('YYYY')),
      ]),
      validator: _validate,
      autovalidateMode: FormValidationMode.changed,
    );
  }

  static String? _validate(String? text) {
    final String value = text ?? '';
    if (value.length == 8) {
      return null;
    }
    return 'Enter a full date (MM/DD/YYYY).';
  }
}

/// Renders the formatted input gallery.
class FormattedInputPreview extends StatelessWidget {
  /// Creates the preview.
  const FormattedInputPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section('Phone', const PhoneControllerPreview()),
                const Gap(24),
                _section('With a leading icon', const PhonePreview()),
                const Gap(24),
                _section('Date + validation', const DatePreview()),
                const Gap(24),
                _section('Disabled', const FormattedInput(enabled: false)),
                const Gap(24),
                _section(
                  'Dark',
                  ShadcnTheme(
                    data: const ShadcnThemeData(
                      colors: ShadcnColors.darkFallback,
                    ),
                    child: const DatePreview(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const Gap(8),
        child,
      ],
    );
  }
}
