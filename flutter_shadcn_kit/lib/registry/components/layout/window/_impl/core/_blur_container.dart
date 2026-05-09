// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../window.dart';

/// _BlurContainer defines a reusable type for this registry module.
class _BlurContainer extends StatelessWidget {
  const _BlurContainer({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedValueBuilder(
      initialValue: 0.0,
      value: 1.0,
      duration: kDefaultDuration,
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.scale(
            scale: lerpDouble(0.8, 1.0, value)!,
            child: Padding(
              padding: EdgeInsets.all(theme.density.baseGap * theme.scaling),
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colorScheme.border),
                      color: theme.colorScheme.card.withAlpha(100),
                      borderRadius: theme.borderRadiusMd,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
