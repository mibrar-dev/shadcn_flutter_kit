// The docs site header (spec §2.0): sticky 64 px (`lg+`) / 56 px bar, no
// border, background fill, four nav items, fixed-width search trigger
// (192/160/256), GitHub, theme toggle and the primary CTA. Below `lg` the nav
// collapses into the full-width mobile popper (not a side drawer); the search
// trigger hides below `md`.

import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import '../routing/docs_nav.dart';
import '../routing/docs_router.dart';
import '../state/docs_state.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/divider/divider.dart';
import '../ui/shadcn/components/tooltip/tooltip.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/primitives/clickable.dart';
import '../ui/shadcn/theme/color_tokens.dart';
import '../ui/shadcn/theme/theme.dart';
import '../web_bridge.dart';
import 'docs_footer.dart' show kDocsRepoUrl;
import 'get_code_dialog.dart';
import 'docs_tokens.dart';

/// The site header.
class DocsHeader extends StatelessWidget {
  /// Creates the header.
  const DocsHeader({
    super.key,
    required this.delegate,
    required this.state,
    required this.currentLocation,
    required this.mobileNavOpen,
    required this.onToggleMobileNav,
  });

  /// Router delegate (navigation + palette).
  final DocsRouterDelegate delegate;

  /// Theme state (toggle).
  final DocsState state;

  /// Current canonical location (active nav state).
  final String currentLocation;

  /// Whether the mobile nav popper is open.
  final bool mobileNavOpen;

  /// Toggles the mobile nav popper.
  final VoidCallback onToggleMobileNav;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final double width = MediaQuery.sizeOf(context).width;
    final bool wide = width >= 1024;
    final bool showSearch = width >= 768;
    final bool showSeparators = width >= 1024;
    final double searchWidth = width >= 1280
        ? DocsMetrics.searchWidthXl
        : (width >= 1024
              ? DocsMetrics.searchWidthLg
              : DocsMetrics.searchWidthMd);
    final bool showCta = width >= 768;
    return Container(
      height: wide ? DocsMetrics.headerHeightLg : DocsMetrics.headerHeightSm,
      color: theme.colors.background,
      padding: const EdgeInsets.symmetric(horizontal: DocsMetrics.barPadding),
      child: Row(
        children: <Widget>[
          // Invisible initial-focus anchor: the reference paints no focus
          // ring on load, but the first Tab must still start in the header
          // (focus_test). A plain `Focus(autofocus: true)` loses the race
          // against the Navigator route scope's own autofocus (it requests
          // focus during build), so the anchor asks in a post-frame callback
          // - the same trick `Button(autofocus)` uses. No `FocusOutline`
          // wraps it, so taking focus paints nothing.
          FocusTraversalOrder(
            order: DocsFocusOrder.headerAnchor,
            child: const _HeaderFocusAnchor(),
          ),
          if (!wide)
            Button(
              variant: ButtonVariant.ghost,
              size: ButtonSize.sm,
              // No `autofocus`: the reference paints no focus ring on load.
              // `OrderedTraversalPolicy` + the shell `FocusTraversalOrder`
              // slots still make the first Tab land in the header.
              onPressed: onToggleMobileNav,
              leading: Icon(
                mobileNavOpen ? LucideIcons.x : LucideIcons.menu,
                size: 16,
              ),
              child: Text(mobileNavOpen ? 'Close' : 'Menu'),
            ),
          if (wide)
            for (final DocsNavLink link in _headerNavFor(width))
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: _NavLink(
                  link: link,
                  active: _navActive(link.location, currentLocation),
                  onPressed: () => delegate.go(context, link.location),
                ),
              ),
          const Spacer(),
          if (showSearch)
            _SearchTrigger(
              width: searchWidth,
              label: width >= 1280 ? 'Search documentation…' : 'Search…',
              onPressed: delegate.openPalette,
            ),
          if (showSeparators) ...<Widget>[const Gap(8), const _BarSeparator()],
          const Gap(8),
          Tooltip(
            tooltip: (BuildContext context) => const Text('GitHub repository'),
            child: Button(
              variant: ButtonVariant.ghost,
              size: ButtonSize.sm,
              onPressed: () => webOpenUrl(kDocsRepoUrl),
              leading: const Icon(LucideIcons.github, size: 16),
              // The label needs `xl`: at exactly 1024 the bar overflows by a
              // few pixels with it (measured in the responsive audit).
              child: width >= 1280
                  ? const Text('GitHub')
                  : const SizedBox.shrink(),
            ),
          ),
          const Gap(4),
          Tooltip(
            tooltip: (BuildContext context) => const Text('Toggle theme'),
            child: SizedBox(
              width: 32,
              height: 32,
              child: Button(
                variant: ButtonVariant.ghost,
                size: ButtonSize.xs,
                theme: const ButtonVariantStyle(padding: EdgeInsets.zero),
                onPressed: state.toggleBrightness,
                child: Icon(
                  state.brightness == Brightness.dark
                      ? LucideIcons.sun
                      : LucideIcons.moon,
                  size: 16,
                ),
              ),
            ),
          ),
          if (showCta) ...<Widget>[
            const Gap(8),
            if (currentLocation == '/themes')
              // Spec §2.7: on `/create`/`/themes` the header swaps the primary
              // CTA for `Get Code`, which opens the export dialog.
              Button(
                key: const ValueKey<String>('docs-header-get-code'),
                variant: ButtonVariant.primary,
                size: ButtonSize.sm,
                onPressed: () => showGetCodeDialog(context, state.themeModel),
                child: const Text('Get Code'),
              )
            else
              Button(
                variant: ButtonVariant.primary,
                size: ButtonSize.sm,
                onPressed: () => delegate.go(context, '/docs/installation'),
                child: const Text('Get Started'),
              ),
          ],
        ],
      ),
    );
  }
}

