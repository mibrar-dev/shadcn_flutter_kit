// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../scaffold.dart';

/// ScaffoldState defines a reusable type for this registry module.
class ScaffoldState extends State<Scaffold> {
  /// Builds the header section of the scaffold.
  ///
  /// Parameters:
  /// - [context] (`BuildContext`, required): Build context.
  ///
  /// Returns: Widget tree for the header.
  Widget buildHeader(BuildContext context) {
    final compTheme = ComponentTheme.maybeOf<ScaffoldTheme>(context);
    return RepaintBoundary(
      child: Container(
        color: widget.headerBackgroundColor ?? compTheme?.headerBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Creates a `Column` instance.
            Column(
              verticalDirection: VerticalDirection.up,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.loadingProgress != null ||
                    widget.loadingProgressIndeterminate)
                  /// Creates a `SizedBox` instance.
                  SizedBox(
                    // to make it float
                    height: 0,
                    child: Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.passthrough,
                      children: [
                        /// Creates a `Positioned` instance.
                        Positioned(
                          left: 0,
                          right: 0,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                            value: widget.loadingProgressIndeterminate
                                ? null
                                : widget.loadingProgress,
                            showSparks: false,
                          ),
                        ),
                      ],
                    ),
                  ),

                /// Creates a `Column` instance.
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = 0; i < widget.headers.length; i++)
                      /// Creates a `Data.inherit` instance.
                      Data.inherit(
                        data: ScaffoldBarData(
                          childIndex: i,
                          childrenCount: widget.headers.length,
                        ),
                        child: widget.headers[i],
                      ),
                  ],
                ),
              ],
            ),
            if (widget.loadingProgress != null &&
                (widget.showLoadingSparks ??
                    compTheme?.showLoadingSparks ??
                    false))
              /// Creates a `SizedBox` instance.
              SizedBox(
                // to make it float
                height: 0,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.passthrough,
                  children: [
                    /// Creates a `Positioned` instance.
                    Positioned(
                      left: 0,
                      right: 0,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        value: widget.loadingProgressIndeterminate
                            ? null
                            : widget.loadingProgress,
                        showSparks: true,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds the footer section of the scaffold.
  ///
  /// Parameters:
  /// - [context] (`BuildContext`, required): Build context.
  /// - [viewInsets] (`EdgeInsets`, required): View insets (e.g., keyboard).
  ///
  /// Returns: Widget tree for the footer.
  Widget buildFooter(BuildContext context, EdgeInsets viewInsets) {
    final compTheme = ComponentTheme.maybeOf<ScaffoldTheme>(context);
    return Offstage(
      offstage: viewInsets.bottom > 0,
      child: RepaintBoundary(
        child: Container(
          color:
              widget.footerBackgroundColor ?? compTheme?.footerBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < widget.footers.length; i++)
                /// Creates a `Data.inherit` instance.
                Data.inherit(
                  data: ScaffoldBarData(
                    isHeader: false,
                    childIndex: i,
                    childrenCount: widget.footers.length,
                  ),
                  child: widget.footers[i],
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Executes `_buildContent` behavior for this component/composite.
  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<ScaffoldTheme>(context);
    final viewInsets = MediaQuery.viewInsetsOf(context);
    return DrawerOverlay(
      child: Container(
        color:
            widget.backgroundColor ??
            compTheme?.backgroundColor ??
            theme.colorScheme.background,
        child: _ScaffoldFlex(
          floatingHeader: widget.floatingHeader,
          floatingFooter: widget.floatingFooter,
          children: [
            /// Creates a `buildHeader` instance.
            buildHeader(context),

            /// Creates a `LayoutBuilder` instance.
            LayoutBuilder(
              builder: (context, constraints) {
                Widget child =
                    (widget.resizeToAvoidBottomInset ??
                        compTheme?.resizeToAvoidBottomInset ??
                        true)
                    ? Container(
                        // Clamp to prevent negative padding on web when keyboard appears
                        padding: EdgeInsets.only(
                          bottom: viewInsets.bottom.clamp(0.0, double.infinity),
                        ),
                        child: MediaQuery(
                          data: MediaQuery.of(context).copyWith(
                            viewInsets: viewInsets.copyWith(bottom: 0),
                          ),
                          child: widget.child,
                        ),
                      )
                    : widget.child;
                if (constraints is ScaffoldBoxConstraints &&
                    (widget.floatingHeader || widget.floatingFooter)) {
                  final currentMediaQuery = MediaQuery.of(context);

                  /// Stores `padding` state/configuration for this implementation.
                  EdgeInsets padding = currentMediaQuery.padding;
                  if (widget.floatingHeader) {
                    padding += EdgeInsets.only(top: constraints.headerHeight);
                  }
                  if (widget.floatingFooter) {
                    padding += EdgeInsets.only(
                      bottom: constraints.footerHeight,
                    );
                  }
                  child = MediaQuery(
                    data: currentMediaQuery.copyWith(padding: padding),
                    child: RepaintBoundary(child: child),
                  );
                }
                return child;
              },
            ),

            /// Creates a `buildFooter` instance.
            buildFooter(context, viewInsets),
          ],
        ),
      ),
    );
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Overlay(initialEntries: [OverlayEntry(builder: _buildContent)]);
  }
}
