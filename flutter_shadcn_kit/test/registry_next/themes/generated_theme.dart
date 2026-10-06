// Loads the values that `tool/rearch/gen_app_theme.dart` wrote, by parsing the
// generated Dart with package:analyzer. This is what lets a widget test assert
// on a *generated* file: the numbers come from the emitted source text, not from
// a Dart object rebuilt from the preset JSON.
//
// Unresolved parsing gives `Foo(...)` as a MethodInvocation and a constant
// `Color(0xFFAABBCC)` as an InstanceCreationExpression, so both are handled.

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/tokens.dart';

import '../../../tool/rearch/gen_app_theme.dart' as gen;

/// The `ShadcnColors`, `ShadcnTokens` and `ShadcnFonts` values of one generated
/// `app_theme.dart`.
class GeneratedTheme {
  GeneratedTheme({
    required this.source,
    required this.prefix,
    required this.lightColors,
    required this.darkColors,
    required this.lightTokens,
    required this.darkTokens,
    required this.fonts,
    required this.buildFunction,
  });

  /// Raw generated source, kept so tests can assert on the shape of the
  /// `build<Id>Theme` factory as well.
  final String source;

  /// Dart identifier fragment of the preset id, e.g. `amberMinimal`.
  final String prefix;

  /// Light colour tokens as written in the file.
  final ShadcnColors lightColors;

  /// Dark colour tokens as written in the file.
  final ShadcnColors darkColors;

  /// Light non-colour tokens as written in the file.
  final ShadcnTokens lightTokens;

  /// Dark non-colour tokens as written in the file.
  final ShadcnTokens darkTokens;

  /// Font families, or null when the preset names none.
  final ShadcnFonts? fonts;

  /// Name of the emitted factory, e.g. `buildAmberMinimalTheme`.
  final String buildFunction;

  /// Mirrors what the generated `build<Id>Theme` returns.
  ShadcnThemeDataView view(Brightness brightness) => ShadcnThemeDataView(
    colors: brightness == Brightness.dark ? darkColors : lightColors,
    tokens: brightness == Brightness.dark ? darkTokens : lightTokens,
    fonts: fonts ?? ShadcnFonts.empty,
  );
}

/// Colors plus tokens plus fonts, the three inputs of `ShadcnThemeData`.
class ShadcnThemeDataView {
  const ShadcnThemeDataView({
    required this.colors,
    required this.tokens,
    required this.fonts,
  });

  /// Colour tokens for one brightness.
  final ShadcnColors colors;

  /// Non-colour tokens for one brightness.
  final ShadcnTokens tokens;

  /// Mode-independent families.
  final ShadcnFonts fonts;
}

/// Renders [presetPath] with the generator and reads the values back.
GeneratedTheme loadGeneratedTheme(String presetPath) {
  final preset = gen.readPreset(presetPath);
  final source = gen.ThemeValues.fromJson(preset).toDartSource();
  return parseGeneratedTheme(source);
}

/// Parses the source of a generated `app_theme.dart`.
GeneratedTheme parseGeneratedTheme(String source) {
  final result = parseString(
    content: source,
    featureSet: FeatureSet.latestLanguageVersion(),
    throwIfDiagnostics: false,
  );
  if (result.errors.isNotEmpty) {
    throw StateError('generated source has syntax errors: ${result.errors}');
  }
  final variables = <String, Expression>{};
  final functions = <String>[];
  for (final declaration in result.unit.declarations) {
    if (declaration is TopLevelVariableDeclaration) {
      for (final variable in declaration.variables.variables) {
        final initializer = variable.initializer;
        if (initializer != null) {
          variables[variable.name.lexeme] = initializer;
        }
      }
    }
    if (declaration is FunctionDeclaration) {
      functions.add(declaration.name.lexeme);
    }
  }

  String? prefix;
  final colors = <String, ShadcnColors>{};
  final tokenValues = <String, ShadcnTokens>{};
  ShadcnFonts? fonts;
  for (final entry in variables.entries) {
    final call = _callOf(entry.value);
    if (call == null) continue;
    final name = _calledName(call);
    final args = _namedArguments(call);
    switch (name) {
      case 'ShadcnColors':
        final mode = entry.key.endsWith('LightColors') ? 'light' : 'dark';
        prefix ??= entry.key.substring(
          0,
          entry.key.length - 'LightColors'.length,
        );
        colors[mode] = _colorsFrom(args);
      case 'ShadcnTokens':
        final mode = entry.key.endsWith('LightTokens') ? 'light' : 'dark';
        tokenValues[mode] = _tokensFrom(args);
      case 'ShadcnFonts':
        fonts = ShadcnFonts(
          fontSans: args['fontSans'] == null
              ? null
              : _string(args['fontSans']!),
          fontSerif: args['fontSerif'] == null
              ? null
              : _string(args['fontSerif']!),
          fontMono: args['fontMono'] == null
              ? null
              : _string(args['fontMono']!),
        );
      default:
        break;
    }
  }
  if (prefix == null ||
      !colors.containsKey('light') ||
      !colors.containsKey('dark')) {
    throw StateError('generated source has no <id>LightColors/<id>DarkColors');
  }
  final id = prefix;
  final build = functions.firstWhere(
    (name) => name == 'build${id[0].toUpperCase()}${id.substring(1)}Theme',
    orElse: () => throw StateError('no build<Id>Theme in the generated source'),
  );
  return GeneratedTheme(
    source: source,
    prefix: id,
    lightColors: colors['light']!,
    darkColors: colors['dark']!,
    lightTokens: tokenValues['light']!,
    darkTokens: tokenValues['dark']!,
    fonts: fonts,
    buildFunction: build,
  );
}

