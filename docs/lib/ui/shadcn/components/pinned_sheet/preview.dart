// Named examples for the `pinned_sheet` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle. Each sheet carries its own bounded box (and its own
// controller): the sheet stack requires bounded constraints, and the old
// gallery's `Expanded` under the unbounded docs stage could not lay out.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'pinned_sheet.dart';

/// Compact sheet content in theme tokens.
class _SheetBody extends StatelessWidget {
  const _SheetBody();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Container(
      padding: EdgeInsets.all(theme.spacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Sheet content',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Gap(theme.spacing.sm),
          Text(
            'Drag the sheet to move between stages.',
            style: TextStyle(color: theme.colors.mutedForeground),
          ),
        ],
      ),
    );
  }
}

/// A sheet resting at its middle stage; the controller is this example's own.
class _DefaultSheet extends StatefulWidget {
  const _DefaultSheet();

  @override
  State<_DefaultSheet> createState() => _DefaultSheetState();
}

class _DefaultSheetState extends State<_DefaultSheet> {
  final SheetController _controller = SheetController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 280,
      child: PinnedSheet(
        controller: _controller,
        initialStage: const SheetStage.fraction(0.4),
        stages: const <SheetStage>[
          SheetStage.closed(),
          SheetStage.fraction(0.4),
          SheetStage.expanded(),
        ],
        child: const _SheetBody(),
      ),
    );
  }
}

/// A sheet snapped between stages with buttons; the controller is local.
class _SnappingSheet extends StatefulWidget {
  const _SnappingSheet();

  @override
  State<_SnappingSheet> createState() => _SnappingSheetState();
}

class _SnappingSheetState extends State<_SnappingSheet> {
  final SheetController _controller = SheetController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 320,
          height: 240,
          child: PinnedSheet(
            controller: _controller,
            initialStage: const SheetStage.fraction(0.4),
            stages: const <SheetStage>[
              SheetStage.closed(),
              SheetStage.fraction(0.4),
              SheetStage.expanded(),
            ],
            child: const _SheetBody(),
          ),
        ),
        Gap(theme.spacing.sm),
        Wrap(
          spacing: theme.spacing.sm,
          children: <Widget>[
            _SnapButton(label: 'Close', onTap: () => _controller.close()),
            _SnapButton(
              label: 'Half',
              onTap: () =>
                  _controller.animateTo(const SheetStage.fraction(0.4)),
            ),
            _SnapButton(label: 'Open', onTap: () => _controller.open()),
          ],
        ),
      ],
    );
  }
}

/// A small stage button in theme tokens.
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

Widget _default(BuildContext context) => const _DefaultSheet();

Widget _snapping(BuildContext context) => const _SnappingSheet();

/// Named docs examples for `pinned_sheet`; the first entry is the default.
const List<ComponentPreview> pinnedSheetPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Snapping', _snapping),
];
