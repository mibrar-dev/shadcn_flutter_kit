// The file items view shared by the file components: list or grid layout,
// optional grouping by a caller key, and the per-row callbacks.
//
// Ported from `form/file_picker/_impl/core/file_upload_items_view.dart`
// (`FileUploadItemsView`, `FileUploadItemsLayout`) plus the old
// `groupListByStatus` behaviour, generalised to a caller-supplied key. It
// lives in `primitives/file_value` (P4-B22, Q7) so the `file_picker` component
// keeps its three-Dart-file folder; `progress` is a slot, so no component is
// imported.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'file_format.dart';
import 'file_upload_row.dart';
import 'file_upload_row_theme.dart';
import 'file_value.dart';

/// How the file rows are laid out.
enum FileUploadItemsLayout {
  /// One row per file, full width.
  list,

  /// A wrapped grid of [FileUploadItemsView.columns] columns.
  grid,
}

/// Builds one row; null renders [FileUploadRow].
typedef FileUploadItemBuilder =
    Widget Function(BuildContext context, FileItem item);

/// Renders the file rows: a list, a grid or caller-keyed groups.
///
/// ```dart
/// FileUploadItemsView(
///   items: items,
///   layout: FileUploadItemsLayout.grid,
///   columns: 3,
///   onRemove: (item) => remove(item.file),
/// )
/// ```
class FileUploadItemsView extends StatelessWidget {
  /// Creates a file items view.
  const FileUploadItemsView({
    super.key,
    required this.items,
    this.layout = FileUploadItemsLayout.list,
    this.columns = 2,
    this.groupKey,
    this.groupHeaderBuilder,
    this.statusLabels,
    this.iconBuilder,
    this.itemBuilder,
    this.progressBuilder,
    this.onRemove,
    this.onRetry,
    this.gap,
    this.maxHeight,
    this.theme,
  });

  /// The rows to render.
  final List<FileItem> items;

  /// List or grid.
  final FileUploadItemsLayout layout;

  /// Grid columns; clamped to at least one.
  final int columns;

  /// Section key per row; null renders one flat list.
  final String Function(FileItem item)? groupKey;

  /// Builds a section header; null renders the key as muted text.
  final Widget Function(BuildContext context, String key)? groupHeaderBuilder;

  /// Status wording; null resolves the localized defaults.
  final FileStatusLabels? statusLabels;

  /// Row thumbnail builder; null renders [defaultFileIcon].
  final FileUploadIconBuilder? iconBuilder;

  /// Custom row builder; null renders [FileUploadRow].
  final FileUploadItemBuilder? itemBuilder;

  /// Progress widget per row; null renders none.
  final Widget? Function(FileItem item)? progressBuilder;

  /// Called when a row's remove action is pressed.
  final ValueChanged<FileItem>? onRemove;

  /// Called when a failed row's retry action is pressed.
  final ValueChanged<FileItem>? onRetry;

  /// Space between rows/sections; null resolves 12.
  final double? gap;

  /// Scroll cap; null grows with the content.
  final double? maxHeight;

  /// Row theme bridge; null lets each row resolve its own legs.
  final FileUploadRowTheme? theme;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final double spacing = (gap ?? 12) * ambient.scaling;
    final String Function(FileItem)? key = groupKey;
    final Widget content = key != null
        ? _grouped(context, ambient, spacing, key)
        : layout == FileUploadItemsLayout.grid
        ? _grid(spacing)
        : _list(context, spacing, items);
    final double? maxHeight = this.maxHeight;
    if (maxHeight == null) {
      return content;
    }
    return SizedBox(
      height: maxHeight,
      child: SingleChildScrollView(child: content),
    );
  }

  Widget _list(BuildContext context, double spacing, List<FileItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < items.length; i++) ...<Widget>[
          if (i > 0) Gap(spacing),
          _row(context, items[i]),
        ],
      ],
    );
  }

  Widget _grid(double spacing) {
    final int count = columns < 1 ? 1 : columns;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final double tile = (width - (count - 1) * spacing) / count;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: <Widget>[
            for (final FileItem item in items)
              SizedBox(width: tile, child: _row(context, item)),
          ],
        );
      },
    );
  }

  Widget _grouped(
    BuildContext context,
    ShadcnThemeData ambient,
    double spacing,
    String Function(FileItem) key,
  ) {
    final Map<String, List<FileItem>> groups = <String, List<FileItem>>{};
    for (final FileItem item in items) {
      groups.putIfAbsent(key(item), () => <FileItem>[]).add(item);
    }
    final List<Widget> children = <Widget>[];
    for (final MapEntry<String, List<FileItem>> entry in groups.entries) {
      if (children.isNotEmpty) {
        children.add(Gap(spacing));
      }
      children.add(
        groupHeaderBuilder?.call(context, entry.key) ??
            DefaultTextStyle.merge(
              style: ambient.typography.xSmall.copyWith(
                color: ambient.colors.mutedForeground,
              ),
              child: Text('${entry.key} (${entry.value.length})'),
            ),
      );
      children.add(Gap(spacing * 0.5));
      for (int i = 0; i < entry.value.length; i++) {
        if (i > 0) {
          children.add(Gap(spacing));
        }
        children.add(_row(context, entry.value[i]));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _row(BuildContext context, FileItem item) {
    final FileUploadItemBuilder? builder = itemBuilder;
    if (builder != null) {
      return builder(context, item);
    }
    final ValueChanged<FileItem>? remove = onRemove;
    final ValueChanged<FileItem>? retry = onRetry;
    return FileUploadRow(
      item: item,
      statusLabels: statusLabels,
      iconBuilder: iconBuilder,
      theme: theme,
      progress: progressBuilder?.call(item),
      onRemove: remove == null ? null : () => remove(item),
      onRetry: retry == null || item.status != FileStatus.error
          ? null
          : () => retry(item),
    );
  }
}
