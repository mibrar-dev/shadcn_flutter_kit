// The docs article layout (spec §2.3): title row (h1 + Copy Page + icon
// prev/next), 640 px prose column, bottom pager, and the sticky TOC column on
// `xl`. Headings register themselves through [DocsArticleScope]; the TOC and
// the scroll spy read the same controller.

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../motion/ease.dart';
import '../motion/motion_scope.dart';
import '../routing/docs_nav.dart';
import '../routing/docs_router.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/tooltip/tooltip.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/theme/theme.dart';
import 'copy_button.dart';
import 'docs_toc.dart';
import 'docs_tokens.dart';

/// One registered heading, in document order.
class DocsHeadingEntry {
  /// Creates a heading entry.
  const DocsHeadingEntry({
    required this.id,
    required this.title,
    required this.level,
    required this.key,
  });

  /// Anchor id (`open-code`).
  final String id;

  /// Visible title.
  final String title;

  /// `2` or `3` (TOC indentation).
  final int level;

  /// The key of the rendered heading (scroll spy + scroll-to).
  final GlobalKey key;
}

/// Shared state of one rendered article: heading registry, scroll controller
/// and the active heading id.
class DocsArticleController extends ChangeNotifier {
  /// Creates the controller.
  DocsArticleController();

  /// The article's scroll controller.
  final ScrollController scroll = ScrollController();

  final List<DocsHeadingEntry> _headings = <DocsHeadingEntry>[];
  String? _activeId;

  /// Registered headings in document order.
  List<DocsHeadingEntry> get headings =>
      List<DocsHeadingEntry>.unmodifiable(_headings);

  /// The heading currently considered active by the scroll spy.
  String? get activeId => _activeId;

  /// Called by `HeadingAnchor` during build.
  void register(DocsHeadingEntry entry) {
    if (_headings.any((DocsHeadingEntry h) => h.id == entry.id)) {
      return;
    }
    _headings.add(entry);
    // Registration happens during build; notify after the frame instead.
    SchedulerBinding.instance.addPostFrameCallback((_) => notifyListeners());
  }

  /// Removes a heading (route change / rebuild).
  void unregister(String id) {
    final int before = _headings.length;
    _headings.removeWhere((DocsHeadingEntry h) => h.id == id);
    if (_headings.length != before) {
      SchedulerBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }

  /// Updates the active heading; notifies only on change.
  void setActive(String? id) {
    if (id == _activeId) {
      return;
    }
    _activeId = id;
    notifyListeners();
  }

  @override
  void dispose() {
    scroll.dispose();
    super.dispose();
  }
}

/// Exposes the article controller to headings and the TOC.
class DocsArticleScope extends InheritedNotifier<DocsArticleController> {
  /// Creates the scope.
  const DocsArticleScope({
    super.key,
    required DocsArticleController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Nearest controller, without creating a dependency.
  static DocsArticleController? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<DocsArticleScope>()?.notifier;
  }
}

/// One docs article: title block, prose column, bottom pager and TOC.
class DocsArticle extends StatefulWidget {
  /// Creates an article.
  const DocsArticle({
    super.key,
    required this.title,
    this.description = '',
    this.children = const <Widget>[],
    this.previous,
    this.next,
    this.titleActions = const <Widget>[],
    this.showTitleActions = true,
  });

  /// Page title (measured 30/36, semibold).
  final String title;

  /// Muted description under the title.
  final String description;

  /// Prose content.
  final List<Widget> children;

  /// Previous page for the icon buttons + bottom pager.
  final DocsNavLink? previous;

  /// Next page for the icon buttons + bottom pager.
  final DocsNavLink? next;

  /// Extra title-row actions (D4's badges, etc.).
  final List<Widget> titleActions;

  /// Whether Copy Page / prev / next render in the title row.
  final bool showTitleActions;

  @override
  State<DocsArticle> createState() => _DocsArticleState();
}

class _DocsArticleState extends State<DocsArticle> {
  final DocsArticleController _controller = DocsArticleController();
  final GlobalKey _articleKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller.scroll.addListener(_updateActive);
    SchedulerBinding.instance.addPostFrameCallback((_) => _updateActive());
  }

  @override
  void dispose() {
    _controller.scroll.removeListener(_updateActive);
    _controller.dispose();
    super.dispose();
  }

  void _updateActive() {
    final RenderBox? box =
        _articleKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) {
      return;
    }
    // A heading becomes active once it crosses the top 20 % of the viewport
    // (spec §2.2 `rootMargin: 0% 0% -80% 0%`).
    final double threshold = box.size.height * 0.2;
    String? active;
    for (final DocsHeadingEntry entry in _controller.headings) {
      final RenderObject? object = entry.key.currentContext?.findRenderObject();
      if (object is! RenderBox || !object.attached) {
        continue;
      }
      final double dy = object.localToGlobal(Offset.zero, ancestor: box).dy;
      if (dy <= threshold) {
        active = entry.id;
      }
    }
    _controller.setActive(
      active ??
          (_controller.headings.isEmpty ? null : _controller.headings.first.id),
    );
  }

