// Unit tests for the `error_handling` primitive.
//
// Covers the model, the rule system and built-in rules, the hub, `guard`,
// the repository base class, the retry backoff and the fingerprint/fallback
// helpers.

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/error_handling/error_handling.dart';
import 'package:flutter_test/flutter_test.dart';

AppError _error({AppErrorCode code = AppErrorCode.server}) =>
    AppError(code: code, title: 'Server error', message: 'Please try again.');

void main() {
  group('model', () {
    test('AppError carries its fields', () {
      final AppError a = AppError(
        code: AppErrorCode.server,
        title: 'T',
        message: 'M',
        actions: <ErrorAction>[ErrorAction.dismiss(() {})],
        metadata: <String, Object?>{'k': 'v'},
        technicalDetails: 'trace',
      );
      expect(a, AppError(code: AppErrorCode.server, title: 'T', message: 'M'));
      expect(a.hasActions, isTrue);
      expect(a.hasMetadata, isTrue);
      expect(a.hasTechnicalDetails, isTrue);
      expect(a.toJson()['code'], 'server');
      expect(a.copyWithActions(const <ErrorAction>[]).actions, isEmpty);
      expect(a.toString(), contains('title: T'));
    });

    test('the action factories set labels and types', () {
      expect(ErrorAction.retry(() {}).type, ErrorActionType.retry);
      expect(ErrorAction.retry(() {}).primary, isTrue);
      expect(ErrorAction.report(() {}).type, ErrorActionType.report);
      expect(ErrorAction.back(() {}).type, ErrorActionType.navigate);
      expect(ErrorAction.login(() {}).primary, isTrue);
      expect(ErrorAction.settings(() {}).label, 'Settings');
      expect(ErrorAction.contactSupport(() {}).label, 'Contact Support');
      expect(ErrorAction.dismiss(() {}).type, ErrorActionType.custom);
      expect(ErrorScopeType.values, hasLength(2));
    });
  });

  group('rule system', () {
    test('rule<T> matches and builds', () {
      final ErrorRule r = rule<int>(
        where: (int v, StackTrace? st) => v > 0,
        build: (int v, StackTrace? st) => _error(code: AppErrorCode.validation),
      );
      expect(r.matches(1, null), isTrue);
      expect(r.matches(-1, null), isFalse);
      expect(r.build(1, null).code, AppErrorCode.validation);
    });

    test('RuleBasedErrorMapper runs by priority then falls back', () {
      final ErrorMapper mapper = RuleBasedErrorMapper(
        rules: <ErrorRule>[
          rule<StateError>(
            priority: 1,
            build: (StateError e, StackTrace? st) =>
                _error(code: AppErrorCode.unknown),
          ),
          rule<ArgumentError>(
            priority: 5,
            build: (ArgumentError e, StackTrace? st) =>
                _error(code: AppErrorCode.invalidInput),
          ),
        ],
        fallback: (Object e, StackTrace? st) =>
            _error(code: AppErrorCode.notFound),
      );
      expect(mapper.map(ArgumentError()).code, AppErrorCode.invalidInput);
      expect(mapper.map(StateError('x')).code, AppErrorCode.unknown);
      expect(mapper.map('z').code, AppErrorCode.notFound);
    });

    test('ErrorRegistry adds and clears', () {
      final ErrorRegistry registry = ErrorRegistry();
      final ErrorRule r = rule<int>(build: (int v, StackTrace? st) => _error());
      registry.add(r);
      registry.addAll(<ErrorRule>[r]);
      expect(registry.rules, hasLength(2));
      registry.clear();
      expect(registry.rules, isEmpty);
    });
  });

  group('built-in rules', () {
    void noop() {}
    final RuleBasedErrorMapper mapper = RuleBasedErrorMapper(
      rules: <ErrorRule>[
        ...authRules(onLogin: noop, onRetry: noop, onReport: noop),
        ...validationRules(onRetry: noop, onReport: noop),
        ...apiRules(onRetry: noop, onReport: noop, onBack: noop),
        ...platformRules(onRetry: noop, onReport: noop),
      ],
      fallback: fallbackRule,
    );

    test('a 500 maps to server with retry/back/report', () {
      final AppError e = mapper.map(ApiException(statusCode: 500));
      expect(e.code, AppErrorCode.server);
      expect(e.actions.map((ErrorAction a) => a.label), contains('Retry'));
      expect(e.metadata!['statusCode'], 500);
    });

    test('a 401 maps to unauthorized without retry', () {
      final AppError e = mapper.map(ApiException(statusCode: 401));
      expect(e.code, AppErrorCode.unauthorized);
      expect(
        e.actions.map((ErrorAction a) => a.label),
        isNot(contains('Retry')),
      );
    });

    test('an AuthException maps to unauthorized with login', () {
      final AppError e = mapper.map(AuthException(message: 'gone'));
      expect(e.code, AppErrorCode.unauthorized);
      expect(e.actions.first.label, 'Log In');
    });

    test('a ValidationException maps to validation with fields', () {
      final AppError e = mapper.map(
        ValidationException(fieldErrors: <String, String>{'email': 'bad'}),
      );
      expect(e.code, AppErrorCode.validation);
      expect((e.metadata!['fields'] as Map<String, String>)['email'], 'bad');
    });

    test('a PlatformException maps to platformError', () {
      expect(
        mapper.map(PlatformException(code: 'x')).code,
        AppErrorCode.platformError,
      );
    });

    test('a TimeoutException maps to timeout', () {
      expect(mapper.map(TimeoutException('slow')).code, AppErrorCode.timeout);
    });

    test('an unknown error falls back', () {
      final AppError e = mapper.map('boom');
      expect(e.code, AppErrorCode.unknown);
      expect(e.fingerprint, isNotNull);
    });
  });

  group('network rules', () {
    final RuleBasedErrorMapper mapper = RuleBasedErrorMapper(
      rules: networkRules(onRetry: () {}, onReport: () {}, onSettings: () {}),
      fallback: fallbackRule,
    );

    test('a SocketException maps to network with settings', () {
      final AppError e = mapper.map(const SocketException('offline'));
      expect(e.code, AppErrorCode.network);
      expect(e.actions.map((ErrorAction a) => a.label), contains('Settings'));
    });

    test('a HandshakeException maps to sslError', () {
      expect(
        mapper.map(const HandshakeException('bad cert')).code,
        AppErrorCode.sslError,
      );
    });

    test('a TimeoutException maps to timeout', () {
      expect(mapper.map(TimeoutException('slow')).code, AppErrorCode.timeout);
    });
  });

  group('hub and scopes', () {
    test('app channels clear, aggregate and dispose', () {
      final ValueNotifier<AppError?> channel = AppErrorHub.I.app('hub.app');
      channel.value = _error();
      expect(AppErrorHub.I.hasAppError, isTrue);
      expect(AppErrorHub.I.activeAppErrors, hasLength(1));
      AppErrorHub.I.clearAllApp();
      expect(channel.value, isNull);

      final ValueNotifier<AppError?> screen = AppErrorHub.I.screen(
        'hub.screen',
      );
      screen.value = _error();
      AppErrorHub.I.clearAllScreens();
      expect(screen.value, isNull);
      AppErrorHub.I.disposeAllScreens();
      expect(AppErrorHub.I.screen('hub.screen'), isNot(same(screen)));
    });

    test('hub-backed scopes clear and dispose', () {
      final HubAppScope app = HubAppScope('hub.scope.app');
      app.notifier.value = _error();
      app.clear();
      expect(app.notifier.value, isNull);

      final HubScreenScope screen = HubScreenScope('hub.scope.screen');
      screen.notifier.value = _error();
      screen.clear();
      expect(screen.notifier.value, isNull);
      screen.dispose();
    });
  });

  group('guard', () {
    test('publishes success and an AppError', () async {
      final HubAppScope scope = HubAppScope('guard.ok');
      addTearDown(() => AppErrorHub.I.clearApp('guard.ok'));
      expect(await guard<int>(() async => 7, scope: scope), 7);

      expect(
        await guard<int>(() async => throw _error(), scope: scope),
        isNull,
      );
      expect(scope.notifier.value?.code, AppErrorCode.server);
    });

    test('maps an unexpected error', () async {
      final HubAppScope scope = HubAppScope('guard.map');
      addTearDown(() => AppErrorHub.I.clearApp('guard.map'));
      await guard<int>(
        () async => throw 'boom',
        scope: scope,
        mapper: RuleBasedErrorMapper(
          rules: <ErrorRule>[],
          fallback: (Object e, StackTrace? st) =>
              _error(code: AppErrorCode.timeout),
        ),
      );
      expect(scope.notifier.value?.code, AppErrorCode.timeout);
    });

    test('guardSync works and requires a scope', () {
      final HubAppScope scope = HubAppScope('guard.sync');
      addTearDown(() => AppErrorHub.I.clearApp('guard.sync'));
      expect(guardSync<int>(() => 3, scope: scope), 3);
      expect(guardSync<int>(() => throw _error(), scope: scope), isNull);
      expect(scope.notifier.value?.code, AppErrorCode.server);
      expect(() => guard<int>(() async => 1), throwsArgumentError);
    });
  });

  group('repository and retry', () {
    test('ErrorHandledRepository maps, reports and rethrows', () async {
      final List<AppError> reported = <AppError>[];
      final _Repo repo = _Repo(
        RuleBasedErrorMapper(
          rules: <ErrorRule>[],
          fallback: (Object e, StackTrace? st) =>
              _error(code: AppErrorCode.unknown),
        ),
        _RecordingReporter(reported),
      );
      expect(await repo.execute<int>(() async => 1), 1);
      await expectLater(
        repo.execute<int>(() async => throw 'x'),
        throwsA(isA<AppError>()),
      );
      expect(reported, hasLength(1));

      expect(repo.executeSync<int>(() => 2), 2);
      expect(
        await repo.executeWithHandler<int>(
          operation: () async => throw 'x',
          onError: (Object e) => 9,
        ),
        9,
      );
    });

    test('RetryStrategy grows and caps the delay', () {
      final RetryStrategy strategy = RetryStrategy(
        baseDelay: const Duration(milliseconds: 100),
        maxDelay: const Duration(seconds: 1),
        jitter: 0,
      );
      expect(strategy.delayForAttempt(0), const Duration(milliseconds: 100));
      expect(strategy.delayForAttempt(1), const Duration(milliseconds: 200));
      expect(strategy.delayForAttempt(10), const Duration(seconds: 1));
    });

    test('fingerprintFor is stable and fallbackRule sets it', () {
      final AppError e = _error();
      expect(fingerprintFor(e), fingerprintFor(e));
      final AppError fallback = fallbackRule('boom');
      expect(fallback.fingerprint, isNotNull);
      expect(fallback.metadata!['fingerprint'], fallback.fingerprint);
    });
  });

  group('ScreenErrorScope', () {
    testWidgets('run/runSync publish and clear', (tester) async {
      late ScreenErrorScopeState state;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: ScreenErrorScope(
            child: Builder(
              builder: (BuildContext context) {
                state = ScreenErrorScope.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(await state.run<int>(() async => throw _error()), isNull);
      expect(state.notifier.value?.title, 'Server error');
      state.clear();
      expect(state.notifier.value, isNull);
      expect(state.runSync<int>(() => throw _error()), isNull);
      expect(state.notifier.value?.title, 'Server error');
    });
  });
}

class _Repo extends ErrorHandledRepository {
  _Repo(ErrorMapper mapper, ErrorReporter reporter)
    : super(errorMapper: mapper, errorReporter: reporter);
}

class _RecordingReporter implements ErrorReporter {
  _RecordingReporter(this.reported);

  final List<AppError> reported;

  @override
  void report(AppError appError, Object error, StackTrace stackTrace) {
    reported.add(appError);
  }
}
