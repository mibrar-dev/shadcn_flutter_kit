// `/themes` — the Theme Studio (spec §2.7).
//
// Two panes like the reference's `/create`: a 192 px rail on the left (24 px
// from the edge) and a large rounded block canvas on the right. Below `sm` the
// rail cannot fit next to the cards, so it collapses into an anchored sheet
// opened from a `Customize` chip, and the canvas takes the full width.

import 'package:flutter/widgets.dart';

import '../routing/docs_router.dart';
import '../state/docs_state.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/popup/popup.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/primitives/overlay.dart';
import '../ui/shadcn/theme/theme.dart';
import '../widgets/studio_canvas.dart';
import '../widgets/theme_rail.dart';

/// `/themes` — the customizer.
class ThemesPage extends StatelessWidget {
  /// Creates the themes page.
  const ThemesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final DocsState state = DocsRouterScope.of(context).state;
    if (MediaQuery.sizeOf(context).width < 640) {
      return ColoredBox(
        color: theme.colors.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Button(
                key: const ValueKey<String>('themes-open-rail'),
                variant: ButtonVariant.outline,
                size: ButtonSize.sm,
                leading: const Icon(LucideIcons.slidersHorizontal, size: 14),
                onPressed: () => _openRail(context, state),
                child: const Text('Customize'),
              ),
            ),
            const Gap(12),
            Expanded(child: ThemeCanvas(state: state)),
          ],
        ),
      );
    }
    return ColoredBox(
      color: theme.colors.background,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Spec §2.7: the rail is a floating 192 px card, 24 px from the left
          // edge, 12 px below the header, 24 px above the bottom.
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 12, bottom: 24),
            child: ThemeRail(state: state),
          ),
          Expanded(child: ThemeCanvas(state: state)),
        ],
      ),
    );
  }

  /// Opens the rail in an anchored sheet (`<640`).
  Future<void> _openRail(BuildContext context, DocsState state) {
    return showShadcnPopup<void>(
      context: context,
      alignment: Alignment.bottomCenter,
      anchorAlignment: Alignment.topLeft,
      widthConstraint: PopoverConstraint.intrinsic,
      heightConstraint: PopoverConstraint.intrinsic,
      builder: (BuildContext context) => SizedBox(
        width: kThemeRailWidth,
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: ThemeRail(state: state),
      ),
    );
  }
}
