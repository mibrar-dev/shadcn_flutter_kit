// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tabs.dart';

/// TabChildWidget defines a reusable type for this registry module.
class TabChildWidget extends StatelessWidget with TabChild {
  /// The child widget to display.
  final Widget child;

  @override
  /// Whether this tab uses indexed positioning.
  ///
  /// Defaults to `false` unless specified in the constructor.
  final bool indexed;

  /// Creates a tab child widget.
  ///
  /// Parameters:
  /// - [child]: The widget to wrap (required)
  /// - [indexed]: Whether to use indexed positioning (defaults to `false`)
  const TabChildWidget({super.key, required this.child, this.indexed = false});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return child;
  }
}

/// A keyed tab child widget identified by a custom key value.
///
/// Extends [TabChildWidget] with [KeyedTabChild] to support tab identification
/// via custom keys rather than positional indices. The key value determines
/// tab selection and tracking.
///
/// Type parameter [T] is the type of the key value.
