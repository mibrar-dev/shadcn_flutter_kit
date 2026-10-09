// Widgets-only preview gallery for the `skeleton` component.
//
// Shows the loading/loaded switch, a custom radius, a themed leg and dark
// tokens.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'skeleton.dart';

/// Preview entry point used by the docs gallery.
class SkeletonPreview extends StatefulWidget {
  /// Creates the preview.
  const SkeletonPreview({super.key});

  @override
  State<SkeletonPreview> createState() => _SkeletonPreviewState();
}

class _SkeletonPreviewState extends State<SkeletonPreview> {
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return ShadcnTheme(
      data: const ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _loading ? 'loading' : 'loaded',
              style: TextStyle(color: colors.foreground),
            ),
            const SizedBox(height: 16),
            ClickableToggle(
              label: 'toggle',
              onTap: () => setState(() => _loading = !_loading),
            ),
            const SizedBox(height: 16),
            Skeleton(enabled: _loading, child: _card(colors)),
            const SizedBox(height: 16),
            const Text('circle'),
            const SizedBox(height: 8),
            const Skeleton(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              child: SizedBox(width: 80, height: 80, child: SizedBox.shrink()),
            ),
            const SizedBox(height: 16),
            const Text('scoped theme leg (accent sweep, slow)'),
            const SizedBox(height: 8),
            ComponentTheme<SkeletonTheme>(
              data: const SkeletonTheme(
                fromColor: ThemedColor.ref(ColorRef.accent),
                toColor: ThemedColor.ref(ColorRef.secondary),
                duration: Duration(milliseconds: 1600),
              ),
              child: Skeleton(enabled: _loading, child: _card(colors)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(ShadcnColors colors) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Card title', style: TextStyle(color: colors.foreground)),
          const SizedBox(height: 8),
          Text(
            'Body copy that keeps its box while loading.',
            style: TextStyle(color: colors.mutedForeground),
          ),
        ],
      ),
    );
  }
}

/// Minimal tap target so the preview stays free of component dependencies.
class ClickableToggle extends StatelessWidget {
  /// Creates a toggle row.
  const ClickableToggle({super.key, required this.label, required this.onTap});

  /// Row label.
  final String label;

  /// Called on tap.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: colors.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label, style: TextStyle(color: colors.foreground)),
      ),
    );
  }
}
