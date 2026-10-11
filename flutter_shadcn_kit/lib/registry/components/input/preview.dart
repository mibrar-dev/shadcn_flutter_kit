// Named examples for the `input` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/input_features/adornment_features.dart';
import '../../primitives/input_features/input_features.dart';
import '../../primitives/input_features/numeric_features.dart';
import '../../theme/theme.dart';
import 'input.dart';

/// A small section label above a field.
class _InputSection extends StatelessWidget {
  const _InputSection(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: theme.spacing.xs),
      child: Text(
        label,
        style: theme.typography.small.copyWith(
          color: theme.colors.mutedForeground,
        ),
      ),
    );
  }
}

/// The default email field.
//
// P7-D1b: capped at 400 px so the stage centres it instead of stretching it
// full-bleed.
Widget _inputDefault(BuildContext context) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 400),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        _InputSection('Email'),
        Input(hintText: 'Email'),
      ],
    ),
  );
}

/// A field with a leading icon and the clear/copy features.
class _InputWithIcon extends StatefulWidget {
  const _InputWithIcon();

  @override
  State<_InputWithIcon> createState() => _InputWithIconState();
}

class _InputWithIconState extends State<_InputWithIcon> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Input(
            controller: _controller,
            hintText: 'Type to enable clear/copy',
            features: <InputFeature>[
              InputLeadingFeature(const Icon(LucideIcons.search, size: 16)),
              InputClearFeature(),
              InputCopyFeature(),
              const InputPasteFeature(),
            ],
          ),
          Gap(spacing.lg),
          const Input(
            obscureText: true,
            hintText: 'Password',
            features: <InputFeature>[InputPasswordToggleFeature()],
          ),
          Gap(spacing.lg),
          const Input(
            keyboardType: TextInputType.number,
            hintText: 'Quantity',
            features: <InputFeature>[InputSpinnerFeature(min: 0, max: 10)],
          ),
        ],
      ),
    );
  }
}

/// An invalid field.
Widget _inputInvalid(BuildContext context) {
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 400),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        _InputSection('Invalid'),
        Input(
          hintText: 'Invalid while non-empty',
          validator: _inputNotAllowed,
          features: <InputFeature>[InputRevalidateFeature()],
        ),
        _InputSection('Above / below and hint'),
        Input(
          hintText: 'With helper rows',
          features: <InputFeature>[
            InputAboveBelowFeature.above(Text('Label')),
            InputAboveBelowFeature.below(Text('Helper text')),
            InputHintFeature(popupBuilder: _inputHintPopup),
          ],
        ),
      ],
    ),
  );
}

String? _inputNotAllowed(String? value) =>
    (value ?? '').isEmpty ? null : 'This value is not allowed.';

Widget _inputHintPopup(BuildContext context) => const Text('Extra information');

/// A disabled field beside a read-only one.
Widget _inputDisabled(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 400),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const _InputSection('Disabled'),
        const Input(hintText: 'Disabled', enabled: false),
        Gap(spacing.lg),
        const _InputSection('Read-only'),
        const Input(
          hintText: 'Read-only',
          readOnly: true,
          initialValue: 'Read-only value',
        ),
      ],
    ),
  );
}

Widget _inputWithIconExample(BuildContext context) => const _InputWithIcon();

/// Named docs examples for `input`; the first entry is the default.
const List<ComponentPreview> inputPreviews = <ComponentPreview>[
  ComponentPreview('Default', _inputDefault),
  ComponentPreview('With icon', _inputWithIconExample),
  ComponentPreview('Invalid', _inputInvalid),
  ComponentPreview('Disabled', _inputDisabled),
];
