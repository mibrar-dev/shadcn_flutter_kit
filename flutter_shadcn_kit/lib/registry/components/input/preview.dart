// Widgets-only preview gallery for the `input` component.
//
// Shows the default look, every built-in feature, error/disabled/read-only
// states and a dark-token subtree.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/input_features/adornment_features.dart';
import '../../primitives/input_features/input_features.dart';
import '../../primitives/input_features/numeric_features.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'input.dart';

/// Gallery of [Input] states and features.
class InputPreview extends StatefulWidget {
  /// Creates the preview.
  const InputPreview({super.key});

  @override
  State<InputPreview> createState() => _InputPreviewState();
}

class _InputPreviewState extends State<InputPreview> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(theme.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const _Section('Basic'),
            const Input(hintText: 'Email'),
            const Gap(16),
            const _Section('Features'),
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
            const Gap(16),
            const Input(
              obscureText: true,
              hintText: 'Password',
              features: <InputFeature>[InputPasswordToggleFeature()],
            ),
            const Gap(16),
            const Input(
              keyboardType: TextInputType.number,
              hintText: 'Quantity',
              features: <InputFeature>[InputSpinnerFeature(min: 0, max: 10)],
            ),
            const Gap(16),
            const Input(
              keyboardType: TextInputType.number,
              hintText: 'Guests',
              features: <InputFeature>[
                InputStepperButtonFeature(),
                InputStepperButtonFeature.decrement(),
              ],
            ),
            const Gap(16),
            const _Section('Above / below and hint'),
            const Input(
              hintText: 'With helper rows',
              features: <InputFeature>[
                InputAboveBelowFeature.above(Text('Label')),
                InputAboveBelowFeature.below(Text('Helper text')),
                InputHintFeature(popupBuilder: _hintPopup),
              ],
            ),
            const Gap(16),
            const _Section('Validation, disabled, read-only'),
            Input(
              hintText: 'Invalid while non-empty',
              validator: (value) =>
                  (value ?? '').isEmpty ? null : 'This value is not allowed.',
              features: const <InputFeature>[InputRevalidateFeature()],
            ),
            const Gap(16),
            const Input(hintText: 'Disabled', enabled: false),
            const Gap(16),
            const Input(
              hintText: 'Read-only',
              readOnly: true,
              initialValue: 'Read-only value',
            ),
            const Gap(16),
            const _Section('Multiline'),
            const Input(
              hintText: 'Notes',
              maxLines: 3,
              minLines: 3,
              features: <InputFeature>[InputClearFeature()],
            ),
            const Gap(24),
            _Section('Dark tokens'),
            ShadcnTheme(
              data: theme.copyWith(colors: () => ShadcnColors.darkFallback),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Input(hintText: 'Dark basic'),
                  Gap(16),
                  Input(
                    obscureText: true,
                    hintText: 'Dark password',
                    features: <InputFeature>[InputPasswordToggleFeature()],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.label);

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

Widget _hintPopup(BuildContext context) => const Text('Extra information');
