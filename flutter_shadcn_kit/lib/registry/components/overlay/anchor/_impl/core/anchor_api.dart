// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../anchor.dart';

/// Describes an anchor point that overlays (popovers, menus, tooltips) can
/// position themselves relative to, and optionally track as it moves
/// (upstream parity with `shadcn_flutter`'s `Anchor`).
abstract class Anchor {
  /// Creates an [Anchor].
  const Anchor();

  /// Starts a live subscription to this anchor's position/visibility.
  AnchorSubscription subscribe();

  /// Fills in any defaults this anchor needs from [context] — the
  /// [BuildContext] of whatever `show()` call is about to use this anchor.
  ///
  /// The base implementation just returns `this` (most anchors don't need
  /// anything from the calling context); [ContextAnchor] overrides this to
  /// substitute [context] when it wasn't given one explicitly.
  Anchor resolve(BuildContext context) => this;
}

/// A live handle on an [Anchor]'s position/visibility, obtained via
/// [Anchor.subscribe] (upstream parity).
///
/// [Listenable] listeners are notified whenever the anchor may have moved,
/// resized, or changed visibility. There's no explicit dispose method —
/// implementations stop their internal work once the last listener is
/// removed.
abstract class AnchorSubscription implements Listenable {
  /// Whether the anchor currently resolves to a live, mounted render object.
  bool get isVisible;

  /// The anchor's current box size, or null if not currently resolvable.
  Size? get anchorSize;

  /// Computes the transform that maps a point in the anchor's local
  /// coordinate space into [source]'s local coordinate space.
  ///
  /// [source] and the anchor are generally not ancestor/descendant of each
  /// other (the anchor lives in the "normal" widget tree, [source] lives in
  /// a separate overlay-entry render tree), so [RenderObject.getTransformTo]
  /// can't be used directly between them.
  Matrix4 computeTransform(RenderObject source);

  /// Whether this subscription supports tracking the anchor through the
  /// compositing pipeline (see [currentAnchorBox]).
  ///
  /// When true, the popover positions itself against the anchor's live
  /// position every scene build — zero-lag, and with margin/invert
  /// re-evaluated during scroll — instead of relying on a per-frame ticker +
  /// re-layout. Defaults to false; [_LinkedAnchorSubscription] enables it.
  bool get supportsCompositeTracking => false;

  /// The anchor's currently-registered [RenderBox], or null if it can't be
  /// resolved right now. Only meaningful when [supportsCompositeTracking]
  /// is true.
  RenderBox? get currentAnchorBox => null;
}

/// Computes the transform from [anchorBox]'s local coordinate space into
/// [source]'s local coordinate space, for two render objects that aren't
/// necessarily ancestor/descendant of each other (upstream parity).
Matrix4 anchorTransformRelativeTo(RenderBox anchorBox, RenderObject source) {
  final Matrix4 anchorToGlobal = anchorBox.getTransformTo(null);
  final Matrix4 sourceToGlobal = source.getTransformTo(null);
  final Matrix4 globalToSource = Matrix4.copy(sourceToGlobal)..invert();
  return globalToSource.multiplied(anchorToGlobal);
}

/// An [Anchor] resolved from a plain [BuildContext] (upstream parity).
///
/// If [context] is null (`const ContextAnchor()`), it's resolved by the
/// consumer to whatever [BuildContext] the `show()` call itself received.
class ContextAnchor extends Anchor {
  /// The context to anchor to, or null to use the consumer's own context.
  final BuildContext? context;

  /// Creates a [ContextAnchor].
  const ContextAnchor([this.context]);

  @override
  AnchorSubscription subscribe() => _ContextAnchorSubscription(context);

  @override
  Anchor resolve(BuildContext context) =>
      this.context == null ? ContextAnchor(context) : this;
}

