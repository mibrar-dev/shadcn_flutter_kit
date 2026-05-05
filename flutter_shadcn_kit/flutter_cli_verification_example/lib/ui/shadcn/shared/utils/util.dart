import 'dart:async';
import 'dart:math';

import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../primitives/form_control.dart';
import '../primitives/form_value_supplier.dart';

part '_impl/core/bi_directional_convert.dart';
part '_impl/core/cached_value_widget.dart';
part '_impl/core/callback_context_action.dart';
part '_impl/core/captured_wrapper.dart';
part '_impl/core/context_callback_action.dart';
part '_impl/core/form_pending_builder.dart';
part '_impl/core/repeated_animation_builder.dart';
part '_impl/core/separated_flex.dart';
part '_impl/core/time_of_day.dart';
part '_impl/state/__cached_value_widget_state.dart';
part '_impl/state/__captured_wrapper_state.dart';
part '_impl/state/__repeated_animation_builder_state.dart';
part '_impl/state/__separated_flex_state.dart';
part '_impl/utils/converted_controller.dart';

/// Type alias for `Predicate` used by public or internal APIs.
typedef Predicate<T> = bool Function(T value);
/// Type alias for `UnaryOperator` used by public or internal APIs.
typedef UnaryOperator<T> = T Function(T value);
/// Type alias for `BinaryOperator` used by public or internal APIs.
typedef BinaryOperator<T> = T Function(T a, T b);
/// Type alias for `ContextedCallback` used by public or internal APIs.
typedef ContextedCallback = void Function(BuildContext context);
/// Type alias for `ContextedValueChanged` used by public or internal APIs.
typedef ContextedValueChanged<T> = void Function(BuildContext context, T value);
/// Type alias for `SearchPredicate` used by public or internal APIs.
typedef SearchPredicate<T> = double Function(T value, String query);
/// Type alias for `NeverWidgetBuilder` used by public or internal APIs.
typedef NeverWidgetBuilder = Widget Function(
    [dynamic,
    dynamic,
    dynamic,
    dynamic,
    dynamic,
    dynamic,
    dynamic,
    dynamic,
    dynamic,
    dynamic]);

/// Mixin for values that need custom rebuild logic.
mixin CachedValue {
  /// Determines if the widget should rebuild when value changes.
  bool shouldRebuild(covariant CachedValue oldValue);
}

/// Callback signature for context actions.
typedef OnContextInvokeCallback<T extends Intent> = Object? Function(T intent,
    [BuildContext? context]);

/// A safe lerp utility class.
class SafeLerp<T> {
  final T? Function(T? a, T? b, double t) nullableLerp;
  const SafeLerp(this.nullableLerp);

/// Executes `lerp` behavior for this component/composite.
  T lerp(T a, T b, double t) {
    T? result = nullableLerp(a, b, t);
    assert(result != null, 'Unsafe lerp');
    return result!;
  }
}

/// Unlerp a double value from a min-max range.
double unlerpDouble(double value, double min, double max) {
  return (value - min) / (max - min);
}

/// Extension on nullable lerp functions.
extension SafeLerpExtension<T> on T? Function(T? a, T? b, double t) {
/// Executes `nonNull` behavior for this component/composite.
  T nonNull(T a, T b, double t) {
    T? result = this(a, b, t);
    assert(result != null);
    return result!;
  }
}

/// Extension methods for List operations.
extension ListExtension<T> on List<T> {
/// Executes `indexOfOrNull` behavior for this component/composite.
  int? indexOfOrNull(T obj, [int start = 0]) {
    int index = indexOf(obj, start);
    return index == -1 ? null : index;
  }

/// Executes `lastIndexOfOrNull` behavior for this component/composite.
  int? lastIndexOfOrNull(T obj, [int? start]) {
    int index = lastIndexOf(obj, start);
    return index == -1 ? null : index;
  }

/// Executes `indexWhereOrNull` behavior for this component/composite.
  int? indexWhereOrNull(Predicate<T> test, [int start = 0]) {
    int index = indexWhere(test, start);
    return index == -1 ? null : index;
  }

/// Executes `lastIndexWhereOrNull` behavior for this component/composite.
  int? lastIndexWhereOrNull(Predicate<T> test, [int? start]) {
    int index = lastIndexWhere(test, start);
    return index == -1 ? null : index;
  }

/// Executes `swapItem` behavior for this component/composite.
  bool swapItem(T element, int targetIndex) {
    int currentIndex = indexOf(element);
    if (currentIndex == -1) {
      insert(targetIndex, element);
      return true;
    }
    if (currentIndex == targetIndex) {
      return true;
    }
    if (targetIndex >= length) {
      remove(element);
      add(element);
      return true;
    }
    removeAt(currentIndex);
    if (currentIndex < targetIndex) {
      insert(targetIndex - 1, element);
    } else {
      insert(targetIndex, element);
    }
    return true;
  }

/// Executes `swapItemWhere` behavior for this component/composite.
  bool swapItemWhere(Predicate<T> test, int targetIndex) {
    int currentIndex = indexWhere(test);
    if (currentIndex == -1) {
      return false;
    }
/// Stores `element` state/configuration for this implementation.
    T element = this[currentIndex];
    return swapItem(element, targetIndex);
  }

/// Executes `optGet` behavior for this component/composite.
  T? optGet(int index) {
    if (index < 0 || index >= length) {
      return null;
    }
    return this[index];
  }
}

/// Extension methods for FutureOr transformation.
extension FutureOrExtension<T> on FutureOr<T> {
  FutureOr<R> map<R>(R Function(T value) transform) {
    if (this is Future<T>) {
      return (this as Future<T>).then(transform);
    }
    return transform(this as T);
  }