/// The header nav items for [width].
///
/// The reference shows every nav item from `lg` (1024) up; with five items our
/// bar overflows there by 11 px (the labels are measured with the fallback
/// font in tests and with Geist in the browser), so `Blocks` joins the nav at
/// `xl` — the same escalation that adds the GitHub label and the 256 px
/// search. Blocks stays reachable below `xl` through the mobile popper (which
/// renders the whole [kHeaderNav]) and the docs sidebar.
List<DocsNavLink> _headerNavFor(double width) {
  if (width >= 1280) {
    return kHeaderNav;
  }
  return <DocsNavLink>[
    for (final DocsNavLink link in kHeaderNav)
      if (link.location != '/blocks') link,
  ];
}

bool _navActive(String linkLocation, String current) {
  if (linkLocation == '/') {
    return current == '/';
  }
  if (linkLocation == '/docs/components') {
    return current.startsWith('/docs/components');
  }
  if (linkLocation == '/blocks') {
    return current.startsWith('/blocks');
  }
  if (linkLocation == '/docs') {
    return current.startsWith('/docs') &&
        !current.startsWith('/docs/components');
  }
  return current == linkLocation;
}

class _HeaderFocusAnchor extends StatefulWidget {
  const _HeaderFocusAnchor();

  @override
  State<_HeaderFocusAnchor> createState() => _HeaderFocusAnchorState();
}

class _HeaderFocusAnchorState extends State<_HeaderFocusAnchor> {
  final FocusNode _node = FocusNode(debugLabel: 'header-focus-anchor');

  @override
  void initState() {
    super.initState();
    // Post-frame: the route's focus scope grabs focus during the first
    // build; asking afterwards makes the header the traversal origin.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _node.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      FocusableActionDetector(focusNode: _node, child: const SizedBox.shrink());
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.link,
    required this.active,
    required this.onPressed,
  });

  final DocsNavLink link;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return Button(
      variant: ButtonVariant.ghost,
      size: ButtonSize.sm,
      theme: ButtonVariantStyle(
        // Spec §2.0 measures the reference nav link at `px-2.5` (10 px
        // horizontal); the kit button's default padding is wider, which with
        // five nav items overflows the 64 px bar at exactly 1024 px.
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        foreground: StateValue<ThemedColor>(
          rest: ThemedColor.value(
            active ? colors.foreground : colors.mutedForeground,
          ),
          hovered: ThemedColor.value(colors.foreground),
        ),
      ),
      onPressed: onPressed,
      child: Text(link.label),
    );
  }
}

