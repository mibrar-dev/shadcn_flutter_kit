// The `scaffold` component: [Scaffold] (headers/body/footers shell with a
// loading bar) and [AppBar] ([ScaffoldBarData] lives in `scaffold_style.dart`).
//
// Ported from `components/layout/scaffold`. Fixes: the `material.dart`
// import is gone (loading bar is the `progress` component); `DrawerOverlay`
// (global mutable layer state) is deleted, drawers need no host; the root
// `Overlay(...)` is gone (it would isolate pushed routes); the custom render
// flex is a `Column`/`Stack` switch (floating bars overlay the body).

import 'dart:ui' show ImageFilter;

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/gap.dart';
import '../../primitives/text/text_extension.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import '../progress/progress.dart';
import 'scaffold_style.dart';

export 'scaffold_style.dart';

/// App screen shell; fixed bars take layout space, floating bars overlay.
class Scaffold extends StatelessWidget {
  /// Creates a scaffold shell.
  const Scaffold({
    super.key,
    required this.child,
    this.headers = const <Widget>[],
    this.footers = const <Widget>[],
    this.loadingProgress,
    this.loadingProgressIndeterminate = false,
    this.floatingHeader = false,
    this.floatingFooter = false,
    this.backgroundColor,
    this.headerBackgroundColor,
    this.footerBackgroundColor,
    this.showLoadingSparks,
    this.resizeToAvoidBottomInset,
    this.theme,
  });

  final Widget child;
  final List<Widget> headers;
  final List<Widget> footers;

  /// Loading fraction 0..1; null hides the bar unless indeterminate.
  final double? loadingProgress;

  /// Whether the loading bar animates without a value.
  final bool loadingProgressIndeterminate;

  /// Whether headers overlay the body instead of pushing it down.
  final bool floatingHeader;

  /// Whether footers overlay the body instead of pushing it up.
  final bool floatingFooter;

  final ThemedColor? backgroundColor;
  final ThemedColor? headerBackgroundColor;
  final ThemedColor? footerBackgroundColor;
  final bool? showLoadingSparks;

  /// Whether the body pads for the keyboard; null falls back to the theme.
  final bool? resizeToAvoidBottomInset;

  /// Widget-leg theme override, merged over the other legs.
  final ScaffoldTheme? theme;

  ScaffoldTheme _resolve(BuildContext context) {
    return resolveComponentStyle<ScaffoldTheme, ScaffoldTheme>(
      context,
      widget: theme,
      select: (t) => t,
      defaults: scaffoldDefaults,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final ScaffoldTheme style = _resolve(context);
    final EdgeInsets viewInsets = MediaQuery.viewInsetsOf(context);
    final bool resize =
        resizeToAvoidBottomInset ?? style.resizeToAvoidBottomInset ?? true;
    final Color? background = (backgroundColor ?? style.background)?.resolve(
      ambient.colors,
    );

    Widget body = child;
    if (resize && viewInsets.bottom > 0) {
      body = Padding(
        padding: EdgeInsets.only(bottom: viewInsets.bottom),
        child: MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(viewInsets: viewInsets.copyWith(bottom: 0)),
          child: child,
        ),
      );
    }
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _header(style),
        Expanded(child: body),
        _footer(style, viewInsets),
      ],
    );
    if (floatingHeader || floatingFooter) {
      content = Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (!floatingHeader) _header(style),
              Expanded(child: body),
              if (!floatingFooter) _footer(style, viewInsets),
            ],
          ),
          if (floatingHeader)
            Positioned(top: 0, left: 0, right: 0, child: _header(style)),
          if (floatingFooter)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _footer(style, viewInsets),
            ),
        ],
      );
    }
    return background == null
        ? content
        : ColoredBox(color: background, child: content);
  }

  /// Fresh header section (built twice in floating mode: layout + overlay).
  Widget _header(ScaffoldTheme style) {
    final bool showBar =
        loadingProgress != null || loadingProgressIndeterminate;
    return _BarSection(
      bars: headers,
      isHeader: true,
      background: headerBackgroundColor ?? style.headerBackground,
      loading: showBar
          ? Progress(
              value: loadingProgressIndeterminate ? null : loadingProgress,
              showSparks: showLoadingSparks ?? style.showLoadingSparks ?? false,
            )
          : null,
    );
  }

  /// Fresh footer section, hidden while the keyboard is open.
  Widget _footer(ScaffoldTheme style, EdgeInsets viewInsets) {
    return Offstage(
      offstage: viewInsets.bottom > 0,
      child: _BarSection(
        bars: footers,
        isHeader: false,
        background: footerBackgroundColor ?? style.footerBackground,
      ),
    );
  }
}

/// One scaffold section: loading bar plus bars with position scope.
class _BarSection extends StatelessWidget {
  const _BarSection({
    required this.bars,
    required this.isHeader,
    required this.background,
    this.loading,
  });

