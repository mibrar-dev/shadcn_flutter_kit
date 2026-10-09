// Gallery preview for the `checkbox` component: the three values, a tri-state
// example, the controlled and controller-driven modes, disabled and dark.
// Widgets-only; the docs app embeds [CheckboxPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'checkbox.dart';

/// Renders the checkbox gallery.
class CheckboxPreview extends StatefulWidget {
  /// Creates the preview.
  const CheckboxPreview({super.key});

  @override
  State<CheckboxPreview> createState() => _CheckboxPreviewState();
}

class _CheckboxPreviewState extends State<CheckboxPreview> {
  final CheckboxController _controller = CheckboxController(
    CheckboxValue.indeterminate,
  );
  CheckboxValue _value = CheckboxValue.checked;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                _section('Values', _values()),
                const Gap(24),
                _section('Controlled', _controlled()),
                const Gap(24),
                _section('Tri-state', _tristate()),
                const Gap(24),
                _section('Controller', _controllerRow()),
                const Gap(24),
                _section('Disabled', _disabled()),
                const Gap(24),
                _section('Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _values() {
    return Wrap(
      spacing: 24,
      runSpacing: 12,
      children: <Widget>[
        for (final CheckboxValue value in CheckboxValue.values)
          Checkbox(value: value, onChanged: (_) {}, label: Text(value.name)),
      ],
    );
  }

  Widget _controlled() {
    return Checkbox(
      value: _value,
      tristate: true,
      onChanged: (value) => setState(() => _value = value),
      label: const Text('Airplane mode'),
    );
  }

  Widget _tristate() {
    return Checkbox(
      tristate: true,
      value: CheckboxValue.unchecked,
      onChanged: (_) {},
      label: const Text('Tap cycles unchecked / checked / indeterminate'),
    );
  }

  Widget _controllerRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Checkbox(
          controller: _controller,
          tristate: true,
          label: const Text('Driven by a controller'),
        ),
        const Gap(16),
        Text('value: ${_controller.value.name}'),
      ],
    );
  }

  Widget _disabled() {
    return const Wrap(
      spacing: 24,
      runSpacing: 12,
      children: <Widget>[
        Checkbox(value: CheckboxValue.checked, label: Text('checked')),
        Checkbox(value: CheckboxValue.unchecked, label: Text('unchecked')),
      ],
    );
  }

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: ColoredBox(
        color: ShadcnColors.darkFallback.background,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Wrap(
            spacing: 24,
            runSpacing: 12,
            children: <Widget>[
              Checkbox(
                value: CheckboxValue.checked,
                onChanged: _noop,
                label: Text('checked'),
              ),
              Checkbox(
                value: CheckboxValue.indeterminate,
                onChanged: _noop,
                label: Text('indeterminate'),
              ),
              Checkbox(
                value: CheckboxValue.unchecked,
                onChanged: _noop,
                label: Text('unchecked'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _noop(CheckboxValue value) {}

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(8),
        child,
      ],
    );
  }
}
