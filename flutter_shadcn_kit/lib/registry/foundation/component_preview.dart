// The docs preview contract: one named example at a time.
//
// Every listed component exports `const List<ComponentPreview> <name>Previews`
// from its `preview.dart`; the docs page renders one example behind a `Select`
// instead of a page-long gallery. The first entry is the default.
//
// Rules an example must respect (P6-F3):
//   * it reads `ShadcnTheme.of(context)` and never hard-codes
//     `ShadcnThemeData`, so the site light/dark toggle re-themes it;
//   * it shrink-wraps inside a bounded box (720x420 in the tests, 375 wide on
//     a phone) with no outer fixed height, no `Expanded` and no assumption of
//     unbounded space;
//   * controllers and other state are created inside the example's own
//     `StatefulWidget`, so two examples never share one.

import 'package:flutter/widgets.dart';

/// One named docs example of a component.
class ComponentPreview {
  /// Creates an example.
  const ComponentPreview(this.name, this.builder, {this.description});

  /// Label shown in the docs `Select`.
  final String name;

  /// Builds the example; it receives the ambient theme through the context.
  final WidgetBuilder builder;

  /// Optional one-line explanation rendered under the example `Select`.
  final String? description;
}
