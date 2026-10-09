# App

The shadcn app shell. Wrap your `main()` widget with `ShadcnApp` once; it
installs the theme, the app-wide component-theme overrides, the overlay
manager and the shadcn localizations.

```dart
void main() {
  runApp(
    ShadcnApp(
      title: 'My App',
      theme: lightTheme,          // ShadcnThemeData
      darkTheme: darkTheme,       // ShadcnThemeData
      componentThemes: appComponentThemes, // generated `component_themes.dart`
      home: const HomePage(),
    ),
  );
}
```

## What it installs

- `ShadcnTheme` (or `AnimatedShadcnTheme` with `enableThemeAnimation: true`)
  with the theme resolved for `themeMode` / platform brightness.
- `ComponentThemes` with `componentThemes` (user-owned `*_theme.dart` values).
- `OverlayManagerLayer` with the three `OverlayHandler`s (default:
  `OverlayHandler.popover`) so `primitives` popovers/menus/tooltips work.
- `ShadcnLocalizations` plus the given delegates; `WidgetsApp` appends
  `DefaultWidgetsLocalizations`. `GlobalWidgetsLocalizations` is included from
  `flutter_localizations` so RTL locales get real text direction — the app
  shell is the one place that carries it; no Material widget is imported.
- `ShadcnUI`: default sans/`foreground` text style and icon colour below the
  theme. Also usable standalone inside an existing `WidgetsApp`.

`scaling` applies an `AdaptiveScaling` on top of the resolved theme.

## Locales

`supportedLocales` defaults to `ShadcnLocalizations.supportedLocales`, which now
starts with `Locale('en')` as the fallback entry. `ShadcnApp` also installs a
default `localeResolutionCallback`
([`ShadcnLocalizations.resolveLocale`](../localizations/README.md)) that
matches by **language code first**, then refines by script/country:

| Device locale | Resolves to |
|---|---|
| `en_US`, `en_GB` | `en` |
| `de_AT` | `de` |
| `zh_TW`, `zh_HK`, `zh_MO`, `zh_Hant*` | `zh` (Hant) |
| `zh_CN`, `zh_SG` | `zh` |
| unknown (`sw`, …) | `en` |

Pass your own `localeResolutionCallback`/`localeListResolutionCallback` to
override. Because `en` is a supported entry now, an `en_US` device resolves to
`en` and no "locale is not supported by all of its localization delegates"
warning is emitted (regression-tested).

## Differences from the old `layout/app`

- `theme`/`darkTheme` are `ShadcnThemeData`, not `ThemeData`; the Material
  `Theme` wrapper is gone (no duplication of `ShadcnTheme`).
- `ShadcnApp.router` and the router parameters are dropped (clean break): use
  `Router`/`RouterDelegate` above a plain `ShadcnApp`, or the `Routes`-style
  `onGenerateRoute` path.
- Dropped: `materialFallback`, `preloadComponentThemeGlobals`,
  `debugShowMaterialGrid`, `scrollBehavior`, the `ThemeData`-animation path.
  Global component-theme registration is now the `ComponentThemes` list.
- Bug fix: `ThemeMode.system` dark resolution used to read `MediaQuery` above
  `WidgetsApp` (always null), so the dark theme never applied; the theme now
  resolves inside the app builder. Regression-tested.
- Bug fix: the old manual `Localizations` override (with a private locale
  resolver) disagreed with `WidgetsApp`'s resolver; the framework resolver is
  used now.

## Keyboard shortcuts and actions

`ShadcnApp` passes `shortcuts` and `actions` to `WidgetsApp`, **merged** over
the framework defaults — `shortcuts` starts from `WidgetsApp.defaultShortcuts`
and `actions` from `WidgetsApp.defaultActions`, and your entries win.

`WidgetsApp` *replaces* its defaults when either map is supplied, so forwarding
them verbatim silently disables, app-wide:

| Key | Intent | Action |
|---|---|---|
| `Tab` / `Shift+Tab` | `NextFocusIntent` / `PreviousFocusIntent` | focus traversal |
| `Enter` / `Space` | `ActivateIntent` | activates the focused control |
| `Escape` | `DismissIntent` | dismisses dialogs/popovers |

Passing neither map leaves the platform default untouched.

```dart
ShadcnApp(
  shortcuts: const <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.keyK, meta: true): OpenPaletteIntent(),
  },
  actions: <Type, Action<Intent>>{
    OpenPaletteIntent: CallbackAction<OpenPaletteIntent>(onInvoke: (_) => …),
  },
  home: const HomePage(),
)
```

Only override an existing binding when you mean to: a caller entry for
`SingleActivator(LogicalKeyboardKey.tab)` replaces the framework's
`NextFocusIntent` mapping.

Regression-tested: with custom shortcuts supplied, `Tab` still moves focus,
`Enter` still activates a `Button`, and `Escape` still dismisses a `Dialog`.
