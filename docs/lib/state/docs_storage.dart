// Where the docs preferences live (spec §1.1/§1.3): `window.localStorage` on
// web through the existing web bridge, a no-op everywhere else (tests inject
// a memory-backed instance).
//
// Split out of `docs_state.dart` so both the shell state and the Theme
// Studio's site-wide theme model can depend on it without importing each
// other.

import '../web_bridge.dart';

/// Reads and writes the docs preference keys.
class DocsStorage {
  /// Creates the default, platform-selecting storage.
  const DocsStorage();

  /// Reads [key], or null.
  String? read(String key) => webLocalStorageRead(key);

  /// Writes [key] = [value]. An empty [value] clears the entry (the bridge
  /// has no `removeItem`, matching the shell's existing convention).
  void write(String key, String value) => webLocalStorageWrite(key, value);
}

/// localStorage keys for the theme preferences.
const String kDocsPresetKey = 'docs.theme.presetId';
const String kDocsBrightnessKey = 'docs.theme.brightness';

/// localStorage key of the whole Theme Studio document (D7).
///
/// The document is the source of truth for every token, so it is stored as
/// one canonical preset JSON rather than as a bag of scalar overrides: a
/// reload then restores exactly what the user built, including fonts, shadow
/// atoms and both colour blocks.
const String kDocsThemeDocumentKey = 'docs.theme.document';
