// Hand-written code samples for the theming and dark-mode pages.
//
// Each sample is a source string so the page renders exactly what the
// analyzer test (`test/theming_page_test.dart`) verifies parses without
// errors; the API names are exercised in the same test's widget tree so the
// samples stay true to the registry theme layer.

/// One docs code sample: a fence language and its source.
class DocsSample {
  /// Creates a sample.
  const DocsSample(this.language, this.raw);

  /// Fence language (`dart`, `bash`).
  final String language;

  /// The source text as written (with the blank lines around the literal).
  final String raw;

  /// The source with the surrounding blank lines removed.
  String get code => raw.trim();
}

/// Theming-page samples, keyed by stable id.
const Map<String, DocsSample> kThemingSamples = <String, DocsSample>{
  'token-read': DocsSample('dart', r'''
import 'package:your_app/ui/shadcn/theme/theme.dart';

// Every colour token is a field on ShadcnColors.
final ShadcnThemeData theme = ShadcnTheme.of(context);
final Color surface = theme.colors.background;
final Color ink = theme.colors.foreground;
final Color brand = theme.colors.primary;
'''),
  'token-pair': DocsSample('dart', r'''
// Semantic background/foreground pairs: the base token paints the surface,
// the `-foreground` token paints the content that sits on it.
final BoxDecoration panel = BoxDecoration(
  color: theme.colors.card,
  border: Border.all(color: theme.colors.border),
  borderRadius: theme.borderRadiusLg,
);
final TextStyle onCard = TextStyle(color: theme.colors.cardForeground);
'''),
  'radius': DocsSample('dart', r'''
// `radius` is a unitless factor: the preset's rem number.
final double base = theme.tokens.radius; // e.g. 0.625
final double lg = theme.radiusLg; // base * 16 px
final double sm = theme.radiusSm; // lg - 4 px, clamped at 0
final double md = theme.radiusMd; // lg - 2 px, clamped at 0
final double xl = theme.radiusXl; // lg + 4 px (0 stays square)
'''),
  'preset-apply': DocsSample('bash', 'flutter_shadcn theme apply neutral'),
  'component-theme': DocsSample('dart', r'''
import 'package:your_app/ui/shadcn/components/button/button.dart';
import 'package:your_app/ui/shadcn/theme/theme.dart';

// 1. A widget argument wins over every other leg.
final Widget primary = Button(
  variant: ButtonVariant.primary,
  theme: const ButtonVariantStyle(padding: EdgeInsets.zero),
  child: const Text('Save'),
);

// 2. A tree-scoped ComponentTheme<ButtonTheme>.
final Widget scoped = ComponentTheme<ButtonTheme>(
  data: const ButtonTheme(primary: ButtonVariantStyle()),
  child: const Button(child: Text('Save')),
);

// 3. The app leg: the user-owned button_theme.dart registered at the root
//    through ShadcnApp(componentThemes: appComponentThemes).
'''),
  'animated': DocsSample('dart', r'''
import 'package:your_app/ui/shadcn/theme/theme.dart';

// AnimatedShadcnTheme tweens ShadcnThemeData changes (colour-only lerp).
final Widget app = AnimatedShadcnTheme(
  data: next,
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeOutCubic,
  child: const MyApp(),
);
'''),
};

/// Dark-mode-page samples, keyed by stable id.
const Map<String, DocsSample> kDarkModeSamples = <String, DocsSample>{
  'read-brightness': DocsSample('dart', r'''
// Read the resolved brightness anywhere below the app shell.
final bool dark = ShadcnTheme.of(context).brightness == Brightness.dark;
'''),
  'app-themes': DocsSample('dart', r'''
import 'package:your_app/ui/shadcn/components/app/app.dart';

// One theme per brightness; ThemeMode picks which one is active.
final Widget app = ShadcnApp(
  theme: lightTheme,
  darkTheme: darkTheme,
  themeMode: ThemeMode.system, // system | light | dark
  home: const HomePage(),
);
'''),
  'toggle': DocsSample('dart', r'''
// Toggle the explicit mode and persist the choice.
void toggleMode() {
  setState(() {
    mode = mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  });
}
'''),
};

/// Every sample, for the analyzer test.
const Map<String, DocsSample> kAllDocsSamples = <String, DocsSample>{
  ...kThemingSamples,
  ...kDarkModeSamples,
};
