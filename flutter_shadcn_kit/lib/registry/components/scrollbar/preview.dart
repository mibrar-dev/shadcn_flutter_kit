// Named examples for the `scrollbar` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle. Each example owns its scroll controller: the old
// gallery shared one controller across four lists, which Flutter rejects with
// "attached to more than one ScrollPosition".

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'scrollbar.dart';

/// A scrollable list; the controller lives in the example's own state.
class _ScrollbarDemo extends StatefulWidget {
  const _ScrollbarDemo({this.thumbVisibility, this.trackVisibility});

  final bool? thumbVisibility;
  final bool? trackVisibility;

  @override
  State<_ScrollbarDemo> createState() => _ScrollbarDemoState();
}

class _ScrollbarDemoState extends State<_ScrollbarDemo> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 180,
      child: Scrollbar(
        controller: _controller,
        thumbVisibility: widget.thumbVisibility,
        trackVisibility: widget.trackVisibility,
        child: ListView.builder(
          controller: _controller,
          itemCount: 30,
          itemBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.all(8),
            child: Text('Item ${index + 1}'),
          ),
        ),
      ),
    );
  }
}

/// The default auto-hiding thumb.
Widget _default(BuildContext context) => const _ScrollbarDemo();

/// A permanently visible thumb over a track.
Widget _alwaysVisible(BuildContext context) =>
    const _ScrollbarDemo(thumbVisibility: true, trackVisibility: true);

/// A thumb tinted from the theme tokens.
Widget _themed(BuildContext context) {
  return const ComponentTheme<ScrollbarTheme>(
    data: ScrollbarTheme(
      color: ThemedColor.ref(ColorRef.primary),
      thickness: 10,
    ),
    child: _ScrollbarDemo(thumbVisibility: true),
  );
}

/// Named docs examples for `scrollbar`; the first entry is the default.
const List<ComponentPreview> scrollbarPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Always visible', _alwaysVisible),
  ComponentPreview('Themed', _themed),
];
