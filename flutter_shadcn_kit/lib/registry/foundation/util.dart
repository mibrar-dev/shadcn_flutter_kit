// Small generic helpers shared across the registry: function typedefs,
// conversion helpers, value caching, list/iterable joining and numeric
// utilities. Nothing here depends on the theme or on any component.

import 'package:flutter/widgets.dart';

/// A test over a value of type [T].
typedef Predicate<T> = bool Function(T value);

/// A transformation of a value of type [T].
typedef UnaryOperator<T> = T Function(T value);

/// A callback that receives a [BuildContext].
typedef ContextedCallback = void Function(BuildContext context);

/// A value callback that also receives a [BuildContext].
typedef ContextedValueChanged<T> = void Function(BuildContext context, T value);

/// A builder that ignores its (up to ten) optional arguments.
typedef NeverWidgetBuilder =
    Widget Function([
      dynamic,
      dynamic,
      dynamic,
      dynamic,
      dynamic,
      dynamic,
      dynamic,
      dynamic,
      dynamic,
      dynamic,
    ]);

/// A callback that invokes an [Intent] with an optional context.
typedef OnContextInvokeCallback<T extends Intent> =
    Object? Function(T intent, [BuildContext? context]);

/// Converts a value from [F] to [T].
typedef Convert<F, T> = T Function(F value);

/// A pair of opposite conversions between [A] and [B].
class BiDirectionalConvert<A, B> {
  /// Converts from A to B.
  final Convert<A, B> aToB;

  /// Converts from B to A.
  final Convert<B, A> bToA;

  BiDirectionalConvert(this.aToB, this.bToA);

  /// Converts [value] from A to B.
  B convertA(A value) => aToB(value);

  /// Converts [value] from B to A.
  A convertB(B value) => bToA(value);

  @override
  String toString() => 'BiDirectionalConvert($aToB, $bToA)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BiDirectionalConvert<A, B> &&
        other.aToB == aToB &&
        other.bToA == bToA;
  }

  @override
  int get hashCode => Object.hash(aToB, bToA);
}

/// A value that decides whether a dependent must rebuild when it changes.
mixin CachedValue {
  /// Whether a cached dependent must rebuild when [oldValue] is replaced.
  bool shouldRebuild(covariant CachedValue oldValue);
}

/// A widget that caches its builder result until [CachedValueWidget.value]
/// reports a rebuild (or simply changes, when it is not a [CachedValue]).
class CachedValueWidget<T> extends StatefulWidget {
  /// The value to cache and pass to the builder.
  final T value;

  /// Builds the widget for the current value.
  final Widget Function(BuildContext context, T value) builder;

  const CachedValueWidget({
    super.key,
    required this.value,
    required this.builder,
  });

  @override
  State<CachedValueWidget<T>> createState() => _CachedValueWidgetState<T>();
}

class _CachedValueWidgetState<T> extends State<CachedValueWidget<T>> {
  Widget? _cachedWidget;

  @override
  void didUpdateWidget(covariant CachedValueWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final value = widget.value;
    final oldValue = oldWidget.value;
    if (value is CachedValue && oldValue is CachedValue) {
      if (value.shouldRebuild(oldValue)) {
        _cachedWidget = null;
      }
    } else if (widget.value != oldWidget.value) {
      _cachedWidget = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _cachedWidget ??= widget.builder(context, widget.value);
    return _cachedWidget!;
  }
}

/// An [Intent] action backed by a plain callback.
class CallbackContextAction<T extends Intent> extends ContextAction<T> {
  /// The callback invoked by the action.
  final OnContextInvokeCallback onInvoke;

  CallbackContextAction({required this.onInvoke});

  @override
  Object? invoke(T intent, [BuildContext? context]) {
    return onInvoke(intent, context);
  }
}

/// List helpers used across the registry.
extension ListExtension<T> on List<T> {
  /// Moves [element] to [targetIndex], inserting it when absent.
  bool swapItem(T element, int targetIndex) {
    int currentIndex = indexOf(element);
    if (currentIndex == -1) {
      insert(targetIndex.clamp(0, length), element);
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
}

/// Joins a list of widgets with [separator], keeping a [List] result.
extension Joinable<T extends Widget> on List<T> {
  /// Returns a new list with [separator] inserted between every two items.
  List<T> joinSeparator(T separator) {
    final result = <T>[];
    for (int i = 0; i < length; i++) {
      if (i > 0) {
        result.add(separator);
      }
      result.add(this[i]);
    }
    return result;
  }
}

/// Joins an iterable of widgets with [separator], keeping an [Iterable].
extension IterableExtension<T> on Iterable<T> {
  /// Returns a lazy iterable with [separator] inserted between every two
  /// items.
  Iterable<T> joinSeparator(T separator) {
    return map((e) => [separator, e]).expand((element) => element).skip(1);
  }
}

/// Invokes [intent] on the action of the currently focused widget.
///
/// Returns whether the action was enabled and its result. When nothing has
/// focus, returns `(false, null)`.
(bool enabled, Object? invokeResult) invokeActionOnFocusedWidget(
  Intent intent,
) {
  final context = primaryFocus?.context;
  if (context != null) {
    final action = Actions.maybeFind<Intent>(context, intent: intent);
    if (action != null) {
      final (bool enabled, Object? invokeResult) = Actions.of(
        context,
      ).invokeActionIfEnabled(action, intent);
      return (enabled, invokeResult);
    }
  }
  return (false, null);
}

/// Maps [value] from a `[min, max]` range back to `0.0..1.0`.
double unlerpDouble(double value, double min, double max) {
  return (value - min) / (max - min);
}

/// Wraps [value] into the `[min, max)` range.
double wrapDouble(double value, double min, double max) {
  final range = max - min;
  if (range == 0) {
    return min;
  }
  return (value - min) % range + min;
}
