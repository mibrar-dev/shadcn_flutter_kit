import 'package:file_picker/file_picker.dart' as native_picker;

import '../../../../ui/shadcn/components/form/file_picker/file_picker.dart'
    as shadcn_file_picker;

Future<List<shadcn_file_picker.FileLike>> pickFilesWithPackage(
  shadcn_file_picker.FileUploadPickRequest request,
) async {
  final allowedExtensions = normalizeFilePickerAllowedExtensions(
    request.allowedExtensions,
  );

  final result = await native_picker.FilePicker.pickFiles(
    allowMultiple: request.allowMultiple,
    withData: request.withData,
    type: allowedExtensions == null || allowedExtensions.isEmpty
        ? native_picker.FileType.any
        : native_picker.FileType.custom,
    allowedExtensions: allowedExtensions,
  );

  if (result == null || result.files.isEmpty) {
    return const [];
  }

  final stamp = DateTime.now().microsecondsSinceEpoch;
  return result.files.asMap().entries.map((entry) {
    final index = entry.key;
    final file = entry.value;
    final extension = _resolveExtension(file.name, file.extension);
    return shadcn_file_picker.FileLike(
      id: file.identifier ?? '${stamp}_${index}_${file.name}',
      name: file.name,
      size: file.size,
      bytes: file.bytes,
      path: file.path,
      extension: extension,
      mimeType: _mimeFromExtension(extension),
      source: file,
    );
  }).toList(growable: false);
}

List<String>? normalizeFilePickerAllowedExtensions(
  Iterable<String>? extensions,
) {
  final normalized = extensions
      ?.map((ext) => ext.trim().toLowerCase().replaceFirst('.', ''))
      .where((ext) => ext.isNotEmpty)
      .toList(growable: false);
  return normalized == null || normalized.isEmpty ? null : normalized;
}

String _resolveExtension(String name, String? extension) {
  if (extension != null && extension.isNotEmpty) {
    return extension.toLowerCase();
  }
  final parts = name.split('.');
  if (parts.length < 2) {
    return '';
  }
  return parts.last.toLowerCase();
}

String? _mimeFromExtension(String extension) {
  if (extension.isEmpty) {
    return null;
  }
  const mimeByExtension = <String, String>{
    'bmp': 'image/bmp',
    'csv': 'text/csv',
    'doc': 'application/msword',
    'docx':
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'gif': 'image/gif',
    'heic': 'image/heic',
    'jpeg': 'image/jpeg',
    'jpg': 'image/jpeg',
    'json': 'application/json',
    'mov': 'video/quicktime',
    'mp4': 'video/mp4',
    'pdf': 'application/pdf',
    'png': 'image/png',
    'svg': 'image/svg+xml',
    'txt': 'text/plain',
    'webp': 'image/webp',
    'xls': 'application/vnd.ms-excel',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  };
  return mimeByExtension[extension];
}
