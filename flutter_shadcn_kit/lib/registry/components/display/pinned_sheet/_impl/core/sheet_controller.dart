// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../pinned_sheet.dart';

/// Controls a [PinnedSheet]: reads its current position and drives it to a
/// [SheetStage] (upstream parity with `shadcn_flutter`'s `SheetController`).
///
/// The controller is a [ChangeNotifier] that notifies whenever the sheet's
/// position changes. [stage] returns a live stage that can be compared
/// against derived stages:
///
/// ```dart
/// final controller = SheetController();
/// ...
/// PinnedSheet(controller: controller, child: ...);
/// ...
/// controller.stage = SheetStage.expanded();
/// controller.animateTo(SheetStage.fixed(120),
///     duration: kDefaultDuration, curve: Curves.easeOut);
/// if (controller.stage == (SheetStage.expanded() - SheetStage.fixed(100))) { ... }
/// ```
class SheetController extends ChangeNotifier {
  _PinnedSheetState? _state;

  /// Whether this controller is attached to a live [PinnedSheet].
  bool get isAttached => _state != null;

  void _attach(_PinnedSheetState state) {
    _state = state;
    notifyListeners();
  }

  void _detach(_PinnedSheetState state) {
    if (identical(_state, state)) {
      _state = null;
    }
  }

  void _notify() => notifyListeners();

  /// The current visible extent of the sheet, in logical pixels.
  double get offset => _state?.currentOffset ?? 0.0;

  /// The current visible extent of the sheet, as a fraction (0..1) of its axis.
  double get fraction => _state?.currentFraction ?? 0.0;

  /// Whether the sheet is showing at all.
  bool get isOpen => fraction > 0;

  /// The current position as a live stage that can be compared against other
  /// (possibly derived) stages using `==`.
  SheetStage get stage => _state != null
      ? _AttachedSheetStage(_state!)
      : const SheetStage.closed();

  /// Assigning a stage animates the sheet to it with the default
  /// duration/curve.
  set stage(SheetStage stage) {
    animateTo(stage);
  }

  /// Animates the sheet to [stage].
  Future<void> animateTo(
    SheetStage stage, {
    Duration duration = kDefaultDuration,
    Curve curve = Curves.linear,
  }) {
    final state = _state;
    if (state == null) return Future<void>.value();
    return state.animateToStage(stage, duration: duration, curve: curve);
  }

  /// Immediately jumps the sheet to [stage] with no animation.
  void jumpTo(SheetStage stage) {
    _state?.jumpToStage(stage);
  }

  /// Animates the sheet fully open ([SheetStage.expanded]).
  Future<void> open({
    Duration duration = kDefaultDuration,
    Curve curve = Curves.easeOut,
  }) =>
      animateTo(const SheetStage.expanded(), duration: duration, curve: curve);

  /// Animates the sheet fully closed ([SheetStage.closed]).
  Future<void> close({
    Duration duration = kDefaultDuration,
    Curve curve = Curves.easeOut,
  }) =>
      animateTo(const SheetStage.closed(), duration: duration, curve: curve);
}
