// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart'
        /// Stores `Checkbox` state/configuration for this implementation.
        hide
        Card,
        Divider,
        NavigationBar,
        Checkbox;

import '../../control/button/button.dart' as shadcn_button;
import '../../../shared/primitives/outlined_container.dart';
import '../../layout/card/card.dart';
import '../../form/checkbox/checkbox.dart';
import '../../display/divider/divider.dart';
import '../navigation_bar/navigation_bar.dart';
import '../../overlay/popover/popover.dart';
import '../../layout/scaffold/scaffold.dart' as shadcn_scaffold;
import '../../form/select/select.dart';
part '_impl/state/_navigation_bar_preview_state.dart';

/// NavigationBarPreview defines a reusable type for this registry module.
class NavigationBarPreview extends StatefulWidget {
  const NavigationBarPreview({super.key});

  @override
  /// Executes `createState` behavior for this component/composite.
  State<NavigationBarPreview> createState() => _NavigationBarPreviewState();
}
