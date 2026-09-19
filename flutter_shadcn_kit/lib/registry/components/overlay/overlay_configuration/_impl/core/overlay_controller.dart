// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../overlay_configuration.dart';

/// Controls a single managed overlay presented from an
/// [OverlayConfiguration] — upstream parity with `shadcn_flutter`'s
/// `OverlayController`.
///
/// Registry adaptation: the native upstream completer plumbing is replaced
/// by a [PopoverController]-backed presentation. [show] opens (or, when the
/// open overlay shares the exact runtime type, updates in place via the
/// controller) and [close]/[closeLater] dismiss. [adaptive] is forwarded to
/// [OverlayConfiguration.adaptiveConversion].
class OverlayController extends ChangeNotifier {
  bool _disposed = false;
  DelegatedOverlayCompleter? _completer;
  OverlayConfiguration? _config;
  PopoverController? _popoverController;

  /// The configuration of the currently-open overlay, or `null` if nothing
  /// is open.
  OverlayConfiguration? get config => _config;

  /// Whether there's an open overlay that hasn't completed.
  bool get hasOpenOverlay => _completer != null && !_completer!.isCompleted;

  /// Whether there's a mounted overlay with an animation in progress.
  bool get hasMountedOverlay =>
      _completer != null && !_completer!.isAnimationCompleted;

  /// Shows an overlay using the given [configuration], anchored to
  /// [context], with [builder] as its content.
  ///
  /// [adaptive] is forwarded to [OverlayConfiguration.adaptiveConversion].
  Future<T?> show<T>(
    BuildContext context,
    OverlayConfiguration configuration, {
    required WidgetBuilder builder,
    bool adaptive = true,
  }) {
    final resolved = adaptive
        ? configuration.adaptiveConversion(context)
        : configuration;

    final currentCompleter = _completer;
    if (currentCompleter != null &&
        !currentCompleter.isCompleted &&
        _config != null &&
        resolved.runtimeType == _config!.runtimeType) {
      // Same-type update: close and reopen so the visible overlay always
      // reflects the latest configuration (the registry popover has no
      // live config setter; behaviorally equivalent for callers).
      close();
    } else {
      close();
    }

    final controller = PopoverController();
    _popoverController = controller;
    final completer = DelegatedOverlayCompleter<T?>(controller);
    _completer = completer;
    _config = resolved;
    notifyListeners();

    final presented = resolved.show<T>(context, builder);
    presented.future.then((value) {
      completer._complete(value);
      if (identical(_completer, completer)) {
        _completer = null;
        _config = null;
        _popoverController = null;
        if (!_disposed) notifyListeners();
      }
      return value;
    });
    return completer.future;
  }

  /// Closes the managed overlay, if any.
  ///
  /// Parameters:
  /// - [immediate] (bool, default: false): Skip closing animations when true.
  void close([bool immediate = false]) {
    final completer = _completer;
    _popoverController?.close(immediate);
    completer?._complete();
    _completer = null;
    _config = null;
    _popoverController = null;
    notifyListeners();
  }

  /// Schedules closure of the managed overlay for the next frame.
  void closeLater() {
    final completer = _completer;
    _popoverController?.closeLater();
    _completer = null;
    _config = null;
    _popoverController = null;
    completer?._complete();
    notifyListeners();
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    closeLater();
    super.dispose();
  }
}
