// Adapted from package:data_widget 0.0.3 (BSD 3-Clause, Copyright 2024 Thito
// Yalasatria Sunarya). See licenses/data_widget.BSD-3-Clause.txt in the kit
// repo. Only the Data / messenger / capture surface used by the registry was
// ported; the Model family, notifier helpers and context extensions were not.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A mixin for data values that decide for themselves whether listeners must
/// rebuild when the value is replaced.
mixin DistinctData {
  /// Whether a dependent should rebuild when [oldData] is replaced by this.
  bool shouldNotify(covariant DistinctData oldData);
}

/// A [DistinctData] that always notifies dependents when replaced.
mixin AlwaysUpdateData implements DistinctData {
  @override
  bool shouldNotify(covariant DistinctData oldData) => true;
}

/// Read-only view of a data holder: finds data of a type for a context.
///
/// Registration of receivers is the messenger's side of the contract and
/// lives in `data_messenger.dart`.
abstract class DataHolder<T> {
  /// Finds data of [type] among the registered receivers for [context].
  T? findData(BuildContext context, Type type);
}

/// An inherited widget that passes a [DataHolder] to its descendants.
abstract class InheritedDataHolderWidget<T> extends InheritedWidget {
  const InheritedDataHolderWidget({required super.child, super.key});

  /// The holder exposed to descendants.
  DataHolder<T> get holder;
}

/// An inherited widget that passes a typed [DataHolder] to its descendants.
class InheritedDataHolder<T> extends InheritedDataHolderWidget<T> {
  @override
  final DataHolder<T> holder;

  const InheritedDataHolder({
    super.key,
    required this.holder,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedDataHolder<T> oldWidget) {
    return oldWidget.holder != holder;
  }
}

/// An inherited widget that passes the root [DataHolder] to its descendants.
class InheritedRootDataHolder extends InheritedDataHolderWidget<dynamic> {
  @override
  final DataHolder<dynamic> holder;

  const InheritedRootDataHolder({
    super.key,
    required this.holder,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant InheritedRootDataHolder oldWidget) {
    return oldWidget.holder != holder;
  }
}

/// An item that can be mixed into [MultiData].
abstract class MultiDataItem {
  /// The compile-time type of the data.
  Type get dataType;

  /// Wraps [child] with the data.
  Widget wrapWidget(Widget child);
}

/// A widget that provides multiple data items to its descendants.
class MultiData extends StatefulWidget {
  /// The data items that will be provided to the descendants.
  final List<MultiDataItem> data;

  /// The child widget.
  final Widget child;

  const MultiData({super.key, required this.data, required this.child});

  @override
  State<MultiData> createState() => _MultiDataState();
}

class _MultiDataState extends State<MultiData> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Widget result = KeyedSubtree(key: _key, child: widget.child);
    for (final data in widget.data) {
      final Type dataType = data.dataType;
      assert(dataType != dynamic, 'Data must have a type');
      result = data.wrapWidget(result);
    }
    return result;
  }
}

/// A widget that provides [T] data to its descendants.
///
/// Use [Data.inherit] to provide a value; use [Data.boundary] to stop a value
/// of type [T] from reaching the subtree below.
class Data<T> extends StatelessWidget implements MultiDataItem {
  final T? _data;

  /// The child widget.
  final Widget? child;

  /// Provides [_data] to the subtree below [child].
  const Data.inherit({super.key, required T this._data, this.child});

  /// Stops [T] data from the ancestors from reaching the descendants.
  const Data.boundary({super.key, this.child}) : _data = null;

  /// The provided data.
  T get data {
    assert(_data != null, 'No Data<$T> found in context');
    return _data!;
  }

  @override
  Widget wrapWidget(Widget child) {
    return _InheritedData<T>._internal(key: key, data: _data, child: child);
  }

  @override
  Widget build(BuildContext context) {
    assert(dataType != dynamic, 'Data must have a type');
    return _InheritedData<T>._internal(
      data: _data,
      child: child ?? const SizedBox(),
    );
  }

  /// Finds and listens to data of type [T] from [context]. Throws if absent.
  static T of<T>(BuildContext context) {
    final data = maybeOf<T>(context);
    assert(data != null, 'No Data<$T> found in context');
    return data!;
  }

  /// Finds and listens to data of type [T] from [context].
  static T? maybeOf<T>(BuildContext context) {
    assert(context.mounted, 'The context must be mounted');
    final widget = context
        .dependOnInheritedWidgetOfExactType<_InheritedData<T>>();
    if (widget == null) {
      return null;
    }
    return widget.data;
  }

