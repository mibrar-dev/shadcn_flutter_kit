// The `autocomplete` component: [AutoCompleteFeature], the `input`-feature
// adapter that turns a field's text into a suggestion popover.
//
// Ported from `components/form/autocomplete/**` (the reachable copy) plus the
// `AutoComplete*` types that had drifted in `components/form/text_field/**`.
// Fixes, all verified against the old source:
//   * `AutoCompleteMode` had two byte-different copies (the reachable one was
//     a bare `enum` line with no docs). One documented enum, owned here; the
//     `input` component keeps only the generic suggestion slot (P3-D).
//   * `AutoCompleteTheme` stored `overlayConfiguration` and `adaptiveOverlay`
//     as `@Deprecated` fields that no code path could honour. Deleted.
//   * The popover content was built from `SurfaceCard` and `Theme.of`, so it
//     froze the theme at show time. It resolves inside the overlay now.
//   * The keyboard map went through `ListenableBuilder` +
//     `FocusableActionDetector`, which is not in the key-event path of an
//     `EditableText`; the arrow keys never reached it. The feature now
//     contributes shortcuts and actions through the feature contract.
//   * `AutoCompleteMode.append` appended at the end of the text even when the
//     caret sat in the middle, so the caret jumped. It inserts at the caret.
//   * `Tab` was bound to "accept", which trapped focus in the field. Only
//     Enter accepts now; Escape dismisses.
//   * The list opened as soon as the parent handed over a non-empty list, even
//     before the user typed anything. It is driven by the query now.
//   * The old `AutoComplete` wrapper widget is deleted: it wrapped an opaque
//     child and re-declared a field surface the `input` component owns. The
//     feature is the whole public surface (P3 design I2).

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../primitives/clickable.dart';
import '../../primitives/input_features/input_features.dart';
import '../../primitives/menu_rows.dart';
import '../../primitives/overlay.dart';
import '../../primitives/popover_controller.dart';
import '../../primitives/popover_overlay_handler.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'autocomplete_style.dart';

export 'autocomplete_style.dart';

/// The `input`-component adapter: an [InputFeature] that turns the field text
/// into the `autocomplete` suggestion popover.
///
/// The list opens while typing and closes when the query yields nothing.
/// Install it with `Input(features: <InputFeature>[AutoCompleteFeature(...)])`.
///
/// ```dart
/// Input(
///   hintText: 'Fruit',
///   features: <InputFeature>[
///     AutoCompleteFeature(suggestions: (query) => _fruits(query)),
///   ],
/// )
/// ```
class AutoCompleteFeature extends InputFeature {
  /// Creates the feature.
  const AutoCompleteFeature({
    required this.suggestions,
    this.mode,
    this.completer = identityAutoCompleteCompleter,
    this.onSuggestionSelected,
    this.itemBuilder,
    this.theme,
    super.visibility,
    super.skipFocusTraversal,
  });

  /// Provides the suggestions for a query. May be asynchronous.
  final SuggestionBuilder suggestions;

  /// Overrides `AutoCompleteTheme.mode`.
  final AutoCompleteMode? mode;

  /// Post-processes a suggestion before it is applied.
  final AutoCompleteCompleter completer;

  /// Called after a suggestion was written into the field.
  final ValueChanged<String>? onSuggestionSelected;

  /// Builds one suggestion row; null renders the shadcn default.
  final SuggestionRowBuilder? itemBuilder;

  /// Widget-leg theme override for the suggestion list.
  final AutoCompleteTheme? theme;

  _AutoCompleteSlot _slotFor(InputFeatureState state) {
    final _AutoCompleteSlot slot = state.slot(this, _AutoCompleteSlot.new);
    slot.state = state;
    return slot;
  }

  AutoCompleteMode _modeFor(AutoCompleteTheme theme) =>
      mode ?? theme.mode ?? AutoCompleteMode.replaceWord;

  AutoCompleteTheme _resolveTheme(BuildContext context) {
    return resolveComponentStyle<AutoCompleteTheme, AutoCompleteTheme>(
      context,
      widget: theme,
      select: (t) => t,
      defaults: autocompleteDefaults,
    );
  }

  @override
  void onTextChanged(InputFeatureState state, String text) =>
      _query(state, text);

  @override
  void onFocusGained(InputFeatureState state) => _query(state, state.text);

