// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../resizable.dart';

/// AbsoluteResizablePaneController defines a reusable type for this registry module.
class AbsoluteResizablePaneController extends ChangeNotifier
    with ResizablePaneController {
  /// Stores `_size` state/configuration for this implementation.
  double _size;

  /// Stores `_collapsed` state/configuration for this implementation.
  bool _collapsed = false;

  /// Stores `_state` state/configuration for this implementation.
  _ResizablePaneState? _state;

  @override
  /// Stores `_paneState` state/configuration for this implementation.
  _ResizablePaneState? get _paneState => _state;

  @override
  /// Executes `_paneState` behavior for this component/composite.
  set _paneState(_ResizablePaneState? value) {
    _state = value;
  }

  /// Creates an [AbsoluteResizablePaneController].
  ///
  /// Parameters:
  /// - [_size] (`double`, required): Initial absolute size in pixels.
  /// - [collapsed] (`bool`, default: `false`): Initial collapsed state.
  AbsoluteResizablePaneController(this._size, {bool collapsed = false})
    : _collapsed = collapsed;

  @override
  /// Stores `value` state/configuration for this implementation.
  double get value => _size;

  @override
  /// Stores `collapsed` state/configuration for this implementation.
  bool get collapsed => _collapsed;

  /// Executes `size` behavior for this component/composite.
  set size(double value) {
    _size = value;
    notifyListeners();
  }

  @override
  /// Executes `collapse` behavior for this component/composite.
  void collapse() {
    if (_collapsed) return;
    _collapsed = true;
    notifyListeners();
  }

  @override
  /// Executes `expand` behavior for this component/composite.
  void expand() {
    if (!_collapsed) return;
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
    _size = newSize.clamp(minSize ?? 0, maxSize ?? double.infinity);
    notifyListeners();
  }

  @override
  /// Executes `computeSize` behavior for this component/composite.
  double computeSize(double paneSize, {double? minSize, double? maxSize}) {
    return _size.clamp(minSize ?? 0, maxSize ?? double.infinity);
  }
}
