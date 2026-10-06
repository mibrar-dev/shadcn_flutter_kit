// Widget/value convenience extensions shared across the registry.
//
// Ported from `shared/utils/widget_extensions.dart` and
// `shared/primitives/icon_extensions.dart`, pruned of the members with zero
// call sites (see rearch/reports/P2E1_PRIMITIVES.md): `.center()`,
// `.positioned()`, `.clip()`, `.clipRRect()`, `.clipOval()`,
// `.intrinsicWidth()`, `.intrinsicHeight()`, `.intrinsic()`, `.separator()`
// and `.asBuilder` were removed.
//
// `NeverWidgetBuilder` stays in `foundation/util.dart` (single owner).

import 'package:flutter/widgets.dart';

import '../theme/theme.dart';

/// Applies the ambient theme's icon sizes and muted colour to a widget.
extension IconExtensions on Widget {
  /// Applies the small icon theme.
  Widget iconSmall() {
    return Builder(
      builder: (context) {
        final theme = ShadcnTheme.of(context);
        final inherited = IconTheme.of(context);
        return IconTheme(
          data: theme.iconTheme.small.merge(inherited),
          child: this,
        );
      },
    );
  }

  /// Applies the extra-small icon theme.
  Widget iconXSmall() {
    return Builder(
      builder: (context) {
        final theme = ShadcnTheme.of(context);
        final inherited = IconTheme.of(context);
        return IconTheme(
          data: theme.iconTheme.xSmall.merge(inherited),
          child: this,
        );
      },
    );
  }

  /// Applies the extra-extra-extra-small icon theme.
  Widget iconX3Small() {
    return Builder(
      builder: (context) {
        final theme = ShadcnTheme.of(context);
        final inherited = IconTheme.of(context);
        return IconTheme(
          data: theme.iconTheme.x3Small.merge(inherited),
          child: this,
        );
      },
    );
  }

  /// Applies the muted-foreground colour to the icon theme.
  Widget iconMutedForeground() {
    return Builder(
      builder: (context) {
        final theme = ShadcnTheme.of(context);
        final inherited = IconTheme.of(context);
        return IconTheme(
          data: IconThemeData(
            color: theme.colors.mutedForeground,
          ).merge(inherited),
          child: this,
        );
      },
    );
  }
}

/// Layout and sizing helpers.
extension WidgetExtension on Widget {
  /// Wraps this widget in a [SizedBox], preserving an existing one's size
  /// when the argument is null.
  Widget sized({double? width, double? height}) {
    if (this is SizedBox) {
      return SizedBox(
        width: width ?? (this as SizedBox).width,
        height: height ?? (this as SizedBox).height,
        child: (this as SizedBox).child,
      );
    }
    return SizedBox(width: width, height: height, child: this);
  }

  /// Wraps this widget in a [ConstrainedBox], preserving an existing one's
  /// constraints when the arguments are null.
  Widget constrained({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
    double? width,
    double? height,
  }) {
    if (this is ConstrainedBox) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minWidth:
              width ??
              minWidth ??
              (this as ConstrainedBox).constraints.minWidth,
          maxWidth:
              width ??
              maxWidth ??
              (this as ConstrainedBox).constraints.maxWidth,
          minHeight:
              height ??
              minHeight ??
              (this as ConstrainedBox).constraints.minHeight,
          maxHeight:
              height ??
              maxHeight ??
              (this as ConstrainedBox).constraints.maxHeight,
        ),
        child: (this as ConstrainedBox).child,
      );
    }
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: width ?? minWidth ?? 0,
        maxWidth: width ?? maxWidth ?? double.infinity,
        minHeight: height ?? minHeight ?? 0,
        maxHeight: height ?? maxHeight ?? double.infinity,
      ),
      child: this,
    );
  }

  /// Wraps this widget in a [Padding].
  ///
  /// The single-value and horizontal/vertical forms are mutually exclusive;
  /// combining them asserts.
  Widget withPadding({
    double? top,
    double? bottom,
    double? left,
    double? right,
    double? horizontal,
    double? vertical,
    double? all,
    EdgeInsetsGeometry? padding,
  }) {
    assert(() {
      if (all != null) {
        if (top != null ||
            bottom != null ||
            left != null ||
            right != null ||
            horizontal != null ||
            vertical != null) {
          throw FlutterError(
            'All padding properties cannot be used with other padding '
            'properties.',
          );
        }
      } else if (horizontal != null) {
        if (left != null || right != null) {
          throw FlutterError(
            'Horizontal padding cannot be used with left or right padding.',
          );
        }
      } else if (vertical != null) {
        if (top != null || bottom != null) {
          throw FlutterError(
            'Vertical padding cannot be used with top or bottom padding.',
          );
        }
      }
      return true;
    }());
    final edgeInsets = EdgeInsets.only(
      top: top ?? vertical ?? all ?? 0,
      bottom: bottom ?? vertical ?? all ?? 0,
      left: left ?? horizontal ?? all ?? 0,
      right: right ?? horizontal ?? all ?? 0,
    );
    return Padding(padding: padding ?? edgeInsets, child: this);
  }

  /// Wraps this widget in an [Align].
  Widget withAlign(AlignmentGeometry alignment) {
    return Align(alignment: alignment, child: this);
  }

  /// Wraps this widget in an [Expanded].
  Widget expanded({int flex = 1}) {
    return Expanded(flex: flex, child: this);
  }

  /// Wraps this widget in an [Opacity].
  Widget withOpacity(double opacity) {
    return Opacity(opacity: opacity, child: this);
  }

  /// Wraps this widget in a [ClipPath].
  Widget clipPath({
    Clip clipBehavior = Clip.antiAlias,
    required CustomClipper<Path> clipper,
  }) {
    return ClipPath(clipBehavior: clipBehavior, clipper: clipper, child: this);
  }

  /// Wraps this widget in a [Transform].
  Widget transform({Key? key, required Matrix4 transform}) {
    return Transform(key: key, transform: transform, child: this);
  }
}

