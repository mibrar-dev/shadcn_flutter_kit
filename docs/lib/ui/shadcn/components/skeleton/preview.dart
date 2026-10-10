// Named examples for the `skeleton` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'skeleton.dart';

/// Tap target that flips the loading state of the example.
class _SkeletonSkeletonToggle extends StatelessWidget {
  const _SkeletonSkeletonToggle({
    required this.loading,
    required this.onPressed,
  });

  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = ShadcnTheme.of(context).colors;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: colors.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          loading ? 'loading - tap to load' : 'loaded - tap to load',
          style: TextStyle(color: colors.foreground),
        ),
      ),
    );
  }
}

/// A text block that swaps between the shimmer and its loaded content.
class _SkeletonSkeletonBlock extends StatefulWidget {
  const _SkeletonSkeletonBlock();

  @override
  State<_SkeletonSkeletonBlock> createState() => _SkeletonSkeletonBlockState();
}

class _SkeletonSkeletonBlockState extends State<_SkeletonSkeletonBlock> {
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _SkeletonSkeletonToggle(
          loading: _loading,
          onPressed: () => setState(() => _loading = !_loading),
        ),
        Gap(theme.spacing.lg),
        Skeleton(
          enabled: _loading,
          child: Container(
            width: 260,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Card title',
                  style: TextStyle(color: theme.colors.foreground),
                ),
                Gap(theme.spacing.sm),
                Text(
                  'Body copy that keeps its box while loading.',
                  style: TextStyle(color: theme.colors.mutedForeground),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// A circular skeleton next to two bars.
class _SkeletonSkeletonCard extends StatelessWidget {
  const _SkeletonSkeletonCard();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Skeleton(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          child: SizedBox(width: 80, height: 80),
        ),
        Gap(theme.spacing.lg),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 180,
              child: Skeleton(
                child: Text(
                  'Title',
                  style: TextStyle(color: theme.colors.foreground),
                ),
              ),
            ),
            Gap(theme.spacing.sm),
            SizedBox(
              width: 140,
              child: Skeleton(
                child: Text(
                  'Supporting copy',
                  style: TextStyle(color: theme.colors.mutedForeground),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _skeletonDefault(BuildContext context) => const _SkeletonSkeletonBlock();

Widget _skeletonCard(BuildContext context) => const _SkeletonSkeletonCard();

/// Named docs examples for `skeleton`; the first entry is the default.
const List<ComponentPreview> skeletonPreviews = <ComponentPreview>[
  ComponentPreview('Default', _skeletonDefault),
  ComponentPreview('Card', _skeletonCard),
];
