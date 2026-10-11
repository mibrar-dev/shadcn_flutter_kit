// The `anchor` component: a point an overlay can position itself against, and
// track while it moves.
//
// Ported from `components/overlay/anchor/**`. Fixes: the process-wide
// `OverlayAnchorRegistry.global` is gone (an `OverlayAnchor` must sit under an
// `OverlayAnchorScope`, so sibling screens can reuse anchor keys);
// `AnchorSubscription.dispose()` is part of the contract; `isVisible` checks
// `attached` rather than a detached element's stale render object; a singular
// `Matrix4` yields the identity; `package:data_widget` and two suppressed-lint pragmas are gone.

import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';

/// Describes an anchor an overlay (popover, menu, tooltip) positions itself
/// against, optionally tracking it as it moves.
abstract class Anchor {
  /// Creates an [Anchor].
  const Anchor();

  /// Starts a live subscription to this anchor's position and visibility. The
  /// caller owns the result and **must** call
  /// [AnchorSubscription.dispose] on it.
  AnchorSubscription subscribe();

  /// Fills in any defaults this anchor needs from [context].
  ///
  /// The base implementation returns `this`; [ContextAnchor] substitutes the
  /// context of the `show()` call when it was not given one.
  Anchor resolve(BuildContext context) => this;
}

/// A live handle on an [Anchor]'s position and visibility. Listeners are
/// notified whenever the anchor may have moved, resized or changed visibility.
abstract class AnchorSubscription implements Listenable {
  /// Releases the subscription; it never notifies again, so implementations
  /// must stop any ticker they own here.
  void dispose();

  /// Whether the anchor currently resolves to a live, mounted render object.
  bool get isVisible;

  /// The anchor's current box size, or null when it cannot be resolved.
  Size? get anchorSize;

  /// The transform mapping the anchor's local coordinates into [source]'s. The
  /// two render objects are usually unrelated in the tree (the anchor lives in
  /// the normal tree, [source] in an overlay entry), so
  /// `RenderObject.getTransformTo` cannot be used directly between them.
  Matrix4 computeTransform(RenderObject source);

  /// Whether this subscription tracks the anchor through the compositing
  /// pipeline (zero lag, re-evaluated on scroll). Defaults to false;
  /// [_LinkedAnchorSubscription] enables it.
  bool get supportsCompositeTracking => false;

  /// The anchor's currently registered [RenderBox], or null. Only meaningful
  /// when [supportsCompositeTracking] is true.
  RenderBox? get currentAnchorBox => null;
}

/// The transform from [anchorBox]'s local coordinates into [source]'s. Returns
/// the identity when [source]'s transform is singular instead of throwing from
/// `Matrix4.invert()`.
Matrix4 anchorTransformRelativeTo(RenderBox anchorBox, RenderObject source) {
  final Matrix4 globalToSource = Matrix4.copy(source.getTransformTo(null));
  // `Matrix4.invert` returns the determinant; a singular matrix used to throw.
  if (globalToSource.invert() == 0) {
    return Matrix4.identity();
  }
  return globalToSource.multiplied(anchorBox.getTransformTo(null));
}

/// An [Anchor] resolved from a plain [BuildContext]. A null [context]
/// (`const ContextAnchor()`) is filled in by the consumer with the context of
/// the `show()` call.
class ContextAnchor extends Anchor {
  /// Creates a context anchor.
  const ContextAnchor([this.context]);

  /// The context to anchor to, or null to use the consumer's own context.
  final BuildContext? context;

  @override
  Anchor resolve(BuildContext context) =>
      this.context == null ? ContextAnchor(context) : this;

  @override
  AnchorSubscription subscribe() => _ContextAnchorSubscription(context);
}

/// An [Anchor] resolved through the nearest [OverlayAnchorRegistry], by the key
/// an [OverlayAnchor] registered itself under. The registry comes from the
/// `BuildContext` passed to [Anchor.resolve]; pass [registry] to pick one.
class LinkedAnchor extends Anchor {
  /// Creates a linked anchor.
  const LinkedAnchor(this.key, {this.registry});

