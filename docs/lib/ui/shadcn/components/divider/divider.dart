// The `divider` component: [Divider], a themed rule in either orientation,
// optionally carrying a centred label.
//
// The old module had two nearly identical widgets (`Divider` +
// `VerticalDivider`, 991 lines) plus three painters and the
// `AxisAlignmentGeometry` family. `VerticalDivider` ignored
// `ComponentTheme`/`DividerTheme` entirely and hard-coded `colorScheme.border`
// and `theme.iconTheme`, so a themed divider silently lost its theme in the
// vertical orientation. One widget with an `axis` keeps a single resolution
// path (PLAN §4 rule 2) and drops the whole alignment hierarchy.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'divider_style.dart';

export 'divider_style.dart';

/// A one-pixel themed rule separating content, with an optional label.
///
/// One widget for both orientations: shadcn's `Separator` is the same element
/// with `orientation: horizontal | vertical`. The label splits the rule and is
/// placed with [DividerLabelAlignment].
class Divider extends StatelessWidget {
  /// Creates a divider.
  const Divider({
    super.key,
    this.axis = Axis.horizontal,
    this.color,
    this.thickness,
    this.extent,
    this.indent,
    this.endIndent,
    this.label,
    this.labelPadding,
    this.labelAlignment,
    this.theme,
  });

  /// Orientation of the rule. A horizontal divider fills the available width;
  /// a vertical one fills the available height.
  final Axis axis;

  /// Rule colour override; null falls back to `DividerTheme.color`.
  final ThemedColor? color;

  /// Stroke width override; null falls back to `DividerTheme.thickness`.
  final double? thickness;

  /// Cross-axis extent override; null falls back to `DividerTheme.extent`.
  final double? extent;

  /// Space before the rule. Applies to the leading edge in both orientations.
  final double? indent;

  /// Space after the rule. Applies to the trailing edge in both orientations.
  final double? endIndent;

  /// Optional label centred in the rule. Omit it for a plain rule.
  final Widget? label;

  /// Padding around [label]; null falls back to `DividerTheme.labelPadding`, a
  /// density-scaled shadcn `px-2` that this widget resolves against
  /// `density.baseContentPadding * scaling`. A literal override passes
  /// through unchanged.
  final EdgeInsetsGeometry? labelPadding;

  /// Cross-axis placement of [label]; null falls back to
  /// `DividerTheme.labelAlignment`.
  final DividerLabelAlignment? labelAlignment;

