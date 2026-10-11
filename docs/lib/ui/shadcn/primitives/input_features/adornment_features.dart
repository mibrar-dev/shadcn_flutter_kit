// Adornment features: affixes, above/below widgets, clear/copy/paste, hint,
// password peek and revalidate, plus their intents and action map.

import 'package:flutter/services.dart' show Clipboard, LogicalKeyboardKey;
import 'package:flutter/widgets.dart';

import '../../foundation/icons/lucide_icons.dart';
import '../popover_controller.dart';
import '../text_editing/editable_text_host.dart';
import 'input_features.dart';

/// Adds a widget before the editable text.
class InputLeadingFeature extends InputFeature {
  /// Creates a leading feature.
  const InputLeadingFeature(this.prefix, {super.visibility});

  /// The widget shown before the editable text.
  final Widget prefix;

  @override
  Iterable<Widget> buildLeading(
    InputFeatureState state,
    BuildContext context,
  ) sync* {
    yield prefix;
  }
}

/// Adds a widget after the editable text.
class InputTrailingFeature extends InputFeature {
  /// Creates a trailing feature.
  const InputTrailingFeature(this.suffix, {super.visibility});

  /// The widget shown after the editable text.
  final Widget suffix;

  @override
  Iterable<Widget> buildTrailing(
    InputFeatureState state,
    BuildContext context,
  ) sync* {
    yield suffix;
  }
}

/// Adds a widget above or below the decorated field.
class InputAboveBelowFeature extends InputFeature {
  /// Creates an above/below feature; defaults to below.
  const InputAboveBelowFeature({
    super.visibility,
    this.child,
    this.position = InputFeaturePosition.below,
  });

  /// Creates an above feature.
  const InputAboveBelowFeature.above(this.child, {super.visibility})
    : position = InputFeaturePosition.above;

  /// Creates a below feature.
  const InputAboveBelowFeature.below(this.child, {super.visibility})
    : position = InputFeaturePosition.below;

  /// The widget shown above/below the field.
  final Widget? child;

  /// Where [child] is placed.
  final InputFeaturePosition position;

  @override
  Widget wrap(InputFeatureState state, Widget child) {
    final extra = this.child;
    if (extra == null) {
      return child;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (position == InputFeaturePosition.above) extra,
        child,
        if (position != InputFeaturePosition.above) extra,
      ],
    );
  }
}

/// Clears the field text.
class InputClearFeature extends InputIconFeature {
  /// Creates a clear button; trailing, shown while text is not empty.
  const InputClearFeature({
    super.position,
    super.visibility = InputFeatureVisibility.textNotEmpty,
    this.icon,
  });

  /// Custom icon; defaults to `LucideIcons.x`.
  final Widget? icon;

  @override
  Widget buildIcon(BuildContext context) => icon ?? const Icon(LucideIcons.x);

  @override
  void onPressed(InputFeatureState state, BuildContext context) =>
      Actions.invoke(context, const InputClearIntent());
}

/// Selects all text and copies it to the clipboard.
class InputCopyFeature extends InputIconFeature {
  /// Creates a copy button; trailing, shown while text is not empty.
  const InputCopyFeature({
    super.position,
    super.visibility = InputFeatureVisibility.textNotEmpty,
    this.icon,
  });

  /// Custom icon; defaults to `LucideIcons.copy`.
  final Widget? icon;

  @override
  Widget buildIcon(BuildContext context) =>
      icon ?? const Icon(LucideIcons.copy);

  @override
  void onPressed(InputFeatureState state, BuildContext context) =>
      Actions.invoke(context, const InputSelectAllAndCopyIntent());
}

/// Appends clipboard text at the end of the field.
class InputPasteFeature extends InputIconFeature {
  /// Creates a paste button.
  const InputPasteFeature({super.position, super.visibility, this.icon});

  /// Custom icon; defaults to `LucideIcons.clipboard`.
  final Widget? icon;

  @override
  Widget buildIcon(BuildContext context) =>
      icon ?? const Icon(LucideIcons.clipboard);

  @override
  void onPressed(InputFeatureState state, BuildContext context) {
    Clipboard.getData('text/plain').then((data) {
      final text = data?.text;
      if (text == null || text.isEmpty || !state.mounted) {
        return;
      }
      if (!context.mounted) {
        return;
      }
      Actions.invoke(context, InputAppendTextIntent(text));
    });
  }
}

/// Shows a hint popover, optionally bound to F1.
class InputHintFeature extends InputIconFeature {
  /// Creates a hint button.
  const InputHintFeature({
    required this.popupBuilder,
    super.position,
    super.visibility,
    this.icon,
    this.enableShortcuts = true,
  });

  /// Builds the hint popover content.
  final WidgetBuilder popupBuilder;

  /// Custom icon; defaults to `LucideIcons.info`.
  final Widget? icon;

  /// Whether F1 opens the hint.
  final bool enableShortcuts;

  @override
  Widget buildIcon(BuildContext context) =>
      icon ?? const Icon(LucideIcons.info);

