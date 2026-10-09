// The `chip_input` component: [ChipInput], a text field whose tokens render as
// `chip` widgets inside the editable text.
//
// A composition, not a re-implementation: the field is the `input` component's
// `Input`, each token is a [Chip], suggestions come from `autocomplete`, and the
// value model lives in `primitives/text_editing/token_editing.dart`. Ported from
// `components/form/chip_input/**` (1,649 LOC, 8 `part` files, a Material
// `TextField` subclass); README.md lists the fixed defects.

import 'dart:async';

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/form_core/form_core.dart';
import '../../primitives/form_core/form_value.dart';
import '../../primitives/input_features/input_features.dart';
import '../../primitives/localizations/localizations.dart';
import '../../primitives/text_editing/token_editing.dart';
import '../../theme/theme.dart';
import '../autocomplete/autocomplete.dart';
import '../chip/chip.dart';
import '../input/input.dart';
import 'chip_input_style.dart';

export 'chip_input_style.dart';

/// Builds the content of one token chip; [index] is its position in
/// [ChipInput.chips], so a builder can remove *that* chip when values repeat.
typedef ChipBuilder<T> = Widget Function(BuildContext, T, int);

/// Converts the word at the caret into a chip value; null rejects it.
typedef ChipSubmitCallback<T> = T? Function(String text);

/// Turns the word at the caret into a chip; bound to <kbd>Enter</kbd>.
class ChipSubmitIntent extends Intent {
  /// Creates a chip-submit intent.
  const ChipSubmitIntent();
}

/// A token field: text typed next to [chip] widgets, each with its own remove
/// button.
///
/// Two modes, like `Toggle`: uncontrolled with a [TokenEditingController], or
/// controlled with [chips] + [onChipsChanged].
///
/// ```dart
/// ChipInput<String>(onChipSubmit: (t) => t.toLowerCase(), initialChips: ['a']);
/// ```
class ChipInput<T> extends StatefulWidget {
  /// Creates a chip input.
  const ChipInput({
    super.key,
    this.controller,
    this.initialChips,
    this.chips,
    this.onChipsChanged,
    required this.onChipSubmit,
    this.chipBuilder,
    this.suggestions,
    this.features = const <InputFeature>[],
    this.clipboardHandler,
    this.hintText,
    this.focusNode,
    this.keyboardType,
    this.enabled = true,
    this.readOnly = false,
    this.validator,
    this.autovalidateMode = FormValidationMode.changed,
    this.theme,
    this.inputTheme,
  });

  /// Owns the field text and its tokens; created and disposed here when null.
  final TokenEditingController<T>? controller;

  /// Chips an uncontrolled field starts with; ignored in controlled mode.
  final List<T>? initialChips;

  /// Controlled mode: the chips to render.
  final List<T>? chips;

  /// Called with the new chip list whenever it changes.
  final ValueChanged<List<T>>? onChipsChanged;

  /// Converts the word at the caret into a chip; null rejects it.
  final ChipSubmitCallback<T> onChipSubmit;

  /// Builds each chip's content; defaults to a `Text` of the value.
  final ChipBuilder<T>? chipBuilder;

  /// Suggestions for the current word; an accepted one becomes a chip.
  final SuggestionBuilder? suggestions;

  /// Extra input features, installed before the field's own key bindings.
  final List<InputFeature> features;

  /// Chip clipboard serialization; defaults to [PlainTokenClipboardHandler].
  final TokenClipboardHandler<T>? clipboardHandler;

  /// Hint shown while the field is empty.
  final String? hintText;

  /// Focus node of the field.
  final FocusNode? focusNode;

  /// Keyboard type of the field; the keyboard action is always `done`.
  final TextInputType? keyboardType;

  /// Whether the field accepts input; a disabled field is dimmed to 50%.
  final bool enabled;

  /// Whether the text and the chips can be edited.
  final bool readOnly;

  /// Validates the chip list; a non-null result paints a destructive border
  /// and shows the message below the field.
  final String? Function(List<T> chips)? validator;

  /// When [validator] runs.
  final FormValidationMode autovalidateMode;

  /// Widget-leg token overrides, merged over the other legs.
  final ChipInputTheme? theme;

