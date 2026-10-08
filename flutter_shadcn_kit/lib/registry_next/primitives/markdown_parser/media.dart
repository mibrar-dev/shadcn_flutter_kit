// Media markdown blocks: tables, images and the image preview overlay.
// Imported by `blocks.dart` dispatchers; shares the style snapshot and
// callback bundle, so no renderer state lives here.

import 'package:flutter/widgets.dart';

import '../../foundation/icons/lucide_icons.dart';
import 'api.dart';
import 'blocks.dart';
import 'document.dart';

/// GFM table: header-first rows, per-column alignment, horizontal scroll
/// past the viewport. Cells hold inline runs only (no nested blocks).
Widget buildMarkdownTable(
  BuildContext context,
  MarkdownRenderStyle style,
  MarkdownCallbacks callbacks,
  MarkdownBlock block,
  int blockIndex,
) {
  final rows = block.tableRows;
  if (rows.isEmpty) return const SizedBox.shrink();
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6),
    decoration: BoxDecoration(
      border: Border.all(color: style.tableBorder),
      borderRadius: BorderRadius.circular(10),
    ),
    clipBehavior: Clip.antiAlias,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        defaultColumnWidth: const IntrinsicColumnWidth(),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder(
          horizontalInside: BorderSide(color: style.tableBorder),
          verticalInside: BorderSide(color: style.tableBorder),
        ),
        children: <TableRow>[
          for (var r = 0; r < rows.length; r++)
            TableRow(
              decoration: BoxDecoration(
                color: r == 0 ? style.tableHeaderBackground : null,
              ),
              children: <Widget>[
                for (var c = 0; c < rows[r].length; c++)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 112),
                      child: _cell(
                        context,
                        style,
                        callbacks,
                        rows[r][c],
                        r == 0 ? style.tableHeader : style.tableCell,
                        c < block.tableAlignments.length
                            ? block.tableAlignments[c]
                            : TextAlign.left,
                        blockIndex,
                        r,
                        c,
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    ),
  );
}

Widget _cell(
  BuildContext context,
  MarkdownRenderStyle style,
  MarkdownCallbacks callbacks,
  String text,
  TextStyle cellStyle,
  TextAlign align,
  int blockIndex,
  int row,
  int col,
) {
  Widget child = markdownRichText(
    context,
    style,
    TextSpan(
      style: cellStyle,
      children: markdownSpans(style, callbacks, cellStyle, text).children,
    ),
    align: align,
  );
  if (callbacks.onTapElement != null) {
    child = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => callbacks.onTapElement!.call(
        MarkdownTapElementDetails(
          kind: row == 0
              ? MarkdownTapElementKind.tableHeaderCell
              : MarkdownTapElementKind.tableCell,
          text: text,
          blockIndex: blockIndex,
          tableRow: row,
          tableColumn: col,
        ),
      ),
      child: child,
    );
  }
  return child;
}

/// Standalone image with optional caption. Network failures fall back to the
/// alt text; [failedUrls] is owned by the widget state (never a static).
Widget buildMarkdownImage(
  BuildContext context,
  MarkdownRenderStyle style,
  MarkdownCallbacks callbacks,
  MarkdownBlock block,
  int blockIndex, {
  required Set<String> failedUrls,
  required bool interactive,
}) {
  final url = (block.imageUrl ?? '').trim();
  final alt = block.imageAlt ?? '';
  Widget picture;
  if (callbacks.imageBuilder != null) {
    picture = callbacks.imageBuilder!(context, url, alt);
  } else if (url.isEmpty || failedUrls.contains(url)) {
    picture = _fallback(context, style, alt.isEmpty ? url : alt);
  } else if (url.startsWith('http://') || url.startsWith('https://')) {
    picture = SelectionContainer.disabled(
      child: Image.network(
        url,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _fallback(context, style, alt.isEmpty ? url : alt);
        },
        errorBuilder: (context, error, stack) {
          failedUrls.add(url);
          return _fallback(context, style, alt.isEmpty ? url : alt);
        },
      ),
    );
  } else {
    final asset = url.startsWith('asset:') ? url.substring(6) : url;
    picture = SelectionContainer.disabled(
      child: Image.asset(
        asset,
        errorBuilder: (context, error, stack) =>
            _fallback(context, style, alt.isEmpty ? asset : alt),
      ),
    );
  }
  Widget framed = ConstrainedBox(
    constraints: const BoxConstraints(maxHeight: 280),
    child: picture,
  );
  if ((block.imageTitle ?? '').isNotEmpty) {
    framed = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        framed,
        const SizedBox(height: 4),
        markdownRichText(
          context,
          style,
          TextSpan(
            style: style.body.copyWith(
              fontSize: (style.body.fontSize ?? 14) * 0.9,
              color: style.muted,
            ),
            text: block.imageTitle,
          ),
        ),
      ],
    );
  }
  if (!interactive) return framed;
  final details = MarkdownImagePreviewDetails(url: url, alt: alt);
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {
      callbacks.onTapImage?.call(MarkdownImageTapDetails(url: url, alt: alt));
      callbacks.onTapElement?.call(
        MarkdownTapElementDetails(
          kind: MarkdownTapElementKind.image,
          text: alt,
          url: url,
          blockIndex: blockIndex,
        ),
      );
      showMarkdownImagePreview(
        context,
        style,
        callbacks,
        details,
        failedUrls: failedUrls,
      );
    },
    child: framed,
  );
}

Widget _fallback(BuildContext context, MarkdownRenderStyle style, String text) {
  return markdownRichText(
    context,
    style,
    TextSpan(style: style.body, text: text),
  );
}

/// Widgets-only image preview: a centered card with the image, its caption
/// and a close affordance. Tapping outside dismisses through the barrier.
void showMarkdownImagePreview(
  BuildContext context,
  MarkdownRenderStyle style,
  MarkdownCallbacks callbacks,
  MarkdownImagePreviewDetails details, {
  required Set<String> failedUrls,
}) {
  if (callbacks.imagePreviewBehavior == MarkdownImagePreviewBehavior.none) {
    return;
  }
  showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: style.dismissLabel,
    barrierColor: const Color(0x80000000),
    transitionDuration: const Duration(milliseconds: 150),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      void close() => Navigator.of(dialogContext).maybePop();
      if (callbacks.imagePreviewBuilder != null) {
        return callbacks.imagePreviewBuilder!(dialogContext, details, close);
      }
      return Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: style.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        details.alt.isEmpty ? details.url : details.alt,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: style.tableHeader.copyWith(
                          color: style.onSurface,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: close,
                      behavior: HitTestBehavior.translucent,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Semantics(
                          button: true,
                          label: style.dismissLabel,
                          child: Icon(
                            LucideIcons.x,
                            size: 18,
                            color: style.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: buildMarkdownImage(
                  dialogContext,
                  style,
                  callbacks,
                  MarkdownBlock(
                    kind: MarkdownBlockKind.image,
                    text: '',
                    imageUrl: details.url,
                    imageAlt: details.alt,
                  ),
                  -1,
                  failedUrls: failedUrls,
                  interactive: false,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
