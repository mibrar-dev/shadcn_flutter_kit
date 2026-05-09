// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../util.dart';

/// FormPendingBuilder defines a reusable type for this registry module.
class FormPendingBuilder extends StatelessWidget {
  /// Stores `child` state/configuration for this implementation.
  final Widget? child;

  /// Stores `builder` state/configuration for this implementation.
  final FormPendingWidgetBuilder builder;

  const FormPendingBuilder({super.key, required this.builder, this.child});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return builder(context, const {}, child);
  }
}

/// Type alias for `RepeatedAnimationWidgetBuilder` used by public or internal APIs.
typedef RepeatedAnimationWidgetBuilder =
    Widget Function(BuildContext context, double value, Widget? child);
