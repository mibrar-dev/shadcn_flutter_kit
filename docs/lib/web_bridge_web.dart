// Web implementation of the docs bridge: DOM custom events, localStorage and
// the `prefers-reduced-motion` probe.
//
// The custom events are the embedder contract kept from the old docs site
// (`shadcn_flutter_app_ready`, `shadcn_flutter_theme_changed`); they are
// harmless when nothing listens. All calls are wrapped: the docs shell must
// never crash because a browser API is unavailable (private mode, iframe).

import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Fires the ready event once the shell has painted its first frame.
void dispatchWebAppReady() {
  try {
    web.window.dispatchEvent(web.CustomEvent('shadcn_flutter_app_ready'));
  } catch (_) {
    // Not available; embedders simply do not get the event.
  }
}

/// Fires the theme-changed event with the current colour tokens.
void dispatchWebThemeChanged(Map<String, String> colors) {
  try {
    web.window.dispatchEvent(
      web.CustomEvent(
        'shadcn_flutter_theme_changed',
        web.CustomEventInit(detail: colors.jsify()),
      ),
    );
  } catch (_) {
    // Same as above.
  }
}

/// Whether the browser asked for reduced motion.
bool webPrefersReducedMotion() {
  try {
    return web.window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  } catch (_) {
    return false;
  }
}

/// Reads a localStorage entry (`null` when it does not exist or is blocked).
String? webLocalStorageRead(String key) {
  try {
    return web.window.localStorage.getItem(key);
  } catch (_) {
    return null;
  }
}

/// Writes a localStorage entry; silently ignored when storage is blocked.
void webLocalStorageWrite(String key, String value) {
  try {
    web.window.localStorage.setItem(key, value);
  } catch (_) {
    // Ignore quota/security errors.
  }
}

/// Opens [url] in a new browser tab; silently ignored when blocked.
void webOpenUrl(String url) {
  try {
    web.window.open(url, '_blank');
  } catch (_) {
    // Popup blocked or not available; the link is simply inert.
  }
}
