// Gallery preview for the `group` component: absolute placement, pinning to
// each edge, a `fromRect` child and a dark palette. Widgets-only; the docs app
// embeds [GroupPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'group.dart';

/// Renders the group gallery.
class GroupPreview extends StatelessWidget {
  /// Creates the preview.
  const GroupPreview({super.key});

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
                _section('Absolute placement', _stage(theme)),
                const Gap(24),
                _section('Dark', _dark(theme)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stage(ShadcnThemeData theme) {
    return SizedBox(
      width: 260,
      height: 160,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colors.muted,
          borderRadius: theme.borderRadiusMd,
        ),
        child: Group(
          children: <Widget>[
            GroupPositioned(top: 12, left: 12, child: _chip(theme, 'top-left')),
            GroupPositioned(
              top: 12,
              right: 12,
              child: _chip(theme, 'top-right'),
            ),
            GroupPositioned.fromRect(
              rect: const Rect.fromLTWH(60, 60, 140, 48),
              child: _chip(theme, 'fromRect'),
            ),
            GroupPositioned(
              bottom: 12,
              left: 12,
              child: _chip(theme, 'bottom-left'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dark(ShadcnThemeData theme) {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: Builder(builder: (context) => _stage(ShadcnTheme.of(context))),
    );
  }

  Widget _chip(ShadcnThemeData theme, String label) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.card,
        border: Border.all(color: theme.colors.border),
        borderRadius: theme.borderRadiusSm,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(label),
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
        child,
      ],
    );
  }
}
