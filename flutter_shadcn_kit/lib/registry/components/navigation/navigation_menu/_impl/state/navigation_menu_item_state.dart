// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_menu.dart';

/// NavigationMenuItemState defines a reusable type for this registry module.
class NavigationMenuItemState extends State<NavigationMenuItem> {
  /// Stores `_menuState` state/configuration for this implementation.
  NavigationMenuState? _menuState;

  @override
  /// Executes `didChangeDependencies` behavior for this component/composite.
  void didChangeDependencies() {
    super.didChangeDependencies();
    var newMenuState = Data.maybeOf<NavigationMenuState>(context);

    /// Creates a `assert` instance.
    assert(
      newMenuState != null,
      'NavigationItem must be a descendant of NavigationMenu',
    );
    if (_menuState != newMenuState) {
      _menuState = newMenuState;
      if (widget.content != null) {
        _menuState!._attachContentBuilder(this, (context) {
          return widget.content!;
        });
      }
    }
  }

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant NavigationMenuItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.content != oldWidget.content) {
      if (widget.content != null) {
        _menuState!._attachContentBuilder(this, (context) {
          return widget.content!;
        });
      } else {
        _menuState!._contentBuilders.remove(this);
      }
    }
  }

  @override
  /// Executes `dispose` behavior for this component/composite.
  void dispose() {
    if (widget.content != null) {
      _menuState!._contentBuilders.remove(this);
    }
    super.dispose();
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: Listenable.merge([
        _menuState!._activeIndex,
        _menuState!._popoverController,
      ]),
      builder: (context, child) {
        return Button(
          style: const ButtonStyle.ghost().copyWith(
            decoration: (context, states, value) {
              if (_menuState!.isActive(this)) {
                return (value as BoxDecoration).copyWith(
                  borderRadius: BorderRadius.circular(theme.radiusMd),
                  color: theme.colorScheme.muted.scaleAlpha(0.8),
                );
              }
              return value;
            },
          ),
          trailing: widget.content != null
              ? AnimatedRotation(
                  duration: kDefaultDuration,
                  turns: _menuState!.isActive(this) ? 0.5 : 0,
                  child: const Icon(RadixIcons.chevronDown).iconXSmall(),
                )
              : null,
          onHover: (hovered) {
            if (hovered) {
              _menuState!._activate(this);
            }
          },
          onPressed: widget.onPressed != null || widget.content != null
              ? () {
                  if (widget.onPressed != null) {
                    widget.onPressed!();
                  }
                  if (widget.content != null) {
                    _menuState!._activate(this);
                  }
                }
              : null,
          child: widget.child,
        );
      },
    );
  }
}
