import 'package:flutter/widgets.dart';

import 'registry/components/app/app.dart';
import 'registry/components/file_diff_viewer/preview.dart';

void main() {
  runApp(const _RegistryApp());
}

class _RegistryApp extends StatelessWidget {
  const _RegistryApp();

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      title: 'File Diff Viewer Preview',
      home: Builder(builder: fileDiffViewerPreviews.first.builder),
    );
  }
}
