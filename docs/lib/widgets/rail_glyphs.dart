// Trailing glyphs and value formatting of the Theme Studio rail rows
// (spec §2.7): the `Aa` font mark, the radius/spacing/shadow marks and the
// short labels the rows show.
//
// Split out of `theme_rail.dart` for the ~400-line rule.

import 'package:flutter/widgets.dart';

import '../theme/theme_document.dart';
import '../ui/shadcn/theme/theme.dart';
import 'theme_rail.dart' show docsRailText;

class RailAaGlyph extends StatelessWidget {
  const RailAaGlyph({super.key, required this.family});

  final String? family;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Aa',
      style: docsRailText(
        context,
        16,
        color: railGlyphMuted(context),
      ).copyWith(fontFamily: railFirstFamilyOf(family)),
    );
  }
}

class RailRadiusGlyph extends StatelessWidget {
  const RailRadiusGlyph({super.key, required this.theme});

  final ShadcnThemeData theme;

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        border: Border.all(color: railGlyphMuted(context)),
        borderRadius: BorderRadius.circular(theme.radiusLg.clamp(0, 9)),
      ),
    ),
  );
}

class RailSpacingGlyph extends StatelessWidget {
  const RailSpacingGlyph({super.key, required this.theme});

  final ShadcnThemeData theme;

  @override
  Widget build(BuildContext context) => Center(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < 3; i++)
          Container(
            width: 2 + theme.tokens.spacingBase / 4,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            color: railGlyphMuted(context),
          ),
      ],
    ),
  );
}

class RailShadowGlyph extends StatelessWidget {
  const RailShadowGlyph({super.key, required this.atoms});

  final DocsShadowAtoms atoms;

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 18,
      height: 14,
      decoration: BoxDecoration(
        color: railGlyphMuted(context),
        borderRadius: BorderRadius.circular(4),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(atoms.color).withValues(alpha: atoms.opacity),
            blurRadius: atoms.blur,
            spreadRadius: atoms.spread,
            offset: Offset(atoms.offsetX, atoms.offsetY),
          ),
        ],
      ),
    ),
  );
}

/// The muted foreground a glyph paints in.
Color railGlyphMuted(BuildContext context) =>
    ShadcnTheme.of(context).colors.mutedForeground;

/// The first family of a CSS family list.
String? railFirstFamilyOf(String? spec) {
  if (spec == null || spec.isEmpty) {
    return null;
  }
  final List<String> parts = spec
      .split(',')
      .map((String part) => part.trim().replaceAll('"', ''))
      .toList();
  return parts.first.isEmpty ? null : parts.first;
}

/// The short label of a CSS family list.
String railFamilyLabel(String? spec) {
  if (spec == null || spec.isEmpty) {
    return 'Default';
  }
  return railFirstFamilyOf(spec) ?? spec;
}

/// The `opacity · blur` label of the shadow row.
String railShadowLabel(DocsShadowAtoms atoms) =>
    '${(atoms.opacity * 100).round()}% · ${atoms.blur.round()} blur';