  FutureOr<R> flatMap<R>(FutureOr<R> Function(T value) transform) {
    if (this is Future<T>) {
      return (this as Future<T>).then(transform);
    }
    return transform(this as T);
  }

  FutureOr<R> then<R>(FutureOr<R> Function(T value) transform) {
    if (this is Future<T>) {
      return (this as Future<T>).then(transform);
    }
    return transform(this as T);
  }

  FutureOr<T> catchError(Function onError,
      {bool Function(Object error)? test}) {
    if (this is Future<T>) {
      return (this as Future<T>).catchError(onError, test: test);
    }
    return this;
  }
}

/// Executes `wrapDouble` behavior for this component/composite.
double wrapDouble(double value, double min, double max) {
/// Stores `range` state/configuration for this implementation.
  final range = max - min;
  if (range == 0) {
    return min;
  }
  return (value - min) % range + min;
}

/// Widget tree change detector
class WidgetTreeChangeDetector extends StatefulWidget {
/// Stores `child` state/configuration for this implementation.
  final Widget child;
  final void Function() onWidgetTreeChange;

/// Creates a `WidgetTreeChangeDetector` instance.
  const WidgetTreeChangeDetector({
    super.key,
    required this.child,
    required this.onWidgetTreeChange,
  });

  @override
/// Executes `createState` behavior for this component/composite.
  WidgetTreeChangeDetectorState createState() =>
      WidgetTreeChangeDetectorState();
}

/// WidgetTreeChangeDetectorState defines a reusable type for this registry module.
class WidgetTreeChangeDetectorState extends State<WidgetTreeChangeDetector> {
  @override
/// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    widget.onWidgetTreeChange();
  }

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Executes `gap` behavior for this component/composite.
Widget gap(double gap, {double? crossGap}) {
  return Gap(
    gap,
    crossAxisExtent: crossGap,
  );
}

/// Extension for joining lists of widgets.
extension Joinable<T extends Widget> on List<T> {
/// Executes `joinSeparator` behavior for this component/composite.
  List<T> joinSeparator(T separator) {
/// Stores `result` state/configuration for this implementation.
    List<T> result = [];
    for (int i = 0; i < length; i++) {
      if (i > 0) {
        result.add(separator);
      }
      result.add(this[i]);
    }
    return result;
  }
}

extension IterableExtension<T> on Iterable<T> {
/// Executes `joinSeparator` behavior for this component/composite.
  Iterable<T> joinSeparator(T separator) {
/// Executes `map` behavior for this component/composite.
    return map((e) => [separator, e]).expand((element) => element).skip(1);
  }

/// Executes `buildSeparator` behavior for this component/composite.
  Iterable<T> buildSeparator(ValueGetter<T> separator) {
/// Executes `map` behavior for this component/composite.
    return map((e) => [separator(), e]).expand((element) => element).skip(1);
  }
}

/// An iterable that inserts a separator between each widget.
Iterable<Widget> join(Iterable<Widget> widgets, Widget separator) {
  return SeparatedIterable(widgets, separator);
}

/// Iterable that lazily inserts separators between widgets.
class SeparatedIterable extends Iterable<Widget> {
/// Stores `_widgets` state/configuration for this implementation.
  final Iterable<Widget> _widgets;
/// Stores `_separator` state/configuration for this implementation.
  final Widget _separator;

  SeparatedIterable(this._widgets, this._separator);

  @override
  Iterator<Widget> get iterator => _SeparatedIterator(_widgets.iterator, _separator);
}

/// _SeparatedIterator defines a reusable type for this registry module.
class _SeparatedIterator implements Iterator<Widget> {
/// Stores `_iterator` state/configuration for this implementation.
  final Iterator<Widget> _iterator;
/// Stores `_separator` state/configuration for this implementation.
  final Widget _separator;
/// Stores `_isOnSeparator` state/configuration for this implementation.
  bool _isOnSeparator = false;
/// Stores `_hasNext` state/configuration for this implementation.
  bool _hasNext = true;
/// Stores `_current` state/configuration for this implementation.
  Widget? _current;

/// Creates a `_SeparatedIterator` instance.
  _SeparatedIterator(this._iterator, this._separator) {
    _hasNext = _iterator.moveNext();
  }

  @override
/// Stores `current` state/configuration for this implementation.
  Widget get current => _current!;

  @override
/// Executes `moveNext` behavior for this component/composite.
  bool moveNext() {
    if (!_hasNext) {
      return false;
    }

    if (_isOnSeparator) {
      _current = _iterator.current;
      _isOnSeparator = false;
      _hasNext = _iterator.moveNext();
      return true;
    }

    _current = _iterator.current;
    if (!_iterator.moveNext()) {
      _hasNext = false;
      return true;
    }

    _isOnSeparator = true;
    _current = _separator;
    return true;
  }
}

/// Mutates a separated list in place when the source list changes.
void mutateSeparated(List<Widget> source, List<Widget> separated, Widget separator) {
/// Stores `expectedLength` state/configuration for this implementation.
  final expectedLength = source.isEmpty ? 0 : source.length * 2 - 1;
  
  if (separated.length != expectedLength) {
    separated.clear();
    separated.addAll(join(source, separator));
    return;
  }

  for (var i = 0; i < source.length; i++) {
/// Stores `separatedIndex` state/configuration for this implementation.
    final separatedIndex = i * 2;
    if (separated[separatedIndex] != source[i]) {
      separated[separatedIndex] = source[i];
    }
  }
}

/// A widget that caches a computed value.
