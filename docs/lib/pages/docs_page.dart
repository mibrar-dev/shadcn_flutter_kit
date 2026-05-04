import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../theme/docs_theme.dart';
import '../theme/theme_controller.dart';
import '../ui/shadcn/components/control/button/button.dart' as shadcn_buttons;
import '../ui/shadcn/components/control/command/command.dart';
import '../ui/shadcn/components/display/badge/badge.dart';
import '../ui/shadcn/components/display/icon/icon.dart';
import '../ui/shadcn/components/layout/basic/basic.dart' as shadcn_basic;
import '../ui/shadcn/components/layout/fade_scroll/fade_scroll.dart';
import '../ui/shadcn/components/layout/scaffold/scaffold.dart'
    as shadcn_scaffold;
import '../ui/shadcn/components/layout/media_query/media_query.dart';
import '../ui/shadcn/components/layout/stage_container/stage_container.dart';
import '../ui/shadcn/components/navigation/breadcrumb/breadcrumb.dart';
import '../ui/shadcn/components/overlay/drawer/drawer.dart';
import '../ui/shadcn/shared/icons/lucide_icons.dart';
import '../ui/shadcn/shared/primitives/text.dart';
import '../ui/shadcn/shared/theme/theme.dart' as shadcn_theme;
import '../ui/shadcn/shared/utils/util.dart';
import 'docs/component_previews.dart';
import 'docs/component_examples.dart';
import 'docs/cli_reference_data.dart';
import 'docs/components_registry.dart';

const double breakpointWidth = 768;
const double breakpointWidth2 = 1024;

class OnThisPage extends LabeledGlobalKey {
  final ValueNotifier<double> visibleFraction = ValueNotifier(0);

  OnThisPage([super.debugLabel]);
}

class PageItemWidget extends StatelessWidget {
  final OnThisPage onThisPage;
  final Widget child;

  const PageItemWidget({
    super.key,
    required this.onThisPage,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: onThisPage,
      child: child,
      onVisibilityChanged: (info) {
        onThisPage.visibleFraction.value = info.visibleFraction;
      },
    );
  }
}

class DocsPage extends StatefulWidget {
  final String name;
  final Widget child;
  final Widget? sidebar;
  final Map<String, OnThisPage> onThisPage;
  final List<Widget> navigationItems;
  final bool scrollable;
  final DocsSidebarMode sidebarMode;

  const DocsPage({
    super.key,
    required this.name,
    required this.child,
    this.sidebar,
    this.onThisPage = const {},
    this.navigationItems = const [],
    this.scrollable = true,
    this.sidebarMode = DocsSidebarMode.main,
  });

  @override
  State<DocsPage> createState() => DocsPageState();
}

enum DocsSidebarMode {
  main,
  cli,
}

enum DocsTag {
  experimental,
  workInProgress,
  updated,
  newFeature,
  ;

  Widget badge(BuildContext context) {
    final badge = switch (this) {
      DocsTag.experimental => const PrimaryBadge(child: Text('Experimental')),
      DocsTag.workInProgress => const PrimaryBadge(child: Text('WIP')),
      DocsTag.updated => const PrimaryBadge(child: Text('Updated')),
      DocsTag.newFeature => const PrimaryBadge(child: Text('New')),
    };
    return IgnorePointer(child: ExcludeSemantics(child: badge));
  }
}

class _OpenSearchIntent extends Intent {
  const _OpenSearchIntent();
}

class DocsPageRef {
  final String title;
  final String name;
  final String routeName;
  final Map<String, String> pathParameters;
  final DocsTag? tag;

  DocsPageRef(
    this.title,
    this.name, {
    String? routeName,
    Map<String, String>? pathParameters,
    this.tag,
  })  : routeName = routeName ?? name,
        pathParameters = pathParameters ?? const {};
}

class DocsSection {
  final String title;
  final IconData icon;
  final List<DocsPageRef> pages;

  DocsSection(this.title, this.pages, {this.icon = Icons.book});
}