  /// Finds data of type [T] from [context] without listening for changes.
  static T find<T>(BuildContext context) {
    final data = maybeFind<T>(context);
    assert(data != null, 'No Data<$T> found in context');
    return data!;
  }

  /// Finds data of type [T] from [context] without listening for changes.
  static T? maybeFind<T>(BuildContext context) {
    assert(context.mounted, 'The context must be mounted');
    final widget = context.findAncestorWidgetOfExactType<Data<T>>();
    if (widget == null) {
      return null;
    }
    return widget.data;
  }

  /// Finds forwarded data of type [T] registered by a forwardable-data
  /// ancestor through a data messenger.
  static T? maybeFindMessenger<T>(BuildContext context) {
    assert(context.mounted, 'The context must be mounted');
    InheritedDataHolderWidget? holder = context
        .findAncestorWidgetOfExactType<InheritedDataHolder<T>>();
    holder ??= context.findAncestorWidgetOfExactType<InheritedRootDataHolder>();
    if (holder != null) {
      return holder.holder.findData(context, T);
    }
    return null;
  }

  /// Finds the outermost data of type [T] above [context].
  static T? maybeFindRoot<T>(BuildContext context) {
    assert(context.mounted, 'The context must be mounted');
    T? found;
    context.visitAncestorElements((element) {
      if (element.widget is Data<T>) {
        var data = (element.widget as Data<T>)._data;
        if (data != null) {
          found = data;
        }
      }
      return true;
    });
    return found;
  }

  /// Captures every distinct data type above [from] up to (excluding) [to] so
  /// that it can be re-injected into another subtree with [CapturedData.wrap].
  static CapturedData capture({
    required BuildContext from,
    required BuildContext? to,
  }) {
    if (from == to) {
      return CapturedData._([]);
    }
    final data = <_InheritedData>[];
    final Set<Type> dataTypes = <Type>{};
    late bool debugDidFindAncestor;
    assert(() {
      debugDidFindAncestor = to == null;
      return true;
    }());

    from.visitAncestorElements((ancestor) {
      if (ancestor == to) {
        assert(() {
          debugDidFindAncestor = true;
          return true;
        }());
        return false;
      }
      if (ancestor is InheritedElement && ancestor.widget is _InheritedData) {
        final dataWidget = ancestor.widget as _InheritedData;
        final Type dataType = dataWidget.dataType;
        if (!dataTypes.contains(dataType)) {
          dataTypes.add(dataType);
          data.add(dataWidget);
        }
      }
      return true;
    });

    assert(
      debugDidFindAncestor,
      'The provided `to` context must be an ancestor of the `from` context.',
    );

    return CapturedData._(data);
  }

  @override
  Type get dataType => T;
}

class _InheritedData<T> extends InheritedWidget {
  final T? data;

  Type get dataType => T;

  const _InheritedData._internal({
    super.key,
    required this.data,
    required super.child,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<T>('data', data));
  }

  @override
  String toStringShort() {
    return key == null ? 'Data<$T>' : 'Data<$T>-$key';
  }

  @override
  bool updateShouldNotify(covariant _InheritedData<T> oldWidget) {
    if (data is DistinctData && oldWidget.data is DistinctData) {
      return (data as DistinctData).shouldNotify(
        oldWidget.data as DistinctData,
      );
    }
    return oldWidget.data != data;
  }

  Widget? wrap(Widget child, BuildContext context) {
    _InheritedData<T>? ancestor = context
        .dependOnInheritedWidgetOfExactType<_InheritedData<T>>();
    // Same type value already above: no need to wrap again.
    if (identical(this, ancestor)) {
      return null;
    }
    final data = this.data;
    if (data == null) {
      return Data<T>.boundary(child: child);
    }
    return Data<T>.inherit(data: data, child: child);
  }
}

/// Data captured from another context, ready to be re-injected with [wrap].
class CapturedData {
  CapturedData._(this._data);

  final List<_InheritedData> _data;

  /// Wraps [child] with the captured data.
  Widget wrap(Widget child) {
    return _CaptureAllData(data: _data, child: child);
  }
}

class _CaptureAllData extends StatelessWidget {
  const _CaptureAllData({required this.data, required this.child});

  final List<_InheritedData> data;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget result = child;
    for (final data in data) {
      final wrap = data.wrap(result, context);
      if (wrap == null) {
        continue;
      }
      result = wrap;
    }
    return result;
  }
}
