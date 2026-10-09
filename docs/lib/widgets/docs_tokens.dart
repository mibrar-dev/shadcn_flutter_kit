// Docs-site presentation constants and helpers (P6 spec §3).
//
// These are page-chrome values, not design-system tokens: the 7 site-only
// CSS variables (`--surface`, `--code`, …) are not part of the preset schema,
// so they live here as docs-app constants derived from the neutral faces of
// the theme (spec §3.1 recommendation).

import 'package:flutter/widgets.dart';

import '../ui/shadcn/theme/color_tokens.dart';
import '../ui/shadcn/theme/theme.dart';

/// Measured layout metrics of the shadcn site (P6 spec §2).
abstract final class DocsMetrics {
  /// Header height at `lg` and up.
  static const double headerHeightLg = 64;

  /// Header height below `lg`.
  static const double headerHeightSm = 56;

  /// Footer height at `xl` and up.
  static const double footerHeightLg = 96;

  /// Footer height below `xl`.
  static const double footerHeightSm = 56;

  /// Docs sidebar column width (`--sidebar-width`).
  static const double sidebarWidth = 288;

  /// Sidebar inner scroll area (`--sidebar-menu-width`).
  static const double sidebarMenuWidth = 224;

  /// Article column max width (`max-w-160` = 40rem).
  static const double articleWidth = 640;

  /// TOC column width (`--sidebar-width`).
  static const double tocWidth = 288;

  /// Outer page gutter (`.container-wrapper` `px-2`).
  static const double containerGutter = 8;

  /// Header/footer horizontal padding.
  static const double barPadding = 24;

  /// Search trigger widths at `md` / `lg` / `xl` (spec §2.0).
  static const double searchWidthMd = 192;
  static const double searchWidthLg = 160;
  static const double searchWidthXl = 256;

  /// Command palette panel width (`sm:max-w-lg`) and top offset fraction.
  static const double paletteWidth = 512;
  static const double paletteTopFraction = 0.15;

  /// Component preview stage height (spec §2.4).
  static const double previewStageHeight = 288;

  /// Collapsed code teaser height (spec §2.4).
  static const double codeTeaserHeight = 109;
}

/// Tab-order slots for the persistent shell and the docs layout.
///
/// The shell scope traverses header → docs navigator → footer; the docs-layout
/// scope traverses sidebar → article content → TOC. Both scopes use
/// [OrderedTraversalPolicy], so the numbers are per-scope (the header and the
/// sidebar may both be `0`). This matches the reference DOM order and keeps the
/// header reachable first even though it lives outside the page navigator.
abstract final class DocsFocusOrder {
  /// Shell: the site header.
  static const NumericFocusOrder header = NumericFocusOrder(0);

  /// Shell: the invisible header focus anchor (before every header item).
  ///
  /// A 0x0 box sorts after the 32 px nav buttons in the reading-order
  /// secondary sort (it is centered at y=32 while they start at y=16), so it
  /// needs its own slot to stay the header's first Tab stop.
  static const NumericFocusOrder headerAnchor = NumericFocusOrder(-1);

  /// Shell: the docs navigator (every page's content).
  static const NumericFocusOrder navigator = NumericFocusOrder(1);

  /// Shell: the one-line footer.
  static const NumericFocusOrder footer = NumericFocusOrder(2);

  /// Docs layout: the sidebar column.
  static const NumericFocusOrder sidebar = NumericFocusOrder(0);

  /// Docs layout: the article content column.
  static const NumericFocusOrder content = NumericFocusOrder(1);

  /// Docs layout: the "On This Page" column.
  static const NumericFocusOrder toc = NumericFocusOrder(2);
}

/// The three palette groups, in order (spec §5.3 D2 delta).
enum PaletteGroup {
  /// Site pages and CLI command entries.
  pages,

  /// Registry components.
  components,

  /// Theme presets.
  presets,
}

/// Site-only colours derived from the theme's neutral faces (spec §3.1).
@immutable
class DocsSiteColors {
  /// Derives the site palette from [colors].
  const DocsSiteColors(this.colors);

  /// The ambient token set.
  final ShadcnColors colors;

  bool get _dark => colors.brightness == Brightness.dark;

  /// Code figure surface (`--code` / `--surface`).
  Color get codeSurface =>
      _dark ? const Color(0xFF161616) : const Color(0xFFF8F8F8);

  /// Code figure highlight (`--code-highlight`).
  Color get codeHighlight =>
      _dark ? const Color(0xFF262626) : const Color(0xFFF2F2F2);

  /// Line numbers (`--code-number`).
  Color get codeNumber =>
      _dark ? const Color(0xFFA4A4A4) : const Color(0xFF747474);

  /// Palette panel ring (`ring-neutral-200/80` / `dark:ring-neutral-800`).
  Color get panelRing => _dark
      ? const Color(0xFF262626)
      : const Color(0xFFE5E5E5).withValues(alpha: 0.8);

  /// Palette footer bar (`bg-neutral-50` / `dark:bg-neutral-800`).
  Color get panelFooter =>
      _dark ? const Color(0xFF262626) : const Color(0xFFFAFAFA);

  /// Neutral ring/footer pair for the palette.
  static DocsSiteColors of(BuildContext context) =>
      DocsSiteColors(ShadcnTheme.of(context).colors);
}

/// A sans text style at the measured site size (Geist, token colour).
TextStyle docsText(
  BuildContext context, {
  required double size,
  FontWeight weight = FontWeight.w400,
  Color? color,
  double? height,
  double? letterSpacing,
}) {
  final ShadcnThemeData theme = ShadcnTheme.of(context);
  return theme.typography.sans.copyWith(
    fontSize: size,
    fontWeight: weight,
    height: height,
    letterSpacing: letterSpacing,
    color: color ?? theme.colors.foreground,
  );
}

/// The docs vertical scrollbar-less look: the reference hides scrollbars on
/// the sidebar, TOC and palette (`scrollbar-none` / `no-scrollbar`).
class DocsScrollBehavior extends ScrollBehavior {
  /// Creates the behaviour.
  const DocsScrollBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
