// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'markdown_file_loader_stub.dart'
    if (dart.library.io) 'markdown_file_loader_io.dart'
    as impl;

Future<String> loadMarkdownFile(String path) {
  return impl.loadMarkdownFile(path);
}
