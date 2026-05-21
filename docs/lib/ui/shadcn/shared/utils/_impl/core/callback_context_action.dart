// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../util.dart';

/// CallbackContextAction defines a reusable type for this registry module.
class CallbackContextAction<T extends Intent> extends ContextAction<T> {
  /// Stores `onInvoke` state/configuration for this implementation.
  final OnContextInvokeCallback onInvoke;
  CallbackContextAction({required this.onInvoke});

  @override
  /// Executes `invoke` behavior for this component/composite.
  Object? invoke(T intent, [BuildContext? context]) {
    return onInvoke(intent, context);
  }
}

/// Type alias for `OnContextedCallback` used by public or internal APIs.
typedef OnContextedCallback<T extends Intent> =
    Object? Function(T intent, [BuildContext? context]);