Expression? _callOf(Expression expression) =>
    expression is InstanceCreationExpression || expression is MethodInvocation
    ? expression
    : null;

String? _calledName(Expression expression) {
  if (expression is InstanceCreationExpression) {
    return expression.constructorName.type.name2.lexeme;
  }
  if (expression is MethodInvocation) {
    final target = expression.target;
    if (target == null) return expression.methodName.name;
    return null;
  }
  return null;
}

Map<String, Expression> _namedArguments(Expression call) {
  final arguments = call is InstanceCreationExpression
      ? call.argumentList.arguments
      : (call as MethodInvocation).argumentList.arguments;
  return <String, Expression>{
    for (final argument in arguments)
      if (argument is NamedExpression)
        argument.name.label.name: argument.expression,
  };
}

ShadcnColors _colorsFrom(Map<String, Expression> args) {
  Color token(String key) {
    final argument = args[key];
    if (argument == null) throw StateError('generated colours miss "$key"');
    return Color(_intOf(argument));
  }

  return ShadcnColors(
    brightness: _string(args['brightness']!) == 'Brightness.light'
        ? Brightness.light
        : Brightness.dark,
    background: token('background'),
    foreground: token('foreground'),
    card: token('card'),
    cardForeground: token('cardForeground'),
    popover: token('popover'),
    popoverForeground: token('popoverForeground'),
    primary: token('primary'),
    primaryForeground: token('primaryForeground'),
    secondary: token('secondary'),
    secondaryForeground: token('secondaryForeground'),
    muted: token('muted'),
    mutedForeground: token('mutedForeground'),
    accent: token('accent'),
    accentForeground: token('accentForeground'),
    destructive: token('destructive'),
    destructiveForeground: token('destructiveForeground'),
    border: token('border'),
    input: token('input'),
    ring: token('ring'),
    chart1: token('chart1'),
    chart2: token('chart2'),
    chart3: token('chart3'),
    chart4: token('chart4'),
    chart5: token('chart5'),
    sidebar: token('sidebar'),
    sidebarForeground: token('sidebarForeground'),
    sidebarPrimary: token('sidebarPrimary'),
    sidebarPrimaryForeground: token('sidebarPrimaryForeground'),
    sidebarAccent: token('sidebarAccent'),
    sidebarAccentForeground: token('sidebarAccentForeground'),
    sidebarBorder: token('sidebarBorder'),
    sidebarRing: token('sidebarRing'),
  );
}

ShadcnTokens _tokensFrom(Map<String, Expression> args) {
  final shadows = args['shadows'];
  if (shadows == null) throw StateError('generated tokens miss "shadows"');
  final call = _callOf(shadows)!;
  final atoms = _namedArguments(call);
  return ShadcnTokens(
    radius: _doubleOf(args['radius']!),
    spacingBase: _doubleOf(args['spacingBase']!),
    trackingNormal: _doubleOf(args['trackingNormal']!),
    trackingTight: args['trackingTight'] == null
        ? null
        : _doubleOf(args['trackingTight']!),
    trackingWide: args['trackingWide'] == null
        ? null
        : _doubleOf(args['trackingWide']!),
    shadows: ShadowScale.derive(
      color: Color(_intOf(atoms['color']!)),
      opacity: _doubleOf(atoms['opacity']!),
      blur: _doubleOf(atoms['blur']!),
      spread: _doubleOf(atoms['spread']!),
      offsetX: _doubleOf(atoms['offsetX']!),
      offsetY: _doubleOf(atoms['offsetY']!),
    ),
  );
}

String _string(Expression expression) {
  if (expression is SimpleStringLiteral) return expression.value;
  if (expression is PrefixedIdentifier) {
    return '${expression.prefix.name}.${expression.identifier.name}';
  }
  if (expression is PropertyAccess) {
    return '${expression.target}.${expression.propertyName.name}';
  }
  throw StateError('not a string literal: $expression');
}

/// `Color(0xFFAABBCC)` -> 0xFFAABBCC.
int _intOf(Expression expression) {
  final call = _callOf(expression);
  if (call == null || _calledName(call) != 'Color') {
    throw StateError('not a Color literal: $expression');
  }
  final argument =
      _namedArguments(call)['color'] ??
      (call as MethodInvocation).argumentList.arguments.first;
  if (argument is IntegerLiteral) return argument.value!;
  throw StateError('not an int literal: $argument');
}

double _doubleOf(Expression expression) {
  if (expression is DoubleLiteral) return expression.value;
  if (expression is IntegerLiteral) return expression.value!.toDouble();
  // A negative literal is a unary minus in front of the literal.
  if (expression is PrefixExpression &&
      expression.operator.lexeme == '-' &&
      expression.operand is DoubleLiteral) {
    return -(expression.operand as DoubleLiteral).value;
  }
  throw StateError('not a numeric literal: $expression');
}
