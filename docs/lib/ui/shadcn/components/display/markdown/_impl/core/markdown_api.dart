// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../markdown.dart';

/// Link callback for markdown links: [label](url)
typedef MarkdownTapLinkCallback = void Function(String text, String url);
typedef MarkdownTapLinkDetailsCallback =
    void Function(MarkdownLinkTapDetails details);
typedef MarkdownTapImageCallback =
    void Function(MarkdownImageTapDetails details);
typedef MarkdownImagePreviewBuilder =
    Widget Function(
      BuildContext context,
      MarkdownImagePreviewDetails details,
      VoidCallback close,
    );
typedef MarkdownTapHeadingCallback =
    void Function(MarkdownHeadingTapDetails details);
typedef MarkdownTapElementCallback =
    void Function(MarkdownTapElementDetails details);
typedef MarkdownBlockBuilder =
    Widget? Function(BuildContext context, MarkdownBlockBuildDetails details);
typedef MarkdownDocumentReadyCallback =
    void Function(MarkdownDocumentMetrics metrics);

enum MarkdownLinkKind { anchor, email, external, relative }

enum MarkdownHtmlSanitizationStrategy {
  permissive,
  stripDangerousHtml,
  stripAllHtml,
}

enum MarkdownImagePreviewBehavior { none, dialog }

enum MarkdownBlockKind {
  blank,
  paragraph,
  heading,
  unorderedList,
  orderedList,
  taskList,
  quote,
  codeBlock,
  table,
  image,
  definitionList,
  details,
  math,
  footnote,
  rawHtml,
  horizontalRule,
}

enum MarkdownTapElementKind {
  paragraph,
  heading,
  listItem,
  quote,
  codeBlock,
  tableHeaderCell,
  tableCell,
  image,
  definitionTerm,
  definitionDescription,
  detailsSummary,
  math,
  footnote,
  rawHtml,
  horizontalRule,
  link,
}

@immutable
class MarkdownLinkTapDetails {
  const MarkdownLinkTapDetails({
    required this.text,
    required this.url,
    required this.kind,
  });

  final String text;
  final String url;
  final MarkdownLinkKind kind;

  bool get isAnchor => kind == MarkdownLinkKind.anchor;
  bool get isEmail => kind == MarkdownLinkKind.email;
  bool get isExternal => kind == MarkdownLinkKind.external;
  bool get isRelative => kind == MarkdownLinkKind.relative;
}

@immutable
class MarkdownImageTapDetails {
  const MarkdownImageTapDetails({
    required this.url,
    required this.alt,
    this.title,
  });

  final String url;
  final String alt;
  final String? title;
}

@immutable
class MarkdownImagePreviewDetails {
  const MarkdownImagePreviewDetails({
    required this.url,
    required this.alt,
    this.title,
  });

  final String url;
  final String alt;
  final String? title;

  bool get isNetwork {
    final lower = url.trim().toLowerCase();
    return lower.startsWith('http://') || lower.startsWith('https://');
  }

  bool get isAsset {
    final trimmed = url.trim();
    if (trimmed.startsWith('asset:')) {
      return true;
    }
    final uri = Uri.tryParse(trimmed);
    return uri == null || !uri.hasScheme;
  }
}

@immutable
class MarkdownHeadingTapDetails {
  const MarkdownHeadingTapDetails({
    required this.text,
    required this.anchor,
    required this.level,
  });

  final String text;
  final String anchor;
  final int level;
}

@immutable
class MarkdownTapElementDetails {
  const MarkdownTapElementDetails({
    required this.kind,
    required this.text,
    this.url,
    this.title,
    this.anchor,
    this.headingLevel,
    this.blockIndex,
    this.tableRow,
    this.tableColumn,
    this.orderedIndex,
    this.checked,
  });

  final MarkdownTapElementKind kind;
  final String text;
  final String? url;
  final String? title;
  final String? anchor;
  final int? headingLevel;
  final int? blockIndex;
  final int? tableRow;
  final int? tableColumn;
  final int? orderedIndex;
  final bool? checked;

