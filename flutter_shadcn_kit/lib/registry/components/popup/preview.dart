// Named examples for the `popup` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../theme/theme.dart';
import '../menu/menu.dart';
import 'popup.dart';

/// The profile card shown on the popup surface by both examples.
class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Ibrar Ali'),
              SizedBox(height: 2),
              Text('ibrar@example.com', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        const MenuSeparator(),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Signed in with a passkey',
            style: TextStyle(
              fontSize: 12,
              color: ShadcnTheme.of(context).colors.mutedForeground,
            ),
          ),
        ),
      ],
    );
  }
}

/// The popup surface rendered inline.
Widget _default(BuildContext context) {
  return const SizedBox(
    width: 220,
    child: MenuPopup(children: <Widget>[_ProfileCard()]),
  );
}

/// A trigger that anchors the same surface with `showShadcnPopup`.
class _AnchoredDemo extends StatelessWidget {
  const _AnchoredDemo();

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return GestureDetector(
      onTap: () => showShadcnPopup(
        context: context,
        builder: (BuildContext context) => const _ProfileCard(),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colors.secondary,
          borderRadius: theme.borderRadiusMd,
        ),
        child: const Text('Show popup'),
      ),
    );
  }
}

Widget _anchored(BuildContext context) => const _AnchoredDemo();

/// Named docs examples for `popup`; the first entry is the default.
const List<ComponentPreview> popupPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Anchored', _anchored),
];
