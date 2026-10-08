// Tests that `showErrorDialog`'s dismiss action reads its label from
// `ShadcnLocalizations` instead of a hard-coded English string.

import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_shadcn_kit/registry_next/components/error_system/error_system.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/localizations/localizations.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('the dismiss action follows the locale', (tester) async {
    final GlobalKey<NavigatorState> nav = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      Localizations(
        locale: const Locale('de'),
        delegates: <LocalizationsDelegate<dynamic>>[
          ...ShadcnLocalizations.localizationsDelegates,
          GlobalWidgetsLocalizations.delegate,
        ],
        child: ShadcnTheme(
          data: const ShadcnThemeData(),
          child: ComponentThemes(
            themes: const <ComponentThemeData>[],
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Navigator(
                key: nav,
                onGenerateRoute: (RouteSettings settings) =>
                    PageRouteBuilder<void>(
                      settings: settings,
                      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
              ),
            ),
          ),
        ),
      ),
    );

    showErrorDialog<void>(
      context: nav.currentContext!,
      error: AppError(
        code: AppErrorCode.server,
        title: 'Server error',
        message: 'Please try again.',
      ),
    );
    await tester.pumpAndSettle();

    // German table: Flutter's translated `modalBarrierDismissLabel`.
    expect(find.text('Schließen'), findsWidgets);
    expect(find.text('Dismiss'), findsNothing);
  });
}
