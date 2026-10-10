// The Theme Studio canvas (spec §2.7).
//
// A large rounded card holding a **masonry** grid of registry block cards, the
// same idea as the reference's `/create` preview area: every card is only as
// tall as its content, the columns pack into the shortest gap, and there are
// enough realistic blocks that a rail edit shows up across buttons, inputs,
// sliders, selects, tables, calendars, switches, badges, progress bars and
// charts.
//
// The canvas wraps itself in `AnimatedShadcnTheme`, so a rail edit tweens the
// whole preview over 300 ms (reduced motion: instant, see `MotionScope`).

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../motion/ease.dart';
import '../../motion/motion_scope.dart';
import '../../state/docs_state.dart';
import '../../ui/shadcn/theme/color_tokens.dart';
import '../../ui/shadcn/components/button/button.dart';
import '../../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../../ui/shadcn/primitives/masonry_layout.dart';
import '../../ui/shadcn/theme/theme.dart';
import 'studio_blocks/studio_form.dart';
import 'studio_blocks/studio_forms.dart';
import 'studio_blocks/studio_list.dart';
import 'studio_blocks/studio_media.dart';
import 'studio_blocks/studio_money.dart';
import 'studio_blocks/studio_settings.dart';
import 'studio_blocks/studio_stats.dart';
import 'studio_blocks/studio_tabs.dart';

/// Bottom padding of the canvas scroll view.
const double _kCanvasPadding = 16;

/// Gap between two cards in the same column and between two columns.
///
/// The reference `/create` preview measures `--gap = 2.5rem` (40 px) on its
/// 3000 px wall; the Studio canvas is ~1176 px wide at 1440 (three columns),
/// so the same ratio would be ~16 px. 24 px sits between the reference's
/// absolute value and its proportion and matches the docs card walls (§2.1),
/// which is what keeps the wall tight without the cards touching.
const double _kCanvasGap = 24;

/// Column count breakpoints, measured against the canvas' own inner width
/// (its width minus the scroll view's 16 px gutters).
///
/// Measured canvas widths (the 192 px rail + 24 px gutter eat 216 px, and the
/// mobile sheet hides the rail below 768): 1440 → 1160, 768 → 488 (rail still
/// open), 375 → 311. The reference `/create` preview is 1176 px wide and shows
/// ~3 card columns, so the top step matches it at 1440.
int _columnsFor(double width) => width >= 1140 ? 3 : (width >= 450 ? 2 : 1);

/// The live block grid.
class ThemeCanvas extends StatelessWidget {
  /// Creates the canvas bound to [state].
  const ThemeCanvas({super.key, required this.state});

  /// The shell state (its theme model drives the tween).
  final DocsState state;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ColoredBox(
      color: theme.colors.background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 24, 24),
        child: ClipRRect(
          borderRadius: theme.borderRadiusXl,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: ColoredBox(
                  color: theme.colors.card,
                  child: AnimatedShadcnTheme(
                    data: state.theme,
                    duration: context.motionDuration(kDurationTheme),
                    curve: kEaseOutExpo,
                    child: const _CanvasScroll(),
                  ),
                ),
              ),
              // The reference parks an 80×36 dark chip at the canvas
              // bottom-right (spec §2.7). Ours flips the whole site, which is
              // the point of the Studio: the rail edits and this chip are one
              // model, so the header toggle and this chip stay in sync.
              Positioned(right: 12, bottom: 12, child: _ModeChip(state: state)),
            ],
          ),
        ),
      ),
    );
  }
}

/// The bottom-right mode chip.
class _ModeChip extends StatelessWidget {
  const _ModeChip({required this.state});

  final DocsState state;

