// Named examples for the `window` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle. Each example owns its controllers and bounds the
// navigator because windows position inside the laid-out viewport.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../theme/theme.dart';
import 'window.dart';

/// One draggable, resizable window; owns its controller.
class _SingleWindow extends StatefulWidget {
  const _SingleWindow();

  @override
  State<_SingleWindow> createState() => _SingleWindowState();
}

class _SingleWindowState extends State<_SingleWindow> {
  final WindowController _notes = WindowController(
    bounds: const Rect.fromLTWH(24, 20, 280, 190),
  );

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 300,
      child: WindowNavigator(
        initialWindows: <Window>[
          Window(
            controller: _notes,
            title: const Text('Notes'),
            content: Padding(
              padding: EdgeInsets.all(ShadcnTheme.of(context).spacing.md),
              child: const Text('Drag the title bar; resize from any edge.'),
            ),
          ),
        ],
        child: const SizedBox.expand(),
      ),
    );
  }
}

Widget _default(BuildContext context) => const _SingleWindow();

/// A maximized window next to a floating one; owns its controllers.
class _MaximizedWindow extends StatefulWidget {
  const _MaximizedWindow();

  @override
  State<_MaximizedWindow> createState() => _MaximizedWindowState();
}

class _MaximizedWindowState extends State<_MaximizedWindow> {
  final WindowController _main = WindowController(
    bounds: const Rect.fromLTWH(24, 20, 280, 190),
    maximized: const Rect.fromLTWH(0, 0, 1, 1),
  );
  final WindowController _inspector = WindowController(
    bounds: const Rect.fromLTWH(60, 60, 220, 150),
    alwaysOnTop: true,
  );

  @override
  void dispose() {
    _main.dispose();
    _inspector.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 300,
      child: WindowNavigator(
        initialWindows: <Window>[
          Window(
            controller: _main,
            title: const Text('Editor'),
            content: Padding(
              padding: EdgeInsets.all(ShadcnTheme.of(context).spacing.md),
              child: const Text('Maximized; restore from the title bar.'),
            ),
          ),
          Window(
            controller: _inspector,
            title: const Text('Inspector'),
            content: Padding(
              padding: EdgeInsets.all(ShadcnTheme.of(context).spacing.md),
              child: const Text('Always on top.'),
            ),
          ),
        ],
        child: const SizedBox.expand(),
      ),
    );
  }
}

Widget _maximized(BuildContext context) => const _MaximizedWindow();

/// Named docs examples for `window`; the first entry is the default.
const List<ComponentPreview> windowPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Maximized', _maximized),
];
