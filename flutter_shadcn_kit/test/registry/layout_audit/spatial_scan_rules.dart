// Scan rules for the P6-D9b spacing audit: the site record and the value
// classifier that decides whether a spatial literal scales with the theme.
//
// Classification:
//   derived_spacing  `EdgeInsets.all(theme.spacing.sm)`, `Gap(theme.spacing.xs)`
//                    — scales with the preset spacing base. COMPLIANT.
//   derived_density  `EdgeInsetsDensity.*`, `resolveEdgeInsets(p, density)`,
//                    `EdgeInsets.all(pad(x))`, a literal multiplied by
//                    `density.baseContentPadding` — scales with density.
//                    COMPLIANT.
//   theme_default    resolved through a component theme / widget leg
//                    (`style.padding`, `chipDefaultPadding`, ...). COMPLIANT if
//                    the default itself is density-derived; the scan reports
//                    the default's own source separately.
//   computed         an expression over parameters, not a literal. COMPLIANT.
//   border_hairline  1px border / divider — allowed by the audit rules.
//   icon_size        icon glyph size owned by the component theme — allowed.
//   shadcn_fixed     a size shadcn pins (`size-4` = 16, `size-2.5` = 10, ...)
//                    in a box context — allowed, must be justified.
//   layout_cap       a width/height layout cap, not padding — allowed.
//   raw              a literal padding/gap that does not scale. FINDING.
//
// See `spatial_scan.dart` for the driver that produces
// `rearch/reports/p6_spacing_audit.json`.
class SpatialSite {
  SpatialSite({
    required this.file,
    required this.line,
    required this.kind,
    required this.construct,
    required this.value,
    required this.classification,
    required this.decl,
    this.isFinding = false,
  });

  final String file;
  final int line;

  /// `edge_insets` | `gap` | `sized_box` | `box_constraints` | `padding` |
  /// `spacing_arg` | `border` | `divider`.
  final String kind;

  /// Constructor the literal came from, e.g. `EdgeInsets.symmetric`.
  final String construct;

  /// Source text of the literal expression.
  final String value;

  /// One of the classifications documented at the top of this file.
  final String classification;

  /// Nearest enclosing declaration (field, method or top-level variable).
  final String decl;

  /// True when the literal is a padding/margin/gap that must scale.
  final bool isFinding;

  Map<String, Object?> toJson() => <String, Object?>{
    'file': file,
    'line': line,
    'kind': kind,
    'construct': construct,
    'value': value,
    'classification': classification,
    'decl': decl,
  };
}

/// shadcn box sizes that are pinned by the upstream Tailwind classes and are
/// deliberately NOT spacing-scale derived (`size-4` is 16px, `size-2.5` is
/// 10px, ...). Used in a width/height/min/max context only.
final Set<double> _shadcnBoxSizes = <double>{
  2.5,
  4,
  8,
  10,
  12,
  14,
  16,
  18,
  20,
  22,
  24,
  28,
  32,
  36,
  40,
  44,
  48,
  56,
  64,
};

/// Values that look like a spacing-scale step rather than a fixed box size.
final Set<double> _spacingScaleValues = <double>{
  2,
  4,
  6,
  8,
  10,
  12,
  16,
  18,
  20,
  24,
  28,
  32,
  36,
  40,
  48,
};

/// Padding multiplier constants exported by `theme/density.dart`; used with
/// `EdgeInsetsDensity` they scale with density.
final RegExp _padMultiplier = RegExp(
  r'\bpad\(|\bpad(Xs|Sm|Md|Lg|Xl|2xl|3xl|4xl)\b',
);

/// References the ambient theme's spacing scale.
final RegExp _spacingRef = RegExp(
  r'\.spacing\s*\.\s*\w+|spacing\.xs|spacing\.sm',
);

/// References density / a density-derived base / the density resolver.
final RegExp _densityRef = RegExp(
  r'EdgeInsetsDensity|DirectionalEdgeInsetsDensity|resolveEdgeInsets'
  r'|baseContentPadding|baseContainerPadding|baseGap|density\b|Density\.',
);

/// Scales a literal by the density base (the `button` pattern).
final RegExp _scaleRef = RegExp(r'\bscale\b');

