// Shared selectable wrapper for every docs code surface (P6-F4).
//
// The registry `CodeSnippet` already wraps its output in a `SelectableRegion`;
// the docs figures render their own highlighted `Text`/`Text.rich` (precomputed
// `DocsSnippet` spans, `syntaxTextSpan`), so they share this wrapper instead.
// It keeps syntax colours byte-identical and only adds selection/copy.
//
// `SelectableRegion` needs an `Overlay` ancestor for its handles and menu; a
// bare harness has none, so the wrapper falls back to the plain child there
// (the same guard the registry `CodeSnippet` uses).

import 'package:flutter/widgets.dart';

import '../ui/shadcn/primitives/text_editing/text_editing.dart';

/// Wraps [child] in a `SelectableRegion` when an `Overlay` exists.
class SelectableCode extends StatelessWidget {
  /// Creates the wrapper around a highlighted code block.
  const SelectableCode({super.key, required this.child});

  /// The highlighted code block (`Text` / `Text.rich`).
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (Overlay.maybeOf(context) == null) {
      return child;
    }
    return SelectableRegion(
      selectionControls: ShadcnSelectionControls(),
      child: child,
    );
  }
}
