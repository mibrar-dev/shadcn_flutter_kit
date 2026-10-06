// Minimal menu group metadata shared by menu-aware components.
//
// Ported from `shared/primitives/menu_group.dart`; the `menu` component
// imports this primitive (OWNERSHIP.md: MenuGroupData owner).

import 'package:flutter/widgets.dart';

/// Layout direction of a menu group.
class MenuGroupData {
  /// Horizontal or vertical.
  final Axis direction;

  /// Creates menu group data.
  const MenuGroupData({required this.direction});
}