  @override
  Widget build(BuildContext context) {
    final bool dark = state.brightness == Brightness.dark;
    return Button(
      key: const ValueKey<String>('theme-canvas-mode'),
      variant: ButtonVariant.outline,
      size: ButtonSize.sm,
      theme: ButtonVariantStyle(
        background: StateValue<ThemedColor>(
          rest: ThemedColor.value(
            dark ? const Color(0xFFFAFAFA) : const Color(0xFF171717),
          ),
          hovered: ThemedColor.value(
            dark ? const Color(0xFFFFFFFF) : const Color(0xFF262626),
          ),
        ),
        foreground: StateValue<ThemedColor>(
          rest: ThemedColor.value(
            dark ? const Color(0xFF0A0A0A) : const Color(0xFFFAFAFA),
          ),
          hovered: ThemedColor.value(
            dark ? const Color(0xFF0A0A0A) : const Color(0xFFFAFAFA),
          ),
        ),
      ),
      onPressed: state.toggleBrightness,
      leading: Icon(dark ? LucideIcons.sun : LucideIcons.moon, size: 14),
      child: Text(dark ? 'Light' : 'Dark'),
    );
  }
}

/// The masonry scroll view. The cards keep their natural heights; the masonry
/// packs them into the shortest column, so nothing is stretched.
class _CanvasScroll extends StatelessWidget {
  const _CanvasScroll();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth - _kCanvasPadding * 2;
        // The gap follows the ambient density, so the rail's density row
        // re-stacks the wall as well as the cards inside it.
        final double gap = math.min(
          _kCanvasGap,
          math.max(12, theme.density.baseGap * 2),
        );
        return SingleChildScrollView(
          padding: const EdgeInsets.all(_kCanvasPadding),
          child: MasonryLayout.fixed(
            crossAxisCount: _columnsFor(width),
            mainAxisSpacing: gap,
            crossAxisSpacing: gap,
            children: blocks,
          ),
        );
      },
    );
  }
}

/// The blocks, in the reference's reading order.
///
/// Order matters only for the reading order: the masonry places each one in
/// the shortest column whatever order they arrive in. Long and short cards
/// are interleaved on purpose so no column ends up with a lone tall run.
final List<Widget> blocks = <Widget>[
  const StudioContributionCard(),
  const StudioPayoutCard(),
  const StudioSavingsCard(),
  const StudioClaimableBalanceCard(),
  const StudioSidebarNavCard(),
  const StudioBreadcrumbPagerCard(),
  const StudioCalendarCard(),
  const StudioDateRangeCard(),
  const StudioTeamMembersCard(),
  const StudioNotificationsCard(),
  const StudioShareCard(),
  const StudioFileUploadCard(),
  const StudioPaymentMethodCard(),
  const StudioPreferencesCard(),
  const StudioCookieCard(),
  const StudioOtpCard(),
  const StudioChatCard(),
  const StudioFaqCard(),
  const StudioStepperCard(),
  const StudioToolbarCard(),
  const StudioStatusCard(),
  const StudioEmptyCard(),
  const StudioTableCard(),
  const StudioTabsCard(),
  const StudioSparklineStatCard(
    title: 'Net Revenue',
    value: r'$48,320',
    caption: '+12.4% vs last month',
    samples: <double>[22, 26, 24, 31, 29, 38, 35, 44, 41, 52],
  ),
  const StudioSparklineStatCard(
    title: 'Active Listeners',
    value: '18,204',
    caption: '+3.1% vs last month',
    samples: <double>[31, 34, 33, 38, 42, 40, 46, 44, 49, 52],
  ),
  const StudioKpiCard(label: 'Monthly revenue', value: r'$412,904'),
  const StudioKpiCard(
    label: 'Payouts pending',
    value: r'$18,204',
    delta: '2 waiting on review',
  ),
  const StudioAveragesCard(),
  const StudioUpcomingPaymentsCard(),
  const StudioDividendCard(),
  const StudioUsageCard(),
  const StudioActivityCard(),
  const StudioCardBalanceCard(),
  const StudioInvestmentCard(),
  const StudioReportIssueCard(),
  const StudioCreateAccountCard(),
  const StudioPricingCard(),
  const StudioGoalCard(),
  const StudioTransactionsCard(),
];