  void _query(InputFeatureState state, String text) {
    final _AutoCompleteSlot slot = _slotFor(state);
    final int request = ++slot.request;
    Future.sync(() => suggestions(text)).then((items) {
      if (!state.mounted || request != slot.request) {
        return;
      }
      slot.items = items.toList(growable: false);
      slot.selected.value = slot.items.isEmpty ? -1 : 0;
      _syncPopover(state);
    }, onError: (Object _) {});
  }

  /// Opens the list while the field is focused and there is something to show.
  void _syncPopover(InputFeatureState state) {
    final _AutoCompleteSlot slot = _slotFor(state);
    final bool shouldOpen = state.focused && slot.items.isNotEmpty;
    if (!shouldOpen) {
      if (slot.controller.hasOpenPopover) {
        slot.controller.close();
      }
      // A closed list must not leave a highlight behind: Enter would then
      // apply a row the user cannot see.
      slot.selected.value = -1;
      return;
    }
    if (slot.controller.hasOpenPopover) {
      return;
    }
    // Applying a suggestion rewrites the text, which re-enters
    // `onTextChanged` with the completed word; the flag stops that from
    // reopening the list the user just dismissed.
    if (slot.suppressReopen) {
      slot.suppressReopen = false;
      return;
    }
    final AutoCompleteTheme theme = _resolveTheme(state.featureContext);
    slot.controller.show<void>(
      context: state.featureContext,
      handler: const PopoverOverlayHandler(),
      // The field keeps the focus while the list moves.
      dismissBackdropFocus: false,
      widthConstraint:
          theme.popoverWidthConstraint ?? PopoverConstraint.anchorMinSize,
      anchorAlignment:
          theme.popoverAnchorAlignment ?? AlignmentDirectional.bottomStart,
      alignment: theme.popoverAlignment ?? AlignmentDirectional.topStart,
      builder: (context) => _buildPopover(context, theme, slot),
    );
  }

