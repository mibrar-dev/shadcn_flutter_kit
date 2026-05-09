// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'markdown_link_opener_stub.dart'
    if (dart.library.html) 'markdown_link_opener_web.dart'
    if (dart.library.io) 'markdown_link_opener_io.dart'
    as impl;

Future<bool> openMarkdownLink(String url) {
  return impl.openMarkdownLink(url);
}