  bool get isTableCell =>
      kind == MarkdownTapElementKind.tableCell ||
      kind == MarkdownTapElementKind.tableHeaderCell;
}

@immutable
class MarkdownBlockBuildDetails {
  const MarkdownBlockBuildDetails({
    required this.kind,
    required this.text,
    required this.blockIndex,
    required this.buildDefault,
    this.headingLevel,
    this.headingAnchor,
    this.language,
    this.orderedIndex,
    this.checked,
    this.tableRows = const <List<String>>[],
    this.tableAlignments = const <TextAlign>[],
    this.imageUrl,
    this.imageAlt,
    this.imageTitle,
    this.label,
    this.items = const <String>[],
    this.htmlTag,
    this.htmlAttributes = const <String, String>{},
    this.rawHtml,
  });

  final MarkdownBlockKind kind;
  final String text;
  final int blockIndex;
  final Widget Function() buildDefault;
  final int? headingLevel;
  final String? headingAnchor;
  final String? language;
  final int? orderedIndex;
  final bool? checked;
  final List<List<String>> tableRows;
  final List<TextAlign> tableAlignments;
  final String? imageUrl;
  final String? imageAlt;
  final String? imageTitle;
  final String? label;
  final List<String> items;
  final String? htmlTag;
  final Map<String, String> htmlAttributes;
  final String? rawHtml;

  bool get isHtmlBlock => htmlTag != null;
}

@immutable
class MarkdownDocumentMetrics {
  const MarkdownDocumentMetrics({
    required this.blockCount,
    required this.chunkCount,
    required this.headingCount,
    required this.imageCount,
    required this.tableCount,
  });

  final int blockCount;
  final int chunkCount;
  final int headingCount;
  final int imageCount;
  final int tableCount;
}

enum MarkdownSourceType { text, asset, file }

int computeStableMarkdownPrefixLength(String data) {
  return _computeStableMarkdownPrefixLength(data);
}

/// Lightweight markdown renderer with no external markdown package dependency.
class Markdown extends StatefulWidget {
  const Markdown({
    super.key,
    required this.data,
    this.selectable = true,
    this.style,
    this.onTapLink,
    this.onTapLinkDetails,
    this.onTapImage,
    this.onTapHeading,
    this.onTapElement,
    this.blockBuilder,
    this.onDocumentReady,
    this.viewportStorageId,
    this.shrinkWrap = true,
    this.followLinks = true,
    this.htmlSanitizationStrategy =
        MarkdownHtmlSanitizationStrategy.stripDangerousHtml,
    this.imagePreviewBehavior = MarkdownImagePreviewBehavior.dialog,
    this.imagePreviewBuilder,
    this.imageBuilder,
    this.loading,
    this.errorBuilder,
  }) : sourceType = MarkdownSourceType.text,
       sourcePath = null;

  const Markdown.asset({
    super.key,
    required String asset,
    this.selectable = true,
    this.style,
    this.onTapLink,
    this.onTapLinkDetails,
    this.onTapImage,
    this.onTapHeading,
    this.onTapElement,
    this.blockBuilder,
    this.onDocumentReady,
    this.viewportStorageId,
    this.shrinkWrap = true,
    this.followLinks = true,
    this.htmlSanitizationStrategy =
        MarkdownHtmlSanitizationStrategy.stripDangerousHtml,
    this.imagePreviewBehavior = MarkdownImagePreviewBehavior.dialog,
    this.imagePreviewBuilder,
    this.imageBuilder,
    this.loading,
    this.errorBuilder,
  }) : data = '',
       sourceType = MarkdownSourceType.asset,
       sourcePath = asset;

