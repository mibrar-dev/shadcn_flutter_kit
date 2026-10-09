// Gallery preview for `pinned_sheet`: closed/peek/open stages driven by a
// [SheetController], plus the dark palette. Widgets-only.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import '../drawer_container/drawer_container.dart';
import 'pinned_sheet.dart';

/// Renders the pinned sheet gallery.
class PinnedSheetPreview extends StatefulWidget {
  /// Creates the preview.
  const PinnedSheetPreview({super.key});

  @override
  State<PinnedSheetPreview> createState() => _PinnedSheetPreviewState();
}

class _PinnedSheetPreviewState extends State<PinnedSheetPreview> {
  final SheetController _controller = SheetController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 14),
        child: ColoredBox(
          color: theme.colors.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Drag the sheet, or snap it with the buttons',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: PinnedSheet(
                  controller: _controller,
                  initialStage: const SheetStage.fraction(0.4),
                  stages: const [
                    SheetStage.closed(),
                    SheetStage.fraction(0.4),
                    SheetStage.expanded(),
                  ],
                  child: const DrawerContainer(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Sheet content'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    _SnapButton(
                      label: 'Close',
                      onTap: () => _controller.close(),
                    ),
                    const Gap(8),
                    _SnapButton(
                      label: 'Half',
                      onTap: () =>
                          _controller.animateTo(const SheetStage.fraction(0.4)),
                    ),
                    const Gap(8),
                    _SnapButton(label: 'Open', onTap: () => _controller.open()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SnapButton extends StatelessWidget {
  const _SnapButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colors.secondary,
          borderRadius: theme.borderRadiusMd,
        ),
        child: Text(label),
      ),
    );
  }
}
