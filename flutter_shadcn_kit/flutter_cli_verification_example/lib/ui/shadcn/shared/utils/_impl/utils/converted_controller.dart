part of '../../util.dart';

/// ConvertedController defines a reusable type for this registry module.
class ConvertedController<F, T> extends ChangeNotifier
    implements ComponentController<T> {
/// Stores `_other` state/configuration for this implementation.
  final ValueNotifier<F> _other;
/// Stores `_convert` state/configuration for this implementation.
  final BiDirectionalConvert<F, T> _convert;

/// Stores `_value` state/configuration for this implementation.
  T _value;
/// Stores `_isUpdating` state/configuration for this implementation.
  bool _isUpdating = false;

  /// Creates a [ConvertedController].
  ConvertedController(ValueNotifier<F> other, BiDirectionalConvert<F, T> convert)
      : _other = other,
        _convert = convert,
        _value = convert.convertA(other.value) {
    _other.addListener(_onOtherValueChanged);
  }

/// Executes `_onOtherValueChanged` behavior for this component/composite.
  void _onOtherValueChanged() {
    if (_isUpdating) {
      return;
    }
    _isUpdating = true;
    try {
      _value = _convert.convertA(_other.value);
      notifyListeners();
    } finally {
      _isUpdating = false;
    }
  }

/// Executes `_onValueChanged` behavior for this component/composite.
  void _onValueChanged() {
    if (_isUpdating) {
      return;
    }
    _isUpdating = true;
    try {
      _other.value = _convert.convertB(_value);
    } finally {
      _isUpdating = false;
    }
  }

  @override
/// Stores `value` state/configuration for this implementation.
  T get value => _value;

  @override
/// Executes `value` behavior for this component/composite.
  set value(T newValue) {
    if (newValue == _value) {
      return;
    }
    _value = newValue;
    notifyListeners();
    _onValueChanged();
  }

  @override
/// Executes `dispose` behavior for this component/composite.
  void dispose() {
    _other.removeListener(_onOtherValueChanged);
    super.dispose();
  }
}