/// An [Anchor] resolved dynamically through an [OverlayAnchorRegistry], via
/// the key an [OverlayAnchor] widget was registered with (upstream parity).
///
/// The registry is resolved from the [BuildContext] passed to a `show()` call
/// (see [resolve]) so the anchor connects to the nearest [OverlayAnchorScope];
/// pass [registry] explicitly to target a specific one.
class LinkedAnchor extends Anchor {
  /// The registry key, matching an [OverlayAnchor.anchor].
  final Object key;

  /// The registry this anchor is bound to. When null it is filled in by
  /// [resolve] from the calling context's nearest [OverlayAnchorScope].
  final OverlayAnchorRegistry? registry;

  /// Creates a [LinkedAnchor].
  const LinkedAnchor(this.key, {this.registry});

  @override
  Anchor resolve(BuildContext context) => registry != null
      ? this
      : LinkedAnchor(key, registry: OverlayAnchorRegistry.of(context));

  @override
  AnchorSubscription subscribe() =>
      _LinkedAnchorSubscription(key, registry ?? OverlayAnchorRegistry.global);
}

/// [ContextAnchor]'s subscription (upstream parity).
///
/// There's no reliable "about to move/be removed" hook for an arbitrary
/// [BuildContext], so this polls every frame via a standalone [Ticker]
/// (not tied to any [TickerProvider]/vsync) while it has listeners.
class _ContextAnchorSubscription extends ChangeNotifier
    implements AnchorSubscription {
  final BuildContext? context;
  late final Ticker _ticker;

  _ContextAnchorSubscription(this.context) {
    _ticker = Ticker(_onTick);
  }

  void _onTick(Duration elapsed) => notifyListeners();

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    if (hasListeners && !_ticker.isActive) _ticker.start();
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners && _ticker.isActive) _ticker.stop();
  }

  RenderBox? get _box {
    final ctx = context;
    if (ctx == null) return null;
    try {
      // ignore: invalid_use_of_protected_member
      final renderObject = ctx.findRenderObject();
      return renderObject is RenderBox ? renderObject : null;
    } catch (_) {
      return null;
    }
  }

  @override
  bool get isVisible => _box != null;

  @override
  bool get supportsCompositeTracking => false;

  @override
  RenderBox? get currentAnchorBox => _box;

  @override
  Size? get anchorSize {
    final box = _box;
    if (box == null || !box.attached || !box.hasSize) return null;
    return box.size;
  }

  @override
  Matrix4 computeTransform(RenderObject source) {
    final box = _box;
    if (box == null || !box.attached) return Matrix4.identity();
    return anchorTransformRelativeTo(box, source);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}

/// [LinkedAnchor]'s subscription (upstream parity).
///
/// Resolves the anchor from [OverlayAnchorRegistry] on every read, so it
/// self-heals if the anchor's render object is swapped for a new instance.
/// Carries no ticker: enables [supportsCompositeTracking] so overlays track
/// the anchor's live position through the compositing pipeline.
class _LinkedAnchorSubscription extends ChangeNotifier
    implements AnchorSubscription {
  final Object key;
  final OverlayAnchorRegistry registry;

  _LinkedAnchorSubscription(this.key, this.registry);

  @override
  bool get supportsCompositeTracking => true;

  @override
  RenderBox? get currentAnchorBox {
    final box = registry.find(key)?.renderBox;
    return (box != null && box.attached) ? box : null;
  }

  @override
  bool get isVisible {
    final entry = registry.find(key);
    if (entry == null) return false;
    try {
      // ignore: invalid_use_of_protected_member
      return entry.context.findRenderObject() != null;
    } catch (_) {
      return false;
    }
  }

  @override
  Size? get anchorSize {
    final box = registry.find(key)?.renderBox;
    if (box == null || !box.attached || !box.hasSize) return null;
    return box.size;
  }

  @override
  Matrix4 computeTransform(RenderObject source) {
    final box = registry.find(key)?.renderBox;
    if (box == null || !box.attached) return Matrix4.identity();
    return anchorTransformRelativeTo(box, source);
  }
}