  final List<Widget> bars;
  final bool isHeader;
  final ThemedColor? background;
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    if (bars.isEmpty && loading == null) {
      return const SizedBox.shrink();
    }
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final Color? fill = background?.resolve(ambient.colors);
    final Widget section = RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ?loading,
          for (int i = 0; i < bars.length; i++)
            Data<ScaffoldBarData>.inherit(
              data: ScaffoldBarData(
                isHeader: isHeader,
                childIndex: i,
                childrenCount: bars.length,
              ),
              child: bars[i],
            ),
        ],
      ),
    );
    return fill == null ? section : ColoredBox(color: fill, child: section);
  }
}

/// Title bar for scaffold headers and footers.
///
/// Showing [header]/[title]/[subtitle] styles them (muted small over large
/// medium over muted small) through the text primitive.
class AppBar extends StatelessWidget {
  /// Creates an app bar.
  const AppBar({
    super.key,
    this.leading = const <Widget>[],
    this.trailing = const <Widget>[],
    this.title,
    this.header,
    this.subtitle,
    this.child,
    this.trailingExpanded = false,
    this.alignment = Alignment.center,
    this.padding,
    this.backgroundColor,
    this.leadingGap,
    this.trailingGap,
    this.height,
    this.surfaceBlur,
    this.surfaceOpacity,
    this.useSafeArea = true,
    this.theme,
  }) : assert(
         child == null || title == null,
         'Cannot provide both child and title',
       );

  final List<Widget> leading;
  final List<Widget> trailing;
  final Widget? title;
  final Widget? header;
  final Widget? subtitle;

  /// Custom center content; overrides [title]/[header]/[subtitle].
  final Widget? child;

  /// Whether the trailing area expands instead of the center.
  final bool trailingExpanded;

  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final ThemedColor? backgroundColor;
  final double? leadingGap;
  final double? trailingGap;
  final double? height;

  /// Backdrop blur override; null falls back to the theme.
  final double? surfaceBlur;

  /// Opacity multiplied onto the background; null falls back to the theme.
  final double? surfaceOpacity;

  /// Whether to respect the device safe area.
  final bool useSafeArea;

  /// Widget-leg theme override, merged over the other legs.
  final AppBarTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final AppBarTheme style = resolveComponentStyle<AppBarTheme, AppBarTheme>(
      context,
      widget: theme,
      select: (t) => t,
      defaults: appBarDefaults,
    );
    final double scale = ambient.scaling;
    final ScaffoldBarData? barData = Data.maybeOf<ScaffoldBarData>(context);
    final double blur =
        surfaceBlur ?? style.surfaceBlur ?? ambient.surfaceBlur ?? 0;
    final double opacity =
        surfaceOpacity ?? style.surfaceOpacity ?? ambient.surfaceOpacity ?? 1;
    final Color base =
        (backgroundColor ?? style.background)?.resolve(ambient.colors) ??
        ambient.colors.card;
    final bool topSafe =
        useSafeArea &&
        (barData == null || (barData.isHeader && barData.childIndex == 0));
    final bool bottomSafe =
        useSafeArea &&
        barData != null &&
        !barData.isHeader &&
        barData.childIndex == barData.childrenCount - 1;
    final double leadGap = leadingGap ?? style.leadingGap ?? 4 * scale;
    final double trailGap = trailingGap ?? style.trailingGap ?? 4 * scale;
    final double sectionGap = style.contentGap ?? 18 * scale;

    Widget center =
        child ??
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (header != null)
              KeyedSubtree(
                key: const ValueKey<String>('header'),
                child: header!.muted().small(),
              ),
            if (title != null)
              KeyedSubtree(
                key: const ValueKey<String>('title'),
                child: title!.large().medium(),
              ),
            if (subtitle != null)
              KeyedSubtree(
                key: const ValueKey<String>('subtitle'),
                child: subtitle!.muted().small(),
              ),
          ],
        );
    center = Flexible(
      fit: trailingExpanded ? FlexFit.loose : FlexFit.tight,
      child: center,
    );
    final Widget trail = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: trailingExpanded ? MainAxisSize.max : MainAxisSize.min,
      children: _spaced(trailing, trailGap),
    );

    return FocusTraversalGroup(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: ColoredBox(
            color: base.withValues(alpha: base.a * opacity),
            child: Align(
              alignment: alignment,
              child: Padding(
                padding:
                    padding ??
                    resolveEdgeInsets(
                      style.padding ?? EdgeInsets.zero,
                      ambient.density.baseContentPadding * scale,
                    ),
                child: SafeArea(
                  top: topSafe,
                  left: useSafeArea,
                  right: useSafeArea,
                  bottom: bottomSafe,
                  child: SizedBox(
                    height: height,
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          if (leading.isNotEmpty)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: _spaced(leading, leadGap),
                            ),
                          if (leading.isNotEmpty) Gap(sectionGap),
                          center,
                          if (trailing.isNotEmpty) Gap(sectionGap),
                          if (trailing.isNotEmpty && !trailingExpanded) trail,
                          if (trailing.isNotEmpty && trailingExpanded)
                            Expanded(child: trail),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Interleaves [gap] pixels between [widgets].
  static List<Widget> _spaced(List<Widget> widgets, double gap) {
    final List<Widget> out = <Widget>[];
    for (int i = 0; i < widgets.length; i++) {
      if (i > 0) out.add(Gap(gap));
      out.add(widgets[i]);
    }
    return out;
  }
}
