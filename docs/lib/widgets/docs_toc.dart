// The "On This Page" table of contents (spec §2.2): 288 px sticky column,
// 12/16 500 muted label, 12.8/18.28 links with no indicator rail, active =
// font-medium + foreground. The scroll spy lives in `DocsArticle`.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/primitives/clickable.dart';
import '../ui/shadcn/theme/theme.dart';
import 'docs_article.dart';
import 'docs_tokens.dart';
import 'scroll_fade.dart';

/// The article TOC column.
class DocsToc extends StatelessWidget {
  /// Creates the TOC.
  const DocsToc({super.key, required this.controller, required this.onSelect});

  /// The article controller (headings + active id).
  final DocsArticleController controller;

  /// Called with the heading id when a link is pressed.
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return SizedBox(
      width: DocsMetrics.tocWidth,
      // Spec §2.2: the column sticks at `header + 1px`, then the
      // `--top-spacing` spacer (16 px ≥lg) and the list's `p-4 pt-0` put the
      // "On This Page" label 33 px below the header.
      child: Padding(
        padding: const EdgeInsets.only(top: 33, bottom: 32),
        child: AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, Widget? child) {
            final List<DocsHeadingEntry> headings = controller.headings;
            if (headings.isEmpty) {
              return const SizedBox.shrink();
            }
            return ScrollFade(
              fadeTop: false,
              fadeBottom: true,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'On This Page',
                        style: docsText(
                          context,
                          size: 12,
                          weight: FontWeight.w500,
                          height: 16 / 12,
                          color: theme.colors.mutedForeground,
                        ),
                      ),
                      const Gap(12),
                      for (final DocsHeadingEntry heading in headings)
                        _TocLink(
                          heading: heading,
                          active: heading.id == controller.activeId,
                          onSelect: onSelect,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TocLink extends StatelessWidget {
  const _TocLink({
    required this.heading,
    required this.active,
    required this.onSelect,
  });

  final DocsHeadingEntry heading;
  final bool active;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: heading.level >= 4 ? 24 : (heading.level == 3 ? 16 : 0),
        bottom: 8,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Clickable(
          onPressed: () => onSelect(heading.id),
          child: Text(
            heading.title,
            style: docsText(
              context,
              size: 12.8,
              weight: active ? FontWeight.w500 : FontWeight.w400,
              height: 18.28 / 12.8,
              color: active
                  ? theme.colors.foreground
                  : theme.colors.mutedForeground,
            ),
          ),
        ),
      ),
    );
  }
}
