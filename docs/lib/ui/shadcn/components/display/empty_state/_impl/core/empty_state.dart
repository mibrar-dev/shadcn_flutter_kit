// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../shared/theme/theme.dart';
import '../../../../control/button/button.dart';
import '../../../../layout/card/card.dart';
import '../utils/empty_state_defaults.dart';
import '../variants/empty_state_action_style.dart';
import '../variants/empty_state_size.dart';
import '../variants/empty_state_variant.dart';
import '../themes/base/empty_state_theme.dart';
import 'empty_state_action.dart';

/// EmptyState holds mutable state for the empty state implementation.
class EmptyState extends StatelessWidget {
  /// Creates `EmptyState` for configuring or rendering empty state.
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
    this.maxWidth,
    this.showIconContainer = true,
  });

  /// Input parameter used by `EmptyState` during rendering and behavior handling.
  final EmptyStateVariant variant;

  /// Layout/size setting that affects empty state rendering.
  final EmptyStateSize size;

  /// Input parameter used by `EmptyState` during rendering and behavior handling.
  final Widget? icon;

  /// Text/content element used by `EmptyState` when composing its visual layout.
  final Widget? title;

  /// Input parameter used by `EmptyState` during rendering and behavior handling.
  final Widget? description;

  /// Input parameter used by `EmptyState` during rendering and behavior handling.
  final EmptyStateAction? primaryAction;

  /// Input parameter used by `EmptyState` during rendering and behavior handling.
  final EmptyStateAction? secondaryAction;

  /// Input parameter used by `EmptyState` during rendering and behavior handling.
  final EmptyStateAction? footerAction;

  /// Layout/size setting that affects empty state rendering.
  final double? maxWidth;

  /// Input parameter used by `EmptyState` during rendering and behavior handling.
  final bool showIconContainer;

  /// Builds the widget tree for empty state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final scaling = theme.scaling;
    final compTheme = ComponentTheme.maybeOf<EmptyStateTheme>(context);
    final resolvedTitle = title ?? Text(defaultEmptyStateTitle(variant));
    final resolvedDescription =
        description ?? Text(defaultEmptyStateDescription(variant));
    final resolvedIcon =
        icon ??
        Icon(
          defaultEmptyStateIcon(variant),
          size:
              compTheme?.iconSize ??
              (size == EmptyStateSize.compact ? 28 * scaling : 36 * scaling),
          color: compTheme?.iconColor ?? theme.colorScheme.mutedForeground,
        );

    final titleStyle =
        compTheme?.titleStyle ??
        (size == EmptyStateSize.compact
                ? theme.typography.large
                : theme.typography.x2Large)
            .merge(theme.typography.semiBold);
    final descriptionStyle =
        compTheme?.descriptionStyle ??
        (size == EmptyStateSize.compact
                ? theme.typography.small
                : theme.typography.base)
            .copyWith(height: 1.35, color: theme.colorScheme.mutedForeground);
    final actionSize = size == EmptyStateSize.compact
        ? ButtonSize.small
        : ButtonSize.normal;

    final hasMainActions = primaryAction != null || secondaryAction != null;

    final hasFooterAction = footerAction != null;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        showIconContainer
            ? DecoratedBox(
                decoration: BoxDecoration(
                  color:
                      compTheme?.iconContainerColor ?? theme.colorScheme.muted,
                  borderRadius:
                      compTheme?.iconContainerBorderRadius ??
                      BorderRadius.circular(14 * scaling),
                  border: Border.all(
                    color:
                        compTheme?.iconContainerBorderColor ??
                        theme.colorScheme.border,
                  ),
                ),
                child: Padding(
                  padding:
                      compTheme?.iconContainerPadding ??
                      EdgeInsets.all(12 * scaling),
                  child: resolvedIcon,
                ),
              )
            : resolvedIcon,

        DensityGap(size == EmptyStateSize.compact ? gapLg : gap2xl),

        DefaultTextStyle.merge(
          style: titleStyle,
          textAlign: TextAlign.center,
          child: resolvedTitle,
        ),

        DensityGap(size == EmptyStateSize.compact ? 0.9 : gapMd),

        DefaultTextStyle.merge(
          style: descriptionStyle,
          textAlign: TextAlign.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 560 * scaling),
            child: resolvedDescription,
          ),
        ),
        if (hasMainActions)
          Padding(
            padding: EdgeInsets.only(
              top:
                  theme.density.baseGap *
                  scaling *
                  (size == EmptyStateSize.compact ? gapLg : gap2xl),
            ),
            child: Wrap(
              spacing: theme.density.baseGap * scaling * gapMd,
              runSpacing: theme.density.baseGap * scaling * gapSm,
              alignment: WrapAlignment.center,
              children: [
                if (primaryAction != null)
                  _buildAction(primaryAction!, size: actionSize),
                if (secondaryAction != null)
                  _buildAction(secondaryAction!, size: actionSize),
              ],
            ),
          ),
        if (hasFooterAction)
          Padding(
            padding: EdgeInsets.only(
              top:
                  theme.density.baseGap *
                  scaling *
                  (size == EmptyStateSize.compact ? gapLg : gap2xl),
            ),
            child: _buildAction(footerAction!, size: ButtonSize.normal),
          ),
      ],
    );

    final constrained = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: compTheme?.maxWidth ?? maxWidth ?? 520 * scaling,
      ),
      child: Padding(
        padding:
            compTheme?.padding ??
            EdgeInsets.all(
              size == EmptyStateSize.compact
                  ? theme.density.baseContainerPadding * scaling * 1.25
                  : theme.density.baseContainerPadding * scaling * padLg,
            ),
        child: content,
      ),
    );

    if (size == EmptyStateSize.compact) {
      return Card(
        borderRadius: compTheme?.cardBorderRadius,
        filled: compTheme?.cardFillColor != null ? true : null,
        fillColor: compTheme?.cardFillColor,
        child: constrained,
      );
    }

    return Center(child: constrained);
  }

  /// Implements `_buildAction` behavior for empty state.
  Widget _buildAction(EmptyStateAction action, {required ButtonSize size}) {
    final child = Text(action.label);

    switch (action.style) {
      case EmptyStateActionStyle.primary:
        return PrimaryButton(
          onPressed: action.onPressed,
          leading: action.icon,
          trailing: action.trailingIcon,
          size: size,
          child: child,
        );
      case EmptyStateActionStyle.secondary:
        return SecondaryButton(
          onPressed: action.onPressed,
          leading: action.icon,
          trailing: action.trailingIcon,
          size: size,
          child: child,
        );
      case EmptyStateActionStyle.link:
        return LinkButton(
          onPressed: action.onPressed,
          leading: action.icon,
          trailing: action.trailingIcon,
          size: size,
          child: child,
        );
    }
  }
}
