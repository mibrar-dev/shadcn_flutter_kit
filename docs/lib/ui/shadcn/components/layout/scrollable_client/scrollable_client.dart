// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../../shared/theme/theme.dart';
part '_impl/core/_scrollable_client_child_vicinity.dart';
part '_impl/core/scrollable_client_viewport.dart';
part '_impl/core/scrollable_client_2.dart';
part '_impl/core/render_scrollable_client_viewport.dart';

/// Theme data for [ScrollableClient].
class ScrollableClientTheme extends ComponentThemeData {
  /// Behavior for diagonal drag gestures.
  final DiagonalDragBehavior? diagonalDragBehavior;

  /// When drag gestures should start.
  final DragStartBehavior? dragStartBehavior;

  /// How the keyboard dismissal should behave.
  final ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;

  /// How to clip the scrollable content.
  final Clip? clipBehavior;

  /// How hit testing should behave for the scrollable.
  final HitTestBehavior? hitTestBehavior;

  /// Whether overscroll effects are enabled.
  final bool? overscroll;

  /// Creates a [ScrollableClientTheme].
  const ScrollableClientTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.diagonalDragBehavior,
    this.dragStartBehavior,
    this.keyboardDismissBehavior,
    this.clipBehavior,
    this.hitTestBehavior,
    this.overscroll,
  });

  /// Creates a copy of this theme with the given fields replaced.
  ScrollableClientTheme copyWith({
    ValueGetter<DiagonalDragBehavior?>? diagonalDragBehavior,
    ValueGetter<DragStartBehavior?>? dragStartBehavior,
    ValueGetter<ScrollViewKeyboardDismissBehavior?>? keyboardDismissBehavior,
    ValueGetter<Clip?>? clipBehavior,
    ValueGetter<HitTestBehavior?>? hitTestBehavior,
    ValueGetter<bool?>? overscroll,
  }) {
    return ScrollableClientTheme(
      diagonalDragBehavior: diagonalDragBehavior == null
          ? this.diagonalDragBehavior
          : diagonalDragBehavior(),
      dragStartBehavior: dragStartBehavior == null
          ? this.dragStartBehavior
          : dragStartBehavior(),
      keyboardDismissBehavior: keyboardDismissBehavior == null
          ? this.keyboardDismissBehavior
          : keyboardDismissBehavior(),
      clipBehavior: clipBehavior == null ? this.clipBehavior : clipBehavior(),
      hitTestBehavior: hitTestBehavior == null
          ? this.hitTestBehavior
          : hitTestBehavior(),
      overscroll: overscroll == null ? this.overscroll : overscroll(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) =>
      other is ScrollableClientTheme &&
      other.diagonalDragBehavior == diagonalDragBehavior &&
      other.dragStartBehavior == dragStartBehavior &&
      other.keyboardDismissBehavior == keyboardDismissBehavior &&
      other.clipBehavior == clipBehavior &&
      other.hitTestBehavior == hitTestBehavior &&
      other.overscroll == overscroll;

  @override
  int get hashCode => Object.hash(
    diagonalDragBehavior,
    dragStartBehavior,
    keyboardDismissBehavior,
    clipBehavior,
    hitTestBehavior,
    overscroll,
  );

  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() =>
      'ScrollableClientTheme(diagonalDragBehavior: $diagonalDragBehavior, dragStartBehavior: $dragStartBehavior, keyboardDismissBehavior: $keyboardDismissBehavior, clipBehavior: $clipBehavior, hitTestBehavior: $hitTestBehavior, overscroll: $overscroll)';
}

/// Builder function for creating scrollable content with viewport information.
typedef ScrollableBuilder =
    Widget Function(
      BuildContext context,
      Offset offset,
      Size viewportSize,
      Widget? child,
    );

/// A customizable scrollable widget with two-axis scrolling support.

/// Viewport widget for [ScrollableClient] with two-dimensional scrolling.

/// Render object for [ScrollableClientViewport].
