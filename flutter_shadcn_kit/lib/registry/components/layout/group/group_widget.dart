// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

part '_impl/core/group_parent_data.dart';
part '_impl/core/render_group.dart';
part '_impl/core/group_positioned.dart';

/// A manual layout surface for positioning children with explicit offsets.
class GroupWidget extends MultiChildRenderObjectWidget {
  /// Creates a [GroupWidget].
  const GroupWidget({super.key, super.children});

  @override
  /// Executes `createRenderObject` behavior for this component/composite.
  RenderObject createRenderObject(BuildContext context) {
    return RenderGroup();
  }

  @override
  /// Executes `updateRenderObject` behavior for this component/composite.
  void updateRenderObject(BuildContext context, RenderGroup renderObject) {}
}

/// Places a child inside a [GroupWidget] at precise coordinates.
