// Adapted from package:data_widget 0.0.3 (BSD 3-Clause, Copyright 2024 Thito
// Yalasatria Sunarya). See licenses/data_widget.BSD-3-Clause.txt in the kit
// repo. Messenger side of the Data API built on `data.dart`.

import 'dart:collection';

import 'package:flutter/widgets.dart';

import 'data.dart';

/// Registration side of a data messenger: stores forwardable receivers so
/// [Data.maybeFindMessenger] can find them from other subtrees.
abstract class DataReceiverRegistry<T> {
  /// Registers a [receiver] that provides data of type [T].
  void register(ForwardableDataState<T> receiver);

  /// Unregisters a previously registered [receiver].
  void unregister(ForwardableDataState<T> receiver);
}

/// The root of a data messenger tree. Stores every kind of forwardable data
/// and provides it to descendants it reaches from the query context.
class DataMessengerRoot extends StatefulWidget {
  /// The child widget.
  final Widget child;

  const DataMessengerRoot({super.key, required this.child});

  @override
  State<DataMessengerRoot> createState() => _DataMessengerRootState();
}

class _DataMessengerRootState extends State<DataMessengerRoot>
    implements DataHolder<dynamic>, DataReceiverRegistry<dynamic> {
  final Map<Type, LinkedHashSet<ForwardableDataState>> _senders = {};

  @override
  void register(ForwardableDataState receiver) {
    final type = receiver.dataType;
    _senders.putIfAbsent(type, () => LinkedHashSet());
    _senders[type]!.add(receiver);
  }

  @override
  void unregister(ForwardableDataState receiver) {
    final type = receiver.dataType;
    _senders[type]?.remove(receiver);
  }

  @override
  dynamic findData(BuildContext context, Type type) {
    final receivers = _senders[type];
    if (receivers == null) {
      return null;
    }
    for (final receiver in receivers) {
      if (_isAncestorOf(receiver, context)) {
        return receiver.widget.data;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return InheritedRootDataHolder(holder: this, child: widget.child);
  }
}

/// A messenger that stores forwardable data of type [T] and provides it to
/// descendants. Only data of the same type registers here.
class DataMessenger<T> extends StatefulWidget {
  /// The child widget.
  final Widget child;

  const DataMessenger({super.key, required this.child});

  @override
  State<DataMessenger<T>> createState() => _DataMessengerState<T>();
}

class _DataMessengerState<T> extends State<DataMessenger<T>>
    implements DataHolder<T>, DataReceiverRegistry<T> {
  final LinkedHashSet<ForwardableDataState<T>> _receivers = LinkedHashSet();

  @override
  void register(ForwardableDataState<T> receiver) {
    _receivers.add(receiver);
  }

  @override
  void unregister(ForwardableDataState<T> receiver) {
    _receivers.remove(receiver);
  }

  @override
  T? findData(BuildContext context, Type type) {
    for (final receiver in _receivers) {
      if (_isAncestorOf(receiver, context)) {
        return receiver.widget.data;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return InheritedDataHolder<T>(holder: this, child: widget.child);
  }
}

/// Whether [context] is a descendant of [receiver]'s element.
bool _isAncestorOf(ForwardableDataState receiver, BuildContext context) {
  var didFindData = false;
  receiver.context.visitAncestorElements((element) {
    if (element == context) {
      didFindData = true;
      return false;
    }
    return true;
  });
  return didFindData;
}

/// A widget that provides [data] to the nearest ancestor messenger so it can
/// be found from other subtrees with [Data.maybeFindMessenger].
class ForwardableData<T> extends StatefulWidget {
  /// The data that will be forwarded.
  final T data;

  /// The child widget.
  final Widget child;

  const ForwardableData({super.key, required this.data, required this.child});

  @override
  State<ForwardableData<T>> createState() => ForwardableDataState<T>();
}

/// The state of a [ForwardableData] widget.
class ForwardableDataState<T> extends State<ForwardableData<T>> {
  DataHolder? _messenger;

  /// The compile-time type of the data.
  Type get dataType => T;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    InheritedDataHolderWidget? inheritedDataHolder = context
        .dependOnInheritedWidgetOfExactType<InheritedDataHolder<T>>();
    inheritedDataHolder ??= context
        .dependOnInheritedWidgetOfExactType<InheritedRootDataHolder>();
    final messenger = inheritedDataHolder?.holder;
    if (messenger != _messenger) {
      if (_messenger is DataReceiverRegistry) {
        (_messenger as DataReceiverRegistry).unregister(this);
      }
      _messenger = messenger;
      if (messenger is DataReceiverRegistry) {
        (messenger as DataReceiverRegistry).register(this);
      }
    }
  }

  @override
  void dispose() {
    if (_messenger is DataReceiverRegistry) {
      (_messenger as DataReceiverRegistry).unregister(this);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Data<T>.inherit(
      data: widget.data,
      child: DataMessenger<T>(child: widget.child),
    );
  }
}
