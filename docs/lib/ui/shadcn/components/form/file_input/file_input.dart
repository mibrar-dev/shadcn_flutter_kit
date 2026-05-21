// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/material.dart' show Icons;
import 'package:flutter/widgets.dart';

part '_impl/utils/file_icon_provider_data.dart';

/// Performs `_buildFileIcon` logic for this form component.
Widget _buildFileIcon(String extension) {
  switch (extension) {
    case 'pdf':
      return const Icon(Icons.picture_as_pdf);
    case 'doc':
    case 'docx':
      return const Icon(Icons.description);
    case 'xls':
    case 'xlsx':
      return const Icon(Icons.table_chart);
    case 'ppt':
    case 'pptx':
      return const Icon(Icons.slideshow);
    case 'zip':
    case 'rar':
      return const Icon(Icons.archive);
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
      return const Icon(Icons.image);
    case 'mp3':
    case 'wav':
      return const Icon(Icons.music_note);
    case 'mp4':
    case 'avi':
    case 'mkv':
      return const Icon(Icons.movie);
    default:
      return const Icon(Icons.insert_drive_file);
  }
}

/// A function that builds a file icon widget based on the file extension.
///
/// Parameters:
/// - [extension]: The file extension (without the dot).
///
/// Returns: A widget representing the file type icon.
typedef FileIconBuilder = Widget Function(String extension);

/// Provides customizable file icons in the widget tree.
///
/// [FileIconProvider] allows applications to define custom file icons based on
/// file extensions. Icons can be provided either through a builder function or
/// a static map of extensions to widgets.
///
/// Example using builder:
/// ```dart
/// FileIconProvider.builder(
///   builder: (extension) {
///     if (extension == 'txt') return Icon(Icons.text_snippet);
///     return Icon(Icons.insert_drive_file);
///   },
///   child: MyFileList(),
/// )
/// ```
///
/// Example using icon map:
/// ```dart
/// FileIconProvider(
///   icons: {
///     'pdf': Icon(Icons.picture_as_pdf),
///     'jpg': Icon(Icons.image),
///   },
///   child: MyFileList(),
/// )
/// ```
class FileIconProvider extends StatelessWidget {
  /// Builder function for creating file icons.
  final FileIconBuilder? builder;

  /// Map of file extensions to icon widgets.
  final Map<String, Widget>? icons;

  /// The child widget.
  final Widget child;

  /// Creates a [FileIconProvider] using a builder function.
  const FileIconProvider.builder({
    super.key,
    FileIconBuilder this.builder = _buildFileIcon,
    required this.child,
  }) : icons = null;

  /// Creates a [FileIconProvider] using a static icon map.
  const FileIconProvider({super.key, required this.icons, required this.child})
    : builder = null;

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Data.inherit(
      data: FileIconProviderData._(builder: builder, icons: icons),
      child: child,
    );
  }

  /// Builds a file icon for the given extension using the configured provider.
  ///
  /// Parameters:
  /// - [context]: The build context to find the provider.
  /// - [extension]: The file extension (without the dot).
  ///
  /// Returns: The appropriate icon widget for the file type.
  static Widget buildIcon(BuildContext context, String extension) {
    final data = Data.maybeOf<FileIconProviderData>(context);
    if (data == null) {
      return _buildFileIcon(extension);
    }
    return data.buildIcon(extension);
  }
}

//
// class SingleFileInput extends StatelessWidget {
//   final XFile? file;
//   final ValueChanged<XFile?>? onChanged;
//   final bool acceptDrop;
//   final bool enabled;
//
//   const SingleFileInput({
//     super.key,
//     this.file,
//     this.onChanged,
//     this.acceptDrop = false,
//     this.enabled = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     throw UnimplementedError();
//   }
// }
