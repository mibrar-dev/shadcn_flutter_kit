import 'package:flutter/widgets.dart';

import 'tokens.dart';

/// Full shadcn text-style set: family bases, size ramp, weight ramp and
/// semantic styles. Family wiring comes from [applyFonts]; tracking stays
/// data on [TrackingScale] (as before: no component consumed it directly).
class Typography {
  /// Sans-serif body base.
  final TextStyle sans;

  /// Monospace base.
  final TextStyle mono;

  /// Extra small (12px).
  final TextStyle xSmall;

  /// Small (14px).
  final TextStyle small;

  /// Base (16px).
  final TextStyle base;

  /// Large (18px).
  final TextStyle large;

  /// Extra large (20px).
  final TextStyle xLarge;

  /// 2x large (24px).
  final TextStyle x2Large;

  /// 3x large (30px).
  final TextStyle x3Large;

  /// 4x large (36px).
  final TextStyle x4Large;

  /// 5x large (48px).
  final TextStyle x5Large;

  /// 6x large (60px).
  final TextStyle x6Large;

  /// 7x large (72px).
  final TextStyle x7Large;

  /// 8x large (96px).
  final TextStyle x8Large;

  /// 9x large (144px).
  final TextStyle x9Large;

  /// Thin (w100).
  final TextStyle thin;

  /// Light (w300).
  final TextStyle light;

  /// Extra light (w200).
  final TextStyle extraLight;

  /// Normal (w400).
  final TextStyle normal;

  /// Medium (w500).
  final TextStyle medium;

  /// Semi-bold (w600).
  final TextStyle semiBold;

  /// Bold (w700).
  final TextStyle bold;

  /// Extra bold (w800).
  final TextStyle extraBold;

  /// Black (w900).
  final TextStyle black;

  /// Italic.
  final TextStyle italic;

  /// Heading 1.
  final TextStyle h1;

  /// Heading 2.
  final TextStyle h2;

  /// Heading 3.
  final TextStyle h3;

  /// Heading 4.
  final TextStyle h4;

  /// Paragraph.
  final TextStyle p;

  /// Block quote.
  final TextStyle blockQuote;

  /// Inline code.
  final TextStyle inlineCode;

  /// Lead paragraph.
  final TextStyle lead;

  /// Large text.
  final TextStyle textLarge;

  /// Small text.
  final TextStyle textSmall;

  /// Muted text.
  final TextStyle textMuted;

  /// Default Geist-backed set.
  const Typography.geist({
    this.sans = const TextStyle(
      fontFamily: 'GeistSans',
      fontFamilyFallback: ['NotoSansSymbols2'],
    ),
    this.mono = const TextStyle(
      fontFamily: 'GeistMono',
      fontFamilyFallback: ['NotoSansSymbols2'],
    ),
    this.xSmall = const TextStyle(fontSize: 12),
    this.small = const TextStyle(fontSize: 14),
    this.base = const TextStyle(fontSize: 16),
    this.large = const TextStyle(fontSize: 18),
    this.xLarge = const TextStyle(fontSize: 20),
    this.x2Large = const TextStyle(fontSize: 24),
    this.x3Large = const TextStyle(fontSize: 30),
    this.x4Large = const TextStyle(fontSize: 36),
    this.x5Large = const TextStyle(fontSize: 48),
    this.x6Large = const TextStyle(fontSize: 60),
    this.x7Large = const TextStyle(fontSize: 72),
    this.x8Large = const TextStyle(fontSize: 96),
    this.x9Large = const TextStyle(fontSize: 144),
    this.thin = const TextStyle(fontWeight: FontWeight.w100),
    this.light = const TextStyle(fontWeight: FontWeight.w300),
    this.extraLight = const TextStyle(fontWeight: FontWeight.w200),
    this.normal = const TextStyle(fontWeight: FontWeight.w400),
    this.medium = const TextStyle(fontWeight: FontWeight.w500),
    this.semiBold = const TextStyle(fontWeight: FontWeight.w600),
    this.bold = const TextStyle(fontWeight: FontWeight.w700),
    this.extraBold = const TextStyle(fontWeight: FontWeight.w800),
    this.black = const TextStyle(fontWeight: FontWeight.w900),
    this.italic = const TextStyle(fontStyle: FontStyle.italic),
    this.h1 = const TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
    this.h2 = const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
    this.h3 = const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    this.h4 = const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    this.p = const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    this.blockQuote = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
    ),
    this.inlineCode = const TextStyle(
      fontFamily: 'GeistMono',
      fontFamilyFallback: ['NotoSansSymbols2'],
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    this.lead = const TextStyle(fontSize: 20),
    this.textLarge = const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    this.textSmall = const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    this.textMuted = const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
  });

