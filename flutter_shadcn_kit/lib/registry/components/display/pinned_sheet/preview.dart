// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';

import '../../overlay/drawer/drawer.dart' show OverlayPosition;
import '../../overlay/drawer_container/drawer_container.dart';
import 'pinned_sheet.dart';

/// PinnedSheetPreview defines a reusable type for this registry module.
class PinnedSheetPreview extends StatelessWidget {
  const PinnedSheetPreview({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Data<DrawerContainerData>.inherit(
      data: const DrawerContainerData(
        position: OverlayPosition.bottom,
        size: Size.zero,
        stackIndex: 0,
      ),
      child: const SizedBox(
        height: 320,
        child: PinnedSheet(
          stages: [SheetStage.closed(), SheetStage.expanded()],
          initialStage: SheetStage.expanded(),
          child: DrawerContainer(child: Text('Sheet content')),
        ),
      ),
    );
  }
}
