// Named examples for the `drawer_container` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/data.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'drawer_container.dart';

/// A framed box that shows the container's bounds.
class _DrawerContainerFrame extends StatelessWidget {
  const _DrawerContainerFrame({required this.child, this.width, this.height});

  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.muted,
        borderRadius: theme.borderRadiusMd,
      ),
      child: Padding(
        padding: EdgeInsetsDensity.pxAll(8),
        child: SizedBox(width: width, height: height, child: child),
      ),
    );
  }
}

/// Drawer chrome at the four edges.
Widget _drawerContainerDefault(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.md,
    runSpacing: spacing.md,
    children: <Widget>[
      for (final position in const <OverlayPosition>[
        OverlayPosition.left,
        OverlayPosition.right,
        OverlayPosition.top,
        OverlayPosition.bottom,
      ])
        _DrawerContainerFrame(
          child: DrawerRawContainer(
            position: position,
            constraints: const BoxConstraints(maxWidth: 140, maxHeight: 120),
            child: const Center(child: Text('Drawer')),
          ),
        ),
    ],
  );
}

/// The sheet form, expanded along the cross axis.
Widget _drawerContainerWithHandle(BuildContext context) {
  return Wrap(
    spacing: ShadcnTheme.of(context).spacing.md,
    runSpacing: ShadcnTheme.of(context).spacing.md,
    children: const <Widget>[
      _DrawerContainerFrame(
        width: 220,
        height: 140,
        child: DrawerRawContainer(
          position: OverlayPosition.bottom,
          isSheet: true,
          expands: true,
          child: Center(child: Text('Sheet')),
        ),
      ),
      _DrawerContainerFrame(
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
      _DrawerContainerFrame(
        width: 240,
        height: 120,
        child: DrawerRawContainer(
          position: OverlayPosition.bottom,
          isSheet: true,
          fadeAnimation: AlwaysStoppedAnimation<double>(1),
          child: Center(child: Text('With barrier')),
        ),
      ),
    ],
  );
}

/// A container driven by the ambient data scope.
Widget _drawerContainerDataDriven(BuildContext context) {
  return _DrawerContainerFrame(
    width: 240,
    height: 140,
    child: Data<DrawerContainerData>.inherit(
      data: DrawerContainerData(
        position: OverlayPosition.right,
        isSheet: true,
        padding: EdgeInsetsDensity.pxAll(12),
      ),
      child: DrawerContainer(
        size: FractionAxisSize(0.6),
        child: const Center(child: Text('Data-driven')),
      ),
    ),
  );
}

/// Named docs examples for `drawer_container`; the first entry is the default.
const List<ComponentPreview> drawerContainerPreviews = <ComponentPreview>[
  ComponentPreview('Default', _drawerContainerDefault),
  ComponentPreview('With handle', _drawerContainerWithHandle),
  ComponentPreview('Data-driven', _drawerContainerDataDriven),
];
