// The one-line site footer (spec §2.0): 56 px below `xl`, 96 px at `xl`,
// centred 12→14 px muted sentence with three links (docs / GitHub / CLI).
// Original wording; hidden on `/docs*` and `/themes` exactly like the
// reference hides it on docs + `/create`.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/primitives/clickable.dart';
import '../ui/shadcn/theme/theme.dart';
import '../web_bridge.dart';
import 'docs_tokens.dart';

/// GitHub repository URL used by the header and footer links.
const String kDocsRepoUrl = 'https://github.com/mibrar-dev/shadcn_flutter_kit';

/// The site footer line.
class DocsFooter extends StatelessWidget {
  /// Creates the footer.
  const DocsFooter({super.key, required this.onDocs, required this.onCli});

  /// Opens `/docs`.
  final VoidCallback onDocs;

  /// Opens `/docs/cli`.
  final VoidCallback onCli;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final double width = MediaQuery.sizeOf(context).width;
    final TextStyle base = docsText(
      context,
      size: width >= 640 ? 14 : 12,
      height: 1.6,
      color: theme.colors.mutedForeground,
    );
    final TextStyle link = base.copyWith(
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.underline,
      decorationColor: theme.colors.mutedForeground,
    );
    return Container(
      height: width >= 1280
          ? DocsMetrics.footerHeightLg
          : DocsMetrics.footerHeightSm,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: DocsMetrics.barPadding),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          Text('A widgets-only Flutter component kit — ', style: base),
          _FooterLink('Docs', link, onDocs),
          Text(' · ', style: base),
          _FooterLink('GitHub', link, () => webOpenUrl(kDocsRepoUrl)),
          Text(' · ', style: base),
          _FooterLink('CLI', link, onCli),
        ],
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  const _FooterLink(this.label, this.style, this.onTap);

  final String label;
  final TextStyle style;
  final VoidCallback onTap;

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Clickable(
        onPressed: widget.onTap,
        child: Text(
          widget.label,
          style: widget.style.copyWith(
            color: _hovered
                ? ShadcnTheme.of(context).colors.foreground
                : widget.style.color,
          ),
        ),
      ),
    );
  }
}
