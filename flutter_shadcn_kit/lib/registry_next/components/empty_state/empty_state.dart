// The `empty_state` component: [EmptyState] (the block), [EmptyStateAction]
// (one action) and the `EmptyStateVariant` presets that pick the default
// strings and icon.
//
// Ported from `components/display/empty_state/**` (13 files, 968 LOC). The
// bugs it fixed are listed in README.md under "Fixed (not ported)".
//
// Three old things are dropped deliberately:
//   * the `emptyStateThemeTokens` / `EmptyStateThemeSchema` pair (a second,
//     hand-maintained theme layer in `themes/config/`) — one
//     `EmptyStateTheme` with a per-size metric table replaces both;
//   * `EmptyStateTheme` extended the old `ComponentThemeData` without
//     implementing `Mergeable`, so an override leg could not be merged per
//     field: a leg that set only `iconColor` silently dropped every other
//     value. Merge is now first-non-null-wins, the receiver wins;
//   * the `emptyStateThemeTokens.ignoreGlobalScaling` /
//     `ignoreGlobalRadius` flags multiplied every metric by `theme.scaling` *in
//     the widget*, so a caller who turned scaling off got a different set of
//     numbers depending on which flag they set. Scaling now happens once, in
//     the size table.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/radix_icons.dart';
import '../../primitives/localizations/localizations.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import '../card/card.dart';
import 'empty_state_style.dart';

export 'empty_state_style.dart';

/// Which preset supplies the default strings and icon.
enum EmptyStateVariant {
  /// Nothing has been created yet.
  empty,

  /// A search or filter returned nothing.
  noResults,

  /// Stands in for a failed load.
  errorFallback;

  /// The icon the preset falls back to.
  IconData get icon => switch (this) {
    EmptyStateVariant.empty => RadixIcons.archive,
    EmptyStateVariant.noResults => RadixIcons.magnifyingGlass,
    EmptyStateVariant.errorFallback => RadixIcons.exclamationTriangle,
  };
}

/// One action of an [EmptyState].
class EmptyStateAction {
  /// Creates an action.
  const EmptyStateAction({
    required this.label,
    this.onPressed,
    this.leading,
    this.trailing,
    this.variant,
    this.size,
  });

  /// Button text.
  final String label;

  /// Called on tap; a null callback renders a disabled button.
  final VoidCallback? onPressed;

  /// Widget shown before the label.
  final Widget? leading;

  /// Widget shown after the label.
  final Widget? trailing;

  /// Button variant; null resolves `primary` for the first action and
  /// `secondary` for the rest.
  final ButtonVariant? variant;

  /// Button size; null resolves the size's own table entry.
  final ButtonSize? size;
}

/// A block that stands in for missing content.
///
/// ```dart
/// EmptyState(
///   variant: EmptyStateVariant.empty,
///   size: EmptyStateSize.fullPage,
///   primaryAction: EmptyStateAction(
///     label: 'Create project',
///     onPressed: _create,
///   ),
/// )
/// ```
class EmptyState extends StatelessWidget {
  /// Creates an empty state.
  const EmptyState({
    super.key,
    this.variant = EmptyStateVariant.empty,
    this.size = EmptyStateSize.fullPage,
    this.icon,
    this.title,
    this.description,
    this.primaryAction,
    this.secondaryAction,
    this.footerAction,
    this.showIconContainer = true,
    this.theme,
  });

  /// Preset for the default strings and icon.
  final EmptyStateVariant variant;

  /// Presentation scale.
  final EmptyStateSize size;

  /// Icon shown above the title; null uses the preset's icon.
  final Widget? icon;

  /// Title; null uses the preset's localized string.
  final Widget? title;

  /// Description; null uses the preset's localized string.
  final Widget? description;

  /// First action.
  final EmptyStateAction? primaryAction;

  /// Second action, shown beside the first.
  final EmptyStateAction? secondaryAction;

  /// Trailing action, shown on its own row below the pair.
  final EmptyStateAction? footerAction;

  /// Whether the icon sits in the muted container.
  final bool showIconContainer;

