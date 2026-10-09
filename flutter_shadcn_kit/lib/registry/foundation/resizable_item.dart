/// One item managed by a [Resizer].
class ResizableItem {
  double _value;

  /// Minimum size this item can be resized to.
  final double min;

  /// Maximum size this item can be resized to.
  final double max;

  /// Whether this item is currently in collapsed state.
  final bool collapsed;

  /// Size of the item when collapsed. If null, collapsed size is 0.
  final double? collapsedSize;

  /// Whether this item can be resized.
  final bool resizable;

  double? _newValue;
  bool? _newCollapsed;

  ResizableItem({
    required double value,
    this.min = 0,
    this.max = double.infinity,
    this.collapsed = false,
    this.collapsedSize,
    this.resizable = true,
  }) : _value = value;

  /// Whether this item is collapsed after pending resize operations.
  bool get newCollapsed => _newCollapsed ?? collapsed;

  /// The size of this item after pending resize operations.
  double get newValue => _newValue ?? _value;

  /// The current committed size of this item.
  double get value => _value;

  /// Whether a pending value was set by a resize operation.
  bool get hasPendingValue => _newValue != null;

  /// Sets the pending size of this item.
  void setNewValue(double? value) {
    _newValue = value;
  }

  /// Sets the pending collapsed state of this item.
  void setNewCollapsed(bool? value) {
    _newCollapsed = value;
  }

  /// Commits [value] as the new current size.
  void setValue(double value) {
    _value = value;
  }

  /// Clears pending size/collapsed values.
  void resetPending() {
    _newValue = null;
    _newCollapsed = null;
  }

  @override
  String toString() {
    return 'ResizableItem(value: $value, min: $min, max: $max)';
  }
}
