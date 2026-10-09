// Widgets-only preview gallery for the `page_route` component.
//
// Pushes and pops a real `ShadcnPageRoute` on a nested `Navigator`, and also
// pushes the `dialog` component on top of the page to show the exit transition
// that the old `canTransitionTo` used to suppress.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import '../dialog/dialog.dart';
import 'page_route.dart';

/// Preview entry point used by the docs gallery.
class PageRoutePreview extends StatelessWidget {
  /// Creates the preview.
  const PageRoutePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShadcnTheme(
      data: ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _PageRoutePreviewBody(),
      ),
    );
  }
}

class _PageRoutePreviewBody extends StatelessWidget {
  const _PageRoutePreviewBody();

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return ColoredBox(
      color: colors.background,
      child: SizedBox(
        width: 320,
        height: 220,
        child: Navigator(
          onGenerateRoute: (settings) => ShadcnPageRoute<void>(
            settings: settings,
            builder: (context) => _HomePage(),
          ),
        ),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ShadcnTheme.of(context).colors.background,
      child: Center(
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: <Widget>[
            Button(
              onPressed: () => Navigator.of(context).push(
                ShadcnPageRoute<void>(
                  settings: const RouteSettings(name: 'detail'),
                  builder: (context) => const _DetailPage(),
                ),
              ),
              child: const Text('push ShadcnPageRoute'),
            ),
            Button(
              variant: ButtonVariant.outline,
              onPressed: () => showShadcnDialog<void>(
                context: context,
                builder: (context) => const _RouteDialogBody(),
              ),
              child: const Text('dialog over the page'),
            ),
            const ShadcnPageTransition(
              animation: AlwaysStoppedAnimation<double>(1),
              child: Text('ShadcnPageTransition (t = 1)'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailPage extends StatelessWidget {
  const _DetailPage();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ShadcnTheme.of(context).colors.card,
      child: Center(
        child: Button(
          variant: ButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('pop'),
        ),
      ),
    );
  }
}

class _RouteDialogBody extends StatelessWidget {
  const _RouteDialogBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[Text('A dialog pushed over a page route.')],
    );
  }
}
