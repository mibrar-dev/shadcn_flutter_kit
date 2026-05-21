// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';

import '../menu/menu.dart';
import '../../../shared/primitives/outlined_container.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/constants.dart';

/// Theme configuration for [Menubar] appearance and layout.
///
/// MenubarTheme defines the visual styling for menubar components including
/// borders, colors, positioning, and spacing. All properties are optional
/// and fall back to theme defaults when not specified.
///
/// The theme controls both the menubar container appearance and the behavior
/// of submenu positioning when menu items are opened.
///
/// Example:
/// ```dart
/// ComponentTheme<MenubarTheme>(
///   data: MenubarTheme(
///     border: true,
///     backgroundColor: Colors.white,
///     borderColor: Colors.grey,
///     borderRadius: BorderRadius.circular(8),
///     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
///     subMenuOffset: Offset(0, 8),
///   ),
///   child: Menubar(...),
/// )
/// ```
/// Theme for [Menubar].

part '_impl/themes/base/menubar_theme.dart';
part '_impl/core/menubar_widget.dart';
part '_impl/state/menubar_state.dart';
