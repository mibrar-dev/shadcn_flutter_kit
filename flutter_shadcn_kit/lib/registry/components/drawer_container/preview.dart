// Gallery preview for the `drawer_container` component: drawer and sheet
// chrome at every edge, the drag handle, cross-axis sizing, the barrier wash
// and a data-driven `DrawerContainer`. Widgets-only.

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'drawer_container.dart';

/// Renders the drawer-container gallery.
class DrawerContainerPreview extends StatelessWidget {
  /// Creates the preview.
  const DrawerContainerPreview({super.key});

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
                _section('Drawers', _drawerRow()),
                const Gap(24),
                _section('Sheet', _sheetBox()),
                const Gap(24),
                _section('Cross-axis size', _crossAxisBox()),
                const Gap(24),
                _section('Barrier wash', _barrierBox()),
                const Gap(24),
                _section('Data-driven', _dataDrivenBox()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawerRow() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        for (final OverlayPosition position in <OverlayPosition>[
          OverlayPosition.left,
          OverlayPosition.right,
          OverlayPosition.top,
          OverlayPosition.bottom,
        ])
          _frame(
            DrawerRawContainer(
              position: position,
              constraints: const BoxConstraints(maxWidth: 140, maxHeight: 120),
              child: const Center(child: Text('Drawer')),
            ),
          ),
      ],
    );
  }

  Widget _sheetBox() {
    return _frame(
      const SizedBox(
        width: 220,
        height: 140,
        child: DrawerRawContainer(
          position: OverlayPosition.bottom,
          isSheet: true,
          expands: true,
          child: Center(child: Text('Sheet')),
        ),
      ),
    );
  }

  Widget _crossAxisBox() {
    return _frame(
      const SizedBox(
        width: 240,
        height: 120,
        child: DrawerRawContainer(
          position: OverlayPosition.bottom,
          isSheet: true,
          crossAxisSize: FractionAxisSize(0.5),
          crossAxisAlignment: 0,
          child: Center(child: Text('Half width')),
        ),
      ),
    );
  }

  Widget _barrierBox() {
    return _frame(
      SizedBox(
        width: 240,
        height: 120,
        child: DrawerRawContainer(
          position: OverlayPosition.bottom,
          isSheet: true,
          fadeAnimation: const AlwaysStoppedAnimation<double>(1),
          barrierColor: const Color(0x40000000),
          child: const Center(child: Text('With barrier')),
        ),
      ),
    );
  }

  Widget _dataDrivenBox() {
    return _frame(
      const SizedBox(
        width: 240,
        height: 140,
        child: Data<DrawerContainerData>.inherit(
          data: DrawerContainerData(
            position: OverlayPosition.right,
            isSheet: true,
            padding: EdgeInsets.all(12),
          ),
          child: DrawerContainer(
            size: FractionAxisSize(0.6),
            child: Center(child: Text('Data-driven')),
          ),
        ),
      ),
    );
  }

  Widget _frame(Widget child) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: Color(0x11000000)),
      child: Padding(padding: const EdgeInsets.all(8), child: child),
    );
  }

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(8),
        child,
      ],
    );
  }
}
