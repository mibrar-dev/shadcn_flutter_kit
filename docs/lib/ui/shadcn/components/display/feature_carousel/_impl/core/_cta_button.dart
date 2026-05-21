// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../feature_carousel.dart';

/// Internal helper class used by the feature carousel component implementation.
class _CtaButton extends StatelessWidget {
  /// Creates `_CtaButton` for configuring or rendering feature carousel.
  const _CtaButton({
    required this.label,
    required this.theme,
    required this.pressed,
    required this.onPressed,
    required this.onPressedChanged,
  });

  /// Text/content element used by `_CtaButton` when composing its visual layout.
  final String label;

  /// Theme override or resolved theme data for feature carousel.
  final FeatureCarouselThemeData theme;

  /// Input parameter used by `_CtaButton` during rendering and behavior handling.
  final bool pressed;

  /// Callback invoked by feature carousel when `onPressed` is triggered.
  final VoidCallback onPressed;

  /// Callback invoked by feature carousel when `onPressedChanged` is triggered.
  final ValueChanged<bool> onPressedChanged;

  /// Builds the widget tree for feature carousel.
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onPressed,
        onTapDown: (_) => onPressedChanged(true),
        onTapUp: (_) => onPressedChanged(false),
        onTapCancel: () => onPressedChanged(false),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 90),
          scale: pressed ? 0.98 : 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            height: theme.ctaHeight,
            constraints: BoxConstraints(minWidth: theme.ctaMinWidth),
            padding: EdgeInsets.symmetric(
              horizontal: theme.ctaHorizontalPadding,
            ),
            decoration: BoxDecoration(
              color: theme.ctaBackground,
              borderRadius: BorderRadius.circular(theme.ctaHeight / 2),
              border: Border.all(color: theme.ctaBorderColor, width: 1),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.ctaTextColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