  /// Custom set with every style required.
  const Typography({
    required this.sans,
    required this.mono,
    required this.xSmall,
    required this.small,
    required this.base,
    required this.large,
    required this.xLarge,
    required this.x2Large,
    required this.x3Large,
    required this.x4Large,
    required this.x5Large,
    required this.x6Large,
    required this.x7Large,
    required this.x8Large,
    required this.x9Large,
    required this.thin,
    required this.light,
    required this.extraLight,
    required this.normal,
    required this.medium,
    required this.semiBold,
    required this.bold,
    required this.extraBold,
    required this.black,
    required this.italic,
    required this.h1,
    required this.h2,
    required this.h3,
    required this.h4,
    required this.p,
    required this.blockQuote,
    required this.inlineCode,
    required this.lead,
    required this.textLarge,
    required this.textSmall,
    required this.textMuted,
  });

  Typography copyWith({
    TextStyle? sans,
    TextStyle? mono,
    TextStyle? xSmall,
    TextStyle? small,
    TextStyle? base,
    TextStyle? large,
    TextStyle? xLarge,
    TextStyle? x2Large,
    TextStyle? x3Large,
    TextStyle? x4Large,
    TextStyle? x5Large,
    TextStyle? x6Large,
    TextStyle? x7Large,
    TextStyle? x8Large,
    TextStyle? x9Large,
    TextStyle? thin,
    TextStyle? light,
    TextStyle? extraLight,
    TextStyle? normal,
    TextStyle? medium,
    TextStyle? semiBold,
    TextStyle? bold,
    TextStyle? extraBold,
    TextStyle? black,
    TextStyle? italic,
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? h4,
    TextStyle? p,
    TextStyle? blockQuote,
    TextStyle? inlineCode,
    TextStyle? lead,
    TextStyle? textLarge,
    TextStyle? textSmall,
    TextStyle? textMuted,
  }) {
    return Typography(
      sans: sans ?? this.sans,
      mono: mono ?? this.mono,
      xSmall: xSmall ?? this.xSmall,
      small: small ?? this.small,
      base: base ?? this.base,
      large: large ?? this.large,
      xLarge: xLarge ?? this.xLarge,
      x2Large: x2Large ?? this.x2Large,
      x3Large: x3Large ?? this.x3Large,
      x4Large: x4Large ?? this.x4Large,
      x5Large: x5Large ?? this.x5Large,
      x6Large: x6Large ?? this.x6Large,
      x7Large: x7Large ?? this.x7Large,
      x8Large: x8Large ?? this.x8Large,
      x9Large: x9Large ?? this.x9Large,
      thin: thin ?? this.thin,
      light: light ?? this.light,
      extraLight: extraLight ?? this.extraLight,
      normal: normal ?? this.normal,
      medium: medium ?? this.medium,
      semiBold: semiBold ?? this.semiBold,
      bold: bold ?? this.bold,
      extraBold: extraBold ?? this.extraBold,
      black: black ?? this.black,
      italic: italic ?? this.italic,
      h1: h1 ?? this.h1,
      h2: h2 ?? this.h2,
      h3: h3 ?? this.h3,
      h4: h4 ?? this.h4,
      p: p ?? this.p,
      blockQuote: blockQuote ?? this.blockQuote,
      inlineCode: inlineCode ?? this.inlineCode,
      lead: lead ?? this.lead,
      textLarge: textLarge ?? this.textLarge,
      textSmall: textSmall ?? this.textSmall,
      textMuted: textMuted ?? this.textMuted,
    );
  }

  /// Scales every sized style by [factor]; unsized styles pass through.
  Typography scale(double factor) {
    TextStyle s(TextStyle t) =>
        t.fontSize == null ? t : t.copyWith(fontSize: t.fontSize! * factor);
    return Typography(
      sans: s(sans),
      mono: s(mono),
      xSmall: s(xSmall),
      small: s(small),
      base: s(base),
      large: s(large),
      xLarge: s(xLarge),
      x2Large: s(x2Large),
      x3Large: s(x3Large),
      x4Large: s(x4Large),
      x5Large: s(x5Large),
      x6Large: s(x6Large),
      x7Large: s(x7Large),
      x8Large: s(x8Large),
      x9Large: s(x9Large),
      thin: s(thin),
      light: s(light),
      extraLight: s(extraLight),
      normal: s(normal),
      medium: s(medium),
      semiBold: s(semiBold),
      bold: s(bold),
      extraBold: s(extraBold),
      black: s(black),
      italic: s(italic),
      h1: s(h1),
      h2: s(h2),
      h3: s(h3),
      h4: s(h4),
      p: s(p),
      blockQuote: s(blockQuote),
      inlineCode: s(inlineCode),
      lead: s(lead),
      textLarge: s(textLarge),
      textSmall: s(textSmall),
      textMuted: s(textMuted),
    );
  }

