// No-op bridge for non-web targets (VM tests, `dart run`).
//
// Keep every signature identical to `web_bridge_web.dart`.

/// Emits the `shadcn_flutter_app_ready` DOM event; no-op off web.
void dispatchWebAppReady() {}

/// Emits the `shadcn_flutter_theme_changed` DOM event; no-op off web.
void dispatchWebThemeChanged(Map<String, String> colors) {}

/// `prefers-reduced-motion: reduce` in the browser; false off web.
bool webPrefersReducedMotion() => false;

/// Reads a `window.localStorage` entry; always null off web.
String? webLocalStorageRead(String key) => null;

/// Writes a `window.localStorage` entry; no-op off web.
void webLocalStorageWrite(String key, String value) {}
