// State of `PopoverOverlayWidget`: anchor tracking, scroll/region handling,
// live configuration setters and the positioned build.
//
// Ported from `shared/primitives/_impl/state/popover_overlay_widget_state.dart`.

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../foundation/data.dart';
import '../foundation/geometry.dart';
import '../foundation/tween_utils.dart';
import '../theme/theme.dart';
import 'overlay.dart';
import 'popover_layout.dart';
import 'popover_overlay_widget.dart';

/// Framework-internal state of [PopoverOverlayWidget], the `onTickFollow` payload.
class PopoverOverlayWidgetState extends State<PopoverOverlayWidget>
    with SingleTickerProviderStateMixin, OverlayHandlerStateMixin {
  late BuildContext _anchorContext;
  late Offset? _position;
  late Offset? _offset;
  late AlignmentGeometry _alignment;
  late AlignmentGeometry _anchorAlignment;
  late PopoverConstraint _widthConstraint;
  late PopoverConstraint _heightConstraint;
  late EdgeInsetsGeometry? _margin;
  Size? _anchorSize;
  late bool _follow;
  late bool _allowInvertHorizontal;
  late bool _allowInvertVertical;
  late Ticker _ticker;
  late LayerLink? _layerLink;
  Offset? _followAnchorDelta;
  ScrollableState? _scrollable;
  ScrollPosition? _scrollPosition;
  bool _isClosingForRegionLoss = false;

  @override
  void initState() {
    super.initState();
    _offset = widget.offset;
    _position = widget.position;
    _alignment = widget.alignment;
    _anchorSize = widget.anchorSize;
    _anchorAlignment = widget.anchorAlignment;
    _widthConstraint = widget.widthConstraint;
    _heightConstraint = widget.heightConstraint;
    _margin = widget.margin;
    _follow = widget.follow;
    _anchorContext = widget.anchorContext;
    _allowInvertHorizontal = widget.allowInvertHorizontal;
    _allowInvertVertical = widget.allowInvertVertical;
    _layerLink = widget.layerLink;
    _followAnchorDelta = null;
    _isClosingForRegionLoss = false;
    _ticker = createTicker((_) => _updatePosition());
    if (_follow && _layerLink == null) {
      _ticker.start();
    }
    _attachScrollListener();
    if (_follow) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _updatePosition();
        }
      });
    }
  }

  @override
  Future<void> close([bool immediate = false]) {
    if (!immediate) {
      return widget.onClose?.call() ?? Future.value();
    } else {
      widget.onImmediateClose?.call();
    }
    return Future.value();
  }

  @override
  void closeLater() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onClose?.call();
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant PopoverOverlayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _alignment = widget.alignment;
    _anchorSize = widget.anchorSize;
    _anchorAlignment = widget.anchorAlignment;
    _widthConstraint = widget.widthConstraint;
    _heightConstraint = widget.heightConstraint;
    _offset = widget.offset;
    _margin = widget.margin;
    _follow = widget.follow;
    _layerLink = widget.layerLink;
    final shouldRunTicker = _follow && _layerLink == null;
    if (shouldRunTicker && !_ticker.isActive) {
      _ticker.start();
    } else if (!shouldRunTicker && _ticker.isActive) {
      _ticker.stop();
    }
    if (oldWidget.anchorContext != widget.anchorContext) {
      _anchorContext = widget.anchorContext;
      _attachScrollListener();
    }
    _allowInvertHorizontal = widget.allowInvertHorizontal;
    _allowInvertVertical = widget.allowInvertVertical;
    if (_follow) {
      _attachScrollListener();
      if (oldWidget.position != widget.position ||
          oldWidget.anchorAlignment != widget.anchorAlignment ||
          oldWidget.anchorContext != widget.anchorContext) {
        _followAnchorDelta = null;
      }
      _updatePosition();
    } else {
      _detachScrollListener();
    }
    if (oldWidget.position != widget.position && !_follow) {
      _position = widget.position;
    }
  }

  Size? get anchorSize => _anchorSize;

  AlignmentGeometry get anchorAlignment => _anchorAlignment;

  Offset? get position => _position;

  AlignmentGeometry get alignment => _alignment;

  PopoverConstraint get widthConstraint => _widthConstraint;

  PopoverConstraint get heightConstraint => _heightConstraint;

  Offset? get offset => _offset;

  EdgeInsetsGeometry? get margin => _margin;

  bool get follow => _follow;

  BuildContext get anchorContext => _anchorContext;

  bool get allowInvertHorizontal => _allowInvertHorizontal;

  bool get allowInvertVertical => _allowInvertVertical;

  LayerLink? get layerLink => _layerLink;

  void _applyIfChanged(bool changed, VoidCallback apply) {
    if (changed) setState(apply);
  }

  set layerLink(LayerLink? value) {
    if (_layerLink != value) {
      setState(() {
        _layerLink = value;
        if (_follow && _layerLink == null) {
          if (!_ticker.isActive) {
            _ticker.start();
          }
        } else {
          _ticker.stop();
        }
      });
    }
  }

  @override
  set alignment(AlignmentGeometry value) {
    _applyIfChanged(_alignment != value, () => _alignment = value);
  }

  set position(Offset? value) {
    _applyIfChanged(_position != value, () => _position = value);
  }

  @override
  set anchorAlignment(AlignmentGeometry value) {
    _applyIfChanged(_anchorAlignment != value, () => _anchorAlignment = value);
  }

  @override
  set widthConstraint(PopoverConstraint value) {
    _applyIfChanged(_widthConstraint != value, () => _widthConstraint = value);
  }

  @override
  set heightConstraint(PopoverConstraint value) {
    _applyIfChanged(
      _heightConstraint != value,
      () => _heightConstraint = value,
    );
  }

  @override
  set margin(EdgeInsetsGeometry? value) {
    _applyIfChanged(_margin != value, () => _margin = value);
  }

  @override
  set follow(bool value) {
    if (_follow != value) {
      setState(() {
        _follow = value;
      });
      if (_follow) {
        if (_layerLink == null && !_ticker.isActive) {
          _ticker.start();
        }
        _attachScrollListener();
        _followAnchorDelta = null;
        _updatePosition();
      } else {
        if (_ticker.isActive) {
          _ticker.stop();
        }
        _detachScrollListener();
      }
    }
  }

  @override
  set anchorContext(BuildContext value) {
    if (_anchorContext != value) {
      setState(() {
        _anchorContext = value;
      });
      _attachScrollListener();
      if (_follow) {
        _followAnchorDelta = null;
        _updatePosition();
      }
    }
  }

  @override
  set allowInvertHorizontal(bool value) {
    _applyIfChanged(
      _allowInvertHorizontal != value,
      () => _allowInvertHorizontal = value,
    );
  }

  @override
  set allowInvertVertical(bool value) {
    _applyIfChanged(
      _allowInvertVertical != value,
      () => _allowInvertVertical = value,
    );
  }

  @override
  void dispose() {
    _detachScrollListener();
    _ticker.dispose();
    super.dispose();
  }

  Rect _globalRectForRenderBox(RenderBox box) =>
      box.localToGlobal(Offset.zero) & box.size;

  Rect? _resolveVisibleRegionRect() {
    final scrollableRenderObject = _scrollable?.context.findRenderObject();
    if (scrollableRenderObject is RenderBox && scrollableRenderObject.hasSize) {
      return _globalRectForRenderBox(scrollableRenderObject);
    }
    final overlayRenderObject = context.findRenderObject();
    if (overlayRenderObject is RenderBox && overlayRenderObject.hasSize) {
      return _globalRectForRenderBox(overlayRenderObject);
    }
    return null;
  }

  void _updatePosition() {
    if (!mounted || !anchorContext.mounted) return;
    final renderObject = anchorContext.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;
    final anchorRect = _globalRectForRenderBox(renderObject);
    final visibleRegionRect = _resolveVisibleRegionRect();
    if (_follow &&
        visibleRegionRect != null &&
        !visibleRegionRect.overlaps(anchorRect)) {
      if (!_isClosingForRegionLoss) {
        _isClosingForRegionLoss = true;
        closeLater();
      }
      return;
    }
    _isClosingForRegionLoss = false;

    final pos = renderObject.localToGlobal(Offset.zero);
    final size = renderObject.size;
    final resolvedAnchorAlignment = _anchorAlignment.optionallyResolve(context);
    final anchorPosition = Offset(
      pos.dx + size.width / 2 + size.width / 2 * resolvedAnchorAlignment.x,
      pos.dy + size.height / 2 + size.height / 2 * resolvedAnchorAlignment.y,
    );
    Offset newPos = anchorPosition;
    if (_follow && widget.position != null) {
      _followAnchorDelta ??= widget.position! - anchorPosition;
      newPos = anchorPosition + _followAnchorDelta!;
    }
    if (_position != newPos || _anchorSize != size) {
      setState(() {
        _anchorSize = size;
        _position = newPos;
        widget.onTickFollow?.call(this);
      });
    }
  }

  void _attachScrollListener() {
    if (!_follow || !mounted || !anchorContext.mounted) return;
    final scrollable = Scrollable.maybeOf(anchorContext);
    if (scrollable == _scrollable && scrollable?.position == _scrollPosition) {
      return;
    }
    _detachScrollListener();
    _scrollable = scrollable;
    _scrollPosition = scrollable?.position;
    _scrollPosition?.addListener(_updatePosition);
  }

  void _detachScrollListener() {
    _scrollPosition?.removeListener(_updatePosition);
    _scrollPosition = null;
    _scrollable = null;
  }

  @override
  Widget build(BuildContext context) {
    Widget childWidget = Data<OverlayHandlerStateMixin>.inherit(
      data: this,
      child: TapRegion(
        onTapOutside: widget.onTapOutside != null
            ? (event) {
                widget.onTapOutside?.call();
              }
            : null,
        groupId: widget.regionGroupId,
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          removeLeft: true,
          removeRight: true,
          removeTop: true,
          child: Builder(
            builder: (context) {
              final theme = ShadcnTheme.of(context);
              final scaling = theme.scaling;
              return PopoverLayout(
                alignment: _alignment.optionallyResolve(context),
                position: _position,
                anchorSize: _anchorSize,
                anchorAlignment: _anchorAlignment.optionallyResolve(context),
                widthConstraint: _widthConstraint,
                heightConstraint: _heightConstraint,
                offset: _offset,
                margin:
                    _margin?.optionallyResolve(context) ??
                    (const EdgeInsets.all(8) * scaling),
                scale: tweenValue(0.9, 1.0, widget.animation),
                scaleAlignment: (widget.transitionAlignment ?? _alignment)
                    .optionallyResolve(context),
                allowInvertVertical: _allowInvertVertical,
                allowInvertHorizontal: _allowInvertHorizontal,
                child: FadeTransition(
                  opacity: AlwaysStoppedAnimation<double>(widget.animation),
                  child: Builder(builder: (context) => widget.builder(context)),
                ),
              );
            },
          ),
        ),
      ),
    );
    if (widget.themes != null) {
      childWidget = widget.themes!.wrap(childWidget);
    }
    if (widget.data != null) {
      childWidget = widget.data!.wrap(childWidget);
    }
    return childWidget;
  }

  @override
  Future<void> closeWithResult<X>([X? value]) {
    return widget.onCloseWithResult?.call(value) ?? Future.value();
  }
}
