// Named examples for the `scaffold` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle. Each shell carries its own bounded box because the
// scaffold stretches to its constraints.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/icons/lucide_icons.dart';
import 'scaffold.dart';

/// A shell with a header bar, a footer bar and body content.
Widget _default(BuildContext context) {
  return const SizedBox(
    width: 360,
    height: 280,
    child: Scaffold(
      headers: <Widget>[
        AppBar(
          leading: <Widget>[Icon(LucideIcons.chevronLeft, size: 16)],
          title: Text('My Application'),
          subtitle: Text('Dashboard'),
          trailing: <Widget>[Icon(LucideIcons.ellipsis, size: 16)],
        ),
      ],
      footers: <Widget>[
        AppBar(title: Text('Status'), subtitle: Text('All systems go')),
      ],
      child: Center(child: Text('Main content area')),
    ),
  );
}

/// A shell showing the loading bar over fetching content.
Widget _withLoading(BuildContext context) {
  return const SizedBox(
    width: 360,
    height: 200,
    child: Scaffold(
      headers: <Widget>[AppBar(title: Text('Syncing'))],
      loadingProgress: 0.4,
      showLoadingSparks: true,
      child: Center(child: Text('Fetching...')),
    ),
  );
}

/// Named docs examples for `scaffold`; the first entry is the default.
const List<ComponentPreview> scaffoldPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('With loading', _withLoading),
];
