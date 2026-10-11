// The generic suggestion slot: `input` knows nothing about `autocomplete`.
//
// [InputAutoCompleteFeature] computes suggestions and hands them, plus a
// selection callback, to a widgets/theme-typed menu builder. The later
// `autocomplete` component plugs its own UI in here.

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'input_features.dart';

/// Generic suggestion slot: `input` knows nothing about `autocomplete`.
///
/// [suggestionMenuBuilder] receives the current suggestions and a selection
/// callback; when null the feature computes and renders nothing.
class InputAutoCompleteFeature extends InputFeature {
  /// Creates a suggestion-slot feature; defaults to `focused` visibility.
  const InputAutoCompleteFeature({
    required this.suggestions,
    super.visibility = InputFeatureVisibility.focused,
    this.onSuggestionSelected,
    this.suggestionMenuBuilder,
  });

  /// Provides suggestions for the current query.
  final SuggestionBuilder suggestions;

  /// Called after a suggestion is selected.
  final ValueChanged<String>? onSuggestionSelected;

  /// Builds the suggestion menu; null renders no menu at all.
  final Widget Function(
    BuildContext context,
    Iterable<String> suggestions,
    ValueChanged<String> onSelected,
  )?
  suggestionMenuBuilder;

  @override
  void onTextChanged(InputFeatureState state, String text) {
    if (suggestionMenuBuilder == null) {
      return;
    }
    final slot = state.slot(this, _SuggestionSlot.new);
    final request = ++slot.request;
    Future.sync(() => suggestions(text)).then((items) {
      if (!state.mounted || request != slot.request) {
        return;
      }
      final list = items.toList(growable: false);
      state.setFeatureState(() => slot.items = list);
      if (list.isEmpty || !state.focused) {
        slot.controller.hide();
      } else {
        slot.controller.show();
      }
    }, onError: (Object _) {});
  }

  void _select(InputFeatureState state, String value) {
    state.slot(this, _SuggestionSlot.new).controller.hide();
    state.controller.text = value;
    onSuggestionSelected?.call(value);
  }

  @override
  Widget wrap(InputFeatureState state, Widget child) {
    final builder = suggestionMenuBuilder;
    if (builder == null) {
      return child;
    }
    final slot = state.slot(this, _SuggestionSlot.new);
    return CompositedTransformTarget(
      link: slot.link,
      child: OverlayPortal(
        controller: slot.controller,
        overlayChildBuilder: (context) {
          if (!state.focused || slot.items.isEmpty) {
            return const SizedBox.shrink();
          }
          final theme = ShadcnTheme.of(context);
          return CompositedTransformFollower(
            link: slot.link,
            showWhenUnlinked: false,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 180,
                maxWidth: 320,
                maxHeight: 240,
              ),
              decoration: BoxDecoration(
                color: theme.colors.popover,
                border: Border.all(color: theme.colors.border),
                borderRadius: theme.borderRadiusMd,
                boxShadow: theme.tokens.shadows.shadowMd,
              ),
              padding: EdgeInsets.all(theme.spacing.xs),
              child: builder(
                context,
                slot.items,
                (value) => _select(state, value),
              ),
            ),
          );
        },
        child: child,
      ),
    );
  }
}

class _SuggestionSlot {
  final LayerLink link = LayerLink();
  final OverlayPortalController controller = OverlayPortalController();
  List<String> items = const <String>[];
  int request = 0;
}