  const Markdown.file({
    super.key,
    required String path,
    this.selectable = true,
    this.style,
    this.onTapLink,
    this.onTapLinkDetails,
    this.onTapImage,
    this.onTapHeading,
    this.onTapElement,
    this.blockBuilder,
    this.onDocumentReady,
    this.viewportStorageId,
    this.shrinkWrap = true,
    this.followLinks = true,
    this.htmlSanitizationStrategy =
        MarkdownHtmlSanitizationStrategy.stripDangerousHtml,
    this.imagePreviewBehavior = MarkdownImagePreviewBehavior.dialog,
    this.imagePreviewBuilder,
    this.imageBuilder,
    this.loading,
    this.errorBuilder,
  }) : data = '',
       sourceType = MarkdownSourceType.file,
       sourcePath = path;

  final String data;
  final bool selectable;
  final TextStyle? style;
  final MarkdownTapLinkCallback? onTapLink;
  final MarkdownTapLinkDetailsCallback? onTapLinkDetails;
  final MarkdownTapImageCallback? onTapImage;
  final MarkdownTapHeadingCallback? onTapHeading;
  final MarkdownTapElementCallback? onTapElement;
  final MarkdownBlockBuilder? blockBuilder;
  final MarkdownDocumentReadyCallback? onDocumentReady;
  final Object? viewportStorageId;
  final bool shrinkWrap;
  final bool followLinks;
  final MarkdownHtmlSanitizationStrategy htmlSanitizationStrategy;
  final MarkdownImagePreviewBehavior imagePreviewBehavior;
  final MarkdownImagePreviewBuilder? imagePreviewBuilder;
  final MarkdownSourceType sourceType;
  final String? sourcePath;
  final Widget Function(BuildContext context, String url, String alt)?
  imageBuilder;
  final Widget? loading;
  final Widget Function(BuildContext context, Object error)? errorBuilder;

