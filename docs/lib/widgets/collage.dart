// The landing collage (spec §2.1): a full-bleed live wall of registry
// components — 4 columns at `1400`, 3 at `1024`, 2 at `768`, gap 24 — with a
// bottom gradient fade and a light-mode-only top fade. The wall is a
// `MasonryLayout`, so every card keeps its natural height and the columns
// pack into the shortest gap. Below 768 the wall is replaced by a
// non-interactive static stack clipped to 140vw (the reference uses a baked
// screenshot image; we ship the composed static fallback instead of a binary
// asset — see the D3 report).

import 'package:flutter/widgets.dart';

import '../ui/shadcn/primitives/masonry_layout.dart';
import '../ui/shadcn/theme/theme.dart';
import 'collage_cards.dart';
import 'collage_cards_controls.dart';

/// The landing hero collage.
class DocsCollage extends StatelessWidget {
  /// Creates the collage.
  const DocsCollage({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    if (width < 768) {
      return const StaticCollage();
    }
    final int columns = width >= 1400 ? 4 : (width >= 1024 ? 3 : 2);
    return _CollageBody(columns: columns);
  }
}

/// The `<768` static collage preview.
///
/// The reference replaces the live grid with a baked screenshot below `md`;
/// this composed fallback shows a reduced, non-interactive, ticker-off card
/// set instead of shipping a binary asset (recorded in the D3 report).
class StaticCollage extends StatelessWidget {
  /// Creates the static collage.
  const StaticCollage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: IgnorePointer(
        child: TickerMode(
          enabled: false,
          child: _CollageBody(
            columns: 1,
            cards: const <Widget>[
              CollageButtonsCard(),
              CollageInputsCard(),
              CollagePresetsCard(),
              CollageInstallCard(),
            ],
          ),
        ),
      ),
    );
  }
}

/// The grid + fades shared by the live and static variants (private).
class _CollageBody extends StatelessWidget {
  const _CollageBody({required this.columns, this.cards});

  final int columns;
  final List<Widget>? cards;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final bool dark = theme.colors.brightness == Brightness.dark;
    final double width = MediaQuery.sizeOf(context).width;
    final double bottomFade = width >= 1280 ? 256 : (width >= 1024 ? 320 : 192);
    final List<Widget> effectiveCards =
        cards ??
        // The masonry packs each card into the shortest column, so the
        // build order is the reading order, not a stack assignment.
        <Widget>[
          const CollageButtonsCard(),
          const CollageInputsCard(),
          const CollageGoalCard(),
          const CollageInstallCard(),
          const CollageTabsCard(),
          const CollagePresetsCard(),
          const CollageRadioCard(),
          const CollagePagesCard(),
          const CollageRegistryCard(),
          const CollageSwitchesCard(),
          const CollageTooltipCard(),
          const CollageTableCard(),
        ];
    return DecoratedBox(
      decoration: BoxDecoration(
        color: dark ? theme.colors.background : theme.colors.muted,
      ),
      child: Stack(
        children: <Widget>[
          if (!dark)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 480,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        theme.colors.background,
                        theme.colors.muted,
                        theme.colors.muted.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1600),
                child: MasonryLayout.fixed(
                  crossAxisCount: columns,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  children: effectiveCards,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: bottomFade,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: <Color>[
                      theme.colors.background,
                      theme.colors.muted.withValues(alpha: 0.8),
                      theme.colors.muted.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