  /// The registry key, matching an [OverlayAnchor.anchor].
  final Object key;

  /// The registry this anchor is bound to; filled in by [resolve].
  final OverlayAnchorRegistry? registry;

  @override
  Anchor resolve(BuildContext context) => registry != null
      ? this
      : LinkedAnchor(key, registry: OverlayAnchorRegistry.maybeOf(context));

  @override
  AnchorSubscription subscribe() {
    final OverlayAnchorRegistry? target = registry;
    assert(
      target != null,
      'LinkedAnchor must be resolved (Anchor.resolve) before subscribing.',
    );
    return _LinkedAnchorSubscription(key, target!);
  }
}

/// A registry entry for a registered [OverlayAnchor].
class OverlayAnchorEntry {
  /// Creates an entry.
  const OverlayAnchorEntry({required this.renderBox});

  /// The [RenderBox] of the registered anchor. The old entry also carried the
  /// element, but every read went through `findRenderObject()`, which stays
  /// non-null after detach; `attached` on this box is the honest liveness check.
  final RenderBox renderBox;
}

/// Maps anchor keys to the [OverlayAnchor] entries registered under them.
/// Registrations never escape their own [OverlayAnchorScope].
class OverlayAnchorRegistry {
  /// Creates a registry, optionally chained to a [parent].
  OverlayAnchorRegistry({this.parent});

  /// The enclosing scope's registry; [find] falls back to it, and so on up the
  /// chain. Registrations stay local.
  OverlayAnchorRegistry? parent;

  final Map<Object, OverlayAnchorEntry> _anchors =
      <Object, OverlayAnchorEntry>{};

  /// The registry of [context]'s nearest [OverlayAnchorScope], or null. Does
  /// not create an inherited-widget dependency, so it is safe to call outside
  /// `build` (for example while showing an overlay).
  static OverlayAnchorRegistry? maybeOf(BuildContext context) =>
      Data.maybeFind<OverlayAnchorRegistry>(context);

  /// Registers [entry] under [key] in this registry.
  void register(Object key, OverlayAnchorEntry entry) {
    _anchors[key] = entry;
  }

  /// Removes the entry for [key].
  void unregister(Object key) {
    _anchors.remove(key);
  }

  /// The entry for [key], falling back to [parent] and up the chain.
  OverlayAnchorEntry? find(Object key) => _anchors[key] ?? parent?.find(key);
}

/// Provides a local [OverlayAnchorRegistry] to its subtree, so anchor keys need
/// only be unique inside it. The [OverlayAnchor] and the opening
/// [LinkedAnchor] must sit under the same scope.
class OverlayAnchorScope extends StatefulWidget {
  /// Creates a scope.
  const OverlayAnchorScope({super.key, required this.child});

  /// The subtree that shares this scope's registry.
  final Widget child;

  @override
  State<OverlayAnchorScope> createState() => _OverlayAnchorScopeState();
}

class _OverlayAnchorScopeState extends State<OverlayAnchorScope> {
  final OverlayAnchorRegistry _registry = OverlayAnchorRegistry();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Chain outward so a lookup that misses here falls back to the parent.
    _registry.parent = Data.maybeOf<OverlayAnchorRegistry>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Data<OverlayAnchorRegistry>.inherit(
      data: _registry,
      child: widget.child,
    );
  }
}

/// A widget that acts as a generalised anchor for overlays: it registers its
/// [RenderBox] and [BuildContext] in the nearest [OverlayAnchorRegistry] under
/// [anchor], where [LinkedAnchor] looks it up again.
class OverlayAnchor extends SingleChildRenderObjectWidget {
  /// Creates an anchor.
  const OverlayAnchor({
    super.key,
    required this.anchor,
    required Widget super.child,
  });

  /// The key representing this anchor; unique inside its scope.
  final Object anchor;

  @override
  RenderOverlayAnchor createRenderObject(BuildContext context) {
    return RenderOverlayAnchor(anchor: anchor, registry: _registryOf(context));
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderOverlayAnchor renderObject,
  ) {
    renderObject.update(anchor: anchor, registry: _registryOf(context));
  }

