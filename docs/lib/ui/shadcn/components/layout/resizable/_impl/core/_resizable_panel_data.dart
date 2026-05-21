// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../resizable.dart';

/// _ResizablePanelData defines a reusable type for this registry module.
class _ResizablePanelData {
  /// Stores `state` state/configuration for this implementation.
  final _ResizablePanelState state;

  /// Stores `index` state/configuration for this implementation.
  final int index;

  _ResizablePanelData(this.state, this.index);

  /// Stores `direction` state/configuration for this implementation.
  Axis get direction => state.widget.direction;

  /// Executes `attach` behavior for this component/composite.
  void attach(ResizablePaneController controller) {
    state.attachController(controller);
  }

  /// Executes `detach` behavior for this component/composite.
  void detach(ResizablePaneController controller) {
    state.detachController(controller);
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _ResizablePanelData &&
        other.state == state &&
        other.index == index;
  }

  @override
  int get hashCode {
    return Object.hash(state, index);
  }
}
