// The `pricing-01` block: a marketing pricing section with a promo-code
// form.
//
// A block is layer 4 of the registry: it may import foundation, theme,
// primitives and components, never another block. Its public widget is the
// preview - the docs page renders it exactly as an app would.
//
// Three plans with a feature list and a highlighted middle tier. From 1080px
// the tiers sit side by side; below that they stack. The highlight uses the
// primary/ring tokens, so it survives a preset switch. The promo-code row is
// a real validated form: a 6-character code, an Apply button with loading,
// and a success alert.

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../components/badge/badge.dart';
import '../../components/button/button.dart';
import '../../components/card/card.dart';
import '../../components/divider/divider.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';
import 'pricing_01_promo.dart';

/// A pricing section: three plans, the middle one highlighted.
class Pricing01 extends StatelessWidget {
  /// Creates the block.
  const Pricing01({super.key, this.onSelectPlan, this.onApplyPromo});

  /// Called with the plan name when a plan button is tapped.
  final ValueChanged<String>? onSelectPlan;

  /// Called once with the typed values after a valid promo submit.
  final FutureOr<void> Function(Pricing01PromoData data)? onApplyPromo;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    // Align loosens the width: a bare ConstrainedBox under the scroll view
    // would receive tight width and its maxWidth cap would be clamped away.
    final Widget body = Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const _Pricing01Heading(),
            Gap(theme.spacing.xxl),
            _Pricing01Plans(onSelectPlan: onSelectPlan),
            Gap(theme.spacing.xxl),
            _Pricing01Faq(onApplyPromo: onApplyPromo),
          ],
        ),
      ),
    );
    return ColoredBox(
      color: theme.colors.background,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (!constraints.maxHeight.isFinite) {
              return Padding(
                padding: EdgeInsets.all(theme.spacing.lg),
                child: body,
              );
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(theme.spacing.lg),
              child: body,
            );
          },
        ),
      ),
    );
  }
}

class _Pricing01Heading extends StatelessWidget {
  const _Pricing01Heading();

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Badge(
          variant: BadgeVariant.secondary,
          child: Text('Pricing', style: theme.typography.xSmall),
        ),
        Gap(theme.spacing.lg),
        Text(
          'Plans that scale with you',
          style: theme.typography.h2,
          textAlign: TextAlign.center,
        ),
        Gap(theme.spacing.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            'Start free, upgrade when your team grows. Every plan includes '
            'the full component library and the theme presets.',
            textAlign: TextAlign.center,
            style: theme.typography.textMuted.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }
}

class _Pricing01Plans extends StatelessWidget {
  const _Pricing01Plans({required this.onSelectPlan});

  final ValueChanged<String>? onSelectPlan;

