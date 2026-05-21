// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

/// Extension adding layout and styling utilities to widgets.
extension WidgetExtension on Widget {
  /// Converts this widget to a builder function.
  NeverWidgetBuilder get asBuilder =>
      ([a, b, c, d, e, f, g, h, i, j]) => this;

  /// Executes `sized` behavior for this component/composite.
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
    /// Creates a `assert` instance.
    assert(() {
      if (all != null) {
        if (top != null ||
            bottom != null ||
            left != null ||
            right != null ||
            horizontal != null ||
            vertical != null) {
          throw FlutterError(
            'All padding properties cannot be used with other padding properties.',
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
    var edgeInsets = EdgeInsets.only(
      top: top ?? vertical ?? all ?? 0,
      bottom: bottom ?? vertical ?? all ?? 0,
      left: left ?? horizontal ?? all ?? 0,
      right: right ?? horizontal ?? all ?? 0,
    );
    return Padding(padding: padding ?? edgeInsets, child: this);
  }

  /// Executes `center` behavior for this component/composite.
  Widget center({Key? key}) {
    return Center(key: key, child: this);
  }

  /// Executes `withAlign` behavior for this component/composite.
  Widget withAlign(AlignmentGeometry alignment) {
    return Align(alignment: alignment, child: this);
  }

  Widget positioned({
    Key? key,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return Positioned(
      key: key,
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: this,
    );
  }

  /// Executes `expanded` behavior for this component/composite.
  Widget expanded({int flex = 1}) {
    return Expanded(flex: flex, child: this);
  }

  /// Executes `withOpacity` behavior for this component/composite.
  Widget withOpacity(double opacity) {
    return Opacity(opacity: opacity, child: this);
  }

  /// Executes `clip` behavior for this component/composite.
  Widget clip({Clip clipBehavior = Clip.hardEdge}) {
    return ClipRect(clipBehavior: clipBehavior, child: this);
  }

  Widget clipRRect({
    BorderRadiusGeometry borderRadius = BorderRadius.zero,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return ClipRRect(
      borderRadius: borderRadius,
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  /// Executes `clipOval` behavior for this component/composite.
  Widget clipOval({Clip clipBehavior = Clip.antiAlias}) {
    return ClipOval(clipBehavior: clipBehavior, child: this);
  }

  Widget clipPath({
    Clip clipBehavior = Clip.antiAlias,
    required CustomClipper<Path> clipper,
  }) {
    return ClipPath(clipBehavior: clipBehavior, clipper: clipper, child: this);
  }

  /// Executes `transform` behavior for this component/composite.
  Widget transform({Key? key, required Matrix4 transform}) {
    return Transform(key: key, transform: transform, child: this);
  }

  /// Executes `intrinsicWidth` behavior for this component/composite.
  Widget intrinsicWidth({double? stepWidth, double? stepHeight}) {
    return IntrinsicWidth(
      stepWidth: stepWidth,
      stepHeight: stepHeight,
      child: this,
    );
  }

  /// Executes `intrinsicHeight` behavior for this component/composite.
  Widget intrinsicHeight() {
    return IntrinsicHeight(child: this);
  }

  /// Executes `intrinsic` behavior for this component/composite.
  Widget intrinsic({double? stepWidth, double? stepHeight}) {
    return IntrinsicWidth(
      stepWidth: stepWidth,
      stepHeight: stepHeight,
      child: IntrinsicHeight(child: this),
    );
  }
}

/// Extension for Column widgets.
extension ColumnExtension on Column {
  /// Executes `gap` behavior for this component/composite.
  Widget gap(double gap) {
    return separator(SizedBox(height: gap));
  }

  /// Executes `separator` behavior for this component/composite.
  Widget separator(Widget separator) {
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
      separator: separator,
      children: children,
    );
  }
}

/// Extension for Row widgets.
extension RowExtension on Row {
  /// Executes `gap` behavior for this component/composite.
  Widget gap(double gap) {
    return separator(SizedBox(width: gap));
  }

  /// Executes `separator` behavior for this component/composite.
  Widget separator(Widget separator) {
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
      separator: separator,
      children: children,
    );
  }
}

/// Extension for Flex widgets.
extension FlexExtension on Flex {
  /// Executes `gap` behavior for this component/composite.
  Widget gap(double gap) {
    return separator(
      direction == Axis.vertical ? SizedBox(height: gap) : SizedBox(width: gap),
    );
  }

  /// Executes `separator` behavior for this component/composite.
  Widget separator(Widget separator) {
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
      separator: separator,
      children: children,
    );
  }
}

/// Extension for double.
extension DoubleExtension on double {
  /// Executes `min` behavior for this component/composite.
  double min(double other) => this < other ? this : other;

  /// Executes `max` behavior for this component/composite.
  double max(double other) => this > other ? this : other;
}

/// Extension for int.
extension IntExtension on int {
  /// Executes `min` behavior for this component/composite.
  int min(int other) => this < other ? this : other;

  /// Executes `max` behavior for this component/composite.
  int max(int other) => this > other ? this : other;
}

/// Type alias for `NeverWidgetBuilder` used by public or internal APIs.
typedef NeverWidgetBuilder =
    Widget Function([
      dynamic,
      dynamic,
      dynamic,
      dynamic,
      dynamic,
      dynamic,
      dynamic,
      dynamic,
      dynamic,
      dynamic,
    ]);

// Reference to SeparatedFlex from util.dart
/// SeparatedFlex defines a reusable type for this registry module.
class SeparatedFlex extends StatefulWidget {
  /// Stores `mainAxisAlignment` state/configuration for this implementation.
  final MainAxisAlignment mainAxisAlignment;

  /// Stores `mainAxisSize` state/configuration for this implementation.
  final MainAxisSize mainAxisSize;

  /// Stores `crossAxisAlignment` state/configuration for this implementation.
  final CrossAxisAlignment crossAxisAlignment;

  /// Stores `textDirection` state/configuration for this implementation.
  final TextDirection? textDirection;

  /// Stores `verticalDirection` state/configuration for this implementation.
  final VerticalDirection verticalDirection;

  /// Stores `textBaseline` state/configuration for this implementation.
  final TextBaseline? textBaseline;

  /// Stores `children` state/configuration for this implementation.
  final List<Widget> children;

  /// Stores `direction` state/configuration for this implementation.
  final Axis direction;

  /// Stores `separator` state/configuration for this implementation.
  final Widget separator;

  /// Stores `clipBehavior` state/configuration for this implementation.
  final Clip clipBehavior;

  /// Creates a `SeparatedFlex` instance.
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
  /// Executes `createState` behavior for this component/composite.
  State<SeparatedFlex> createState() => _SeparatedFlexState();
}

/// _SeparatedFlexState defines a reusable type for this registry module.
class _SeparatedFlexState extends State<SeparatedFlex> {
  /// Stores `_children` state/configuration for this implementation.
  late List<Widget> _children;

  @override
  /// Executes `initState` behavior for this component/composite.
  void initState() {
    super.initState();
    _children = _join(widget.children, widget.separator).toList();
  }

  @override
  /// Executes `didUpdateWidget` behavior for this component/composite.
  void didUpdateWidget(covariant SeparatedFlex oldWidget) {
    super.didUpdateWidget(oldWidget);
    _children = _join(widget.children, widget.separator).toList();
  }

  /// Executes `_join` behavior for this component/composite.
  Iterable<Widget> _join(Iterable<Widget> widgets, Widget separator) {
    return widgets
        .map((e) => [separator, e])
        .expand((element) => element)
        .skip(1);
  }

  @override
  /// Executes `build` behavior for this component/composite.
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