  /// Widget-leg style override.
  final EmptyStateTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData shadcnTheme = ShadcnTheme.of(context);
    final ShadcnLocalizations l10n = ShadcnLocalizations.of(context);
    final EmptyStateTheme container =
        resolveComponentStyle<EmptyStateTheme, EmptyStateTheme>(
          context,
          widget: theme,
          select: (EmptyStateTheme t) => t,
          defaults: emptyStateDefaults,
        );
    final EmptyStateMetrics metrics = container.metricsFor(size, shadcnTheme);

    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildIcon(context, container, metrics),
        Gap(metrics.contentGap),
        DefaultTextStyle.merge(
          style: container.titleStyle ?? metrics.titleStyle,
          child:
              title ?? Text(_defaultTitle(l10n), textAlign: TextAlign.center),
        ),
        Gap(metrics.titleGap),
        DefaultTextStyle.merge(
          style: container.descriptionStyle ?? metrics.descriptionStyle,
          textAlign: TextAlign.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: metrics.descriptionMaxWidth),
            child:
                description ??
                Text(_defaultDescription(l10n), textAlign: TextAlign.center),
          ),
        ),
        _buildActions(context, metrics),
      ],
    );

    final Widget constrained = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: container.maxWidth ?? metrics.maxWidth,
      ),
      child: Padding(
        padding: container.padding ?? metrics.padding,
        child: content,
      ),
    );

    if (size.hasSurface) {
      return Card(
        padding: EdgeInsets.zero,
        background: container.surface,
        child: constrained,
      );
    }
    return Center(child: constrained);
  }

  Widget _buildIcon(
    BuildContext context,
    EmptyStateTheme container,
    EmptyStateMetrics metrics,
  ) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    final Widget resolved =
        icon ??
        Icon(
          variant.icon,
          size: metrics.iconSize,
          color: (container.iconColor ?? emptyStateDefaults.iconColor)?.resolve(
            colors,
          ),
        );
    if (!showIconContainer || !size.hasIconContainer) {
      return resolved;
    }
    return DecoratedBox(
      key: emptyStateIconContainerKey,
      decoration: BoxDecoration(
        color: container.iconContainerBackground?.resolve(colors),
        borderRadius:
            metrics.iconContainerBorderRadius ??
            container.iconContainerBorderRadius,
        border: Border.all(
          color:
              container.iconContainerBorderColor?.resolve(colors) ??
              const Color(0x00000000),
        ),
      ),
      child: Padding(
        padding:
            metrics.iconContainerPadding ??
            container.iconContainerPadding ??
            EdgeInsets.zero,
        child: resolved,
      ),
    );
  }

  Widget _buildActions(BuildContext context, EmptyStateMetrics metrics) {
    final EmptyStateAction? primary = primaryAction;
    final EmptyStateAction? secondary = secondaryAction;
    final EmptyStateAction? footer = footerAction;
    if (primary == null && secondary == null && footer == null) {
      return const SizedBox.shrink();
    }
    final List<Widget> children = <Widget>[];
    if (primary != null || secondary != null) {
      children.add(
        Padding(
          padding: EdgeInsets.only(top: metrics.actionGap),
          child: Wrap(
            key: emptyStateActionsKey,
            spacing: metrics.actionSpacing,
            alignment: WrapAlignment.center,
            children: <Widget>[
              if (primary != null) _buildAction(primary, metrics),
              if (secondary != null)
                _buildAction(secondary, metrics, secondary: true),
            ],
          ),
        ),
      );
    }
    if (footer != null) {
      children.add(
        Padding(
          padding: EdgeInsets.only(top: metrics.actionGap),
          child: _buildAction(footer, metrics),
        ),
      );
    }
    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }

  /// Renders [action]. [secondary] picks the positional default variant: the
  /// first action is primary and every later one is secondary.
  Widget _buildAction(
    EmptyStateAction action,
    EmptyStateMetrics metrics, {
    bool secondary = false,
  }) {
    return Button(
      variant:
          action.variant ??
          (secondary ? ButtonVariant.secondary : ButtonVariant.primary),
      size:
          action.size ??
          (size == EmptyStateSize.compact ? ButtonSize.sm : ButtonSize.md),
      onPressed: action.onPressed,
      leading: action.leading,
      trailing: action.trailing,
      child: Text(action.label),
    );
  }

  String _defaultTitle(ShadcnLocalizations l10n) => switch (variant) {
    EmptyStateVariant.empty => l10n.emptyStateEmptyTitle,
    EmptyStateVariant.noResults => l10n.emptyStateNoResultsTitle,
    EmptyStateVariant.errorFallback => l10n.emptyStateErrorTitle,
  };

  String _defaultDescription(ShadcnLocalizations l10n) => switch (variant) {
    EmptyStateVariant.empty => l10n.emptyStateEmptyDescription,
    EmptyStateVariant.noResults => l10n.emptyStateNoResultsDescription,
    EmptyStateVariant.errorFallback => l10n.emptyStateErrorDescription,
  };
}

/// Lookup key of the muted icon container.
const ValueKey<String> emptyStateIconContainerKey = ValueKey<String>(
  'shadcn.empty_state.icon_container',
);

/// Lookup key of the wrapped action row.
const ValueKey<String> emptyStateActionsKey = ValueKey<String>(
  'shadcn.empty_state.actions',
);
