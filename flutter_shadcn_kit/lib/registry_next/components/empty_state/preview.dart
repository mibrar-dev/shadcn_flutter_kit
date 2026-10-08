// Gallery preview for the `empty_state` component: both sizes, all three
// variants, the action slots and dark.
// Widgets-only; the docs app embeds [EmptyStatePreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'empty_state.dart';

/// Renders the empty-state gallery.
class EmptyStatePreview extends StatelessWidget {
  /// Creates the preview.
  const EmptyStatePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section('Full page — empty', _fullPage()),
                const Gap(24),
                _section('No results', _noResults()),
                const Gap(24),
                _section('Error fallback', _error()),
                const Gap(24),
                _section('Compact', _compact()),
                const Gap(24),
                _section('Bare icon', _bare()),
                const Gap(24),
                _section('Dark', _dark()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fullPage() {
    return const EmptyState(
      variant: EmptyStateVariant.empty,
      primaryAction: EmptyStateAction(label: 'Create project'),
      secondaryAction: EmptyStateAction(label: 'Import'),
    );
  }

  Widget _noResults() {
    return const EmptyState(
      variant: EmptyStateVariant.noResults,
      primaryAction: EmptyStateAction(label: 'Clear filters'),
    );
  }

  Widget _error() {
    return const EmptyState(
      variant: EmptyStateVariant.errorFallback,
      primaryAction: EmptyStateAction(label: 'Try again'),
      footerAction: EmptyStateAction(
        label: 'Report this',
        variant: ButtonVariant.link,
      ),
    );
  }

  Widget _compact() {
    return const EmptyState(
      size: EmptyStateSize.compact,
      variant: EmptyStateVariant.empty,
      title: Text('Nothing here yet'),
      primaryAction: EmptyStateAction(label: 'Create'),
    );
  }

  Widget _bare() {
    return const EmptyState(
      size: EmptyStateSize.compact,
      variant: EmptyStateVariant.noResults,
      showIconContainer: false,
      title: Text('No matches'),
      description: Text('Try a different term.'),
    );
  }

  Widget _dark() {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: ColoredBox(
        color: ShadcnColors.darkFallback.background,
        child: const SizedBox(
          height: 320,
          child: EmptyState(
            variant: EmptyStateVariant.empty,
            primaryAction: EmptyStateAction(label: 'Create project'),
          ),
        ),
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const Gap(8),
        SizedBox(height: 320, child: child),
      ],
    );
  }
}