class DocsPageState extends State<DocsPage> {
  static final List<DocsSection> mainBaseSections = [
    DocsSection(
      'Getting Started',
      [
        DocsPageRef('Introduction', 'introduction'),
        DocsPageRef('Installation', 'installation'),
        DocsPageRef('App Setup', 'app-setup'),
        DocsPageRef('Registry Guide', 'registry-guide'),
        DocsPageRef('Theme', 'theme'),
        DocsPageRef('Typography', 'typography'),
        DocsPageRef('Layout', 'layout'),
        DocsPageRef('Web Preloader', 'web_preloader'),
        DocsPageRef('Components', 'components'),
        DocsPageRef('Icons', 'icons'),
        DocsPageRef('Colors', 'colors'),
        DocsPageRef('Material/Cupertino', 'material'),
        DocsPageRef('State Management', 'state'),
        DocsPageRef(
          'CLI',
          'cli-overview',
          routeName: 'cli_reference',
          pathParameters: {'id': 'cli-overview'},
        ),
      ],
    ),
  ];

  static final List<DocsSection> cliBaseSections = [
    for (final section in cliReferenceSections)
      DocsSection(
        section.title,
        [
          for (final pageId in section.pageIds)
            DocsPageRef(
              cliReferenceDocs[pageId]!.title,
              pageId,
              routeName: 'cli_reference',
              pathParameters: {'id': pageId},
            ),
        ],
        icon: Icons.terminal,
      ),
  ];

  final ScrollController scrollController = ScrollController();
  final ScrollController _sidebarScrollController = ScrollController();
  final ScrollController _drawerSidebarScrollController = ScrollController();
  final ScrollController _onThisPageScrollController = ScrollController();
  final FocusNode _shortcutFocusNode = FocusNode(
    debugLabel: 'docs-page-shortcuts',
  );
  OnThisPage? _activeOnThisPage;
  bool _isSheetOpen = false;
  late List<DocsSection> _sections;
  static const Map<String, String> _categoryOverrides = {
    'app': 'application',
    'go_router_app_example': 'application',
    'wrapper': 'application',
    'refresh_trigger': 'utility',
  };

