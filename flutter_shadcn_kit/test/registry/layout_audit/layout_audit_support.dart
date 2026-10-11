// Shared harness for the P6-D9b layout audit.
//
// Every assertion in this directory renders a component under a fixed density
// and measures the result with `tester.getSize` / `tester.getRect`. The three
// densities mirror `Density` in `registry/theme/density.dart`:
//
//   compact      baseContainerPadding 8,  baseContentPadding 8,  baseGap 4
//   default      16 / 16 / 8   (the shadcn reference size)
//   comfortable  20 / 20 / 10
//
// `Density.copyWith` also re-derives `spacing` from `baseGap` (`baseGap / 2`),
// so the audit theme always keeps the two scales consistent.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/theme/density.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_shadcn_kit/registry/primitives/clickable.dart';
import 'package:flutter_test/flutter_test.dart';

/// `Density.compactDensity` — 8 / 8 / 4.
const Density auditCompact = Density.compactDensity;

/// `Density.defaultDensity` — 16 / 16 / 8; the shadcn reference size.
const Density auditDefault = Density.defaultDensity;

/// `Density.spaciousDensity` — 20 / 20 / 10.
const Density auditComfortable = Density.spaciousDensity;

/// All audited densities, in ascending order.
const List<Density> auditDensities = <Density>[
  auditCompact,
  auditDefault,
  auditComfortable,
];

/// Names paired with [auditDensities] for test output.
const List<String> auditDensityNames = <String>[
  'compact',
  'default',
  'comfortable',
];

/// Wraps [child] in an audit theme with [density] and [textDirection].
Widget auditFrame({
  required Widget child,
  Density density = auditDefault,
  TextDirection textDirection = TextDirection.ltr,
  Widget? parent,
}) {
  final ShadcnThemeData data = const ShadcnThemeData().copyWith(
    density: () => density,
  );
  Widget body = Directionality(
    textDirection: textDirection,
    child: parent ?? child,
  );
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(themes: const <ComponentThemeData>[], child: body),
  );
}

/// A loose parent: a wide `Row`/`Column` the component may shrink inside.
///
/// Used for the no-stretch and no-compact assertions: an intrinsic-size
/// component must ignore the extra room, and a tight one must keep padding.
Widget looseHost({required Widget child, Axis axis = Axis.horizontal}) {
  if (axis == Axis.horizontal) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[child],
    );
  }
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[child],
  );
}

/// Where [resolvedPaddingOf] should read a component's padding from.
enum PaddingSource {
  /// `Clickable` padding first, then an inner `Padding`.
  auto,

  /// Only the `Clickable` padding (components that hand it to the primitive).
  clickable,

  /// Only an inner `Padding` widget.
  padding,
}

/// First [Padding] inside a component of type [T].
EdgeInsetsGeometry paddingOf(WidgetTester tester, Type type, {int index = 0}) {
  return tester
      .widgetList<Padding>(
        find.descendant(of: find.byType(type), matching: find.byType(Padding)),
      )
      .elementAt(index)
      .padding;
}

/// First resolved [EdgeInsets] inside a component of type [T].
///
/// The `Clickable` padding wins when the component hands its padding to the
/// primitive (button, input); a component that builds its own `Padding`
/// (chip, badge, card) has no Clickable padding and falls through to it.
EdgeInsets resolvedPaddingOf(
  WidgetTester tester,
  Type type, {
  int index = 0,
  PaddingSource source = PaddingSource.auto,
}) {
  final EdgeInsetsGeometry? fromClickable = source == PaddingSource.padding
      ? null
      : _clickablePaddingOf(tester, type);
  final EdgeInsetsGeometry? fromPadding = source == PaddingSource.clickable
      ? null
      : _firstPaddingOf(tester, type, index);
  final EdgeInsetsGeometry geometry =
      fromClickable ?? fromPadding ?? EdgeInsets.zero;
  return geometry.resolve(Directionality.of(tester.element(find.byType(type))));
}

EdgeInsetsGeometry? _firstPaddingOf(WidgetTester tester, Type type, int index) {
  final Iterable<Padding> matches = tester.widgetList<Padding>(
    find.descendant(of: find.byType(type), matching: find.byType(Padding)),
  );
  if (matches.length <= index) {
    return null;
  }
  return matches.elementAt(index).padding;
}

/// Padding of the `Clickable` inside [type], when the component uses that
/// primitive for its padding (button, input).
EdgeInsetsGeometry? _clickablePaddingOf(WidgetTester tester, Type type) {
  final Iterable<Clickable> matches = tester.widgetList<Clickable>(
    find.descendant(of: find.byType(type), matching: find.byType(Clickable)),
  );
  for (final Clickable clickable in matches) {
    final WidgetStateProperty<EdgeInsetsGeometry?>? property =
        clickable.padding;
    if (property != null) {
      final EdgeInsetsGeometry? resolved = property.resolve(
        const <WidgetState>{},
      );
      if (resolved != null) {
        return resolved;
      }
    }
  }
  return null;
}

/// Size of a component of type [T].
Size sizeOf(WidgetTester tester, Type type, {int index = 0}) =>
    tester.getSize(find.byType(type).at(index));

/// Rect of a component of type [T].
Rect rectOf(WidgetTester tester, Type type, {int index = 0}) =>
    tester.getRect(find.byType(type).at(index));

/// Rect of the widget with key [key].
Rect rectOfKey(WidgetTester tester, Key key) => tester.getRect(find.byKey(key));

/// Size of the widget with key [key].
Size sizeOfKey(WidgetTester tester, Key key) => tester.getSize(find.byKey(key));
