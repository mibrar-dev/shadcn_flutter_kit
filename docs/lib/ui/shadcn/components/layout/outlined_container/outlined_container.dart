// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../../shared/primitives/animated_value_builder.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/border_utils.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/geometry_extensions.dart';
import '../../../shared/utils/style_value.dart';

part '_impl/themes/base/outlined_container_theme.dart';
part '_impl/core/dashed_painters.dart';
part '_impl/core/dashed_container_properties.dart';
part '_impl/core/dashed_line_properties.dart';
part '_impl/core/dashed_container.dart';
part '_impl/core/dashed_line.dart';
part '_impl/state/_outlined_container_state.dart';
part '_impl/core/outlined_container_2.dart';
part '_impl/core/dashed_painter.dart';

/// SurfaceBlur defines a reusable type for this registry module.
class SurfaceBlur extends StatelessWidget {
  /// Creates a `SurfaceBlur` instance.
  const SurfaceBlur({
    super.key,
    required this.child,
    required this.surfaceBlur,
    this.borderRadius,
  });

  /// Stores `child` state/configuration for this implementation.
  final Widget child;

  /// Stores `surfaceBlur` state/configuration for this implementation.
  final double surfaceBlur;

  /// Stores `borderRadius` state/configuration for this implementation.
  final BorderRadiusGeometry? borderRadius;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    if (surfaceBlur <= 0) {
      return child;
    }
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: surfaceBlur, sigmaY: surfaceBlur),
        child: child,
      ),
    );
  }
}