/// The search trigger; exact `h-8`/pl-3/muted surface layout (spec §2.0).
class _SearchTrigger extends StatelessWidget {
  const _SearchTrigger({
    required this.width,
    required this.label,
    required this.onPressed,
  });

  final double width;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return SizedBox(
      key: const ValueKey<String>('docs-search-trigger'),
      width: width,
      height: 32,
      child: Clickable(
        onPressed: onPressed,
        decoration: WidgetStateProperty.resolveWith<Decoration?>((
          Set<WidgetState> states,
        ) {
          return BoxDecoration(
            color: colors.muted.withValues(
              alpha: states.contains(WidgetState.hovered) ? 0.5 : 1,
            ),
            borderRadius: ShadcnTheme.of(context).borderRadiusLg,
          );
        }),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 12),
        ),
        textStyle: WidgetStatePropertyAll<TextStyle?>(
          docsText(context, size: 14, color: colors.mutedForeground),
        ),
        child: Row(
          children: <Widget>[
            Icon(LucideIcons.search, size: 14, color: colors.mutedForeground),
            const Gap(8),
            Expanded(
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarSeparator extends StatelessWidget {
  const _BarSeparator();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      child: Divider(
        axis: Axis.vertical,
        thickness: 1,
        color: ThemedColor.value(ShadcnTheme.of(context).colors.border),
      ),
    );
  }
}

/// The full-width mobile navigation popper (spec §2.8): background 90 % +
/// blur, `Menu` group (site nav) then `Sections` (docs pages), gap 12.
class DocsMobileNav extends StatelessWidget {
  /// Creates the mobile nav.
  const DocsMobileNav({
    super.key,
    required this.delegate,
    required this.currentLocation,
    required this.onNavigate,
  });

  /// Router delegate.
  final DocsRouterDelegate delegate;

  /// Current canonical location.
  final String currentLocation;

  /// Called after a link is chosen (closes the popper).
  final VoidCallback onNavigate;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final double width = MediaQuery.sizeOf(context).width;
    final double headerHeight = width >= 1024
        ? DocsMetrics.headerHeightLg
        : DocsMetrics.headerHeightSm;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height - headerHeight,
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: ColoredBox(
            color: theme.colors.background.withValues(alpha: 0.9),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _MobileGroup(
                    label: 'Menu',
                    links: kHeaderNav,
                    currentLocation: currentLocation,
                    delegate: delegate,
                    onNavigate: onNavigate,
                  ),
                  const Gap(48),
                  _MobileGroup(
                    label: 'Sections',
                    links: kDocsSections,
                    currentLocation: currentLocation,
                    delegate: delegate,
                    onNavigate: onNavigate,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileGroup extends StatelessWidget {
  const _MobileGroup({
    required this.label,
    required this.links,
    required this.currentLocation,
    required this.delegate,
    required this.onNavigate,
  });

  final String label;
  final List<DocsNavLink> links;
  final String currentLocation;
  final DocsRouterDelegate delegate;
  final VoidCallback onNavigate;

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: docsText(
            context,
            size: 14,
            weight: FontWeight.w500,
            color: colors.mutedForeground,
          ),
        ),
        const Gap(12),
        for (final DocsNavLink link in links)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Clickable(
              onPressed: () {
                onNavigate();
                delegate.go(context, link.location);
              },
              behavior: HitTestBehavior.opaque,
              child: Text(
                link.label,
                style: docsText(context, size: 18, weight: FontWeight.w500),
              ),
            ),
          ),
      ],
    );
  }
}
