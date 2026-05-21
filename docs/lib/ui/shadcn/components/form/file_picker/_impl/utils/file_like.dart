// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:typed_data';

/// FileLike represents a form-related type in the registry.
class FileLike {
  /// Constructs `FileLike` with the provided parameters.
  const FileLike({
    required this.id,
    required this.name,
    required this.size,
    this.bytes,
    this.path,
    this.mimeType,
    this.extension,
    this.source,
  });

  /// Field storing `id` for this form implementation.
  final String id;

  /// Field storing `name` for this form implementation.
  final String name;

  /// Field storing `size` for this form implementation.
  final int size;

  /// Field storing `bytes` for this form implementation.
  final Uint8List? bytes;

  /// Field storing `path` for this form implementation.
  final String? path;

  /// Field storing `mimeType` for this form implementation.
  final String? mimeType;

  /// Field storing `extension` for this form implementation.
  final String? extension;

  /// Field storing `source` for this form implementation.
  final Object? source;

  String get resolvedExtension {
    final explicit = extension;
    if (explicit != null && explicit.isNotEmpty) {
      return explicit.toLowerCase();
    }
    final parts = name.split('.');
    if (parts.length <= 1) return '';
    return parts.last.toLowerCase();
  }

  bool get isImage {
    final type = mimeType;
    if (type != null && type.startsWith('image/')) {
      return true;
    }
    const imageExtensions = [
      'png',
      'jpg',
      'jpeg',
      'gif',
      'webp',
      'bmp',
      'svg',
      'heic',
    ];
    return imageExtensions.contains(resolvedExtension);
  }
}
