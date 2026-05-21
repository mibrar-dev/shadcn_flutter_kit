// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../toast.dart';

/// Controller that displays toast entries using Overlay.
class ToastController {
  final List<_ToastItem> _entries = [];
  final Map<String, _ToastItem> _groupActive = {};
  final Map<String, _ToastItem> _idActive = {};

  /// Stores `defaultDuration` state/configuration for this implementation.
  final Duration defaultDuration;

  /// Stores `animationDuration` state/configuration for this implementation.
  final Duration animationDuration;

  /// Creates a `ToastController` instance.
  ToastController({
    this.defaultDuration = const Duration(seconds: 3),
    this.animationDuration = const Duration(milliseconds: 250),
  });

  List<String> get activeToastIds => List<String>.unmodifiable(_idActive.keys);

  bool containsToast(String id) => _idActive.containsKey(id);

  void dismissById(String id) {
    final item = _idActive[id];
    if (item == null) return;
    _removeItem(item);
  }

  void show({
    required BuildContext context,
    required WidgetBuilder builder,
    Duration? duration,
    double? spacing,
    bool? overlapStackWhenMultiple,
    double? overlapStackOffset,
    bool? pauseAutoDismissWhenMultiple,
    Duration? stackAnimationDuration,
    Curve? stackAnimationCurve,
    int? maxVisibleCount,
    bool? dismissWholeStackWhenMultiple,
    bool? enableStackExpandedMode,
    bool? singleToastPerGroup,
    String? toastId,
    bool? pauseOnHover,
    bool autoDismiss = true,
    Set<ToastSwipeDirection>? dismissDirections,
    double? dismissDragThreshold,
    VoidCallback? onDismissed,
    double? top,
    double? right,
    double? bottom,
    double? left,
  }) {
    final overlay = Overlay.of(context);
    final groupKey = _groupKey(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
    );

    // Same id updates the existing toast in place to avoid remove/add flicker.
    if (toastId != null) {
      final existing = _idActive[toastId];
      if (existing != null && existing.groupKey == groupKey) {
        existing
          ..builder = builder
          ..duration = duration ?? defaultDuration
          ..autoDismiss = autoDismiss
          ..pauseOnHover = pauseOnHover
          ..dismissDirections = dismissDirections
          ..dismissDragThreshold = dismissDragThreshold
          ..onDismissed = onDismissed;
        existing.refreshSignal += 1;
        existing.entry.markNeedsBuild();
        return;
      }
      if (existing != null) {
        _removeItem(existing);
      }
    }

    // Stacking is intentionally removed; keep only one toast per position group.
    final enforceSingle = singleToastPerGroup ?? true;
    if (enforceSingle) {
      _dismissGroupImmediate(groupKey);
    }

    final resolvedDuration = duration ?? defaultDuration;

    late final _ToastItem item;
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (overlayContext) {
        final theme = Theme.of(overlayContext);
        final toastTheme = ComponentTheme.maybeOf<ToastTheme>(overlayContext);
        final padding =
            toastTheme?.padding ??
            EdgeInsets.all(theme.density.baseContentPadding);
        final resolvedPauseOnHover =
            pauseOnHover ?? toastTheme?.pauseOnHover ?? false;
        final resolvedDismissDirections =
            item.dismissDirections ??
            toastTheme?.dismissDirections ??
            _autoDismissDirections(
              top: top,
              right: right,
              bottom: bottom,
              left: left,
            );
        final resolvedDismissDragThreshold =
            item.dismissDragThreshold ??
            toastTheme?.dismissDragThreshold ??
            72.0;

        final isBottomStack = bottom != null;
        final resolvedTop = top ?? (isBottomStack ? null : 32);
        final resolvedBottom = bottom;
        final resolvedLeft = left;
        final resolvedRight = right ?? (left == null ? 24 : null);

        final foregroundColor = theme.colorScheme.foreground;

        return Positioned(
          top: resolvedTop,
          right: resolvedRight,
          bottom: resolvedBottom,
          left: resolvedLeft,
          child: Padding(
            padding: EdgeInsets.zero,
            child: ToastEntry(
              duration: item.duration,
              animationDuration: animationDuration,
              animationCurve: toastTheme?.animationCurve ?? Curves.easeOut,
              pauseOnHover: resolvedPauseOnHover,
              autoDismiss: item.autoDismiss,
              onTap: null,
              dismissSignal: item.dismissSignal,
              refreshSignal: item.refreshSignal,
              onDismissRequest: null,
              dismissDirections: resolvedDismissDirections,
              dismissDragThreshold: resolvedDismissDragThreshold,
              onDismissed: () {
                _removeItem(item);
              },
              child: ToastStackScope(
                data: ToastStackContext(
                  expanded: false,
                  itemExpanded: false,
                  hasMultiple: false,
                  visibleCount: 1,
                  isPrimary: true,
                  toggleExpanded: () {},
                  setExpanded: (_) {},
                  dismissAll: () => _dismissGroupImmediate(groupKey),
                ),
                child: DefaultTextStyle.merge(
                  style: TextStyle(color: foregroundColor),
                  child: IconTheme.merge(
                    data: IconThemeData(color: foregroundColor),
                    child: Container(
                      padding: padding,
                      width: toastTheme?.width,
                      child: item.builder(overlayContext),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    item = _ToastItem(
      entry: entry,
      groupKey: groupKey,
      toastId: toastId,
      builder: builder,
      duration: resolvedDuration,
      autoDismiss: autoDismiss,
      pauseOnHover: pauseOnHover,
      dismissDirections: dismissDirections,
      dismissDragThreshold: dismissDragThreshold,
      onDismissed: onDismissed,
    );

    _entries.add(item);
    _groupActive[groupKey] = item;
    if (toastId != null) {
      _idActive[toastId] = item;
    }

    overlay.insert(entry);
  }

  void _dismissGroupImmediate(String groupKey) {
    final item = _groupActive[groupKey];
    if (item == null) return;
    _removeItem(item);
  }

  void _removeItem(_ToastItem item) {
    if (!_entries.remove(item)) return;
    item.entry.remove();
    final activeForGroup = _groupActive[item.groupKey];
    if (identical(activeForGroup, item)) {
      _groupActive.remove(item.groupKey);
    }
    final id = item.toastId;
    if (id != null) {
      final activeForId = _idActive[id];
      if (identical(activeForId, item)) {
        _idActive.remove(id);
      }
    }
    item.onDismissed?.call();
  }

  String _groupKey({
    required double? top,
    required double? right,
    required double? bottom,
    required double? left,
  }) {
    String encode(double? value) =>
        value == null ? 'n' : value.toStringAsFixed(1);
    return 't:${encode(top)}|r:${encode(right)}|b:${encode(bottom)}|l:${encode(left)}';
  }

  Set<ToastSwipeDirection> _autoDismissDirections({
    required double? top,
    required double? right,
    required double? bottom,
    required double? left,
  }) {
    final directions = <ToastSwipeDirection>{};
    if (top != null) directions.add(ToastSwipeDirection.up);
    if (bottom != null) directions.add(ToastSwipeDirection.down);
    if (left != null && right == null) directions.add(ToastSwipeDirection.left);
    if (right != null && left == null) {
      directions.add(ToastSwipeDirection.right);
    }
    if (directions.isEmpty) {
      directions.addAll(const {
        ToastSwipeDirection.up,
        ToastSwipeDirection.down,
        ToastSwipeDirection.left,
        ToastSwipeDirection.right,
      });
    }
    return directions;
  }
}

class _ToastItem {
  _ToastItem({
    required this.entry,
    required this.groupKey,
    required this.toastId,
    required this.builder,
    required this.duration,
    required this.autoDismiss,
    required this.pauseOnHover,
    required this.dismissDirections,
    required this.dismissDragThreshold,
    required this.onDismissed,
  });

  final OverlayEntry entry;
  final String groupKey;
  final String? toastId;
  WidgetBuilder builder;
  Duration duration;
  bool autoDismiss;
  bool? pauseOnHover;
  Set<ToastSwipeDirection>? dismissDirections;
  double? dismissDragThreshold;
  VoidCallback? onDismissed;
  int dismissSignal = 0;
  int refreshSignal = 0;
}
