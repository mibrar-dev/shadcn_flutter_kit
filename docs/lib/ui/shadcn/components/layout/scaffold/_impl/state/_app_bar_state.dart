// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../scaffold.dart';

/// _AppBarState defines a reusable type for this registry module.
class _AppBarState extends State<AppBar> {
  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final barData = Data.maybeOf<ScaffoldBarData>(context);

    /// Stores `surfaceBlur` state/configuration for this implementation.
    var surfaceBlur = widget.surfaceBlur ?? theme.surfaceBlur;

    /// Stores `surfaceOpacity` state/configuration for this implementation.
    var surfaceOpacity = widget.surfaceOpacity ?? theme.surfaceOpacity;
    final baseBackgroundColor =
        widget.backgroundColor ?? theme.colorScheme.card;
    return FocusTraversalGroup(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: surfaceBlur ?? 0,
            sigmaY: surfaceBlur ?? 0,
          ),
          child: Container(
            color: baseBackgroundColor.scaleAlpha(surfaceOpacity ?? 1),
            alignment: widget.alignment,
            padding:
                widget.padding ??
                (EdgeInsets.symmetric(
                      horizontal: theme.density.baseContentPadding * 1.125,
                      vertical: theme.density.baseGap * 1.5,
                    ) *
                    scaling),
            child: SafeArea(
              top:
                  widget.useSafeArea &&
                  barData?.isHeader == true &&
                  barData?.childIndex == 0,
              right: widget.useSafeArea,
              left: widget.useSafeArea,
              bottom:
                  widget.useSafeArea &&
                  barData?.isHeader == false &&
                  barData?.childIndex == (barData?.childrenCount ?? 0) - 1,
              child: SizedBox(
                height: widget.height,
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (widget.leading.isNotEmpty)
                        /// Creates a `Row` instance.
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: widget.leading,
                        ).gap(widget.leadingGap ?? (4 * scaling)),

                      /// Creates a `Flexible` instance.
                      Flexible(
                        fit: widget.trailingExpanded
                            ? FlexFit.loose
                            : FlexFit.tight,
                        child:
                            widget.child ??
                            /// Creates a `Column` instance.
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (widget.header != null)
                                  /// Creates a `KeyedSubtree` instance.
                                  KeyedSubtree(
                                    key: const ValueKey('header'),
                                    child: widget.header!.muted().small(),
                                  ),
                                if (widget.title != null)
                                  /// Creates a `KeyedSubtree` instance.
                                  KeyedSubtree(
                                    key: const ValueKey('title'),
                                    child: widget.title!.large().medium(),
                                  ),
                                if (widget.subtitle != null)
                                  /// Creates a `KeyedSubtree` instance.
                                  KeyedSubtree(
                                    key: const ValueKey('subtitle'),
                                    child: widget.subtitle!.muted().small(),
                                  ),
                              ],
                            ),
                      ),
                      if (widget.trailing.isNotEmpty)
                        if (!widget.trailingExpanded)
                          /// Creates a `Row` instance.
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: widget.trailing,
                          ).gap(widget.trailingGap ?? (4 * scaling))
                        else
                          /// Creates a `Expanded` instance.
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: widget.trailing,
                            ).gap(widget.trailingGap ?? (4 * scaling)),
                          ),
                    ],
                  ).gap(18 * scaling),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
