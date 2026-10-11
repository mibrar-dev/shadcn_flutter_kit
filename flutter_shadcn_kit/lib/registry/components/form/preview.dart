// Named examples for the `form` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Each example
// owns its controller. The fixed width is inherent: the field rows use
// `Expanded`, so the form needs a bounded box.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import '../input/input.dart';
import 'form.dart';

/// A submit flow: one field, a submit button and the result line.
class _DefaultForm extends StatefulWidget {
  const _DefaultForm();

  @override
  State<_DefaultForm> createState() => _DefaultFormState();
}

class _DefaultFormState extends State<_DefaultForm> {
  final FormController _controller = FormController();
  final FormKey<String> _emailKey = const FormKey<String>('email');
  String _result = 'Not submitted';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return SizedBox(
      width: 320,
      child: ShadcnForm(
        controller: _controller,
        onSubmit: (values) =>
            setState(() => _result = 'Submitted ${values.length} value(s)'),
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
            Gap(theme.spacing.lg),
            Button(
              onPressed: () => _controller.submit(context),
              child: const Text('Submit'),
            ),
            Gap(theme.spacing.sm),
            Text(_result),
          ],
        ),
      ),
    );
  }
}

Widget _default(BuildContext context) => const _DefaultForm();

/// A field validating on every change, so the error shows immediately.
class _ValidatingForm extends StatefulWidget {
  const _ValidatingForm();

  @override
  State<_ValidatingForm> createState() => _ValidatingFormState();
}

class _ValidatingFormState extends State<_ValidatingForm> {
  final FormController _controller = FormController();
  final FormKey<String> _emailKey = const FormKey<String>('email');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: ShadcnForm(
        controller: _controller,
        child: ShadcnFormField<String>(
          key: _emailKey,
          label: const Text('Email'),
          validator: const NotEmptyValidator() & const EmailValidator(),
          showErrors: const <FormValidationMode>{FormValidationMode.changed},
          child: const Input(),
        ),
      ),
    );
  }
}

Widget _validating(BuildContext context) => const _ValidatingForm();

/// Named docs examples for `form`; the first entry is the default.
const List<ComponentPreview> formPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Validating', _validating),
];