  static OverlayAnchorRegistry _registryOf(BuildContext context) {
    final OverlayAnchorRegistry? registry = OverlayAnchorRegistry.maybeOf(
      context,
    );
    assert(
      registry != null,
      'OverlayAnchor must sit under an OverlayAnchorScope.',
    );
    return registry!;
  }
}

/// The render object for [OverlayAnchor]. Registers on attach, unregisters on
/// detach and re-registers when the key or the scope changes.
class RenderOverlayAnchor extends RenderProxyBox {
  /// Creates a render anchor.
  RenderOverlayAnchor({
    required this._anchor,
    required this._registry,
    RenderBox? child,
  }) : super(child);

  Object _anchor;
  OverlayAnchorRegistry _registry;

  /// Updates the key and the registry.
  void update({
    required Object anchor,
    required OverlayAnchorRegistry registry,
  }) {
    if (_anchor != anchor || !identical(_registry, registry)) {
      // Drop the old registration before moving to a new key or scope.
      _registry.unregister(_anchor);
      _anchor = anchor;
      _registry = registry;
      if (attached) {
        _register();
      }
    }
  }

  void _register() =>
      _registry.register(_anchor, OverlayAnchorEntry(renderBox: this));

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _register();
  }

  @override
  void detach() {
    _registry.unregister(_anchor);
    super.detach();
  }
}

/// [ContextAnchor]'s subscription. There is no reliable "about to move" hook for
/// an arbitrary [BuildContext], so this polls every frame with a standalone
/// [Ticker] while it has listeners.
class _ContextAnchorSubscription extends ChangeNotifier
    implements AnchorSubscription {
  _ContextAnchorSubscription(this.context) {
    _ticker = Ticker(_onTick);
  }

  final BuildContext? context;
  late final Ticker _ticker;

  @override
  bool get supportsCompositeTracking => false;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    if (hasListeners && !_ticker.isActive) {
      _ticker.start();
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners && _ticker.isActive) {
      _ticker.stop();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) => notifyListeners();

  RenderBox? get _box {
    final BuildContext? ctx = context;
    if (ctx == null) {
      return null;
    }
    final RenderObject? renderObject = ctx.findRenderObject();
    return renderObject is RenderBox ? renderObject : null;
  }

  @override
  bool get isVisible => _box?.attached ?? false;

  @override
  RenderBox? get currentAnchorBox => _box;

  @override
  Size? get anchorSize {
    final RenderBox? box = _box;
    if (box == null || !box.attached || !box.hasSize) {
      return null;
    }
    return box.size;
  }

  @override
  Matrix4 computeTransform(RenderObject source) {
    final RenderBox? box = _box;
    if (box == null || !box.attached) {
      return Matrix4.identity();
    }
    return anchorTransformRelativeTo(box, source);
  }
}

/// [LinkedAnchor]'s subscription. Resolves the anchor from the registry on every
/// read, so it self-heals when the anchor's render object is replaced. Carries
/// no ticker, which is what enables [supportsCompositeTracking].
class _LinkedAnchorSubscription extends ChangeNotifier
    implements AnchorSubscription {
  _LinkedAnchorSubscription(this.key, this.registry);

  final Object key;
  final OverlayAnchorRegistry registry;

  @override
  bool get supportsCompositeTracking => true;

  @override
  RenderBox? get currentAnchorBox {
    final RenderBox? box = registry.find(key)?.renderBox;
    return (box != null && box.attached) ? box : null;
  }

  @override
  bool get isVisible => currentAnchorBox != null;

  @override
  Size? get anchorSize {
    final RenderBox? box = currentAnchorBox;
    if (box == null || !box.hasSize) {
      return null;
    }
    return box.size;
  }

  @override
  Matrix4 computeTransform(RenderObject source) {
    final RenderBox? box = currentAnchorBox;
    if (box == null) {
      return Matrix4.identity();
    }
    return anchorTransformRelativeTo(box, source);
  }
}