  @override
  void initState() {
    super.initState();
    _sections = List.of(_baseSectionsForMode(widget.sidebarMode));
    for (final child in widget.onThisPage.values) {
      child.visibleFraction.addListener(_onVisibilityChanged);
    }
    scrollController.addListener(_onScrollChanged);
    if (widget.sidebarMode == DocsSidebarMode.main) {
      _loadComponentSections();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _updateActiveOnThisPage(force: true);
      if (!_shortcutFocusNode.hasFocus) {
        _shortcutFocusNode.requestFocus();
      }
    });
  }

  @override
  void didUpdateWidget(covariant DocsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!mapEquals(oldWidget.onThisPage, widget.onThisPage)) {
      for (final child in oldWidget.onThisPage.values) {
        child.visibleFraction.removeListener(_onVisibilityChanged);
      }
      for (final child in widget.onThisPage.values) {
        child.visibleFraction.addListener(_onVisibilityChanged);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _updateActiveOnThisPage(force: true);
      });
    }
    if (oldWidget.sidebarMode != widget.sidebarMode) {
      _sections = List.of(_baseSectionsForMode(widget.sidebarMode));
      if (widget.sidebarMode == DocsSidebarMode.main) {
        _loadComponentSections();
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _updateActiveOnThisPage(force: true);
        });
      }
    }
  }

  @override
  void dispose() {
    for (final child in widget.onThisPage.values) {
      child.visibleFraction.removeListener(_onVisibilityChanged);
    }
    scrollController.removeListener(_onScrollChanged);
    scrollController.dispose();
    _sidebarScrollController.dispose();
    _drawerSidebarScrollController.dispose();
    _onThisPageScrollController.dispose();
    _shortcutFocusNode.dispose();
    super.dispose();
  }

  void _onScrollChanged() {
    if (widget.onThisPage.isEmpty) {
      return;
    }
    _updateActiveOnThisPage();
  }

  void _onVisibilityChanged() {
    _updateActiveOnThisPage();
  }

  void _updateActiveOnThisPage({bool force = false}) {
    if (!mounted) return;
    final next = _resolveActiveOnThisPage();
    if (!force && next == _activeOnThisPage) {
      return;
    }
    setState(() => _activeOnThisPage = next);
  }

  bool isVisible(OnThisPage onThisPage) {
    return _activeOnThisPage == onThisPage;
  }

  OnThisPage? _resolveActiveOnThisPage() {
    if (widget.onThisPage.isEmpty) {
      return null;
    }
    final visible = widget.onThisPage.values
        .where((key) => key.visibleFraction.value > 0)
        .toList(growable: false);
    if (visible.isEmpty) {
      return null;
    }

    final anchorY =
        MediaQuery.of(context).padding.top + (112 * context.docsTheme.scaling);
    OnThisPage? best;
    double bestScore = double.infinity;
    for (final key in visible) {
      final renderObject = key.currentContext?.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.attached) {
        continue;
      }
      final top = renderObject.localToGlobal(Offset.zero).dy;
      final score = top >= anchorY
          ? (top - anchorY)
          : (anchorY - top) + 10000; // prefer first item at/after anchor
      if (score < bestScore) {
        bestScore = score;
        best = key;
      }
    }
    return best ?? visible.first;
  }

  List<DocsSection> _baseSectionsForMode(DocsSidebarMode mode) {
    return switch (mode) {
      DocsSidebarMode.main => mainBaseSections,
      DocsSidebarMode.cli => cliBaseSections,
    };
  }

  void showSearchDialog() {
    showCommandDialog(
      context: context,
      builder: (context, query) {
        final search = query?.trim().toLowerCase() ?? '';
        final filteredSections = <DocsSection>[];
        for (final section in _sections) {
          final pages = section.pages.where((page) {
            if (search.isEmpty) return true;
            return page.title.toLowerCase().contains(search) ||
                page.name.toLowerCase().contains(search) ||
                section.title.toLowerCase().contains(search);
          }).toList();
          if (pages.isEmpty) continue;
          filteredSections.add(
            DocsSection(
              section.title,
              pages,
              icon: section.icon,
            ),
          );
        }
        return Stream.value([
          ListView(
            shrinkWrap: true,
            children: [
              for (final section in filteredSections)
                CommandCategory(
                  title: Text(section.title),
                  children: [
                    for (final page in section.pages)
                      CommandItem(
                        title: Text(page.title),
                        trailing: Icon(section.icon),
                        onTap: () => context.goNamed(
                          page.routeName,
                          pathParameters: page.pathParameters,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ]);
      },
    );
  }

  Future<void> _loadComponentSections() async {
    final components = (await loadRegistryComponents())
        .where((component) => originalComponentIds.contains(component.id))
        .toList();
    if (!mounted) {
      return;
    }

    final grouped = <String, List<RegistryComponent>>{};
    final wipComponents = <RegistryComponent>[];
    for (final component in components) {
      if (_tagForComponent(component.id) == DocsTag.workInProgress) {
        wipComponents.add(component);
        continue;
      }
      final category = _resolvedCategoryForComponent(component);
      grouped.putIfAbsent(category, () => []);
      grouped[category]!.add(component);
    }

    const categoryOrder = [
      'application',
      'animation',
      'control',
      'disclosure',
      'display',
      'feedback',
      'form',
      'layout',
      'navigation',
      'overlay',
      'utility',
      'data',
    ];

    final categoryKeys = [
      ...categoryOrder.where(grouped.containsKey),
      ...grouped.keys.where((key) => !categoryOrder.contains(key)).toList()
        ..sort(),
    ];

    final componentSections = [
      for (final category in categoryKeys)
        DocsSection(
          _titleCase(category),
          grouped[category]!
              .map((component) => DocsPageRef(
                    _displayComponentTitle(component.name),
                    component.id,
                    routeName: 'component_detail',
                    pathParameters: {'id': _toKebabCase(component.id)},
                    tag: _tagForComponent(component.id),
                  ))
              .toList(),
          icon: iconForCategory(category),
        ),
      if (wipComponents.isNotEmpty)
        DocsSection(
          'WIP Components',
          (wipComponents..sort((a, b) => a.name.compareTo(b.name)))
              .map((component) => DocsPageRef(
                    _displayComponentTitle(component.name),
                    component.id,
                    routeName: 'component_detail',
                    pathParameters: {'id': _toKebabCase(component.id)},
                    tag: DocsTag.workInProgress,
                  ))
              .toList(),
          icon: Icons.construction,
        ),
    ];

    setState(() {
      _sections = [
        ..._baseSectionsForMode(widget.sidebarMode),
        ...componentSections,
      ];
    });
  }

  String _resolvedCategoryForComponent(RegistryComponent component) {
    final override = _categoryOverrides[component.id];
    if (override != null) {
      return override;
    }
    return component.category.toLowerCase().trim();
  }

  String _displayComponentTitle(String title) {
    return title.replaceAll(RegExp(r'\s*\((Composed|WIP)\)\s*$'), '').trim();
  }

  List<DocsSection> get _sidebarSections {
    if (widget.sidebarMode == DocsSidebarMode.cli) {
      return _sections.toList(growable: false);
    }
    return _sections
        .where((section) => section.title.toLowerCase() != 'application')
        .toList(growable: false);
  }

  DocsTag? _tagForComponent(String componentId) {
    final status = componentStatusTags[componentId];
    switch (status) {
      case 'Experimental':
        return DocsTag.experimental;
      case 'WIP':
        return DocsTag.workInProgress;
      case 'New':
        return DocsTag.newFeature;
      case 'Updated':
        return DocsTag.updated;
    }
    return null;
  }

  String _titleCase(String value) {
    if (value.isEmpty) {
      return value;
    }
    return value[0].toUpperCase() + value.substring(1);
  }

  Widget _buildHeader(BuildContext context, {required double contentHeight}) {
    final scaling = context.docsTheme.scaling;
    final theme = shadcn_theme.Theme.of(context);
    final spacing = theme.spacing;
    final width = MediaQuery.of(context).size.width;
    final isCliMode = widget.sidebarMode == DocsSidebarMode.cli;
    final showSearchBar = width >= breakpointWidth2;
    final showDrawer = width < breakpointWidth;
    final horizontalPadding = width >= breakpointWidth2 ? 32.0 : 18.0;
    final backLabel =
        width >= breakpointWidth2 ? 'shadcn_registry_docs' : 'docs';
    final shellSurface = Color.lerp(
          theme.colorScheme.background,
          theme.colorScheme.card,
          theme.brightness == Brightness.dark ? 0.72 : 0.48,
        ) ??
        theme.colorScheme.card;
    return shadcn_scaffold.AppBar(
      leading: const [],
      trailing: const [],
      height: contentHeight,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding * scaling,
        vertical: 12 * scaling,
      ),
      backgroundColor: shellSurface.withValues(
        alpha: theme.brightness == Brightness.dark ? 0.94 : 0.9,
      ),
      surfaceOpacity: theme.surfaceOpacity,
      surfaceBlur: theme.surfaceBlur,
      child: Row(
        children: [
          if (showDrawer)
            shadcn_buttons.GhostButton(
              onPressed: _openDrawer,
              density: shadcn_buttons.ButtonDensity.icon,
              child: const Icon(Icons.menu),
            ),
          if (isCliMode)
            shadcn_buttons.TextButton(
              onPressed: () => context.goNamed('introduction'),
              leading: const Icon(LucideIcons.chevronLeft).iconSmall(),
              child: Text(backLabel).small().semiBold(),
            )
          else
            Text(
              'shadcn_flutter_registry',
              style: TextStyle(color: theme.colorScheme.foreground),
            ).semiBold(),
          if (showSearchBar) ...[
            const Spacer(),
            Expanded(
              flex: 3,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: shadcn_buttons.OutlineButton(
                    onPressed: showSearchDialog,
                    child: Row(
                      children: [
                        const Icon(Icons.search)
                            .iconSmall()
                            .iconMutedForeground(),
                        SizedBox(width: spacing.xs * scaling),
                        Expanded(
                          child: const Text(
                            'Search documentation...',
                            overflow: TextOverflow.ellipsis,
                          ).muted(),
                        ),
                        SizedBox(width: spacing.xs * scaling),
                        const Text('Cmd+F / Ctrl+F').xSmall().muted(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
          ] else
            const Spacer(),
          if (!showSearchBar)
            shadcn_buttons.GhostButton(
              onPressed: showSearchDialog,
              density: shadcn_buttons.ButtonDensity.icon,
              child: const Icon(Icons.search),
            ),
          shadcn_buttons.GhostButton(
            onPressed: () => launchUrlString(
              'https://github.com/ibrar-x/shadcn_flutter_kit',
            ),
            density: shadcn_buttons.ButtonDensity.icon,
            child: const Icon(LucideIcons.github),
          ),
          _buildThemeToggle(context),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    final controller = context.docsThemeController;
    final isDark = controller.brightness == Brightness.dark;
    return shadcn_buttons.ButtonGroup(
      children: [
        isDark
            ? shadcn_buttons.IconButton.ghost(
                onPressed: () => controller.setBrightness(Brightness.light),
                size: shadcn_buttons.ButtonSize.small,
                density: shadcn_buttons.ButtonDensity.iconDense,
                icon: const Icon(
                  Icons.light_mode,
                  semanticLabel: 'Switch to light theme',
                ),
              )
            : shadcn_buttons.IconButton.secondary(
                onPressed: () => controller.setBrightness(Brightness.light),
                size: shadcn_buttons.ButtonSize.small,
                density: shadcn_buttons.ButtonDensity.iconDense,
                icon: const Icon(
                  Icons.light_mode,
                  semanticLabel: 'Switch to light theme',
                ),
              ),
        isDark
            ? shadcn_buttons.IconButton.secondary(
                onPressed: () => controller.setBrightness(Brightness.dark),
                size: shadcn_buttons.ButtonSize.small,
                density: shadcn_buttons.ButtonDensity.iconDense,
                icon: const Icon(
                  Icons.dark_mode,
                  semanticLabel: 'Switch to dark theme',
                ),
              )
            : shadcn_buttons.IconButton.ghost(
                onPressed: () => controller.setBrightness(Brightness.dark),
                size: shadcn_buttons.ButtonSize.small,
                density: shadcn_buttons.ButtonDensity.iconDense,
                icon: const Icon(
                  Icons.dark_mode,
                  semanticLabel: 'Switch to dark theme',
                ),
              ),
      ],
    );
  }

  void _openDrawer() {
    if (_isSheetOpen) {
      return;
    }
    setState(() {
      _isSheetOpen = true;
    });
    final mediaWidth = MediaQuery.of(context).size.width;
    final targetWidth = mediaWidth * 0.6;
    final routerContext = context;
    openSheet(
      context: context,
      position: OverlayPosition.left,
      constraints: BoxConstraints.tightFor(width: targetWidth),
      builder: (context) {
        final theme = shadcn_theme.Theme.of(context);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
                    left: 32, right: 32, bottom: 48, top: 48) *
                theme.scaling,
            child: SizedBox(
              width: targetWidth,
              child: FadeScroll(
                controller: _drawerSidebarScrollController,
                startOffset: 20,
                endOffset: 20,
                gradient: [
                  Colors.transparent,
                  theme.colorScheme.background,
                ],
                child: SingleChildScrollView(
                  controller: _drawerSidebarScrollController,
                  child: SidebarNav(
                    children: [
                      for (final section in _sidebarSections)
                        SidebarSection(
                          header: Text(section.title),
                          children: [
                            for (final page in section.pages)
                              DocsNavigationButton(
                                onPressed: () {
                                  closeSheet(context);
                                  routerContext.goNamed(
                                    page.routeName,
                                    pathParameters: page.pathParameters,
                                  );
                                },
                                selected: page.name == widget.name,
                                child: shadcn_basic.Basic(
                                  content: Text(page.title),
                                  trailing: page.tag?.badge(context),
                                  trailingAlignment:
                                      AlignmentDirectional.centerStart,
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      if (mounted) {
        setState(() {
          _isSheetOpen = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasOnThisPage = widget.onThisPage.isNotEmpty;
    final isThemePage = widget.name == 'theme';
    final currentPage = _sections
        .expand((section) => section.pages)
        .where((page) => page.name == widget.name)
        .firstOrNull;
    final width = MediaQuery.of(context).size.width;
    if (_isSheetOpen && width >= breakpointWidth) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          closeSheet(context);
        }
      });
    }

    return StageContainer(
      breakpoint: isThemePage
          ? StageBreakpoint.constant(
              1,
              minSize: 0,
              maxSize: double.infinity,
            )
          : StageBreakpoint.defaultBreakpoints,
      padding: isThemePage ? const EdgeInsets.symmetric(horizontal: 16) : null,
      builder: (context, padding) {
        final theme = shadcn_theme.Theme.of(context);
        final headerContentHeight = 36 * theme.scaling;
        return Shortcuts(
          shortcuts: {
            LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyF):
                const _OpenSearchIntent(),
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF):
                const _OpenSearchIntent(),
            LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyK):
                const _OpenSearchIntent(),
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyK):
                const _OpenSearchIntent(),
            LogicalKeySet(LogicalKeyboardKey.slash): const _OpenSearchIntent(),
          },
          child: Actions(
            actions: {
              _OpenSearchIntent: CallbackAction<_OpenSearchIntent>(
                onInvoke: (_) {
                  showSearchDialog();
                  return null;
                },
              ),
            },
            child: Focus(
              focusNode: _shortcutFocusNode,
              child: shadcn_scaffold.Scaffold(
                headers: [
                  _buildHeader(
                    context,
                    contentHeight: headerContentHeight,
                  ),
                  const Divider(height: 1),
                ],
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MediaQueryVisibility(
                      minWidth: breakpointWidth,
                      child: FocusTraversalGroup(
                        child: FadeScroll(
                          controller: _sidebarScrollController,
                          startOffset: 20,
                          endOffset: 20,
                          gradient: [
                            Colors.transparent,
                            theme.colorScheme.background,
                          ],
                          child: SingleChildScrollView(
                            controller: _sidebarScrollController,
                            key: const PageStorageKey('sidebar'),
                            padding: EdgeInsets.only(
                                  top: 32,
                                  left: (isThemePage ? 12 : 24) + padding.left,
                                  bottom: 32,
                                ) *
                                theme.scaling,
                            child: SidebarNav(
                              children: [
                                for (final section in _sidebarSections)
                                  SidebarSection(
                                    header: Text(section.title),
                                    children: [
                                      for (final page in section.pages)
                                        DocsNavigationButton(
                                          onPressed: () => context.goNamed(
                                            page.routeName,
                                            pathParameters: page.pathParameters,
                                          ),
                                          selected: page.name == widget.name,
                                          child: shadcn_basic.Basic(
                                            content: Text(page.title),
                                            trailing: page.tag?.badge(context),
                                            trailingAlignment:
                                                AlignmentDirectional
                                                    .centerStart,
                                          ),
                                        ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: widget.scrollable
                          ? SingleChildScrollView(
                              controller: scrollController,
                              clipBehavior: Clip.none,
                              padding: (EdgeInsets.symmetric(
                                        horizontal: isThemePage ? 32 : 40,
                                        vertical: 32,
                                      ).copyWith(
                                        right: (hasOnThisPage ||
                                                widget.sidebar != null)
                                            ? (isThemePage ? 16 : 24)
                                            : padding.right + 32,
                                      ) *
                                      theme.scaling) +
                                  MediaQuery.of(context).padding,
                              child: DefaultTextStyle.merge(
                                style: TextStyle(
                                  color: theme.colorScheme.foreground,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Breadcrumb(
                                      separator: Breadcrumb.arrowSeparator,
                                      children: [
                                        shadcn_buttons.LinkButton(
                                          density: shadcn_buttons
                                              .ButtonDensity.compact,
                                          onPressed: () {
                                            if (widget.sidebarMode ==
                                                DocsSidebarMode.cli) {
                                              context.goNamed(
                                                'cli_reference',
                                                pathParameters: const {
                                                  'id': 'cli-overview'
                                                },
                                              );
                                              return;
                                            }
                                            context.goNamed('introduction');
                                          },
                                          child: Text(
                                            widget.sidebarMode ==
                                                    DocsSidebarMode.cli
                                                ? 'CLI'
                                                : 'Docs',
                                          ),
                                        ),
                                        ...widget.navigationItems,
                                        if (currentPage != null)
                                          Text(currentPage.title),
                                      ],
                                    ),
                                    SizedBox(
                                      height: theme.spacing.lg,
                                    ),
                                    widget.child,
                                  ],
                                ),
                              ),
                            )
                          : DefaultTextStyle.merge(
                              style: TextStyle(
                                color: theme.colorScheme.foreground,
                              ),
                              child: widget.child,
                            ),
                    ),
                    if (widget.sidebar != null)
                      MediaQueryVisibility(
                        minWidth: breakpointWidth2,
                        child: FocusTraversalGroup(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.only(
                                  top: 32,
                                  right: isThemePage ? 16 : 24,
                                  bottom: 32,
                                  left: 0,
                                ) *
                                theme.scaling,
                            child: DefaultTextStyle.merge(
                              style: TextStyle(
                                color: theme.colorScheme.foreground,
                              ),
                              child: widget.sidebar ?? const SizedBox.shrink(),
                            ),
                          ),
                        ),
                      ),
                    if (hasOnThisPage)
                      MediaQueryVisibility(
                        minWidth: breakpointWidth2,
                        child: SizedBox(
                          width: (padding.right + 180) * theme.scaling,
                          child: FocusTraversalGroup(
                            child: FadeScroll(
                              controller: _onThisPageScrollController,
                              startOffset: 20,
                              endOffset: 20,
                              gradient: [
                                Colors.transparent,
                                theme.colorScheme.background,
                              ],
                              child: SingleChildScrollView(
                                controller: _onThisPageScrollController,
                                padding: EdgeInsets.only(
                                      top: 32,
                                      right: isThemePage ? 16 : 24,
                                      bottom: 32,
                                      left: isThemePage ? 16 : 24,
                                    ) *
                                    theme.scaling,
                                child: SidebarNav(
                                  children: [
                                    SidebarSection(
                                      header: const Text('On This Page'),
                                      children: [
                                        for (final entry
                                            in widget.onThisPage.entries)
                                          SidebarButton(
                                            onPressed: () {
                                              final context =
                                                  entry.value.currentContext;
                                              if (context == null) {
                                                return;
                                              }
                                              Scrollable.ensureVisible(
                                                context,
                                                duration: const Duration(
                                                  milliseconds: 200,
                                                ),
                                              );
                                            },
                                            selected:
                                                entry.value.currentContext !=
                                                        null &&
                                                    isVisible(entry.value),
                                            child: Text(entry.key),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}

class SidebarNav extends StatelessWidget {
  final List<Widget> children;

  const SidebarNav({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final spacedChildren = <Widget>[];
    for (var index = 0; index < children.length; index += 1) {
      if (index > 0) {
        spacedChildren.add(const Gap(16));
      }
      spacedChildren.add(children[index]);
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: spacedChildren,
      ),
    );
  }
}

class SidebarSection extends StatelessWidget {
  final Widget header;
  final List<Widget> children;

  const SidebarSection({
    super.key,
    required this.header,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = shadcn_theme.Theme.of(context);
    final headerColor = theme.brightness == Brightness.dark
        ? theme.colorScheme.mutedForeground.withValues(alpha: 0.92)
        : theme.colorScheme.mutedForeground.withValues(alpha: 0.78);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextStyle.merge(
          style: TextStyle(color: headerColor),
          child: header.base().semiBold(),
        ).withPadding(vertical: 4, horizontal: 10),
        const Gap(8),
        ...children,
      ],
    );
  }
}

class DocsNavigationButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool selected;
  final Widget child;
  final Widget? trailing;

  const DocsNavigationButton({
    super.key,
    required this.onPressed,
    required this.selected,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final data = shadcn_theme.Theme.of(context);
    final selectedText = data.colorScheme.primary;
    final unselectedText = data.brightness == Brightness.dark
        ? data.colorScheme.mutedForeground.withValues(alpha: 0.84)
        : data.colorScheme.mutedForeground.withValues(alpha: 0.7);
    final style = shadcn_buttons.ButtonVariance.link
        .copyWith(
          padding: (context, states, value) =>
              const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          textStyle: (context, states, value) {
            return value.copyWith(
              fontSize: 12.5,
              height: 1.25,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            );
          },
        )
        .withForegroundColor(
          color: selected ? selectedText : unselectedText,
          hoverColor: selected
              ? selectedText.withValues(alpha: 0.9)
              : unselectedText.withValues(alpha: 0.78),
        );
    return shadcn_buttons.Button(
      onPressed: onPressed,
      alignment: AlignmentDirectional.centerStart,
      style: style,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          if (trailing != null) const Gap(8),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class SidebarButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool selected;
  final Widget child;

  const SidebarButton({
    super.key,
    required this.onPressed,
    required this.selected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final data = shadcn_theme.Theme.of(context);
    final selectedText = data.colorScheme.primary;
    final unselectedText = data.brightness == Brightness.dark
        ? data.colorScheme.mutedForeground.withValues(alpha: 0.84)
        : data.colorScheme.mutedForeground.withValues(alpha: 0.7);
    final style = shadcn_buttons.ButtonVariance.link
        .copyWith(
          padding: (context, states, value) =>
              const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          textStyle: (context, states, value) {
            return value.copyWith(
              fontSize: 12.5,
              height: 1.25,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            );
          },
        )
        .withForegroundColor(
          color: selected ? selectedText : unselectedText,
          hoverColor: selected
              ? selectedText.withValues(alpha: 0.9)
              : unselectedText.withValues(alpha: 0.78),
        );
    return shadcn_buttons.Button(
      onPressed: onPressed,
      alignment: AlignmentDirectional.centerStart,
      style: style,
      child: child,
    );
  }
}

String _toKebabCase(String value) {
  return value.replaceAll('_', '-');
}
