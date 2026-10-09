// The components-index link grid (spec §2.5): 2 columns, 3 at `md`, plain
// 16/500 links (18/500 below `md`) that underline on hover. Links come from
// the generated [kComponentLinks]; the grid never hard-codes names.

import 'package:flutter/widgets.dart';

import '../generated/docs_data.dart';
import '../routing/docs_router.dart';
import '../ui/shadcn/theme/theme.dart';
import 'docs_tokens.dart';

/// An alphabetical grid of component page links.
class ComponentLinkGrid extends StatelessWidget {
  /// Creates the grid.
  const ComponentLinkGrid({super.key, this.links = kComponentLinks});

  /// Link rows (defaults to the generated set).
  final List<DocsComponentLink> links;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final int columns = width >= 768 ? 3 : 2;
    final double columnGap = width >= 1280 ? 80 : (width >= 1024 ? 64 : 32);
    final double rowGap = width >= 1024 ? 24 : 16;
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int column = 0; column < columns; column++) ...<Widget>[
            if (column > 0) SizedBox(width: columnGap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  for (int i = column; i < links.length; i += columns)
                    Padding(
                      padding: EdgeInsets.only(bottom: rowGap),
                      child: _ComponentLink(link: links[i], small: width < 768),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ComponentLink extends StatefulWidget {
  const _ComponentLink({required this.link, required this.small});

  final DocsComponentLink link;
  final bool small;

  @override
  State<_ComponentLink> createState() => _ComponentLinkState();
}

class _ComponentLinkState extends State<_ComponentLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => DocsRouterScope.of(
          context,
        ).go(context, '/docs/components/${widget.link.id}'),
        child: Text(
          widget.link.name,
          // CSS grid cells let a long unbroken name spill into the 80 px
          // column gap; Flutter must be told explicitly (no mid-word wrap).
          softWrap: false,
          overflow: TextOverflow.visible,
          style:
              docsText(
                context,
                size: widget.small ? 18 : 16,
                weight: FontWeight.w500,
                height: 1.5,
                color: theme.colors.foreground,
              ).copyWith(
                decoration: _hovered
                    ? TextDecoration.underline
                    : TextDecoration.none,
                decorationColor: theme.colors.foreground,
              ),
        ),
      ),
    );
  }
}
