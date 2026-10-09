// The live preview area of the themes page (spec §2.7): a dense grid of
// registry cards that re-themes live through AnimatedShadcnTheme when the
// preset, mode or radius changes. The reference's customizer fills its preview
// pane with a multi-column card wall, so this pane reuses the landing collage
// cards (all registry components) instead of one isolated demo card.

import 'package:flutter/widgets.dart';

import '../state/docs_state.dart';
import '../ui/shadcn/theme/theme.dart';
import '../motion/ease.dart';
import '../motion/motion_scope.dart';
import 'collage_cards.dart';
import 'collage_cards_controls.dart';

/// The live preview area: registry components re-theming live.
class LivePreview extends StatelessWidget {
  /// Creates the preview.
  const LivePreview({super.key, required this.state});

  /// The docs theme state.
  final DocsState state;

  @override
  Widget build(BuildContext context) {
    return AnimatedShadcnTheme(
      data: state.theme,
      duration: context.motionDuration(kDurationTheme),
      curve: kEaseOutExpo,
      child: ColoredBox(
        color: state.theme.colors.background,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double width = constraints.maxWidth;
            final bool narrow = width < 640;
            final int columns = width >= 1320 ? 3 : (width >= 840 ? 2 : 1);
            final double gap = 24;
            final double gutter = narrow ? 16 : 24;
            final double cardWidth =
                (width - gutter * 2 - gap * (columns - 1)) / columns;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(gutter, gutter, gutter, 48),
              child: Wrap(
                spacing: gap,
                runSpacing: gap,
                children: <Widget>[
                  for (final Widget card in _cards)
                    SizedBox(width: cardWidth, child: card),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static const List<Widget> _cards = <Widget>[
    CollageButtonsCard(),
    CollageGoalCard(),
    CollageInputsCard(),
    CollageTabsCard(),
    CollageSwitchesCard(),
    CollageTableCard(),
    CollageRadioCard(),
    CollageInstallCard(),
    CollagePresetsCard(),
    CollageTooltipCard(),
    CollagePagesCard(),
    CollageRegistryCard(),
  ];
}
