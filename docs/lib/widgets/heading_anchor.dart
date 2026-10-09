// Section heading with the shadcn `#` anchor (spec §2.3): the hash fades in
// on hover over 200 ms linear and the heading registers itself with the
// article's TOC/scroll-spy controller.
//
// Measured typeset sizes: h2 18.75/26.25 mt 32.8; h3 16.875/24.47 mt 16.875.

import 'package:flutter/widgets.dart';

import '../motion/ease.dart';
import '../motion/motion_scope.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/theme/theme.dart';
import 'docs_article.dart';
import 'docs_tokens.dart';

/// A registered prose heading (`h2`/`h3`) with a hover `#` anchor.
class HeadingAnchor extends StatefulWidget {
  /// Creates a heading.
  const HeadingAnchor({
    super.key,
    required this.id,
    required this.title,
    this.level = 2,
  });

  /// Anchor id (also the TOC target).
  final String id;

  /// Heading text.
  final String title;

  /// `2` (18.75 px) or `3` (16.875 px).
  final int level;

  @override
  State<HeadingAnchor> createState() => _HeadingAnchorState();
}

class _HeadingAnchorState extends State<HeadingAnchor> {
  final GlobalKey _key = GlobalKey();
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    // No dependency: read the controller once and register after build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        DocsArticleScope.maybeOf(context)?.register(
          DocsHeadingEntry(
            id: widget.id,
            title: widget.title,
            level: widget.level,
            key: _key,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final bool h2 = widget.level <= 2;
    final double size = h2 ? 18.75 : 16.875;
    final double height = h2 ? 26.25 : 24.47;
    final double top = h2 ? 32.8 : 16.875;
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Row(
          key: _key,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Text(
              widget.title,
              style: docsText(
                context,
                size: size,
                weight: FontWeight.w600,
                height: height / size,
              ),
            ),
            const Gap(8),
            AnimatedOpacity(
              // The reference reveals the anchor's opacity over `.2s linear`
              // (its margin is constant in Flutter's text layout).
              opacity: _hovered ? 1 : 0,
              duration: context.motionDuration(kDurationHeadingAnchor),
              curve: Curves.linear,
              child: Text(
                '#',
                style: docsText(
                  context,
                  size: size,
                  weight: FontWeight.w600,
                  color: theme.colors.mutedForeground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
