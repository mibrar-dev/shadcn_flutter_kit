import 'package:flutter/services.dart';
import 'package:flutter/material.dart' show SelectableText;
import 'package:flutter/widgets.dart';

import '../../control/button/button.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/style_value.dart';

part '_impl/core/file_diff_models.dart';
part '_impl/state/file_diff_viewer_state.dart';
part '_impl/themes/base/file_diff_viewer_theme.dart';

/// Visual mode used by [FileDiffViewer].
enum FileDiffLayout {
  /// Renders a compact single column patch.
  unified,

  /// Renders old and new sides beside each other.
  split,
}

/// Semantic type of a diff line.
enum FileDiffLineType {
  /// Unchanged context line.
  context,

  /// Added line.
  addition,

  /// Deleted line.
  deletion,

  /// Hunk header such as `@@ -1,4 +1,6 @@`.
  hunk,
}

/// A comprehensive file diff viewer with unified and split layouts.
class FileDiffViewer extends StatefulWidget {
  /// Files rendered by the viewer.
  final List<FileDiff> files;

  /// Layout mode.
  final FileDiffLayout layout;

  /// Whether file headers are shown.
  final bool showFileHeaders;

  /// Whether line number gutters are shown.
  final bool showLineNumbers;

  /// Whether unchanged context blocks marked as collapsed are hidden.
  final bool collapseUnchanged;

  /// Whether each file header includes a compact copy button.
  final bool showCopyAction;

  /// Maximum height for the scrollable diff body.
  final double? maxHeight;

  /// Minimum width reserved for code rows before horizontal scrolling begins.
  final double minContentWidth;

  /// Creates a file diff viewer.
  const FileDiffViewer({
    super.key,
    required this.files,
    this.layout = FileDiffLayout.unified,
    this.showFileHeaders = true,
    this.showLineNumbers = true,
    this.collapseUnchanged = true,
    this.showCopyAction = true,
    this.maxHeight,
    this.minContentWidth = 720.0,
  });

  /// Creates the State object used by this file diff viewer.
  @override
  State<FileDiffViewer> createState() => _FileDiffViewerState();
}
