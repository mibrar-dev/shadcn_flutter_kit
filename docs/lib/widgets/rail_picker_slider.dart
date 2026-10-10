// A slider whose drags stay local until release (apply-on-select).
//
// The registry `Slider` reports every drag frame through `onChanged`; wiring
// that straight to the theme model would rebuild the whole site per frame
// (hover/drag jank). `DraftSlider` shows each frame locally and calls
// [onCommit] exactly once per interaction: on pointer release, or when
// [flush] is called (the picker's `Done` button, covering keyboard edits and
// releases outside the thumb). Pointer cancel and popup dismissal discard
// the draft without committing: there is deliberately no settle timer, so a
// draft can never commit while its popup is closing.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/components/slider/slider.dart';

/// A single-value slider that commits once per interaction.
class DraftSlider extends StatefulWidget {
  /// Creates a draft slider around the last committed [value].
  const DraftSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onCommit,
    this.onDraft,
  });

  /// The last committed value (what the site shows).
  final double value;

  /// The domain minimum.
  final double min;

  /// The domain maximum.
  final double max;

  /// Called once per interaction with the settled value.
  final ValueChanged<double> onCommit;

  /// Called for every drag frame with the local draft (for popup labels).
  final ValueChanged<double>? onDraft;

  @override
  State<DraftSlider> createState() => DraftSliderState();
}

/// The draft-slider state; [flush] is called by the picker's `Done` button.
class DraftSliderState extends State<DraftSlider> {
  late double _draft = widget.value;

  /// The value the thumb currently shows (committed or mid-drag).
  double get draft => _draft;

  void _edit(double next) {
    setState(() => _draft = next);
    widget.onDraft?.call(next);
  }

  /// Commits the draft when it differs from the last committed value.
  ///
  /// Safe to call when clean (a no-op) and only while mounted: the owning
  /// picker calls it from its `Done` button, and dismissal unmounts (and
  /// thereby discards the draft) instead.
  void flush() {
    if (_draft != widget.value) {
      widget.onCommit(_draft);
    }
  }

  void _discard() {
    if (_draft != widget.value) {
      setState(() => _draft = widget.value);
    }
  }

  @override
  void didUpdateWidget(covariant DraftSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    // An external commit (a preset tap): adopt it and drop a pending draft.
    // The parent already refreshes its own labels in the same `setState`,
    // so no `onDraft` call here (it would `setState` during build).
    if (widget.value != oldWidget.value) {
      _draft = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (_) => flush(),
      onPointerCancel: (_) => _discard(),
      child: Slider(
        value: _draft,
        min: widget.min,
        max: widget.max,
        onChanged: _edit,
      ),
    );
  }
}
