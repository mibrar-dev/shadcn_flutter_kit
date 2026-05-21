// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../refresh_trigger.dart';

/// DefaultRefreshIndicator defines a reusable type for this registry module.
class DefaultRefreshIndicator extends StatefulWidget {
  /// Current refresh trigger stage.
  final RefreshTriggerStage stage;

  /// Creates a default refresh indicator.
  const DefaultRefreshIndicator({super.key, required this.stage});

  @override
  /// Executes `createState` behavior for this component/composite.
  State<DefaultRefreshIndicator> createState() =>
      _DefaultRefreshIndicatorState();
}