  /// Widget-leg override, merged over the component/app/defaults legs.
  final DividerTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final DividerTheme style =
        resolveComponentStyle<DividerTheme, DividerTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: dividerDefaults,
        );
    final Color resolved =
        (color ?? style.color)?.resolve(ambient.colors) ??
        ambient.colors.border;
    final double stroke =
        thickness ?? style.thickness ?? dividerDefaultThickness;
    final double cross = extent ?? style.extent ?? dividerDefaultExtent;
    final double leading = indent ?? style.indent ?? 0;
    final double trailing = endIndent ?? style.endIndent ?? 0;

    // `indent`/`endIndent` are logical (before/after the rule). A horizontal
    // rule mirrors in RTL: the `Row` child order mirrors by itself, but the
    // painter's physical insets need the swap done here. (Vertical rules are
    // unaffected by text direction.)
    final bool rtl =
        axis == Axis.horizontal &&
        Directionality.of(context) == TextDirection.rtl;

    if (label == null) {
      // A bare rule is decorative: keep it out of the semantics tree.
      return ExcludeSemantics(
        child: axis == Axis.horizontal
            ? SizedBox(
                width: double.infinity,
                height: cross,
                child: CustomPaint(
                  painter: _RulePainter(
                    color: resolved,
                    thickness: stroke,
                    insetStart: rtl ? trailing : leading,
                    insetEnd: rtl ? leading : trailing,
                    vertical: false,
                  ),
                ),
              )
            : SizedBox(
                width: cross,
                height: double.infinity,
                child: CustomPaint(
                  painter: _RulePainter(
                    color: resolved,
                    thickness: stroke,
                    insetStart: leading,
                    insetEnd: trailing,
                    vertical: true,
                  ),
                ),
              ),
      );
    }

    final TextStyle labelStyle = (style.labelStyle ?? dividerDefaultLabelStyle)
        .copyWith(color: ambient.colors.mutedForeground);
    final EdgeInsetsGeometry padding = resolveEdgeInsets(
      labelPadding ?? style.labelPadding ?? dividerDefaultLabelPadding,
      ambient.density.baseContentPadding * ambient.scaling,
    );
    final DividerLabelAlignment alignment =
        labelAlignment ?? style.labelAlignment ?? DividerLabelAlignment.center;
    final Widget labelWidget = Padding(
      padding: padding,
      child: DefaultTextStyle.merge(style: labelStyle, child: label!),
    );

    if (axis == Axis.horizontal) {
      final List<Widget> row = <Widget>[];
      // Positioned first, so the `Row` mirrors it to the leading side in
      // RTL by itself.
      if (leading > 0) row.add(SizedBox(width: leading));
      row.add(
        Expanded(
          flex: _flexFor(alignment, leadingSide: true),
          child: SizedBox(
            height: cross,
            child: CustomPaint(
              painter: _RulePainter(
                color: resolved,
                thickness: stroke,
                insetStart: 0,
                insetEnd: 0,
                vertical: false,
              ),
            ),
          ),
        ),
      );
      row.add(labelWidget);
      row.add(
        Expanded(
          flex: _flexFor(alignment, leadingSide: false),
          child: SizedBox(
            height: cross,
            child: CustomPaint(
              painter: _RulePainter(
                color: resolved,
                thickness: stroke,
                // Logical trailing gap: the physical side mirrors in RTL.
                insetStart: rtl ? trailing : 0,
                insetEnd: rtl ? 0 : trailing,
                vertical: false,
              ),
            ),
          ),
        ),
      );
      return IntrinsicHeight(
        child: Row(mainAxisSize: MainAxisSize.min, children: row),
      );
    }

    final List<Widget> column = <Widget>[];
    if (leading > 0) column.add(SizedBox(height: leading));
    column.add(
      Expanded(
        flex: _flexFor(alignment, leadingSide: true),
        child: SizedBox(
          width: cross,
          child: CustomPaint(
            painter: _RulePainter(
              color: resolved,
              thickness: stroke,
              insetStart: 0,
              insetEnd: 0,
              vertical: true,
            ),
          ),
        ),
      ),
    );
    column.add(labelWidget);
    column.add(
      Expanded(
        flex: _flexFor(alignment, leadingSide: false),
        child: SizedBox(
          width: cross,
          child: CustomPaint(
            painter: _RulePainter(
              color: resolved,
              thickness: stroke,
              insetStart: 0,
              insetEnd: trailing,
              vertical: true,
            ),
          ),
        ),
      ),
    );
    return IntrinsicWidth(
      child: Column(mainAxisSize: MainAxisSize.min, children: column),
    );
  }

  /// Share of the split rule before (or after) the label.
  ///
  /// `start` collapses the leading half and gives the trailing half all the
  /// flex, so the label sits at the start; `center` splits evenly and `end`
  /// does the opposite. Flex is an int, so a zero share is expressed as a
  /// collapsed box rather than `flex: 0`.
  static int _flexFor(
    DividerLabelAlignment alignment, {
    required bool leadingSide,
  }) {
    return switch (alignment) {
      DividerLabelAlignment.center => 1,
      DividerLabelAlignment.start => leadingSide ? 0 : 1,
      DividerLabelAlignment.end => leadingSide ? 1 : 0,
    };
  }
}

/// Paints a straight rule between two insets.
class _RulePainter extends CustomPainter {
  const _RulePainter({
    required this.color,
    required this.thickness,
    required this.insetStart,
    required this.insetEnd,
    required this.vertical,
  });

  final Color color;
  final double thickness;
  final double insetStart;
  final double insetEnd;
  final bool vertical;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.square;
    if (vertical) {
      final double x = size.width / 2;
      canvas.drawLine(
        Offset(x, insetStart),
        Offset(x, size.height - insetEnd),
        paint,
      );
      return;
    }
    final double y = size.height / 2;
    canvas.drawLine(
      Offset(insetStart, y),
      Offset(size.width - insetEnd, y),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RulePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.thickness != thickness ||
      oldDelegate.insetStart != insetStart ||
      oldDelegate.insetEnd != insetEnd ||
      oldDelegate.vertical != vertical;
}