  /// Widget-leg overrides for the field surface itself.
  final InputTheme? inputTheme;

  @override
  State<ChipInput<T>> createState() => _ChipInputState<T>();
}

class _ChipInputState<T> extends State<ChipInput<T>>
    with FormValueSupplier<List<T>, ChipInput<T>> {
  late TokenEditingController<T> _controller;
  late final _ChipInputFeature<T> _chipFeature;
  bool _ownsController = false;
  List<T>? _reported;

  /// Resolved each build: the token builder runs while `EditableText` paints,
  /// where an inherited-widget lookup throws, so both are captured here.
  ChipInputTheme _style = chipInputDefaults;
  String _removeLabel = '';

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? _createController();
    _controller.addListener(_handleControllerChanged);
    _chipFeature = _ChipInputFeature<T>(onSubmit: _submitWord);
    _reported = _controller.tokens;
    formValue = _reported;
  }

  TokenEditingController<T> _createController() {
    _ownsController = true;
    return TokenEditingController<T>(
      initialTokens: widget.chips ?? widget.initialChips,
      tokenBuilder: _buildChip,
    );
  }

  @override
  void didUpdateWidget(covariant ChipInput<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_handleControllerChanged);
      if (_ownsController) {
        _controller.dispose();
      }
      _ownsController = false;
      _controller = widget.controller ?? _createController();
      _controller.addListener(_handleControllerChanged);
      _reported = null;
    }
    // A controlled list always wins over whatever the field is holding.
    if (widget.chips case final List<T> incoming
        when !listEquals(incoming, _controller.tokens)) {
      _controller.tokens = incoming;
    }
    _reported ??= _controller.tokens;
    formValue = _controller.tokens;
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleControllerChanged() {
    final List<T> chips = _controller.tokens;
    if (listEquals(_reported, chips)) {
      return;
    }
    _reported = chips;
    formValue = chips;
    widget.onChipsChanged?.call(chips);
  }

  void _submitWord(String text) =>
      _controller.submitTokenAtCursor((_) => widget.onChipSubmit(text));

  Widget _buildChip(BuildContext context, T chip, int index) {
    final ChipInputTheme style = _style;
    final bool removable =
        (style.removable ?? chipInputDefaults.removable!) &&
        !widget.readOnly &&
        widget.enabled;
    final Widget content =
        widget.chipBuilder?.call(context, chip, index) ?? Text('$chip');
    if (!removable) {
      // Still a chip: `removable` only drops the button, never the token look.
      return Chip(theme: style.chipTheme, child: content);
    }
    return Chip(
      theme: style.chipTheme,
      trailing: ChipButton(
        iconSize: style.chipIconSize ?? chipInputDefaultChipIconSize,
        onPressed: () => _controller.removeTokenAt(index),
        child: Icon(LucideIcons.x, semanticLabel: _removeLabel),
      ),
      child: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ChipInputTheme style =
        resolveComponentStyle<ChipInputTheme, ChipInputTheme>(
          context,
          widget: widget.theme,
          select: (t) => t,
          defaults: chipInputDefaults,
        );
    _style = style;
    _removeLabel = ShadcnLocalizations.of(context).chipInputRemoveChip;
    _controller.spacing = style.spacing ?? chipInputDefaultSpacing;
    _controller.alignment = style.alignment ?? PlaceholderAlignment.middle;
    return Input(
      controller: _controller,
      focusNode: widget.focusNode,
      hintText: widget.hintText,
      keyboardType: widget.keyboardType,
      // The keyboard action submits the typed word as a chip.
      textInputAction: TextInputAction.done,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      features: _features(),
      validator: widget.validator == null
          ? null
          : (_) => widget.validator!(_controller.tokens),
      autovalidateMode: widget.autovalidateMode,
      theme: widget.inputTheme,
    );
  }

  List<InputFeature> _features() {
    final bool editable = widget.enabled && !widget.readOnly;
    _chipFeature.handler =
        widget.clipboardHandler ??
        // The widget's own converter reads pasted pieces back as chips, so a
        // copied `ab, cd` round-trips to two chips instead of one string.
        PlainTokenClipboardHandler<T>(chipDeserializer: widget.onChipSubmit);
    _chipFeature.editable = editable;
    return <InputFeature>[
      ...widget.features,
      if (widget.suggestions case final SuggestionBuilder suggestions)
        AutoCompleteFeature(
          suggestions: suggestions,
          mode: AutoCompleteMode.replaceWord,
          onSuggestionSelected: _submitWord,
        ),
      _chipFeature,
    ];
  }

  @override
  void didReplaceFormValue(List<T> value) {
    _controller.tokens = value;
    widget.onChipsChanged?.call(_controller.tokens);
  }
}