  void _scrollTo(String id) {
    final GlobalKey? key = _controller.headings
        .where((DocsHeadingEntry h) => h.id == id)
        .map((DocsHeadingEntry h) => h.key)
        .firstOrNull;
    final RenderBox? box =
        _articleKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderObject? object = key?.currentContext?.findRenderObject();
    if (box == null || object is! RenderBox || !_controller.scroll.hasClients) {
      return;
    }
    final double dy =
        object.localToGlobal(Offset.zero, ancestor: box).dy +
        _controller.scroll.offset;
    final double max = _controller.scroll.position.maxScrollExtent;
    final Duration duration = context.motionDuration(
      const Duration(milliseconds: 250),
    );
    _controller.scroll.animateTo(
      (dy - 12).clamp(0, max).toDouble(),
      duration: duration,
      curve: kEaseStandard,
    );
  }

  String get _copyText {
    final DocsRouterDelegate? delegate = DocsRouterScope.maybeOf(context);
    final String location = delegate?.currentConfiguration.location ?? '/docs';
    return '${widget.title}\n\n${widget.description}\n\n$location';
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final double width = MediaQuery.sizeOf(context).width;
    final bool showToc = width >= 1280;
    final bool showActions = widget.showTitleActions && width >= 640;
    return Row(
      key: _articleKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ScrollConfiguration(
            behavior: const DocsScrollBehavior(),
            child: SingleChildScrollView(
              controller: _controller.scroll,
              padding: const EdgeInsets.only(top: 16, bottom: 48),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: DocsMetrics.articleWidth,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width >= 768 ? 0 : 16,
                      vertical: width >= 1024 ? 32 : 24,
                    ),
                    child: DocsArticleScope(
                      controller: _controller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _titleRow(context, theme, showActions),
                          if (widget.description.isNotEmpty) ...<Widget>[
                            const Gap(8),
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: DocsMetrics.articleWidth * 0.8,
                              ),
                              child: Text(
                                widget.description,
                                style: docsText(
                                  context,
                                  size: 16,
                                  height: 1.5,
                                  color: theme.colors.mutedForeground,
                                ),
                              ),
                            ),
                          ],
                          const Gap(24),
                          ...widget.children,
                          if (width >= 640 &&
                              (widget.previous != null || widget.next != null))
                            _pager(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showToc)
          FocusTraversalOrder(
            order: DocsFocusOrder.toc,
            child: DocsToc(controller: _controller, onSelect: _scrollTo),
          ),
      ],
    );
  }

  Widget _titleRow(
    BuildContext context,
    ShadcnThemeData theme,
    bool showActions,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Text(
            widget.title,
            style: docsText(
              context,
              size: 30,
              weight: FontWeight.w600,
              height: 36 / 30,
              letterSpacing: -0.75,
            ),
          ),
        ),
        if (showActions)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ...widget.titleActions,
              CopyButton(
                text: _copyText,
                label: 'Copy Page',
                showLabel: true,
                variant: ButtonVariant.secondary,
                size: ButtonSize.xs,
              ),
              const Gap(8),
              if (widget.previous != null)
                _iconNavButton(
                  context,
                  icon: LucideIcons.chevronLeft,
                  tooltip: 'Previous',
                  link: widget.previous!,
                ),
              if (widget.previous != null && widget.next != null) const Gap(4),
              if (widget.next != null)
                _iconNavButton(
                  context,
                  icon: LucideIcons.chevronRight,
                  tooltip: 'Next',
                  link: widget.next!,
                ),
            ],
          ),
      ],
    );
  }

  Widget _iconNavButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required DocsNavLink link,
  }) {
    return Tooltip(
      tooltip: (BuildContext context) => Text(tooltip),
      child: SizedBox(
        width: 28,
        height: 28,
        child: Button(
          variant: ButtonVariant.secondary,
          size: ButtonSize.xs,
          theme: const ButtonVariantStyle(padding: EdgeInsets.zero),
          onPressed: () =>
              DocsRouterScope.of(context).go(context, link.location),
          child: Icon(icon, size: 16),
        ),
      ),
    );
  }

  Widget _pager(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: SizedBox(
        height: 64,
        child: Row(
          children: <Widget>[
            if (widget.previous != null)
              Button(
                variant: ButtonVariant.secondary,
                size: ButtonSize.sm,
                onPressed: () => DocsRouterScope.of(
                  context,
                ).go(context, widget.previous!.location),
                leading: const Icon(LucideIcons.arrowLeft, size: 16),
                child: Text(widget.previous!.label),
              ),
            const Spacer(),
            if (widget.next != null)
              Button(
                variant: ButtonVariant.secondary,
                size: ButtonSize.sm,
                onPressed: () => DocsRouterScope.of(
                  context,
                ).go(context, widget.next!.location),
                trailing: const Icon(LucideIcons.arrowRight, size: 16),
                child: Text(widget.next!.label),
              ),
          ],
        ),
      ),
    );
  }
}
