// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../toast.dart';

/// Expansion behavior modes for toast notification stacks — upstream parity
/// with `shadcn_flutter`'s `ExpandMode`.
///
/// The registry toast keeps one toast per position group (no visual stack),
/// so this is accepted/stored for API parity (e.g. on [ToastLayer] and
/// [UpstreamToastEntry]) and documented; stacking behavior itself is owned
/// by the registry redesign.
enum ExpandMode {
  /// Toast stack is always expanded, showing all notifications simultaneously.
  alwaysExpanded,

  /// Toast stack expands when the mouse cursor hovers over the area.
  expandOnHover,

  /// Toast stack expands when the user taps the notification area.
  expandOnTap,

  /// Toast expansion is completely disabled.
  disabled,
}

/// Builder function for custom toast widgets — upstream parity with
/// `shadcn_flutter`'s `ToastBuilder`.
///
/// Takes a [BuildContext] and [ToastOverlay] instance, returning the widget
/// that represents the toast's visual content.
typedef ToastBuilder = Widget Function(
  BuildContext context,
  ToastOverlay overlay,
);

/// Upstream-shaped toast entry configuration — adapter over the registry
/// toast redesign.
///
/// Upstream `shadcn_flutter` models a toast as a `ToastEntry` value passed
/// to a `ToastLayer`; the registry models it as a `ToastEntry` widget
/// driven by [ToastController]. This class carries the upstream-shaped
/// fields ([builder], [location], [dismissible], [curve], [duration],
/// [onClosed], [showDuration]) and adapts them onto [showToast] via [show],
/// so upstream-style call sites keep compiling.
///
/// When shown inside a [ToastLayer], upstream defaults apply
/// ([ToastLocation.bottomRight], 5s); otherwise the registry
/// [ToastController] path is used (see [showToast]).
class UpstreamToastEntry {
  /// Builder function to create the toast widget.
  final ToastBuilder builder;

  /// Position where the toast should appear.
  final ToastLocation location;

  /// Whether the toast can be dismissed by user interaction.
  final bool dismissible;

  /// Animation curve for entry/exit transitions.
  final Curve curve;

  /// Duration for entry/exit animations.
  final Duration duration;

  /// Callback invoked when the toast is closed.
  final VoidCallback? onClosed;

  /// How long the toast remains visible before auto-dismissing.
  /// When set, takes precedence over the registry `duration`.
  final Duration? showDuration;

  /// Creates an upstream-shaped toast entry.
  const UpstreamToastEntry({
    required this.builder,
    this.location = ToastLocation.bottomRight,
    this.dismissible = true,
    this.curve = Curves.easeOutCubic,
    this.duration = const Duration(milliseconds: 500),
    this.onClosed,
    this.showDuration = const Duration(seconds: 5),
  });

  /// Shows this entry via [showToast], adapting upstream fields onto the
  /// registry controller (or [ToastLayer] defaults when present).
  void show(BuildContext context) {
    showToast(
      context: context,
      builder: builder,
      location: location,
      duration: duration,
      dismissible: dismissible,
      curve: curve,
      entryDuration: duration,
      onClosed: onClosed,
      showDuration: showDuration,
    );
  }
}

/// Ancestor widget providing upstream toast defaults — compat layer over
/// the registry redesign.
///
/// Upstream `shadcn_flutter` requires a `ToastLayer` above `showToast` call
/// sites (asserting its presence) and defaults to
/// ([ToastLocation.bottomRight], 5s). The registry redesign uses a
/// [ToastController] singleton defaulting to ([ToastLocation.topRight], 3s).
///
/// This widget bridges both models: place it high in the widget tree to opt
/// into upstream defaults — [showToast] honors [defaultLocation] and
/// [defaultShowDuration] when a [ToastLayer] is present and falls back to
/// the registry defaults otherwise. [expandMode] and [maxStackedEntries]
/// are accepted/stored for API parity (the registry keeps one toast per
/// position group; see [ExpandMode]).
///
/// ```dart
/// ToastLayer(
///   child: MyAppContent(),
/// );
/// ```
class ToastLayer extends StatelessWidget {
  /// The child widget to wrap with toast defaults.
  final Widget child;

  /// Default toast location when [showToast] omits one. Upstream default:
  /// [ToastLocation.bottomRight].
  final ToastLocation defaultLocation;

  /// Default auto-dismiss timeout when [showToast] omits one. Upstream
  /// default: 5 seconds.
  final Duration defaultShowDuration;

  /// Stack expansion behavior (accepted for upstream parity; stored).
  final ExpandMode expandMode;

  /// Maximum stacked entries (accepted for upstream parity; stored).
  final int maxStackedEntries;

  /// Creates a [ToastLayer].
  const ToastLayer({
    super.key,
    required this.child,
    this.defaultLocation = ToastLocation.bottomRight,
    this.defaultShowDuration = const Duration(seconds: 5),
    this.expandMode = ExpandMode.expandOnHover,
    this.maxStackedEntries = 3,
  });

  /// Returns the nearest ancestor [ToastLayer], or null if none exists.
  static ToastLayer? maybeOf(BuildContext context) {
    return context.findAncestorWidgetOfExactType<ToastLayer>();
  }

  @override
  Widget build(BuildContext context) => child;
}