  Markdown copyWith({
    String? data,
    bool? selectable,
    TextStyle? style,
    MarkdownTapLinkCallback? onTapLink,
    MarkdownTapLinkDetailsCallback? onTapLinkDetails,
    MarkdownTapImageCallback? onTapImage,
    MarkdownTapHeadingCallback? onTapHeading,
    MarkdownTapElementCallback? onTapElement,
    MarkdownBlockBuilder? blockBuilder,
    MarkdownDocumentReadyCallback? onDocumentReady,
    Object? viewportStorageId,
    bool? shrinkWrap,
    bool? followLinks,
    MarkdownHtmlSanitizationStrategy? htmlSanitizationStrategy,
    MarkdownImagePreviewBehavior? imagePreviewBehavior,
    MarkdownImagePreviewBuilder? imagePreviewBuilder,
    Widget Function(BuildContext context, String url, String alt)? imageBuilder,
    Widget? loading,
    Widget Function(BuildContext context, Object error)? errorBuilder,
  }) {
    return switch (sourceType) {
      MarkdownSourceType.text => Markdown(
        key: key,
        data: data ?? this.data,
        selectable: selectable ?? this.selectable,
        style: style ?? this.style,
        onTapLink: onTapLink ?? this.onTapLink,
        onTapLinkDetails: onTapLinkDetails ?? this.onTapLinkDetails,
        onTapImage: onTapImage ?? this.onTapImage,
        onTapHeading: onTapHeading ?? this.onTapHeading,
        onTapElement: onTapElement ?? this.onTapElement,
        blockBuilder: blockBuilder ?? this.blockBuilder,
        onDocumentReady: onDocumentReady ?? this.onDocumentReady,
        viewportStorageId: viewportStorageId ?? this.viewportStorageId,
        shrinkWrap: shrinkWrap ?? this.shrinkWrap,
        followLinks: followLinks ?? this.followLinks,
        htmlSanitizationStrategy:
            htmlSanitizationStrategy ?? this.htmlSanitizationStrategy,
        imagePreviewBehavior: imagePreviewBehavior ?? this.imagePreviewBehavior,
        imagePreviewBuilder: imagePreviewBuilder ?? this.imagePreviewBuilder,
        imageBuilder: imageBuilder ?? this.imageBuilder,
        loading: loading ?? this.loading,
        errorBuilder: errorBuilder ?? this.errorBuilder,
      ),
      MarkdownSourceType.asset => Markdown.asset(
        key: key,
        asset: sourcePath ?? '',
        selectable: selectable ?? this.selectable,
        style: style ?? this.style,
        onTapLink: onTapLink ?? this.onTapLink,
        onTapLinkDetails: onTapLinkDetails ?? this.onTapLinkDetails,
        onTapImage: onTapImage ?? this.onTapImage,
        onTapHeading: onTapHeading ?? this.onTapHeading,
        onTapElement: onTapElement ?? this.onTapElement,
        blockBuilder: blockBuilder ?? this.blockBuilder,
        onDocumentReady: onDocumentReady ?? this.onDocumentReady,
        viewportStorageId: viewportStorageId ?? this.viewportStorageId,
        shrinkWrap: shrinkWrap ?? this.shrinkWrap,
        followLinks: followLinks ?? this.followLinks,
        htmlSanitizationStrategy:
            htmlSanitizationStrategy ?? this.htmlSanitizationStrategy,
        imagePreviewBehavior: imagePreviewBehavior ?? this.imagePreviewBehavior,
        imagePreviewBuilder: imagePreviewBuilder ?? this.imagePreviewBuilder,
        imageBuilder: imageBuilder ?? this.imageBuilder,
        loading: loading ?? this.loading,
        errorBuilder: errorBuilder ?? this.errorBuilder,
      )._copyToTextIfRequested(data),
      MarkdownSourceType.file => Markdown.file(
        key: key,
        path: sourcePath ?? '',
        selectable: selectable ?? this.selectable,
        style: style ?? this.style,
        onTapLink: onTapLink ?? this.onTapLink,
        onTapLinkDetails: onTapLinkDetails ?? this.onTapLinkDetails,
        onTapImage: onTapImage ?? this.onTapImage,
        onTapHeading: onTapHeading ?? this.onTapHeading,
        onTapElement: onTapElement ?? this.onTapElement,
        blockBuilder: blockBuilder ?? this.blockBuilder,
        onDocumentReady: onDocumentReady ?? this.onDocumentReady,
        viewportStorageId: viewportStorageId ?? this.viewportStorageId,
        shrinkWrap: shrinkWrap ?? this.shrinkWrap,
        followLinks: followLinks ?? this.followLinks,
        htmlSanitizationStrategy:
            htmlSanitizationStrategy ?? this.htmlSanitizationStrategy,
        imagePreviewBehavior: imagePreviewBehavior ?? this.imagePreviewBehavior,
        imagePreviewBuilder: imagePreviewBuilder ?? this.imagePreviewBuilder,
        imageBuilder: imageBuilder ?? this.imageBuilder,
        loading: loading ?? this.loading,
        errorBuilder: errorBuilder ?? this.errorBuilder,
      )._copyToTextIfRequested(data),
    };
  }

  @override
  State<Markdown> createState() => _MarkdownState();
}

extension on Markdown {
  Markdown _copyToTextIfRequested(String? nextData) {
    if (nextData == null) {
      return this;
    }
    return Markdown(
      key: key,
      data: nextData,
      selectable: selectable,
      style: style,
      onTapLink: onTapLink,
      onTapLinkDetails: onTapLinkDetails,
      onTapImage: onTapImage,
      onTapHeading: onTapHeading,
      onTapElement: onTapElement,
      blockBuilder: blockBuilder,
      onDocumentReady: onDocumentReady,
      viewportStorageId: viewportStorageId,
      shrinkWrap: shrinkWrap,
      followLinks: followLinks,
      htmlSanitizationStrategy: htmlSanitizationStrategy,
      imagePreviewBehavior: imagePreviewBehavior,
      imagePreviewBuilder: imagePreviewBuilder,
      imageBuilder: imageBuilder,
      loading: loading,
      errorBuilder: errorBuilder,
    );
  }
}
