// Gallery preview for the `resizable` component: horizontal and vertical
// splits, a grip handle, min/max constraints, a collapsed pane, an external
// controller and a themed handle. Widgets-only.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'resizable.dart';

/// Renders the resizable gallery.
class ResizablePreview extends StatelessWidget {
  /// Creates the preview.
  const ResizablePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section(context, 'Horizontal (grip handle)', _horizontal()),
                Gap(theme.spacing.xl),
                _section(context, 'Vertical', _vertical()),
                Gap(theme.spacing.xl),
                _section(context, 'Constrained + collapsed', _constrained()),
                Gap(theme.spacing.xl),
                _section(context, 'Controlled', _ControlledDemo()),
                Gap(theme.spacing.xl),
                _section(context, 'Themed', _themed()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _horizontal() {
    return SizedBox(
      width: 360,
      height: 140,
      child: ResizablePanelGroup(
        children: <Widget>[
          ResizablePanel(defaultSize: 120, child: _pane('Sidebar')),
          const ResizableHandle(withHandle: true),
          ResizablePanel(flex: 2, child: _pane('Main')),
          const ResizableHandle(),
          ResizablePanel(flex: 1, child: _pane('Inspector')),
        ],
      ),
    );
  }

  Widget _vertical() {
    return SizedBox(
      width: 360,
      height: 180,
      child: ResizablePanelGroup(
        direction: Axis.vertical,
        children: <Widget>[
          ResizablePanel(defaultSize: 60, child: _pane('Header')),
          const ResizableHandle(),
          ResizablePanel(flex: 1, child: _pane('Body')),
          const ResizableHandle(),
          ResizablePanel(defaultSize: 48, child: _pane('Footer')),
        ],
      ),
    );
  }

  Widget _constrained() {
    return SizedBox(
      width: 360,
      height: 140,
      child: ResizablePanelGroup(
        children: <Widget>[
          ResizablePanel(
            defaultSize: 140,
            minSize: 80,
            maxSize: 200,
            collapsedSize: 24,
            child: _pane('min 80 / max 200'),
          ),
          const ResizableHandle(withHandle: true),
          ResizablePanel(flex: 1, child: _pane('flex')),
        ],
      ),
    );
  }

  Widget _themed() {
    return SizedBox(
      width: 360,
      height: 120,
      child: ComponentTheme<ResizableTheme>(
        data: const ResizableTheme(
          handleThickness: 2,
          handleColor: StateValue(rest: ThemedColor.ref(ColorRef.primary)),
        ),
        child: ResizablePanelGroup(
          children: <Widget>[
            ResizablePanel(defaultSize: 120, child: _pane('Themed handle')),
            const ResizableHandle(withHandle: true),
            ResizablePanel(flex: 1, child: _pane('flex')),
          ],
        ),
      ),
    );
  }

  Widget _pane(String label) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      color: const Color(0x11000000),
      child: Text(label, textAlign: TextAlign.center),
    );
  }

  Widget _section(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        Gap(ShadcnTheme.of(context).spacing.sm),
        child,
      ],
    );
  }
}

class _ControlledDemo extends StatefulWidget {
  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  final ResizablePaneController _controller = ResizablePaneController(
    size: 100,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 120,
      child: ResizablePanelGroup(
        children: <Widget>[
          ResizablePanel(
            controller: _controller,
            child: Container(
              alignment: Alignment.center,
              color: const Color(0x11000000),
              child: Text('size ${_controller.value.round()}'),
            ),
          ),
          const ResizableHandle(withHandle: true),
          ResizablePanel(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              color: const Color(0x08000000),
              child: const Text('flex'),
            ),
          ),
        ],
      ),
    );
  }
}
