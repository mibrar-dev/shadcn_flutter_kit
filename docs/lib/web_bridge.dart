// Platform bridge for the few things the docs app needs from the DOM.
//
// Web builds use `web_bridge_web.dart`; every other target (VM for tests and
// `flutter analyze`) uses the no-op stub. Keeping the platform surface here
// means no plugin dependency (no shared_preferences, no url_launcher) and no
// `dart:html` anywhere in app code.

export 'web_bridge_stub.dart'
    if (dart.library.js_interop) 'web_bridge_web.dart';
