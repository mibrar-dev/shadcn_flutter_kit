// The scroll area of the Theme Studio picker popups (spec §2.7).
//
// Split out of `rail_pickers.dart` for the ~400-line rule: every picker popup
// scrolls through this widget, which pairs its own scrollable with the fixed
// registry edge fade and reveals the live row on mount and on keyboard focus.

import 'package:flutter/widgets.dart';

import '../../ui/shadcn/primitives/fade_scroll.dart';

/// The scroll area of every picker popup: its own scrollable with the fixed
/// registry edge fade, capped by the popup chrome above.
class RailPickerScroll extends StatefulWidget {
  /// Creates a picker scroll area.
  const RailPickerScroll({super.key, required this.child});

  /// The popup body.
  final Widget child;

  @override
  State<RailPickerScroll> createState() => _RailPickerScrollState();
}

class _RailPickerScrollState extends State<RailPickerScroll> {
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeScroll(
      controller: _scroll,
      startOffset: 8,
      endOffset: 8,
      child: SingleChildScrollView(controller: _scroll, child: widget.child),
    );
  }
}

/// Reveals [child] on mount when it is the selected row of a long list.
///
/// The preset list holds every registry preset, so the current one can start
/// far below the fold; keyboard focus reveals rows through [revealOnFocus].
Widget revealSelectedOnMount({required bool selected, required Widget child}) {
  if (!selected) return child;
  return _RevealOnMount(child: child);
}

/// Scrolls a selected row into view once the popup has laid out.
class _RevealOnMount extends StatefulWidget {
  /// Creates a mount revealer.
  const _RevealOnMount({required this.child});

  /// The selected row.
  final Widget child;

  @override
  State<_RevealOnMount> createState() => _RevealOnMountState();
}

class _RevealOnMountState extends State<_RevealOnMount> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 150),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Scrolls a row into view when keyboard focus lands on it.
void revealOnFocus(BuildContext context, bool focused) {
  if (!focused) return;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (context.mounted) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 150),
      );
    }
  });
}