/// The field's own key bindings, registered last so they win: <kbd>Enter</kbd>
/// submits the word at the caret as a chip, copy/cut/paste move chips.
class _ChipInputFeature<T> extends InputFeature {
  _ChipInputFeature({required this.onSubmit});

  final void Function(String word) onSubmit;

  /// Clipboard serialization, and whether copy/cut/paste may edit the field.
  /// Both are assigned every build.
  late TokenClipboardHandler<T> handler;
  late bool editable;

  /// A context below the field's `Actions`, so [ChipSubmitIntent] can reach
  /// the suggestion list. A feature's own context sits *above* that scope.
  BuildContext? fieldContext;

  @override
  Widget wrap(InputFeatureState state, Widget child) => Builder(
    builder: (BuildContext context) {
      fieldContext = context;
      return child;
    },
  );

  @override
  Iterable<MapEntry<ShortcutActivator, Intent>> buildShortcuts(
    InputFeatureState state,
  ) sync* {
    yield const MapEntry(
      SingleActivator(LogicalKeyboardKey.enter),
      ChipSubmitIntent(),
    );
  }

  @override
  Iterable<MapEntry<Type, Action<Intent>>> buildActions(
    InputFeatureState state,
  ) sync* {
    yield _action<CopySelectionTextIntent>(
      CopySelectionTextIntent.copy,
      (CopySelectionTextIntent intent) =>
          _copy(state, intent.collapseSelection),
    );
    yield _action<PasteTextIntent>(
      const PasteTextIntent(SelectionChangedCause.keyboard),
      (_) => _paste(state),
    );
    if (!editable) {
      return;
    }
    yield _action<ChipSubmitIntent>(ChipSubmitIntent(), (_) => _accept(state));
  }

  static MapEntry<Type, Action<Intent>> _action<I extends Intent>(
    I intent,
    void Function(I intent) run,
  ) => MapEntry<Type, Action<Intent>>(
    I,
    CallbackAction<I>(
      onInvoke: (I value) {
        run(value);
        return null;
      },
    ),
  );

  TokenEditingController<T> _of(InputFeatureState state) =>
      state.controller as TokenEditingController<T>;

  void _accept(InputFeatureState state) {
    // An open suggestion list takes Enter first: accepting writes the completed
    // word into the field, whose `onSuggestionSelected` makes it a chip.
    final BuildContext? field = fieldContext;
    if (field != null && field.mounted) {
      Actions.maybeInvoke<AutoCompleteAcceptIntent>(
        field,
        const AutoCompleteAcceptIntent(),
      );
    }
    final String word = _of(state).textAtCursor;
    if (word.isNotEmpty) {
      onSubmit(word);
    }
  }

  void _copy(InputFeatureState state, bool collapseSelection) {
    final TokenEditingController<T> controller = _of(state);
    final TextSelection selection = controller.selection;
    if (!selection.isValid || selection.isCollapsed) {
      return;
    }
    unawaited(copyTokenClipboard(handler, controller.fragmentsIn(selection)));
    if (collapseSelection && editable) {
      controller.replaceSelectionWith(const <Never>[]);
    }
  }

  void _paste(InputFeatureState state) {
    // Consumed even when read-only: the field's own paste inserts raw text.
    if (!editable) return;
    unawaited(
      pasteTokenClipboard<T>(handler).then((List<TokenFragment<T>>? list) {
        if (list == null || !state.mounted) {
          return;
        }
        _of(state).replaceSelectionWith(list);
      }, onError: (Object _) {}),
    );
  }
}