/// A literal multiplied by 16 (the rem bridge used for px Tailwind values).
final RegExp _remRef = RegExp(r'\*\s*16\b|rem\b');

/// A nested padding construction recorded by its own visit.
final RegExp spatialConstruction = RegExp(
  r'^(const\s+)?(EdgeInsets|EdgeInsetsDirectional|EdgeInsetsDensity'
  r'|DirectionalEdgeInsetsDensity)\b',
);

/// Resolves through a component-theme or widget-leg field.
final RegExp _themeRef = RegExp(
  r'(^|[^\w.])(padding|contentPadding|insetPadding|gap|inset|margin)\b'
  r'|Default[A-Za-z]*|Defaults\b',
);

/// Literal `EdgeInsets.*` constructors we care about.
const Map<String, List<String>> edgeInsetsArgs = <String, List<String>>{
  'EdgeInsets': <String>['all', 'only', 'symmetric', 'fromLTRB', 'fromSTEB'],
  'EdgeInsetsDirectional': <String>['all', 'only', 'symmetric', 'fromSTEB'],
  'EdgeInsetsDensity': <String>['all', 'only', 'symmetric', 'fromSTEB'],
  'DirectionalEdgeInsetsDensity': <String>['all', 'only', 'symmetric'],
};

/// Offset-component argument names of an `EdgeInsets` construction.
const Set<String> insetArgNames = <String>{
  'left',
  'top',
  'right',
  'bottom',
  'start',
  'end',
  'horizontal',
  'vertical',
  'value',
};

/// Classifies a value expression, given what kind of slot it fills.
///
/// Returns one of the classifications documented at the top of this file. Only
/// a numeric literal that lands in a padding/gap/spacing slot becomes `raw`
/// (a finding); every non-literal expression is code-derived and never a
/// finding.
String classifyValue(String expr, String argName, String kind) {
  final String value = expr.trim();
  if (_spacingRef.hasMatch(value)) {
    return 'derived_spacing';
  }
  if (_densityRef.hasMatch(value)) {
    return 'derived_density';
  }
  if (_scaleRef.hasMatch(value) || _remRef.hasMatch(value)) {
    return 'derived_density';
  }
  if (_padMultiplier.hasMatch(value)) {
    return 'derived_density';
  }
  if (_themeRef.hasMatch(value)) {
    return 'theme_default';
  }
  final double? literal = _numericLiteral(value);
  if (literal == null) {
    // An identifier, a call (`_innerMin(...)`), an `??` chain or arithmetic
    // over parameters: resolved code, not a hard-coded literal.
    return _isPlainIdentifier(value) ? 'theme_default' : 'computed';
  }
  if (kind == 'border' || kind == 'divider') {
    return 'border_hairline';
  }
  if (argName == 'iconSize' || argName == 'size') {
    return 'icon_size';
  }
  if (insetArgNames.contains(argName) ||
      kind == 'gap' ||
      kind == 'spacing_arg') {
    return 'raw';
  }
  if (kind == 'edge_insets' || kind == 'padding') {
    // `EdgeInsets.all(8)` and friends: positional args have no argName.
    return 'raw';
  }
  if (kind == 'box_constraints') {
    // A width/height cap (`maxWidth: 460`) or a fixed box size, not padding.
    return _shadcnBoxSizes.contains(literal) ? 'shadcn_fixed' : 'layout_cap';
  }
  if (kind == 'sized_box' && _spacingScaleValues.contains(literal)) {
    // `SizedBox(height: 8)` used as a spacer is an unscaled gap.
    return 'raw';
  }
  return _shadcnBoxSizes.contains(literal) ? 'shadcn_fixed' : 'layout_cap';
}

/// True for a bare identifier or dotted identifier chain (`gap`,
/// `style.padding`).
bool _isPlainIdentifier(String expr) =>
    RegExp(r'^[A-Za-z_$][\w$.]*$').hasMatch(expr);

/// Parses a standalone numeric literal (integer or decimal).
double? _numericLiteral(String expr) {
  final String trimmed = expr.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  return double.tryParse(trimmed);
}
