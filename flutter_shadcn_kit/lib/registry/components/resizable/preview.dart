// Named examples for the `resizable` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle. Each group carries its own bounded box, and pane
// fills read the theme instead of the gallery's hard-coded black overlay.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../theme/theme.dart';
import 'resizable.dart';

/// A muted pane label in theme tokens.
class _Pane extends StatelessWidget {
  const _Pane(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      color: theme.colors.muted,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(color: theme.colors.mutedForeground),
      ),
    );
  }
}

/// Panes sized in absolute pixels.
Widget _absolute(BuildContext context) {
  return const SizedBox(
    width: 360,
    height: 140,
    child: ResizablePanelGroup(
      children: <Widget>[
        ResizablePanel(defaultSize: 120, child: _Pane('Sidebar')),
        ResizableHandle(withHandle: true),
        ResizablePanel(defaultSize: 200, child: _Pane('Main')),
      ],
    ),
  );
}

/// Panes sharing space by flex.
Widget _flexible(BuildContext context) {
  return const SizedBox(
    width: 360,
    height: 140,
    child: ResizablePanelGroup(
      children: <Widget>[
        ResizablePanel(flex: 2, child: _Pane('Main')),
        ResizableHandle(withHandle: true),
        ResizablePanel(flex: 1, child: _Pane('Inspector')),
      ],
    ),
  );
}

/// Named docs examples for `resizable`; the first entry is the default.
const List<ComponentPreview> resizablePreviews = <ComponentPreview>[
  ComponentPreview('Absolute', _absolute),
  ComponentPreview('Flexible', _flexible),
];
