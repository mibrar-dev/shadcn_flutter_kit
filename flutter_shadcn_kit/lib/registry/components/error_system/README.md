# Error System

Structured error models, rule-based mapping, app/screen error channels and the
matching UI surfaces. Widgets-only; it composes `card`, `button`, `divider`,
`alert_dialog` and `toast`.

## When to use

- You want one `AppError` shape for user-facing failures and one place to map
  raw exceptions into it.
- You need app-level (persistent) and screen-level (disposable) error channels.
- You want ready-made surfaces: full page, inline, banner, dialog, toast,
  blocking overlay.

For a plain inline message use `Text`; for a single toast use `toast`.

## Snippets

```dart
final scope = HubAppScope(AppErrorHub.sessionExpired);
final error = AppError(
  code: AppErrorCode.sessionExpired,
  title: 'Session expired',
  message: 'Please sign in again.',
  actions: <ErrorAction>[ErrorAction.login(signIn)],
);
scope.notifier.value = error;
```

Map an exception with a rule:

```dart
final mapper = RuleBasedErrorMapper(
  rules: <ErrorRule>[
    rule<TimeoutException>(
      build: (e, st) => AppError(
        code: AppErrorCode.timeout,
        title: 'Request timed out',
        message: 'The server is taking too long to respond.',
      ),
      priority: 4,
    ),
  ],
  fallback: (e, st) => AppError(
    code: AppErrorCode.unknown,
    title: 'Something went wrong',
    message: 'Please try again.',
  ),
);
```

Run an operation through a channel:

```dart
await guard(() => repository.load(), scope: scope, mapper: mapper);
```

## UI surfaces

| Widget | Use |
|---|---|
| `ErrorState` | full-page / section card with title, message and actions |
| `InlineError` | compact icon + message row for forms |
| `AppErrorBanner` | top-of-app banner bound to an `ErrorScope` |
| `showErrorDialog` | modal dialog over `alert_dialog` |
| `showErrorSnackbar` | toast over `toast` |
| `AppErrorGate` | full-screen blocking overlay over a `ValueListenable` |
| `ScreenErrorScope` | owns a screen-level channel and disposes it |

## Theme resolution

`widget theme > ComponentTheme<ErrorSystemTheme> in tree > app overrides
(error_system_theme.dart) > errorSystemDefaults`, merged per field.

| Field | Default |
|---|---|
| `iconColor` | `destructive` token |
| `iconSize` | 36 |
| `titleStyle` | 16 / w600 |
| `messageStyle` | 14 |
| `cardPadding` | 24 |
| `bannerBackground` | `card` token |
| `bannerBorder` | `destructive` token |
| `bannerPadding` | 16 / 12 |

## Primitive

The non-visual machinery lives in `primitives/error_handling/` and is
re-exported by `error_system.dart`:

| File | Contents |
|---|---|
| `error_models.dart` | `AppError`, `AppErrorCode`, `ErrorAction`, `ErrorScopeType`, `Env`, the typed exceptions |
| `error_rules.dart` | `ErrorRule`, `rule`, `ErrorMapper`, `RuleBasedErrorMapper`, `ErrorRegistry`, `apiRules` / `authRules` / `validationRules` / `platformRules` |
| `network_rules.dart` | `networkRules` |
| `error_scopes.dart` | `AppErrorHub`, `ErrorScope`, `HubAppScope`, `HubScreenScope`, `ScreenErrorScope` |
| `error_recovery.dart` | `guard`, `guardSync`, `ErrorHandledRepository`, `RetryStrategy`, `ErrorReporter`, `ConsoleErrorReporter`, `fingerprintFor`, `fallbackRule` |

## Differences from the old `utility/error_system`

The old component was 42 files / 3,257 LOC. The non-visual machinery now lives
in the `primitives/error_handling/` primitive (re-exported here); the component
keeps only the visual widgets, the theme and the style.

Restored from the old tree (had a consumer or were documented user-facing API):
`ErrorHandledRepository`, `RetryStrategy`, `ErrorReporter` /
`ConsoleErrorReporter`, `Env`, `fingerprintFor`, `fallbackRule`,
`ErrorRegistry`, `guardSync`, `AppError.copyWithActions` / `hasMetadata`, the
typed exceptions and the per-domain rule builders (`apiRules`, `authRules`,
`validationRules`, `platformRules`, `networkRules`), `ScreenErrorScope`'s
`clearOnInit` / `runSync`, `ErrorSlot`, `AppErrorGate`'s
`overlayBuilder` / `blockInteraction`, and the `BuildContext` extensions.

Still dropped (with reason):

- `ErrorSnackbar`'s raw `OverlayEntry` machinery and its static entry list:
  `showErrorSnackbar` calls the `toast` component's `showToast`, which owns the
  queue and lifecycle.
- The deprecated `AppErrorHub.global` / `scope` aliases (clean break).
- `networkRules`' old `dart:io` conditional-import trio: it declares the same
  top-level `networkRules` twice, which the single-owner check rejects, and
  `dart:io` types cannot be named on web. It is one web-safe file now that
  matches the IO exception types by name (`SocketException`,
  `HandshakeException`); on web those rules simply never match.
- The old `ErrorState` read `ComponentTheme.maybeOf` only and defaulted every
  colour to a literal; the new one resolves all four legs and uses tokens.
