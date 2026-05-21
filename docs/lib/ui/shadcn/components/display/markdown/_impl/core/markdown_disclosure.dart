// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../markdown.dart';

class _MarkdownDisclosure extends StatefulWidget {
  const _MarkdownDisclosure({
    required this.summary,
    required this.child,
    required this.summaryStyle,
    required this.decoration,
    required this.headerPadding,
    required this.bodyPadding,
    this.onSummaryTap,
  });

  final String summary;
  final Widget child;
  final TextStyle summaryStyle;
  final BoxDecoration decoration;
  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry bodyPadding;
  final VoidCallback? onSummaryTap;

  @override
  State<_MarkdownDisclosure> createState() => _MarkdownDisclosureState();
}

class _MarkdownDisclosureState extends State<_MarkdownDisclosure> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: widget.decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() => _expanded = !_expanded);
              widget.onSummaryTap?.call();
            },
            child: Padding(
              padding: widget.headerPadding,
              child: Row(
                children: [
                  Text(_expanded ? '▼' : '▶', style: widget.summaryStyle),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(widget.summary, style: widget.summaryStyle),
                  ),
                ],
              ),
            ),
          ),
          ClipRect(
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              heightFactor: _expanded ? 1 : 0,
              alignment: Alignment.topCenter,
              child: Padding(padding: widget.bodyPadding, child: widget.child),
            ),
          ),
        ],
      ),
    );
  }
}