  @override
  Widget build(BuildContext context) {
    final double spacing = ShadcnTheme.of(context).spacing.lg;
    const List<_Pricing01Plan> plans = <_Pricing01Plan>[
      _Pricing01Plan(
        name: 'Starter',
        price: '\$0',
        cadence: 'per user / month',
        features: <String>[
          'Up to 3 projects',
          'Community support',
          '1 theme preset',
        ],
        cta: 'Get started',
        highlighted: false,
      ),
      _Pricing01Plan(
        name: 'Pro',
        price: '\$20',
        cadence: 'per user / month',
        features: <String>[
          'Unlimited projects',
          'All 42 theme presets',
          'Blocks and charts',
          'Priority support',
        ],
        cta: 'Subscribe',
        highlighted: true,
      ),
      _Pricing01Plan(
        name: 'Enterprise',
        price: 'Custom',
        cadence: 'annual billing',
        features: <String>[
          'SSO and audit log',
          'Dedicated support',
          'Custom themes',
        ],
        cta: 'Contact sales',
        highlighted: false,
      ),
    ];
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 1080) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (final _Pricing01Plan plan in plans) ...<Widget>[
                _Pricing01Card(plan: plan, onSelectPlan: onSelectPlan),
                if (plan != plans.last) Gap(spacing),
              ],
            ],
          );
        }
        // IntrinsicHeight bounds the cross axis before the stretch Row sees
        // it: inside the block's own scroll view the height is unbounded and
        // a bare Row(stretch) hands its Gap separators a tight infinite
        // height, which asserts in debug builds. Cards keep equal heights.
        //
        // Under the unbounded docs frame the Row sizes to its tallest card;
        // IntrinsicHeight needs no bounded host, so this tree is safe both
        // ways. Gap has no intrinsic width contribution issue here because
        // the Row is bounded horizontally.
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (final _Pricing01Plan plan in plans) ...<Widget>[
                Expanded(
                  child: _Pricing01Card(plan: plan, onSelectPlan: onSelectPlan),
                ),
                if (plan != plans.last) Gap(spacing),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _Pricing01Plan {
  const _Pricing01Plan({
    required this.name,
    required this.price,
    required this.cadence,
    required this.features,
    required this.cta,
    required this.highlighted,
  });

  final String name;
  final String price;
  final String cadence;
  final List<String> features;
  final String cta;
  final bool highlighted;
}

class _Pricing01Card extends StatelessWidget {
  const _Pricing01Card({required this.plan, required this.onSelectPlan});

  final _Pricing01Plan plan;
  final ValueChanged<String>? onSelectPlan;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    // The highlight is a 2 px primary border on the default card fill, so
    // every text colour stays the card's own (primary-foreground on a card
    // fill would be unreadable after a preset switch).
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: theme.borderRadiusXl,
        border: Border.all(
          color: plan.highlighted ? theme.colors.primary : theme.colors.border,
          width: plan.highlighted ? 2 : 1,
        ),
      ),
      child: Card(
        borderRadius: BorderRadius.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(plan.name, style: theme.typography.textLarge),
                ),
                if (plan.highlighted)
                  Icon(
                    LucideIcons.sparkles,
                    size: 16,
                    color: theme.colors.primary,
                  ),
              ],
            ),
            Gap(theme.spacing.sm),
            Text(plan.price, style: theme.typography.h1),
            Gap(theme.spacing.xs),
            Text(
              plan.cadence,
              style: theme.typography.textSmall.copyWith(
                color: theme.colors.mutedForeground,
              ),
            ),
            Gap(theme.spacing.lg),
            const Divider(),
            Gap(theme.spacing.lg),
            _Pricing01Features(plan: plan),
            Gap(theme.spacing.xl),
            Button(
              variant: plan.highlighted
                  ? ButtonVariant.secondary
                  : ButtonVariant.outline,
              onPressed: () => onSelectPlan?.call(plan.name),
              child: Text(plan.cta),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pricing01Features extends StatelessWidget {
  const _Pricing01Features({required this.plan});

  final _Pricing01Plan plan;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (final String feature in plan.features) ...<Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(LucideIcons.check, size: 16, color: theme.colors.primary),
              Gap(theme.spacing.sm),
              Expanded(child: Text(feature, style: theme.typography.textSmall)),
            ],
          ),
          if (feature != plan.features.last) Gap(theme.spacing.md),
        ],
      ],
    );
  }
}

class _Pricing01Faq extends StatelessWidget {
  const _Pricing01Faq({required this.onApplyPromo});

  final FutureOr<void> Function(Pricing01PromoData data)? onApplyPromo;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('Questions', style: theme.typography.h3),
        Gap(theme.spacing.lg),
        Wrap(
          spacing: theme.spacing.xl,
          runSpacing: theme.spacing.lg,
          alignment: WrapAlignment.center,
          children: const <Widget>[
            _Pricing01FaqItem(
              question: 'Can I change plans later?',
              answer: 'Yes. Upgrades apply immediately, downgrades next cycle.',
            ),
            _Pricing01FaqItem(
              question: 'Is there a free trial?',
              answer: 'Every plan starts with 14 days, no card required.',
            ),
          ],
        ),
        Gap(theme.spacing.xl),
        const Divider(),
        Gap(theme.spacing.xl),
        Pricing01PromoForm(onApplyPromo: onApplyPromo),
      ],
    );
  }
}

class _Pricing01FaqItem extends StatelessWidget {
  const _Pricing01FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(question, style: theme.typography.textSmall),
          Gap(theme.spacing.sm),
          Text(
            answer,
            style: theme.typography.textSmall.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
