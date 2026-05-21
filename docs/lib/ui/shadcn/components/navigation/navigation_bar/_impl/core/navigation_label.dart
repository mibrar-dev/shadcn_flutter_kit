// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// NavigationLabel defines a reusable type for this registry module.
class NavigationLabel extends StatelessWidget implements NavigationBarItem {
  /// Content widget to display as the label.
  final Widget child;

  /// Alignment of the label content.
  final AlignmentGeometry? alignment;

  /// Padding around the label.
  final EdgeInsetsGeometry? padding;

  /// How to handle text overflow.
  final NavigationOverflow overflow;

  /// Whether the label floats when scrolling (sidebar only).
  final bool floating;

  /// Whether the label is pinned when scrolling (sidebar only).
  final bool pinned;

  /// Creates a navigation label.
  ///
  /// Parameters:
  /// - [child] (Widget, required): Label content
  /// - [alignment] (AlignmentGeometry?): Content alignment
  /// - [floating] (bool): Floating behavior, defaults to false
  /// - [pinned] (bool): Pinned behavior, defaults to false
  /// - [overflow] (NavigationOverflow): Overflow handling, defaults to clip
  /// - [padding] (EdgeInsetsGeometry?): Label padding
  const NavigationLabel({
    super.key,
    this.alignment,
    this.floating = false,
    this.pinned = false,
    this.overflow = NavigationOverflow.clip,
    this.padding,
    required this.child,
  });

  @override
  /// Stores `selectable` state/configuration for this implementation.
  bool get selectable => false;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final data = Data.maybeOf<NavigationControlData>(context);
    if (data?.containerType == NavigationContainerType.sidebar) {
      return buildSliver(context, data);
    }
    return buildBox(context, data);
  }

  /// Builds the child widget with visibility and overflow handling.
  ///
  /// Wraps the child with [Hidden] widget that responds to expansion state
  /// and applies overflow handling based on the overflow property.
  ///
  /// Parameters:
  /// - [context] (BuildContext, required): Build context
  /// - [data] (NavigationControlData?): Navigation control data
  ///
  /// Returns the wrapped child widget.
  Widget buildChild(BuildContext context, NavigationControlData? data) {
    /// Stores `expanded` state/configuration for this implementation.
    bool expanded = data?.expanded ?? true;
    return Hidden(
      hidden: !expanded,
      direction: data?.direction ?? Axis.vertical,
      child: NavigationPadding(
        child: DefaultTextStyle.merge(
          textAlign: TextAlign.center,
          maxLines: 1,
          child: _NavigationChildOverflowHandle(
            overflow: overflow,
            child: child,
          ),
        ),
      ),
    );
  }

  /// Builds the label for box-based navigation containers.
  ///
  /// Creates a centered, padded container with the label text.
  /// Appropriate for use in navigation bars and rails.
  ///
  /// Parameters:
  /// - [context] (BuildContext, required): Build context
  /// - [data] (NavigationControlData?): Navigation control data
  ///
  /// Returns widget for box-based navigation.
  Widget buildBox(BuildContext context, NavigationControlData? data) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    return DefaultTextStyle.merge(
      textAlign: TextAlign.center,
      child: Container(
        alignment: alignment ?? Alignment.center,
        padding:
            padding ??
            /// Creates a `EdgeInsets.symmetric` instance.
            EdgeInsets.symmetric(horizontal: theme.density.baseGap * scaling),
        child: buildChild(context, data).xSmall(),
      ),
    );
  }

  /// Builds the label for sliver-based navigation containers (sidebars).
  ///
  /// Creates a persistent header that can be configured as floating or pinned.
  /// Animates based on expansion state and supports scrolling behaviors.
  ///
  /// Parameters:
  /// - [context] (BuildContext, required): Build context
  /// - [data] (NavigationControlData?): Navigation control data
  ///
  /// Returns sliver widget for sidebar navigation.
  Widget buildSliver(BuildContext context, NavigationControlData? data) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    return AnimatedValueBuilder(
      duration: kDefaultDuration,
      curve: Curves.easeInOut,
      value: (data?.expanded ?? true) ? 1.0 : 0.0,
      child: buildChild(context, data),
      builder: (context, value, child) {
        return SliverPersistentHeader(
          pinned: pinned,
          floating: floating,
          delegate: _NavigationLabelDelegate(
            maxExtent: 48 * scaling * value,
            minExtent: 48 * scaling * value,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                /// Creates a `Scrollable.ensureVisible` instance.
                Scrollable.ensureVisible(
                  context,
                  duration: kDefaultDuration,
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                alignment: alignment ?? AlignmentDirectional.centerStart,
                padding:
                    padding ??
                    /// Creates a `EdgeInsets.symmetric` instance.
                    EdgeInsets.symmetric(
                      horizontal: theme.density.baseContentPadding * scaling,
                    ),
                child: child!.semiBold().large(),
              ),
            ),
          ),
        );
      },
    );
  }
}
