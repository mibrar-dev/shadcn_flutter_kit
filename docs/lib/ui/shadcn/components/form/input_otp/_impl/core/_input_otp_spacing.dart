// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../input_otp.dart';

/// _InputOTPSpacing renders form UI and wires input behavior.
class _InputOTPSpacing extends StatelessWidget {
  const _InputOTPSpacing();

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<InputOTPTheme>(context);
    return SizedBox(
      width:
          compTheme?.spacing ?? theme.density.baseGap * theme.scaling * gapSm,
    );
  }
}
