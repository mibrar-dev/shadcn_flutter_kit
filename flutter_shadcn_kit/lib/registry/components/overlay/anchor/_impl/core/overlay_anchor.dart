// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../anchor.dart';

/// The registry entry representing a registered [OverlayAnchor]
/// (upstream parity with `shadcn_flutter`'s `OverlayAnchorEntry`).
class OverlayAnchorEntry {
  /// The [RenderBox] of the registered anchor.
  final RenderBox renderBox;

  /// The [BuildContext] (Element) of the registered anchor.
  final BuildContext context;

  /// Creates an [OverlayAnchorEntry].
  const OverlayAnchorEntry({required this.renderBox, required this.context});
}

/// A registry mapping anchor keys to their [OverlayAnchor] entries
/// (upstream parity with `shadcn_flutter`'s `OverlayAnchorRegistry`).
///
/// By default anchors register with the process-wide [global] registry, so
/// keys must be globally unique. Wrap a subtree in an [OverlayAnchorScope]
/// to give it its own registry — then keys only need to be unique within
/// that scope, and the same key can be reused in sibling scopes (e.g. one
/// per list item, tab, or route). [OverlayAnchor] and [LinkedAnchor] both
/// resolve their registry from the nearest scope via [of].
class OverlayAnchorRegistry {
  /// The process-wide fallback registry, used when there's no enclosing
  /// [OverlayAnchorScope]. Has no [parent].
  static final OverlayAnchorRegistry global = OverlayAnchorRegistry();

  /// The enclosing scope's registry. [find] falls back to it (and so on up
  /// to [global]) when a key isn't registered in this scope. Null for
  /// [global]. Set by the owning [OverlayAnchorScope]; registrations always
  /// stay local.
  OverlayAnchorRegistry? parent;

  /// Creates an [OverlayAnchorRegistry], optionally chained to a [parent].
  OverlayAnchorRegistry({this.parent});

  final Map<Object, OverlayAnchorEntry> _anchors = {};

  /// The registry for [context]'s nearest [OverlayAnchorScope], or [global]
  /// if there is none. Does not create an inherited-widget dependency, so
  /// it is safe to call outside of build (e.g. while showing an overlay).
  static OverlayAnchorRegistry of(BuildContext context) =>
      Data.maybeFind<OverlayAnchorRegistry>(context) ?? global;

  /// Registers an [OverlayAnchorEntry] with the given key in this registry.
  void register(Object key, OverlayAnchorEntry entry) {
    _anchors[key] = entry;
  }

  /// Unregisters the entry for the given key from this registry.
  void unregister(Object key) {
    _anchors.remove(key);
  }

  /// Finds the entry for [key], falling back to [parent] (and up the chain
  /// to [global]) when it isn't registered in this scope.
  OverlayAnchorEntry? find(Object key) {
    return _anchors[key] ?? parent?.find(key);
  }
}

/// Provides a local [OverlayAnchorRegistry] to its subtree, so
/// [OverlayAnchor] keys only need to be unique within this scope rather
/// than globally (upstream parity).
///
/// Place a scope around each repeated region (list item, tab, dialog, route)
/// that reuses the same anchor keys. Both the [OverlayAnchor] and the code
/// that opens a [LinkedAnchor]-based overlay must sit under the same scope
/// for them to connect.
class OverlayAnchorScope extends StatefulWidget {
  /// The subtree that shares this scope's registry.
  final Widget child;

  /// Creates an [OverlayAnchorScope].
  const OverlayAnchorScope({super.key, required this.child});

  @override
  State<OverlayAnchorScope> createState() => _OverlayAnchorScopeState();
}

/// State for [OverlayAnchorScope].
class _OverlayAnchorScopeState extends State<OverlayAnchorScope> {
  final OverlayAnchorRegistry _registry = OverlayAnchorRegistry();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Chain to the enclosing scope (or the global registry) so a lookup
    // that misses here falls back outward.
    _registry.parent =
        Data.maybeOf<OverlayAnchorRegistry>(context) ??
        OverlayAnchorRegistry.global;
  }

  @override
  Widget build(BuildContext context) {
    return Data<OverlayAnchorRegistry>.inherit(
      data: _registry,
      child: widget.child,
    );
  }
}

/// A widget that acts as a generalized anchor for overlays (upstream parity
/// with `shadcn_flutter`'s `OverlayAnchor`).
///
/// It registers its [RenderBox] and [BuildContext] dynamically in the nearest
/// [OverlayAnchorRegistry] (see [OverlayAnchorScope]) using an arbitrary key
/// (see [LinkedAnchor]).
class OverlayAnchor extends SingleChildRenderObjectWidget {
  /// The unique key representing this anchor.
  final Object anchor;

  /// Creates an [OverlayAnchor].
  const OverlayAnchor({
    super.key,
    required this.anchor,
    required Widget super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderOverlayAnchor(
      anchor: anchor,
      anchorContext: context,
      registry: OverlayAnchorRegistry.of(context),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderOverlayAnchor renderObject,
  ) {
    renderObject.update(
      anchor: anchor,
      anchorContext: context,
      registry: OverlayAnchorRegistry.of(context),
    );
  }
}

/// The render object for [OverlayAnchor] (upstream parity).
///
/// Handles construction, updates, and automatic unregistration when
/// detached. Overlays anchored to it read its live on-screen position
/// directly through [RenderObject.getTransformTo] during compositing, so it
/// needs no special layer of its own.
class RenderOverlayAnchor extends RenderProxyBox {
  Object _anchor;
  BuildContext _anchorContext;
  OverlayAnchorRegistry _registry;

  /// Creates a [RenderOverlayAnchor].
  RenderOverlayAnchor({
    required Object anchor,
    required BuildContext anchorContext,
    required OverlayAnchorRegistry registry,
    RenderBox? child,
  })  : _anchor = anchor,
        _anchorContext = anchorContext,
        _registry = registry,
        super(child);

  /// Updates properties and registry.
  void update({
    required Object anchor,
    required BuildContext anchorContext,
    required OverlayAnchorRegistry registry,
  }) {
    if (_anchor != anchor || !identical(_registry, registry)) {
      // Drop the old registration before moving to a new key or scope.
      _registry.unregister(_anchor);
      _anchor = anchor;
      _registry = registry;
    }
    _anchorContext = anchorContext;
    if (attached) {
      _register();
    }
  }

  void _register() {
    _registry.register(
      _anchor,
      OverlayAnchorEntry(renderBox: this, context: _anchorContext),
    );
  }

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
