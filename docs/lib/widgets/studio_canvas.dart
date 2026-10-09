// The Theme Studio canvas (spec §2.7).
//
// A large rounded card holding a masonry grid of registry block cards, the
// same idea as the reference's `/create` preview area: dashboard stats with
// progress, a form card with select/slider/textarea, a transactions list with
// avatars, an empty state with a CTA, tabs, a calendar and a table.
//
// The canvas wraps itself in `AnimatedShadcnTheme`, so a rail edit tweens the
// whole preview over 300 ms (reduced motion: instant, see `MotionScope`).

import 'package:flutter/widgets.dart';

import '../../motion/ease.dart';
import '../../motion/motion_scope.dart';
import '../../state/docs_state.dart';
import '../../ui/shadcn/components/button/button.dart';
import '../../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../../ui/shadcn/theme/color_tokens.dart';
import '../../ui/shadcn/theme/theme.dart';
import 'studio_blocks/studio_form.dart';
import 'studio_blocks/studio_list.dart';
import 'studio_blocks/studio_stats.dart';
import 'studio_blocks/studio_tabs.dart';

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
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colors.card,
            borderRadius: theme.borderRadiusXl,
            border: Border.all(color: theme.colors.border),
          ),
          child: ClipRRect(
            borderRadius: theme.borderRadiusXl,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: AnimatedShadcnTheme(
                    data: state.theme,
                    duration: context.motionDuration(kDurationTheme),
                    curve: kEaseOutExpo,
                    child: const _CanvasScroll(),
                  ),
                ),
                // The reference parks an 80×36 dark chip at the canvas
                // bottom-right (spec §2.7). Ours flips the whole site, which is
                // the point of the Studio: the rail edits and this chip are one
                // model, so the header toggle and this chip stay in sync.
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: _ModeChip(state: state),
                ),
              ],
            ),
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

class _CanvasScroll extends StatelessWidget {
  const _CanvasScroll();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final int columns = width >= 1180 ? 3 : (width >= 760 ? 2 : 1);
        const double gap = 16;
        final double cardWidth = (width - gap * (columns - 1) - 32) / columns;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: gap,
            runSpacing: gap,
            children: <Widget>[
              for (final Widget block in blocks)
                SizedBox(width: cardWidth, child: block),
            ],
          ),
        );
      },
    );
  }
}

/// The blocks, in the reference's reading order.
final List<Widget> blocks = <Widget>[
  const StudioKpiCard(
    label: 'Monthly revenue',
    value: r'$48,320',
    delta: '+12.4% vs last month',
  ),
  const StudioKpiCard(
    label: 'Active listeners',
    value: '18,204',
    delta: '+3.1% vs last month',
  ),
  const StudioSavingsCard(),
  const StudioPayoutCard(),
  const StudioEmptyCard(),
  const StudioBalanceCard(),
  const StudioTransactionsCard(),
  const StudioTableCard(),
  const StudioTabsCard(),
  const StudioCalendarCard(),
  const StudioBadgeCard(),
];