  /// Wires [fonts] families in: fontSans into [sans], fontMono into [mono]
  /// and [inlineCode]. Null/empty specs keep the current style. `"A, B"`
  /// splits into family A plus fallback B.
  Typography applyFonts(ShadcnFonts fonts) {
    return copyWith(
      sans: _withFamily(sans, fonts.fontSans),
      mono: _withFamily(mono, fonts.fontMono),
      inlineCode: _withFamily(inlineCode, fonts.fontMono),
    );
  }

  static TextStyle _withFamily(TextStyle style, String? spec) {
    if (spec == null) return style;
    final parts = spec
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return style;
    return style.copyWith(
      fontFamily: parts.first,
      fontFamilyFallback: parts.length > 1 ? parts.sublist(1) : null,
    );
  }

  static Typography lerp(Typography a, Typography b, double t) {
    TextStyle m(TextStyle x, TextStyle y) => TextStyle.lerp(x, y, t)!;
    return Typography(
      sans: m(a.sans, b.sans),
      mono: m(a.mono, b.mono),
      xSmall: m(a.xSmall, b.xSmall),
      small: m(a.small, b.small),
      base: m(a.base, b.base),
      large: m(a.large, b.large),
      xLarge: m(a.xLarge, b.xLarge),
      x2Large: m(a.x2Large, b.x2Large),
      x3Large: m(a.x3Large, b.x3Large),
      x4Large: m(a.x4Large, b.x4Large),
      x5Large: m(a.x5Large, b.x5Large),
      x6Large: m(a.x6Large, b.x6Large),
      x7Large: m(a.x7Large, b.x7Large),
      x8Large: m(a.x8Large, b.x8Large),
      x9Large: m(a.x9Large, b.x9Large),
      thin: m(a.thin, b.thin),
      light: m(a.light, b.light),
      extraLight: m(a.extraLight, b.extraLight),
      normal: m(a.normal, b.normal),
      medium: m(a.medium, b.medium),
      semiBold: m(a.semiBold, b.semiBold),
      bold: m(a.bold, b.bold),
      extraBold: m(a.extraBold, b.extraBold),
      black: m(a.black, b.black),
      italic: m(a.italic, b.italic),
      h1: m(a.h1, b.h1),
      h2: m(a.h2, b.h2),
      h3: m(a.h3, b.h3),
      h4: m(a.h4, b.h4),
      p: m(a.p, b.p),
      blockQuote: m(a.blockQuote, b.blockQuote),
      inlineCode: m(a.inlineCode, b.inlineCode),
      lead: m(a.lead, b.lead),
      textLarge: m(a.textLarge, b.textLarge),
      textSmall: m(a.textSmall, b.textSmall),
      textMuted: m(a.textMuted, b.textMuted),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Typography &&
        other.sans == sans &&
        other.mono == mono &&
        other.xSmall == xSmall &&
        other.small == small &&
        other.base == base &&
        other.large == large &&
        other.xLarge == xLarge &&
        other.x2Large == x2Large &&
        other.x3Large == x3Large &&
        other.x4Large == x4Large &&
        other.x5Large == x5Large &&
        other.x6Large == x6Large &&
        other.x7Large == x7Large &&
        other.x8Large == x8Large &&
        other.x9Large == x9Large &&
        other.thin == thin &&
        other.light == light &&
        other.extraLight == extraLight &&
        other.normal == normal &&
        other.medium == medium &&
        other.semiBold == semiBold &&
        other.bold == bold &&
        other.extraBold == extraBold &&
        other.black == black &&
        other.italic == italic &&
        other.h1 == h1 &&
        other.h2 == h2 &&
        other.h3 == h3 &&
        other.h4 == h4 &&
        other.p == p &&
        other.blockQuote == blockQuote &&
        other.inlineCode == inlineCode &&
        other.lead == lead &&
        other.textLarge == textLarge &&
        other.textSmall == textSmall &&
        other.textMuted == textMuted;
  }

  @override
  int get hashCode => Object.hashAll([
    sans,
    mono,
    xSmall,
    small,
    base,
    large,
    xLarge,
    x2Large,
    x3Large,
    x4Large,
    x5Large,
    x6Large,
    x7Large,
    x8Large,
    x9Large,
    thin,
    light,
    extraLight,
    normal,
    medium,
    semiBold,
    bold,
    extraBold,
    black,
    italic,
    h1,
    h2,
    h3,
    h4,
    p,
    blockQuote,
    inlineCode,
    lead,
    textLarge,
    textSmall,
    textMuted,
  ]);
}

/// Icon sizes for the type scale (driven by text scaling).
class IconThemeProperties {
  /// Default sizes: 6, 8, 10, 12, 16, 20, 24, 32, 40, 48, 56.
  const IconThemeProperties({
    this.x4Small = const IconThemeData(size: 6),
    this.x3Small = const IconThemeData(size: 8),
    this.x2Small = const IconThemeData(size: 10),
    this.xSmall = const IconThemeData(size: 12),
    this.small = const IconThemeData(size: 16),
    this.medium = const IconThemeData(size: 20),
    this.large = const IconThemeData(size: 24),
    this.xLarge = const IconThemeData(size: 32),
    this.x2Large = const IconThemeData(size: 40),
    this.x3Large = const IconThemeData(size: 48),
    this.x4Large = const IconThemeData(size: 56),
  });

