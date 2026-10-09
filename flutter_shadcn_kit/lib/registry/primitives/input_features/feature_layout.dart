// Collects the widgets, actions and shortcuts contributed by the visible
// features of one field.

import 'package:flutter/widgets.dart';

import 'input_features.dart';

/// Widgets/actions/shortcuts contributed by a field's visible features.
class InputFeatureLayout {
  /// Creates a layout slice.
  const InputFeatureLayout({
    required this.leading,
    required this.trailing,
    required this.actions,
    required this.shortcuts,
  });

  /// Leading widgets (focus traversal already applied).
  final List<Widget> leading;

  /// Trailing widgets (focus traversal already applied).
  final List<Widget> trailing;

  /// Actions contributed by features.
  final Map<Type, Action<Intent>> actions;

  /// Shortcuts contributed by features.
  final Map<ShortcutActivator, Intent> shortcuts;
}

/// Collects the contributions of every visible feature.
InputFeatureLayout collectInputFeatures({
  required InputFeatureState state,
  required BuildContext context,
  required List<InputFeature> features,
}) {
  final leading = <Widget>[];
  final trailing = <Widget>[];
  final actions = <Type, Action<Intent>>{};
  final shortcuts = <ShortcutActivator, Intent>{};
  for (final feature in features) {
    if (!feature.visibility.canShow(state)) {
      continue;
    }
    for (final child in feature.buildLeading(state, context)) {
      leading.add(
        Focus(skipTraversal: feature.skipFocusTraversal, child: child),
      );
    }
    for (final child in feature.buildTrailing(state, context)) {
      trailing.add(
        Focus(skipTraversal: feature.skipFocusTraversal, child: child),
      );
    }
    for (final action in feature.buildActions(state)) {
      actions[action.key] = action.value;
    }
    for (final shortcut in feature.buildShortcuts(state)) {
      shortcuts[shortcut.key] = shortcut.value;
    }
  }
  return InputFeatureLayout(
    leading: leading,
    trailing: trailing,
    actions: actions,
    shortcuts: shortcuts,
  );
}
