// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../refresh_trigger.dart';

/// RefreshTrigger defines a reusable type for this registry module.
class RefreshTrigger extends StatefulWidget {
  /// Default indicator builder that creates a spinning progress indicator.
  ///
  /// Displays a platform-appropriate circular progress indicator that rotates
  /// based on pull extent and animates during refresh.
  static Widget defaultIndicatorBuilder(
    BuildContext context,
    RefreshTriggerStage stage,
  ) {
    return DefaultRefreshIndicator(stage: stage);
  }

  /// Minimum pull extent required to trigger refresh.
  ///
  /// Pull distance must exceed this value to activate the refresh callback.
  /// If null, uses theme or default value.
  final double? minExtent;

  /// Maximum pull extent allowed.
  ///
  /// Limits how far the user can pull to prevent excessive stretching.
  /// If null, uses theme or default value.
  final double? maxExtent;

  /// Callback invoked when refresh is triggered.
  ///
  /// Should return a Future that completes when the refresh operation finishes.
  /// While the Future is pending, the refresh indicator shows loading state.
  final Future<void> Function()? onRefresh;

  /// The scrollable child widget being refreshed.
  final Widget child;

  /// Direction of the pull gesture.
  ///
  /// Defaults to [Axis.vertical] for standard top-down pull-to-refresh.
  final Axis direction;

  /// Whether to reverse the pull direction.
  ///
  /// If true, pull gesture is inverted (e.g., pull down instead of up).
  final bool reverse;

  /// Custom builder for the refresh indicator.
  ///
  /// If null, uses [defaultIndicatorBuilder].
  final RefreshIndicatorBuilder? indicatorBuilder;

  /// Animation curve for extent changes.
  ///
  /// Controls how the pull extent animates during interactions.
  final Curve? curve;

  /// Duration for the completion animation.
  ///
  /// Time to display the completion state before hiding the indicator.
  final Duration? completeDuration;

  /// Creates a [RefreshTrigger] with pull-to-refresh functionality.
  ///
  /// Wraps the provided child widget with refresh gesture detection and
  /// visual indicator management.
  ///
  /// Parameters:
  /// - [child] (Widget, required): Scrollable content to wrap with refresh capability
  /// - [onRefresh] (`Future<void> Function()?`, optional): Async callback triggered on refresh
  /// - [direction] (Axis, default: Axis.vertical): Pull gesture direction
  /// - [reverse] (bool, default: false): Whether to trigger from opposite direction
  /// - [minExtent] (double?, optional): Minimum pull distance to trigger refresh
  /// - [maxExtent] (double?, optional): Maximum allowed pull distance
  /// - [indicatorBuilder] (RefreshIndicatorBuilder?, optional): Custom indicator widget builder
  /// - [curve] (Curve?, optional): Animation curve for refresh transitions
  /// - [completeDuration] (Duration?, optional): Duration of completion animation
  ///
  /// The [onRefresh] callback should return a Future that completes when the
  /// refresh operation is finished. During this time, a loading indicator will be shown.
  ///
  /// Example:
  /// ```dart
  /// RefreshTrigger(
  ///   onRefresh: () async {
  ///     final newData = await fetchDataFromAPI();
  ///     setState(() => items = newData);
  ///   },
  ///   minExtent: 60,
  ///   direction: Axis.vertical,
  ///   child: ListView(children: widgets),
  /// )
  /// ```
  const RefreshTrigger({
    super.key,
    this.minExtent,
    this.maxExtent,
    this.onRefresh,
    this.direction = Axis.vertical,
    this.reverse = false,
    this.indicatorBuilder,
    this.curve,
    this.completeDuration,
    required this.child,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<RefreshTrigger> createState() => RefreshTriggerState();
}

/// Default refresh indicator widget with platform-appropriate styling.
///
/// Displays a circular progress indicator that responds to pull gestures
/// and animates during the refresh lifecycle stages.
