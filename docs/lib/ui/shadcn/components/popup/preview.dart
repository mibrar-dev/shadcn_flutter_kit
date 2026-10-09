// Gallery preview of the popup surface: a small profile card in the
// MenuPopup chrome. showShadcnPopup anchors the same surface to any widget.

import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import '../menu/menu.dart';

/// Gallery preview of [MenuPopup] / `showShadcnPopup`.
class PopupPreview extends StatelessWidget {
  /// Creates the preview.
  const PopupPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 220,
        child: MenuPopup(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Ibrar Ali'),
                  const SizedBox(height: 2),
                  Text(
                    'ibrar@example.com',
                    style: TextStyle(
                      fontSize: 12,
                      color: ShadcnTheme.of(context).colors.mutedForeground,
                    ),
                  ),
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
        ),
      ),
    );
  }
}
