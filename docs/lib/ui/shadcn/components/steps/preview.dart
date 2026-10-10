// Named examples for the `steps` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../theme/color_tokens.dart';
import 'steps.dart';

/// The default vertical flow.
Widget _default(BuildContext context) {
  return const Steps(
    children: <Widget>[
      StepItem(
        title: Text('Account'),
        content: <Widget>[Text('Sign up with your email address.')],
      ),
      StepItem(
        title: Text('Verify'),
        content: <Widget>[Text('Check your inbox for a code.')],
      ),
      StepItem(
        title: Text('Profile'),
        content: <Widget>[Text('Add your personal information.')],
      ),
    ],
  );
}

/// Larger indicators tinted with the primary token.
Widget _custom(BuildContext context) {
  return const Steps(
    theme: StepsTheme(
      indicatorSize: 32,
      indicatorColor: ThemedColor.ref(ColorRef.primary),
      indicatorForeground: ThemedColor.ref(ColorRef.primaryForeground),
      connectorColor: ThemedColor.ref(ColorRef.primary, alpha: 0.4),
    ),
    children: <Widget>[
      StepItem(title: Text('Cart'), content: <Widget>[Text('Review items.')]),
      StepItem(title: Text('Pay'), content: <Widget>[Text('Choose a method.')]),
    ],
  );
}

/// A single step.
Widget _single(BuildContext context) {
  return const Steps(
    children: <Widget>[
      StepItem(title: Text('Done'), content: <Widget>[Text('Nothing else.')]),
    ],
  );
}

/// Named docs examples for `steps`; the first entry is the default.
const List<ComponentPreview> stepsPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Custom indicators', _custom),
  ComponentPreview('Single step', _single),
];
