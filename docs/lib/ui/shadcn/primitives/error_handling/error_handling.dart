// The `error_handling` primitive: the non-visual error machinery shared by the
// `error_system` component (and any app-level error pipeline).
//
// Layer 2. It owns the [AppError] model, the rule-based mapper, the app/screen
// [AppErrorHub], the recovery helpers and the built-in rule builders. The
// `error_system` component owns only the visual widgets and the theme.

export 'error_models.dart';
export 'error_recovery.dart';
export 'error_rules.dart';
export 'error_scopes.dart';
export 'network_rules.dart';