/// `gap` helper for [Column]s: inserts a vertical gap between children.
extension ColumnExtension on Column {
  /// Returns a [Column] with a vertical [gap] between every two children.
  Widget gap(double gap) {
    return SeparatedFlex(
      key: key,
      direction: Axis.vertical,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      separator: SizedBox(height: gap),
      children: children,
    );
  }
}

/// `gap` helper for [Row]s: inserts a horizontal gap between children.
extension RowExtension on Row {
  /// Returns a [Row] with a horizontal [gap] between every two children.
  Widget gap(double gap) {
    return SeparatedFlex(
      key: key,
      direction: Axis.horizontal,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      separator: SizedBox(width: gap),
      children: children,
    );
  }
}

/// `gap` helper for any [Flex].
extension FlexExtension on Flex {
  /// Returns a [Flex] with a [gap] between every two children along
  /// [direction].
  Widget gap(double gap) {
    return SeparatedFlex(
      key: key,
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      separator: direction == Axis.vertical
          ? SizedBox(height: gap)
          : SizedBox(width: gap),
      children: children,
    );
  }
}

/// Numeric min/max helpers.
extension DoubleExtension on double {
  /// Smaller of this value and [other].
  double min(double other) => this < other ? this : other;

  /// Larger of this value and [other].
  double max(double other) => this > other ? this : other;
}

/// Integer min/max helpers.
extension IntExtension on int {
  /// Smaller of this value and [other].
  int min(int other) => this < other ? this : other;

  /// Larger of this value and [other].
  int max(int other) => this > other ? this : other;
}

/// A [Flex] that inserts [separator] between every two [children].
class SeparatedFlex extends StatefulWidget {
  /// Main-axis alignment.
  final MainAxisAlignment mainAxisAlignment;

  /// Main-axis size.
  final MainAxisSize mainAxisSize;

  /// Cross-axis alignment.
  final CrossAxisAlignment crossAxisAlignment;

  /// Text direction passed to the [Flex].
  final TextDirection? textDirection;

  /// Vertical direction passed to the [Flex].
  final VerticalDirection verticalDirection;

  /// Text baseline passed to the [Flex].
  final TextBaseline? textBaseline;

  /// The children, without separators.
  final List<Widget> children;

  /// Flex direction.
  final Axis direction;

  /// Inserted between every two children.
  final Widget separator;

  /// Clip behavior passed to the [Flex].
  final Clip clipBehavior;

  /// Creates a [SeparatedFlex].
  const SeparatedFlex({
    super.key,
    required this.mainAxisAlignment,
    required this.mainAxisSize,
    required this.crossAxisAlignment,
    this.textDirection,
    required this.verticalDirection,
    this.textBaseline,
    required this.children,
    required this.separator,
    required this.direction,
    this.clipBehavior = Clip.none,
  });

  @override
  State<SeparatedFlex> createState() => _SeparatedFlexState();
}

class _SeparatedFlexState extends State<SeparatedFlex> {
  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = _join(widget.children, widget.separator).toList();
  }

  @override
  void didUpdateWidget(covariant SeparatedFlex oldWidget) {
    super.didUpdateWidget(oldWidget);
    _children = _join(widget.children, widget.separator).toList();
  }

  Iterable<Widget> _join(Iterable<Widget> widgets, Widget separator) {
    return widgets
        .map((e) => [separator, e])
        .expand((element) => element)
        .skip(1);
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      key: widget.key,
      direction: widget.direction,
      mainAxisAlignment: widget.mainAxisAlignment,
      mainAxisSize: widget.mainAxisSize,
      crossAxisAlignment: widget.crossAxisAlignment,
      textDirection: widget.textDirection,
      verticalDirection: widget.verticalDirection,
      textBaseline: widget.textBaseline,
      clipBehavior: widget.clipBehavior,
      children: _children,
    );
  }
}
