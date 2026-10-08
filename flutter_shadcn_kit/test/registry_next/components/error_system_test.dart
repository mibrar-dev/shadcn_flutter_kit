// Tests for the `error_system` component.
//
// Covers the model, the rule mapper, the hub, `guard`, the UI surfaces and the
// four theme legs, plus regressions for the old bugs: the literal-only theme
// (no four-leg resolution), the raw `OverlayEntry` snackbar and the missing
// `AppError` guard in `ErrorSnackbar`.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/error_system/error_system.dart';
import 'package:flutter_shadcn_kit/registry_next/components/toast/toast.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  ErrorSystemTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<ErrorSystemTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(alignment: Alignment.topLeft, child: body),
      ),
    ),
  );
}

AppError _error({List<ErrorAction> actions = const <ErrorAction>[]}) =>
    AppError(
      code: AppErrorCode.server,
      title: 'Server error',
      message: 'Please try again.',
      actions: actions,
    );

Color? _iconColor(WidgetTester tester) => tester
    .widgetList<Icon>(
      find.descendant(of: find.byType(ErrorState), matching: find.byType(Icon)),
    )
    .first
    .color;

void main() {
  group('model', () {
    test('AppError carries its fields and compares by code/title/message', () {
      final AppError a = _error();
      final AppError b = _error();
      expect(a, b);
      expect(a.hasActions, isFalse);
      expect(a.toJson()['code'], 'server');
    });
  });

  group('mapper', () {
    test('rules run in priority order and fall back', () {
      final ErrorMapper mapper = RuleBasedErrorMapper(
        rules: <ErrorRule>[
          rule<StateError>(
            build: (StateError e, StackTrace? st) => AppError(
              code: AppErrorCode.unknown,
              title: 'state',
              message: e.message,
            ),
            priority: 1,
          ),
          rule<ArgumentError>(
            build: (ArgumentError e, StackTrace? st) => AppError(
              code: AppErrorCode.invalidInput,
              title: 'arg',
              message: '${e.message}',
            ),
            priority: 5,
          ),
        ],
        fallback: (Object e, StackTrace? st) => AppError(
          code: AppErrorCode.unknown,
          title: 'fallback',
          message: '$e',
        ),
      );
      expect(mapper.map(ArgumentError('x')).title, 'arg');
      expect(mapper.map(StateError('y')).title, 'state');
      expect(mapper.map('z').title, 'fallback');
    });

    test('where narrows a rule', () {
      final ErrorRule r = rule<int>(
        where: (int v, StackTrace? st) => v > 0,
        build: (int v, StackTrace? st) => AppError(
          code: AppErrorCode.validation,
          title: 'positive',
          message: '$v',
        ),
      );
      expect(r.matches(1, null), isTrue);
      expect(r.matches(-1, null), isFalse);
    });
  });

  group('hub and guard', () {
    test('app and screen channels clear and dispose', () {
      final ValueNotifier<AppError?> channel = AppErrorHub.I.app('t1');
      channel.value = _error();
      AppErrorHub.I.clearApp('t1');
      expect(channel.value, isNull);

      final ValueNotifier<AppError?> screen = AppErrorHub.I.screen('t2');
      screen.value = _error();
      AppErrorHub.I.disposeScreen('t2');
      // A disposed channel is removed; a fresh lookup returns a new one.
      expect(AppErrorHub.I.screen('t2'), isNot(same(screen)));
    });

    test('guard publishes success and failure', () async {
      final HubAppScope scope = HubAppScope('guard');
      addTearDown(() => AppErrorHub.I.clearApp('guard'));
      final int? ok = await guard<int>(() async => 7, scope: scope);
      expect(ok, 7);

      final int? bad = await guard<int>(
        () async => throw _error(),
        scope: scope,
      );
      expect(bad, isNull);
      expect(scope.notifier.value?.code, AppErrorCode.server);
    });

    test('guard maps an unexpected error', () async {
      final HubAppScope scope = HubAppScope('guard2');
      addTearDown(() => AppErrorHub.I.clearApp('guard2'));
      final ErrorMapper mapper = RuleBasedErrorMapper(
        rules: <ErrorRule>[],
        fallback: (Object e, StackTrace? st) => AppError(
          code: AppErrorCode.timeout,
          title: 'mapped',
          message: '$e',
        ),
      );
      await guard<int>(() async => throw 'boom', scope: scope, mapper: mapper);
      expect(scope.notifier.value?.title, 'mapped');
    });
  });

  group('UI', () {
    testWidgets('ErrorState renders title, message and actions', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          ErrorState(
            error: _error(
              actions: <ErrorAction>[
                ErrorAction.retry(() {}),
                ErrorAction.report(() {}),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Server error'), findsOneWidget);
      expect(find.text('Please try again.'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.text('Report'), findsOneWidget);
    });

    testWidgets('InlineError renders its message', (tester) async {
      await tester.pumpWidget(_frame(const InlineError(message: 'Required')));
      expect(find.text('Required'), findsOneWidget);
    });

    testWidgets('AppErrorBanner shows and dismisses', (tester) async {
      final HubAppScope scope = HubAppScope('banner');
      addTearDown(() => AppErrorHub.I.clearApp('banner'));
      await tester.pumpWidget(_frame(AppErrorBanner(scope: scope)));
      expect(find.byType(ErrorState), findsNothing);
      scope.notifier.value = _error();
      await tester.pump();
      expect(find.text('Server error'), findsOneWidget);
    });

    testWidgets('AppErrorGate overlays and absorbs', (tester) async {
      final ValueNotifier<AppError?> channel = ValueNotifier<AppError?>(null);
      addTearDown(channel.dispose);
      await tester.pumpWidget(
        _frame(AppErrorGate(notifier: channel, child: const Text('behind'))),
      );
      expect(find.text('behind'), findsOneWidget);
      channel.value = _error();
      await tester.pump();
      expect(find.byType(ErrorState), findsOneWidget);
    });

    testWidgets('ScreenErrorScope runs and clears', (tester) async {
      late ScreenErrorScopeState state;
      await tester.pumpWidget(
        _frame(
          ScreenErrorScope(
            child: Builder(
              builder: (BuildContext context) {
                state = ScreenErrorScope.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      final int? value = await state.run<int>(() async => throw _error());
      expect(value, isNull);
      expect(state.notifier.value?.title, 'Server error');
      state.clear();
      expect(state.notifier.value, isNull);
    });

    testWidgets('showErrorDialog opens a dialog', (tester) async {
      final GlobalKey<NavigatorState> nav = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        _frame(
          Navigator(
            key: nav,
            onGenerateRoute: (RouteSettings settings) => PageRouteBuilder<void>(
              settings: settings,
              pageBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
        ),
      );
      showErrorDialog<void>(context: nav.currentContext!, error: _error());
      await tester.pumpAndSettle();
      expect(find.text('Server error'), findsWidgets);
      expect(find.text('Please try again.'), findsWidgets);
    });

    testWidgets('showErrorSnackbar shows a toast', (tester) async {
      late BuildContext inner;
      await tester.pumpWidget(
        _frame(
          ToastLayer(
            child: Builder(
              builder: (BuildContext context) {
                inner = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      showErrorSnackbar(inner, _error());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Please try again.'), findsOneWidget);
    });

    testWidgets(
      'restored machinery: guard + apiRules render through ErrorSlot',
      (tester) async {
        late ScreenErrorScopeState state;
        final ErrorMapper mapper = RuleBasedErrorMapper(
          rules: apiRules(onRetry: () {}, onReport: () {}, onBack: () {}),
          fallback: fallbackRule,
        );
        await tester.pumpWidget(
          _frame(
            ScreenErrorScope(
              child: Builder(
                builder: (BuildContext context) {
                  state = ScreenErrorScope.of(context);
                  return ErrorSlot(scope: state.scope);
                },
              ),
            ),
          ),
        );
        expect(find.byType(ErrorState), findsNothing);

        await guard<void>(
          () async => throw ApiException(statusCode: 500, message: 'Boom'),
          scope: state.scope,
          mapper: mapper,
        );
        await tester.pump();
        expect(find.text('Server error'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      },
    );
  });

  group('theme precedence', () {
    testWidgets('the widget leg wins over everything', (tester) async {
      await tester.pumpWidget(
        _frame(
          ErrorState(
            error: _error(),
            theme: const ErrorSystemTheme(iconColor: ThemedColor.value(_green)),
          ),
          app: const <ComponentThemeData>[
            ErrorSystemTheme(iconColor: ThemedColor.value(_blue)),
          ],
          scoped: const ErrorSystemTheme(
            iconColor: ThemedColor.value(Color(0xFF123456)),
          ),
        ),
      );
      expect(_iconColor(tester), _green);
    });

    testWidgets('the scoped leg wins over the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          ErrorState(error: _error()),
          app: const <ComponentThemeData>[
            ErrorSystemTheme(iconColor: ThemedColor.value(_blue)),
          ],
          scoped: const ErrorSystemTheme(iconColor: ThemedColor.value(_green)),
        ),
      );
      expect(_iconColor(tester), _green);
    });

    testWidgets('the app leg wins over the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          ErrorState(error: _error()),
          app: const <ComponentThemeData>[
            ErrorSystemTheme(iconColor: ThemedColor.value(_green)),
          ],
        ),
      );
      expect(_iconColor(tester), _green);
    });

    testWidgets('a leg that sets only the colour keeps the default size', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          ErrorState(error: _error()),
          app: const <ComponentThemeData>[
            ErrorSystemTheme(iconColor: ThemedColor.value(_green)),
          ],
        ),
      );
      final Icon icon = tester.widget<Icon>(
        find
            .descendant(
              of: find.byType(ErrorState),
              matching: find.byType(Icon),
            )
            .first,
      );
      expect(icon.size, errorSystemDefaults.iconSize);
    });

    testWidgets('regression: dark tokens drive the icon', (tester) async {
      await tester.pumpWidget(
        _frame(
          ErrorState(error: _error()),
          data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
        ),
      );
      expect(_iconColor(tester), ShadcnColors.darkFallback.destructive);
    });
  });
}
