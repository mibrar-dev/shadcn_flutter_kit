// Gallery preview for the `window` component: a navigator with a normal and
// an always-on-top window, plus a dark palette. Widgets-only.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'window.dart';

/// Renders the window gallery.
class WindowPreview extends StatefulWidget {
  /// Creates the preview.
  const WindowPreview({super.key});

  @override
  State<WindowPreview> createState() => _WindowPreviewState();
}

class _WindowPreviewState extends State<WindowPreview> {
  final WindowController _notes = WindowController(
    bounds: const Rect.fromLTWH(32, 24, 288, 200),
  );
  final WindowController _inspector = WindowController(
    bounds: const Rect.fromLTWH(196, 120, 240, 170),
    alwaysOnTop: true,
  );

  @override
  void dispose() {
    _notes.dispose();
    _inspector.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: SizedBox(
        height: 460,
        child: ShadcnTheme(
          data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
          child: Builder(
            builder: (BuildContext context) => WindowNavigator(
              initialWindows: <Window>[
                Window(
                  controller: _notes,
                  title: const Text('Notes'),
                  content: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Drag the title bar; resize from any edge.'),
                  ),
                ),
                Window(
                  controller: _inspector,
                  title: const Text('Inspector'),
                  content: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Always on top.'),
                  ),
                ),
              ],
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
  }
}
