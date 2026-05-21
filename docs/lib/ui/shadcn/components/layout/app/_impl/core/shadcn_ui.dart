// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../app.dart';

/// A widget that applies shadcn text + icon styles to descendants.
class ShadcnUI extends StatelessWidget {
  const ShadcnUI({super.key, this.textStyle, required this.child});

  final TextStyle? textStyle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDarkMode = scheme.brightness == Brightness.dark;
    final fallbackIconColor = isDarkMode
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF000000);

    Color pickReadableIconColor(Color preferred) {
      final background = scheme.background;
      final contrastDistance =
          (preferred.computeLuminance() - background.computeLuminance()).abs();
      if (contrastDistance >= 0.30) {
        return preferred;
      }
      final foregroundDistance =
          (scheme.foreground.computeLuminance() - background.computeLuminance())
              .abs();
      if (foregroundDistance >= 0.30) {
        return scheme.foreground;
      }
      return fallbackIconColor;
    }

    final iconColor = pickReadableIconColor(scheme.secondaryForeground);
    return AnimatedDefaultTextStyle(
      style:
          textStyle ??
          theme.typography.sans.copyWith(color: theme.colorScheme.foreground),
      duration: kDefaultDuration,
      child: IconTheme(
        data: IconThemeData(color: iconColor),
        child: child,
      ),
    );
  }
}
