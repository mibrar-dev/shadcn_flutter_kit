// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../file_picker.dart';

/// FileUploadItemsLayout enumerates fixed values used by this implementation.
enum FileUploadItemsLayout { list, grid }

/// FileUploadItemsView represents a form-related type in the registry.
class FileUploadItemsView extends StatelessWidget {
  /// Constructs `FileUploadItemsView` with the provided parameters.
  const FileUploadItemsView({
    super.key,
    required this.items,
    this.layout = FileUploadItemsLayout.list,
    this.groupByStatus = false,
    this.statusLabels = const FileUploadStatusLabels(),
    this.itemLoading = const FileUploadItemLoadingOptions(),
    this.columns = 2,
    this.gap,
    this.padding,
    this.showContainer = true,
    this.maxHeight,
    this.itemBuilder,
  });

  /// Field storing `items` for this form implementation.
  final List<FileUploadItem> items;

  /// Field storing `layout` for this form implementation.
  final FileUploadItemsLayout layout;

  /// Field storing `groupByStatus` for this form implementation.
  final bool groupByStatus;

  /// Field storing `statusLabels` for this form implementation.
  final FileUploadStatusLabels statusLabels;

  /// Field storing `itemLoading` for this form implementation.
  final FileUploadItemLoadingOptions itemLoading;

  /// Field storing `columns` for this form implementation.
  final int columns;

  /// Field storing `gap` for this form implementation.
  final double? gap;

  /// Field storing `padding` for this form implementation.
  final EdgeInsetsGeometry? padding;

  /// Field storing `showContainer` for this form implementation.
  final bool showContainer;

  /// Field storing `maxHeight` for this form implementation.
  final double? maxHeight;
  final Widget Function(BuildContext context, FileUploadItem item)? itemBuilder;

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final spacing = gap ?? theme.density.baseGap * scaling * 1.5;
    Widget content = layout == FileUploadItemsLayout.grid
        ? _buildGrid(context, spacing)
        : groupByStatus
        ? _buildGroupedList(context, spacing, theme)
        : _buildList(context, spacing);

    if (maxHeight != null) {
      content = SizedBox(
        height: maxHeight,
        child: SingleChildScrollView(child: content),
      );
    }

    if (!showContainer) {
      return content;
    }

    return OutlinedContainer(
      borderWidth: 1,
      child: Padding(
        padding:
            padding ??
            EdgeInsets.all(theme.density.baseContentPadding * scaling),
        child: content,
      ),
    );
  }

  /// Performs `_buildList` logic for this form component.
  Widget _buildList(BuildContext context, double spacing) {
    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          _buildItem(context, items[i]),
          if (i != items.length - 1) Gap(spacing),
        ],
      ],
    );
  }

  Widget _buildGroupedList(
    BuildContext context,
    double spacing,
    ThemeData theme,
  ) {
    final waiting = items
        .where((item) => item.status == FileUploadItemStatus.idle)
        .toList();
    final uploading = items
        .where((item) => item.status == FileUploadItemStatus.uploading)
        .toList();
    final completed = items
        .where((item) => item.status == FileUploadItemStatus.success)
        .toList();
    final failed = items
        .where((item) => item.status == FileUploadItemStatus.error)
        .toList();

    final sections = <Widget>[];

    /// Performs `addSection` logic for this form component.
    void addSection(String label, List<FileUploadItem> group) {
      if (group.isEmpty) return;
      sections.add(
        DefaultTextStyle.merge(
          style: theme.typography.xSmall.copyWith(
            color: theme.colorScheme.mutedForeground,
          ),
          child: Text('$label (${group.length})'),
        ),
      );
      sections.add(Gap(spacing * 0.5));
      for (var i = 0; i < group.length; i++) {
        sections.add(_buildItem(context, group[i]));
        if (i != group.length - 1) {
          sections.add(Gap(spacing));
        }
      }
    }

    addSection(statusLabels.uploading, uploading);
    addSection(statusLabels.completed, completed);
    addSection(statusLabels.waiting, waiting);
    addSection(statusLabels.failed, failed);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < sections.length; i++) ...[
          sections[i],
          if (i != sections.length - 1) Gap(spacing),
        ],
      ],
    );
  }

  /// Performs `_buildGrid` logic for this form component.
  Widget _buildGrid(BuildContext context, double spacing) {
    final columnCount = columns < 1 ? 1 : columns;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final tileWidth = (width - (columnCount - 1) * spacing) / columnCount;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final item in items)
              SizedBox(width: tileWidth, child: _buildItem(context, item)),
          ],
        );
      },
    );
  }

  /// Performs `_buildItem` logic for this form component.
  Widget _buildItem(BuildContext context, FileUploadItem item) {
    return itemBuilder?.call(context, item) ??
        FileItem(
          item: item,
          statusLabels: statusLabels,
          itemLoading: itemLoading,
        );
  }
}