  @override
  void onPressed(InputFeatureState state, BuildContext context) =>
      _show(state, context);

  void _show(InputFeatureState state, BuildContext context) {
    state
        .slot(this, PopoverController.new)
        .show<void>(
          context: context,
          builder: popupBuilder,
          alignment: AlignmentDirectional.topCenter,
          anchorAlignment: AlignmentDirectional.bottomCenter,
        );
  }

  @override
  Iterable<MapEntry<ShortcutActivator, Intent>> buildShortcuts(
    InputFeatureState state,
  ) sync* {
    if (enableShortcuts) {
      yield const MapEntry<ShortcutActivator, Intent>(
        SingleActivator(LogicalKeyboardKey.f1),
        InputShowHintIntent(),
      );
    }
  }

  @override
  Iterable<MapEntry<Type, Action<Intent>>> buildActions(
    InputFeatureState state,
  ) sync* {
    if (enableShortcuts) {
      yield MapEntry<Type, Action<Intent>>(
        InputShowHintIntent,
        CallbackAction<InputShowHintIntent>(
          onInvoke: (intent) {
            _show(state, state.featureContext);
            return null;
          },
        ),
      );
    }
  }

  @override
  void dispose(InputFeatureState state) {
    state.slot<PopoverController>(this, PopoverController.new).dispose();
  }
}

/// How the password toggle behaves while pressed.
enum PasswordPeekMode {
  /// Show the password only while the button is held down.
  hold,

  /// Toggle password visibility on each press.
  toggle,
}

/// Toggles between obscured and plain text.
class InputPasswordToggleFeature extends InputIconFeature {
  /// Creates a password toggle button.
  const InputPasswordToggleFeature({
    super.position,
    super.visibility,
    this.mode = PasswordPeekMode.toggle,
    this.icon,
    this.iconShow,
  });

  /// Hold-to-peek or toggle behaviour.
  final PasswordPeekMode mode;

  /// Icon while the text is hidden; defaults to `LucideIcons.eye`.
  final Widget? icon;

  /// Icon while the text is shown; defaults to `LucideIcons.eyeOff`.
  final Widget? iconShow;

  @override
  Widget buildIcon(BuildContext context) => icon ?? const Icon(LucideIcons.eye);

  @override
  void onPressed(InputFeatureState state, BuildContext context) {}

  @override
  Widget buildButton(InputFeatureState state, BuildContext context) {
    final hidden = state.obscureText;
    final resolved = hidden
        ? (icon ?? const Icon(LucideIcons.eye))
        : (iconShow ?? const Icon(LucideIcons.eyeOff));
    if (mode == PasswordPeekMode.hold) {
      return InputFeatureIconButton(
        icon: resolved,
        onTapDown: (_) => state.setObscureText(false),
        onTapUp: (_) => state.setObscureText(true),
        onTapCancel: () => state.setObscureText(true),
      );
    }
    return InputFeatureIconButton(
      icon: resolved,
      onPressed: () => state.setObscureText(!hidden),
    );
  }
}

/// Re-runs the input's validator immediately.
class InputRevalidateFeature extends InputIconFeature {
  /// Creates a revalidate button.
  const InputRevalidateFeature({super.position, super.visibility, this.icon});

  /// Custom icon; defaults to `LucideIcons.refreshCw`.
  final Widget? icon;

  @override
  Widget buildIcon(BuildContext context) =>
      icon ?? const Icon(LucideIcons.refreshCw);

  @override
  void onPressed(InputFeatureState state, BuildContext context) =>
      state.validateNow();
}

// ---------------------------------------------------------------------------
// Intents and the default action map.
// ---------------------------------------------------------------------------

/// Clears the field text.
class InputClearIntent extends Intent {
  /// Creates an [InputClearIntent].
  const InputClearIntent();
}

/// Appends [text] at the end of the field and moves the caret after it.
class InputAppendTextIntent extends Intent {
  /// Creates an [InputAppendTextIntent] carrying [text].
  const InputAppendTextIntent(this.text);

  /// Text to append.
  final String text;
}

/// Selects everything and copies it to the clipboard.
class InputSelectAllAndCopyIntent extends Intent {
  /// Creates an [InputSelectAllAndCopyIntent].
  const InputSelectAllAndCopyIntent();
}

/// Shows the hint popover.
class InputShowHintIntent extends Intent {
  /// Creates an [InputShowHintIntent].
  const InputShowHintIntent();
}

/// The base action map every field with these features should install.
Map<Type, Action<Intent>> buildInputActions(EditableTextHost host) {
  return <Type, Action<Intent>>{
    InputClearIntent: CallbackAction<InputClearIntent>(
      onInvoke: (intent) {
        host.clear();
        return null;
      },
    ),
    InputAppendTextIntent: CallbackAction<InputAppendTextIntent>(
      onInvoke: (intent) {
        host.appendText(intent.text);
        return null;
      },
    ),
    InputSelectAllAndCopyIntent: CallbackAction<InputSelectAllAndCopyIntent>(
      onInvoke: (intent) {
        host.selectAllAndCopy();
        return null;
      },
    ),
  };
}