  final IconThemeData x4Small;
  final IconThemeData x3Small;
  final IconThemeData x2Small;
  final IconThemeData xSmall;
  final IconThemeData small;
  final IconThemeData medium;
  final IconThemeData large;
  final IconThemeData xLarge;
  final IconThemeData x2Large;
  final IconThemeData x3Large;
  final IconThemeData x4Large;

  IconThemeProperties copyWith({
    IconThemeData? x4Small,
    IconThemeData? x3Small,
    IconThemeData? x2Small,
    IconThemeData? xSmall,
    IconThemeData? small,
    IconThemeData? medium,
    IconThemeData? large,
    IconThemeData? xLarge,
    IconThemeData? x2Large,
    IconThemeData? x3Large,
    IconThemeData? x4Large,
  }) {
    return IconThemeProperties(
      x4Small: x4Small ?? this.x4Small,
      x3Small: x3Small ?? this.x3Small,
      x2Small: x2Small ?? this.x2Small,
      xSmall: xSmall ?? this.xSmall,
      small: small ?? this.small,
      medium: medium ?? this.medium,
      large: large ?? this.large,
      xLarge: xLarge ?? this.xLarge,
      x2Large: x2Large ?? this.x2Large,
      x3Large: x3Large ?? this.x3Large,
      x4Large: x4Large ?? this.x4Large,
    );
  }

  /// Scales every sized icon by [factor].
  IconThemeProperties scale(double factor) {
    IconThemeData s(IconThemeData t) =>
        t.size == null ? t : t.copyWith(size: t.size! * factor);
    return IconThemeProperties(
      x4Small: s(x4Small),
      x3Small: s(x3Small),
      x2Small: s(x2Small),
      xSmall: s(xSmall),
      small: s(small),
      medium: s(medium),
      large: s(large),
      xLarge: s(xLarge),
      x2Large: s(x2Large),
      x3Large: s(x3Large),
      x4Large: s(x4Large),
    );
  }

  static IconThemeProperties lerp(
    IconThemeProperties a,
    IconThemeProperties b,
    double t,
  ) {
    IconThemeData m(IconThemeData x, IconThemeData y) =>
        IconThemeData.lerp(x, y, t);
    return IconThemeProperties(
      x4Small: m(a.x4Small, b.x4Small),
      x3Small: m(a.x3Small, b.x3Small),
      x2Small: m(a.x2Small, b.x2Small),
      xSmall: m(a.xSmall, b.xSmall),
      small: m(a.small, b.small),
      medium: m(a.medium, b.medium),
      large: m(a.large, b.large),
      xLarge: m(a.xLarge, b.xLarge),
      x2Large: m(a.x2Large, b.x2Large),
      x3Large: m(a.x3Large, b.x3Large),
      x4Large: m(a.x4Large, b.x4Large),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IconThemeProperties &&
        other.x4Small == x4Small &&
        other.x3Small == x3Small &&
        other.x2Small == x2Small &&
        other.xSmall == xSmall &&
        other.small == small &&
        other.medium == medium &&
        other.large == large &&
        other.xLarge == xLarge &&
        other.x2Large == x2Large &&
        other.x3Large == x3Large &&
        other.x4Large == x4Large;
  }

  @override
  int get hashCode => Object.hash(
    x4Small,
    x3Small,
    x2Small,
    xSmall,
    small,
    medium,
    large,
    xLarge,
    x2Large,
    x3Large,
    x4Large,
  );
}
