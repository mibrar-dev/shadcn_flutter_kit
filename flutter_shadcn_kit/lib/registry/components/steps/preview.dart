// Gallery preview for the `steps` component: the default vertical flow,
// a custom indicator theme, a single step and the dark palette.
// Widgets-only; the docs app embeds [StepsPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'steps.dart';

/// Renders the steps gallery.
class StepsPreview extends StatelessWidget {
  /// Creates the preview.
  const StepsPreview({super.key});

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
                _section(context, 'Default', _flow()),
                Gap(theme.spacing.xl),
                _section(context, 'Custom indicators', _custom()),
                Gap(theme.spacing.xl),
                _section(context, 'Single step', _single()),
                Gap(theme.spacing.xl),
                _section(context, 'Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _flow() {
    return Steps(
      children: <Widget>[
        StepItem(
          title: const Text('Account'),
          content: const <Widget>[Text('Sign up with your email address.')],
        ),
        StepItem(
          title: const Text('Verify'),
          content: const <Widget>[Text('Check your inbox for a code.')],
        ),
        StepItem(
          title: const Text('Profile'),
          content: const <Widget>[Text('Add your personal information.')],
        ),
      ],
    );
  }

  Widget _custom() {
    return const Steps(
      theme: StepsTheme(
        indicatorSize: 32,
        indicatorColor: ThemedColor.ref(ColorRef.primary),
        indicatorForeground: ThemedColor.ref(ColorRef.primaryForeground),
        connectorColor: ThemedColor.ref(ColorRef.primary, alpha: 0.4),
      ),
      children: <Widget>[
        StepItem(title: Text('Cart'), content: <Widget>[Text('Review items.')]),
        StepItem(
          title: Text('Pay'),
          content: <Widget>[Text('Choose a method.')],
        ),
      ],
    );
  }

  Widget _single() {
    return const Steps(
      children: <Widget>[
        StepItem(title: Text('Done'), content: <Widget>[Text('Nothing else.')]),
      ],
    );
  }

  Widget _dark() {
    return const ShadcnTheme(
      data: ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: Steps(
        children: <Widget>[
          StepItem(title: Text('Draft'), content: <Widget>[Text('Editing.')]),
          StepItem(title: Text('Publish'), content: <Widget>[Text('Live.')]),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Gap(ShadcnTheme.of(context).spacing.sm),
        child,
      ],
    );
  }
}
