// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../carousel.dart';

/// A controller for the carousel.
class CarouselController extends Listenable {
  /// Controller dependency used to coordinate carousel behavior.
  final AnimationQueueController _controller = AnimationQueueController();

  /// Whether the carousel should animate.
  bool get shouldAnimate => _controller.shouldTick;

  /// The current value of the controller.
  double get value => _controller.value;

  /// Jumps to the next item.
  void next() {
    _controller.value = (_controller.value + 1).roundToDouble();
  }

  /// Jumps to the previous item.
  void previous() {
    _controller.value = (_controller.value - 1).roundToDouble();
  }

  /// Animates to the next item.
  void animateNext(Duration duration, [Curve curve = Curves.easeInOut]) {
    _controller.push(
      AnimationRequest(
        (_controller.value + 1).roundToDouble(),
        duration,
        curve,
      ),
      false,
    );
  }

  /// Animates to the previous item.
  void animatePrevious(Duration duration, [Curve curve = Curves.easeInOut]) {
    _controller.push(
      AnimationRequest(
        (_controller.value - 1).roundToDouble(),
        duration,
        curve,
      ),
      false,
    );
  }

  /// Snaps the current value to the nearest integer.
  void snap() {
    _controller.value = _controller.value.roundToDouble();
  }

  /// Animates the current value to the nearest integer.
  void animateSnap(Duration duration, [Curve curve = Curves.easeInOut]) {
    _controller.push(
      AnimationRequest(_controller.value.roundToDouble(), duration, curve),
    );
  }

  /// Jumps to the specified value.
  void jumpTo(double value) {
    _controller.value = value;
  }

  /// Animates to the specified value.
  void animateTo(
    double value,
    Duration duration, [
    Curve curve = Curves.linear,
  ]) {
    _controller.push(AnimationRequest(value, duration, curve), false);
  }

  /// Returns the current index accounting for wrap behavior.
  double getCurrentIndex(int? itemCount) {
    if (itemCount == null) {
      return _controller.value;
    }
    return wrapDouble(_controller.value, 0, itemCount.toDouble());
  }

  /// Advances controller time.
  void tick(Duration delta) {
    _controller.tick(delta);
  }

  /// Implements `addListener` behavior for carousel.
  @override
  void addListener(VoidCallback listener) {
    _controller.addListener(listener);
  }

  /// Implements `removeListener` behavior for carousel.
  @override
  void removeListener(VoidCallback listener) {
    _controller.removeListener(listener);
  }

  /// Disposes the controller.
  void dispose() {
    _controller.dispose();
  }
}
