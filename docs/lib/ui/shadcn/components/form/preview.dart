// Gallery preview for the `form` component.

import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../button/button.dart';
import '../input/input.dart';
import 'form.dart';

/// Shows the three field layouts, an object field and a submit flow.
class FormPreview extends StatefulWidget {
  /// Creates the preview.
  const FormPreview({super.key});

  @override
  State<FormPreview> createState() => _FormPreviewState();
}

class _FormPreviewState extends State<FormPreview> {
  final FormController _controller = FormController();
  final FormKey<String> _emailKey = const FormKey<String>('email');
  final FormKey<String> _nameKey = const FormKey<String>('name');
  final FormKey<DateTime> _dateKey = const FormKey<DateTime>('date');
  String _result = 'Not submitted';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: EdgeInsets.all(theme.spacing.md),
      child: ShadcnForm(
        controller: _controller,
        onSubmit: (values) => setState(() => _result = 'Submitted: $values'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ShadcnFormField<String>(
              key: _emailKey,
              label: const Text('Email'),
              hint: const Text('We never share it.'),
              validator: const NotEmptyValidator() & const EmailValidator(),
              child: const Input(),
            ),
            SizedBox(height: theme.spacing.md),
            FormInline<String>(
              key: _nameKey,
              label: const Text('Name'),
              validator: const NotEmptyValidator(),
              child: const Input(),
            ),
            SizedBox(height: theme.spacing.md),
            FormTableLayout(
              rows: <ShadcnFormField<Object?>>[
                ShadcnFormField<Object?>(
                  key: _dateKey,
                  label: const Text('Date'),
                  child: ObjectFormField<DateTime>(
                    value: null,
                    onChanged: (_) {},
                    placeholder: const Text('Pick a date'),
                    builder: (context, value) => Text('$value'),
                    editorBuilder: (context, handler) =>
                        const Text('Calendar editor goes here'),
                  ),
                ),
              ],
            ),
            SizedBox(height: theme.spacing.lg),
            Button(
              onPressed: () => _controller.submit(context),
              child: const Text('Submit'),
            ),
            SizedBox(height: theme.spacing.sm),
            Text(_result),
          ],
        ),
      ),
    );
  }
}
