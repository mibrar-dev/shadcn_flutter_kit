// The docs sidebar (spec §2.2): 288 px column, 224 px scroll area with pl-10,
// 1 px gradient right rule, scroll-fade mask, Sections + Components groups.
// Items are 30 px rows (12.8/18.29 500) driven by the shared `Clickable`
// primitive; the active item gets the accent fill + 1 px border (no ring, no
// file-count badges, no palette button — spec §5.1).
//
// The active item is centred in the scroll area on route changes (the
// reference's longest-match auto-scroll). Session persistence is intentionally
// omitted.

import 'package:flutter/widgets.dart';

import '../generated/docs_data.dart';
import '../motion/ease.dart';
import '../motion/motion_scope.dart';
import '../routing/docs_nav.dart';
import '../routing/docs_router.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/primitives/clickable.dart';
import '../ui/shadcn/theme/color_tokens.dart';
import '../ui/shadcn/theme/theme.dart';
import 'docs_tokens.dart';
import 'scroll_fade.dart';

/// The documentation sidebar.
class DocsSidebar extends StatefulWidget {
  /// Creates the sidebar.
  const DocsSidebar({super.key, required this.activeLocation});

  /// The canonical location of the current page (exact-match active state).
  final String activeLocation;

  @override
  State<DocsSidebar> createState() => _DocsSidebarState();
}

class _DocsSidebarState extends State<DocsSidebar> {
  final ScrollController _scroll = ScrollController();
  GlobalKey? _activeKey;
  String? _activeKeyLocation;

  @override
  void initState() {
    super.initState();
    _scheduleCentre();
  }

  @override
  void didUpdateWidget(covariant DocsSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activeLocation != widget.activeLocation) {
      _scheduleCentre();
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _scheduleCentre() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? context = _activeKey?.currentContext;
      if (!mounted || context == null) {
        return;
      }
      // `ensureVisible` handles both the sidebar's own scroll area and any
      // outer viewport without manual offset math.
      final Duration duration = context.motionDuration(kDurationFast);
      Scrollable.ensureVisible(
        context,
        alignment: 0.5,
        duration: duration,
        curve: kEaseStandard,
      );
    });
  }

  GlobalKey? _keyFor(String location) {
    if (location != widget.activeLocation) {
      return null;
    }
    if (_activeKeyLocation != location) {
      _activeKeyLocation = location;
      _activeKey = GlobalKey(debugLabel: 'sidebar-$location');
    }
    return _activeKey;
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    // Spec §2.2: the sidebar sticks at `header + 0.6rem` (10 px) and the
    // first group starts `pt-12` (48 px) below that; the scroll area sits at
    // `pl-2.5` + the container gutter's 8 px, so rows start at x = 26.
    return SizedBox(
      width: DocsMetrics.sidebarWidth,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: SizedBox(
                width: DocsMetrics.sidebarMenuWidth,
                child: ScrollConfiguration(
                  behavior: const DocsScrollBehavior(),
                  child: ScrollFade(
                    fadeTop: false,
                    fadeBottom: true,
                    child: SingleChildScrollView(
                      controller: _scroll,
                      padding: const EdgeInsets.only(top: 48, bottom: 24),
                      // Rows hug their label (reference: the active pill is
                      // content-wide, not the full 224 px menu width).
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const _GroupLabel('Sections'),
                          for (final DocsNavLink link in kDocsSections)
                            _SidebarItem(
                              label: link.label,
                              location: link.location,
                              active: link.isActiveFor(widget.activeLocation),
                              itemKey: _keyFor(link.location),
                              spacing: 4,
                            ),
                          const Gap(24),
                          const _GroupLabel('Components'),
                          for (final DocsComponentLink link in kComponentLinks)
                            _SidebarItem(
                              label: link.name,
                              location: '/docs/components/${link.id}',
                              active: _isComponentActive(link),
                              itemKey: _keyFor('/docs/components/${link.id}'),
                              spacing: 2,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 48,
              right: 8,
              bottom: 0,
              width: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      theme.colors.border.withValues(alpha: 0),
                      theme.colors.border,
                      theme.colors.border,
                      theme.colors.border.withValues(alpha: 0),
                    ],
                    stops: const <double>[0, 0.1, 0.9, 1],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isComponentActive(DocsComponentLink link) {
    return widget.activeLocation == '/docs/components/${link.id}';
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
      child: SizedBox(
        height: 32,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: docsText(
              context,
              size: 12,
              weight: FontWeight.w500,
              height: 16 / 12,
              color: theme.colors.mutedForeground,
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.label,
    required this.location,
    required this.active,
    required this.spacing,
    this.itemKey,
  });

  final String label;
  final String location;
  final bool active;
  final double spacing;
  final Key? itemKey;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final ShadcnColors colors = theme.colors;
    final BorderRadius radius = theme.borderRadiusMd;
    return Padding(
      padding: EdgeInsets.only(bottom: spacing),
      child: Clickable(
        key: itemKey,
        onPressed: () => DocsRouterScope.of(context).go(context, location),
        decoration: WidgetStateProperty.resolveWith<Decoration?>((
          Set<WidgetState> states,
        ) {
          if (active) {
            return BoxDecoration(
              color: colors.accent,
              border: Border.all(color: colors.accent),
              borderRadius: radius,
            );
          }
          if (states.contains(WidgetState.hovered)) {
            return BoxDecoration(
              color: colors.sidebarAccent,
              borderRadius: radius,
            );
          }
          return const BoxDecoration();
        }),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        ),
        textStyle: WidgetStateProperty.resolveWith<TextStyle?>((
          Set<WidgetState> states,
        ) {
          final bool hovered = states.contains(WidgetState.hovered);
          return docsText(
            context,
            size: 12.8,
            weight: FontWeight.w500,
            height: 18.29 / 12.8,
            color: active
                ? colors.accentForeground
                : (hovered
                      ? colors.sidebarAccentForeground
                      : colors.sidebarForeground),
          );
        }),
        child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
