// GENERATED FILE - DO NOT EDIT.
// Update via docs/scripts/generate_component_pages.py.

import 'package:flutter/material.dart';
import 'package:docs/pages/docs/component_page.dart';
import 'package:docs/ui/shadcn/components/display/pinned_sheet/preview.dart';

class PinnedSheetDocsPage extends StatelessWidget {
  const PinnedSheetDocsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ComponentPage(
      name: 'pinned_sheet',
      displayName: 'Pinned Sheet',
      description: 'Upstream-parity controller-driven sheet (PinnedSheet + SheetController + SheetStage algebra) that snaps between stages with drag gestures and backdrop transforms.',
      children: [
        PinnedSheetPreview(),
      ],
    );
  }
}
