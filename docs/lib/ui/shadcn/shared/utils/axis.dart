// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

part '_impl/core/axis_alignment.dart';
part '_impl/core/axis_alignment_directional.dart';
part '_impl/core/axis_alignment_geometry.dart';
part '_impl/core/axis_insets.dart';
part '_impl/core/axis_insets_directional.dart';
part '_impl/core/axis_insets_geometry.dart';

/// Represents a directional axis (up/down/start/end) that can be resolved to
/// a concrete [AxisDirection] based on [TextDirection].
enum AxisDirectional {
  up,
  down,
  start,
  end;

  /// Resolves this directional axis to a concrete [AxisDirection].
  AxisDirection resolve(TextDirection textDirection) {
    return switch ((this, textDirection)) {
      (AxisDirectional.up, _) => AxisDirection.up,
      (AxisDirectional.down, _) => AxisDirection.down,
      (AxisDirectional.start, TextDirection.ltr) => AxisDirection.left,
      (AxisDirectional.start, TextDirection.rtl) => AxisDirection.right,
      (AxisDirectional.end, TextDirection.ltr) => AxisDirection.right,
      (AxisDirectional.end, TextDirection.rtl) => AxisDirection.left,
    };
  }

  /// Returns the reversed directional axis.
  AxisDirectional get reversed => switch (this) {
    AxisDirectional.up => AxisDirectional.down,
    AxisDirectional.down => AxisDirectional.up,
    AxisDirectional.start => AxisDirectional.end,
    AxisDirectional.end => AxisDirectional.start,
  };
}

/// Base class for axis alignments that can resolve based on [TextDirection].