  Widget _buildPopover(
    BuildContext context,
    AutoCompleteTheme theme,
    _AutoCompleteSlot slot,
  ) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final List<String> items = slot.items;
    // The shared menu surface hugs the widest suggestion (never narrower
    // than the field through the anchor-minimum sizing) and scrolls past
    // `maxHeight`, so options stay single-line instead of wrapping.
    return ConstrainedBox(
      constraints:
          theme.popoverConstraints ??
          BoxConstraints(
            maxHeight: theme.maxHeight ?? autocompleteDefaultMaxHeight,
          ),
      child: MenuPopupSurface(
        fill:
            theme.containerBackground?.resolve(ambient.colors) ??
            ambient.colors.popover,
        foreground:
            theme.containerForeground?.resolve(ambient.colors) ??
            ambient.colors.popoverForeground,
        borderColor:
            theme.containerBorderColor?.resolve(ambient.colors) ??
            ambient.colors.border,
        borderWidth: theme.containerBorderWidth ?? 1,
        borderRadius: (theme.containerBorderRadius ?? ambient.borderRadiusMd)
            .resolve(Directionality.of(context)),
        padding: resolveEdgeInsets(
          theme.containerPadding ?? EdgeInsetsDensity.pxAll(4),
          ambient.density.baseContentPadding * ambient.scaling,
        ),
        minWidth: 128,
        maxHeight: theme.maxHeight ?? autocompleteDefaultMaxHeight,
        shadows:
            theme.themeShadows?.shadowMd ?? ambient.tokens.shadows.shadowMd,
        children: <Widget>[
          ListenableBuilder(
            listenable: slot.selected,
            builder: (context, _) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 0; i < items.length; i++)
                  _buildRow(
                    context,
                    theme,
                    slot,
                    items[i],
                    i == slot.selected.value,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    AutoCompleteTheme theme,
    _AutoCompleteSlot slot,
    String suggestion,
    bool highlighted,
  ) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final TextStyle base = theme.itemTextStyle ?? autocompleteDefaultTextStyle;
    final TextStyle rowStyle = base.copyWith(
      fontFamily: ambient.fonts.fontSans,
      color: theme.itemForeground
          ?.resolve(<WidgetState>{if (highlighted) WidgetState.selected})
          ?.resolve(ambient.colors),
    );
    final Widget content =
        itemBuilder?.call(context, suggestion, highlighted) ??
        Text(
          suggestion,
          textAlign: TextAlign.start,
          style: rowStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        );
    return Clickable(
      focusOutline: false,
      onPressed: () => _accept(slot, suggestion, theme),
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry?>(
        // `Clickable` hands its padding to a `Container`, so the density
        // multipliers must be resolved here.
        resolveEdgeInsets(
          theme.itemPadding ?? autocompleteDefaultItemPadding,
          ambient.density.baseContentPadding * ambient.scaling,
        ),
      ),
      decoration: WidgetStateProperty.resolveWith<Decoration?>((states) {
        final Color? fill = theme.itemBackground
            ?.resolve(<WidgetState>{
              ...states,
              if (highlighted) WidgetState.selected,
            })
            ?.resolve(ambient.colors);
        if (fill == null) {
          return null;
        }
        return BoxDecoration(color: fill, borderRadius: theme.itemRadius);
      }),
      textStyle: WidgetStatePropertyAll<TextStyle?>(rowStyle),
      child: SizedBox(width: double.infinity, child: content),
    );
  }

  void _accept(
    _AutoCompleteSlot slot,
    String suggestion,
    AutoCompleteTheme theme,
  ) {
    final InputFeatureState? state = slot.state;
    if (state == null) {
      return;
    }
    slot.suppressReopen = true;
    slot.controller.close();
    final String completed = completer(suggestion);
    applyAutoCompleteSuggestion(state.controller, completed, _modeFor(theme));
    onSuggestionSelected?.call(completed);
  }

  void _navigate(_AutoCompleteSlot slot, int direction) {
    if (slot.items.isEmpty) {
      return;
    }
    final int next = (slot.selected.value + direction) % slot.items.length;
    slot.selected.value = next < 0 ? slot.items.length - 1 : next;
  }

  @override
  Iterable<MapEntry<ShortcutActivator, Intent>> buildShortcuts(
    InputFeatureState state,
  ) sync* {
    yield const MapEntry<ShortcutActivator, Intent>(
      SingleActivator(LogicalKeyboardKey.arrowDown),
      AutoCompleteNavigateIntent(1),
    );
    yield const MapEntry<ShortcutActivator, Intent>(
      SingleActivator(LogicalKeyboardKey.arrowUp),
      AutoCompleteNavigateIntent(-1),
    );
    yield const MapEntry<ShortcutActivator, Intent>(
      SingleActivator(LogicalKeyboardKey.enter),
      AutoCompleteAcceptIntent(),
    );
    yield const MapEntry<ShortcutActivator, Intent>(
      SingleActivator(LogicalKeyboardKey.escape),
      AutoCompleteDismissIntent(),
    );
  }

  @override
  Iterable<MapEntry<Type, Action<Intent>>> buildActions(
    InputFeatureState state,
  ) sync* {
    yield MapEntry<Type, Action<Intent>>(
      AutoCompleteNavigateIntent,
      CallbackAction<AutoCompleteNavigateIntent>(
        onInvoke: (intent) {
          _navigate(_slotFor(state), intent.direction);
          return null;
        },
      ),
    );
    yield MapEntry<Type, Action<Intent>>(
      AutoCompleteAcceptIntent,
      CallbackAction<AutoCompleteAcceptIntent>(
        onInvoke: (intent) {
          final _AutoCompleteSlot slot = _slotFor(state);
          final int index = slot.selected.value;
          if (index >= 0 && index < slot.items.length) {
            _accept(
              slot,
              slot.items[index],
              _resolveTheme(state.featureContext),
            );
          }
          return null;
        },
      ),
    );
    yield MapEntry<Type, Action<Intent>>(
      AutoCompleteDismissIntent,
      CallbackAction<AutoCompleteDismissIntent>(
        onInvoke: (intent) {
          final _AutoCompleteSlot slot = _slotFor(state);
          slot.controller.close();
          // Drop the highlight too: Enter must not apply a row the user can no
          // longer see.
          slot.selected.value = -1;
          return null;
        },
      ),
    );
  }

  @override
  void dispose(InputFeatureState state) {
    final Object? existing = state.featureSlotOf(this);
    if (existing is _AutoCompleteSlot) {
      existing.dispose();
    }
  }
}

/// Per-field mutable state of an [AutoCompleteFeature].
class _AutoCompleteSlot {
  final PopoverController controller = PopoverController();
  final ValueNotifier<int> selected = ValueNotifier<int>(-1);
  List<String> items = const <String>[];

  /// Monotonic id of the newest query; a late answer is dropped.
  int request = 0;

  /// Set right after an accept so the resulting text change does not reopen
  /// the list the user just dismissed.
  bool suppressReopen = false;

  /// The field that owns this slot, so a row tap can write back into it.
  InputFeatureState? state;

  void dispose() {
    controller.dispose();
    selected.dispose();
  }
}
