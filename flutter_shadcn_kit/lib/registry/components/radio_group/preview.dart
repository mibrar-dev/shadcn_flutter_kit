// Gallery preview for the `radio_group` component: rows and cards, controlled
// and controller-driven, a horizontal group, disabled items and dark.
// Widgets-only; the docs app embeds [RadioGroupPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'radio_group.dart';

/// Renders the radio-group gallery.
class RadioGroupPreview extends StatefulWidget {
  /// Creates the preview.
  const RadioGroupPreview({super.key});

  @override
  State<RadioGroupPreview> createState() => _RadioGroupPreviewState();
}

class _RadioGroupPreviewState extends State<RadioGroupPreview> {
  final ShadcnRadioGroupController<String> _controller =
      ShadcnRadioGroupController<String>('pro');
  String _plan = 'free';
  String _size = 'm';

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
                _section('Rows', _rows()),
                const Gap(24),
                _section('Horizontal', _horizontal()),
                const Gap(24),
                _section('Cards', _cards()),
                const Gap(24),
                _section('Controller', _controllerGroup()),
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

  Widget _rows() {
    return ShadcnRadioGroup<String>(
      value: _plan,
      onChanged: (String value) => setState(() => _plan = value),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          RadioItem<String>(value: 'free', label: Text('Free')),
          RadioItem<String>(value: 'pro', label: Text('Pro')),
          RadioItem<String>(value: 'team', label: Text('Team')),
        ],
      ),
    );
  }

  Widget _horizontal() {
    return ShadcnRadioGroup<String>(
      value: _size,
      direction: Axis.horizontal,
      onChanged: (String value) => setState(() => _size = value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const <Widget>[
          RadioItem<String>(value: 's', label: Text('S')),
          RadioItem<String>(value: 'm', label: Text('M')),
          RadioItem<String>(value: 'l', label: Text('L')),
        ],
      ),
    );
  }

  Widget _cards() {
    return ShadcnRadioGroup<String>(
      value: _plan,
      onChanged: (String value) => setState(() => _plan = value),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final String plan in <String>['free', 'pro'])
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RadioCard<String>(
                value: plan,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      plan,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Gap(4),
                    Text('${plan[0].toUpperCase()}${plan.substring(1)} plan'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _controllerGroup() {
    return ShadcnRadioGroup<String>(
      controller: _controller,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (final String plan in <String>['free', 'pro'])
            RadioItem<String>(value: plan, label: Text(plan)),
        ],
      ),
    );
  }

  Widget _disabled() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RadioItem<String>(value: 'a', label: Text('enabled')),
        RadioItem<String>(
          value: 'b',
          label: Text('disabled item'),
          enabled: false,
        ),
        RadioItem<String>(
          value: 'c',
          label: Text('another one'),
          enabled: false,
        ),
      ],
    );
  }

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: ColoredBox(
        color: ShadcnColors.darkFallback.background,
        child: ShadcnRadioGroup<String>(
          value: 'pro',
          onChanged: (String _) {},
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RadioItem<String>(value: 'free', label: Text('free')),
              RadioItem<String>(value: 'pro', label: Text('pro')),
            ],
          ),
        ),
      ),
    );
  }

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
