// Tests that the `error_handling` built-ins take their user-facing text from
// the supplied `ShadcnLocalizations` table (English when none is given).

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/primitives/error_handling/error_handling.dart';
import 'package:flutter_shadcn_kit/registry/primitives/localizations/localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const _TestStrings strings = _TestStrings();

  group('action factories', () {
    test('use the supplied table for their labels', () {
      expect(ErrorAction.retry(() {}, strings: strings).label, 'Riprova');
      expect(ErrorAction.report(() {}, strings: strings).label, 'Segnala');
      expect(ErrorAction.back(() {}, strings: strings).label, 'Indietro');
      expect(ErrorAction.login(() {}, strings: strings).label, 'Accedi');
      expect(
        ErrorAction.settings(() {}, strings: strings).label,
        'Impostazioni',
      );
      expect(
        ErrorAction.contactSupport(() {}, strings: strings).label,
        'Supporto',
      );
      expect(ErrorAction.dismiss(() {}, strings: strings).label, 'Chiudi');
    });

    test('default to English without a table', () {
      expect(ErrorAction.retry(() {}).label, 'Retry');
      expect(ErrorAction.dismiss(() {}).label, 'Dismiss');
    });
  });

  group('built-in rules', () {
    test('apiRules uses the supplied table', () {
      final ErrorMapper mapper = RuleBasedErrorMapper(
        rules: apiRules(
          onRetry: () {},
          onReport: () {},
          onBack: () {},
          strings: strings,
        ),
        fallback: fallbackRule,
      );
      final AppError error = mapper.map(ApiException(statusCode: 500));
      expect(error.title, 'Errore del server');
      expect(error.message, 'Errore del server. Riprova.');
      expect(error.actions.first.label, 'Riprova');
    });

    test('networkRules uses the supplied table', () {
      final ErrorMapper mapper = RuleBasedErrorMapper(
        rules: networkRules(
          onRetry: () {},
          onReport: () {},
          onSettings: () {},
          strings: strings,
        ),
        fallback: fallbackRule,
      );
      final AppError error = mapper.map(TimeoutException('slow'));
      expect(error.title, 'Richiesta scaduta');
      expect(error.message, 'Server lento.');
    });
  });

  group('recovery helpers', () {
    test('fallbackRule takes the table as a third argument', () {
      final AppError error = fallbackRule('boom', null, strings);
      expect(error.title, 'Ops');
      expect(error.message, 'Riprova piu tardi.');
    });

    test('guard uses the table for an unmapped error', () async {
      final HubAppScope scope = HubAppScope('guard.l10n');
      addTearDown(() => AppErrorHub.I.clearApp('guard.l10n'));
      await guard<int>(
        () async => throw 'boom',
        scope: scope,
        strings: strings,
      );
      expect(scope.notifier.value?.title, 'Ops');
      expect(scope.notifier.value?.message, 'Riprova piu tardi.');
    });
  });
}

class _TestStrings extends ShadcnLocalizations {
  const _TestStrings() : super(const Locale('it'));

  @override
  String get dialogDismiss => 'Chiudi';

  @override
  String get errorActionRetry => 'Riprova';

  @override
  String get errorActionReport => 'Segnala';

  @override
  String get errorActionBack => 'Indietro';

  @override
  String get errorActionLogin => 'Accedi';

  @override
  String get errorActionSettings => 'Impostazioni';

  @override
  String get errorActionContactSupport => 'Supporto';

  @override
  String get errorServerError => 'Errore del server';

  @override
  String get errorServerErrorMessage => 'Errore del server. Riprova.';

  @override
  String get errorRequestTimedOut => 'Richiesta scaduta';

  @override
  String get errorRequestTimedOutMessage => 'Server lento.';

  @override
  String get errorSomethingWentWrong => 'Ops';

  @override
  String get errorUnexpectedMessage => 'Riprova piu tardi.';
}
