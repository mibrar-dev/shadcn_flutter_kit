// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../resizable.dart';

/// FlexibleResizablePaneController defines a reusable type for this registry module.
class FlexibleResizablePaneController extends ChangeNotifier
    with ResizablePaneController {
  /// Stores `_flex` state/configuration for this implementation.
  double _flex;

  /// Stores `_collapsed` state/configuration for this implementation.
  bool _collapsed = false;

  /// Creates a [FlexibleResizablePaneController].
  ///
  /// Parameters:
  /// - [_flex] (`double`, required): Initial flex factor.
  /// - [collapsed] (`bool`, default: `false`): Initial collapsed state.
  FlexibleResizablePaneController(this._flex, {bool collapsed = false})
    : _collapsed = collapsed;

  @override
  /// Stores `value` state/configuration for this implementation.
  double get value => _flex;

  @override
  /// Stores `collapsed` state/configuration for this implementation.
  bool get collapsed => _collapsed;

  /// Executes `flex` behavior for this component/composite.
  set flex(double value) {
    _flex = value;
    notifyListeners();
  }

  @override
  /// Executes `collapse` behavior for this component/composite.
  void collapse() {
    _collapsed = true;
    notifyListeners();
  }

  @override
  /// Executes `expand` behavior for this component/composite.
  void expand() {
    _collapsed = false;
    notifyListeners();
  }

  @override
  void resize(
    double newSize,
    double paneSize, {
    double? minSize,
    double? maxSize,
  }) {
    _flex = newSize.clamp(minSize ?? 0, maxSize ?? double.infinity) / paneSize;
    notifyListeners();
  }

  @override
  /// Executes `computeSize` behavior for this component/composite.
  double computeSize(double paneSize, {double? minSize, double? maxSize}) {
    return (_flex * paneSize).clamp(minSize ?? 0, maxSize ?? double.infinity);
  }
}
