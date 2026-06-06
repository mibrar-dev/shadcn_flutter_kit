import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/display/file_diff_viewer/preview.dart';

import 'package:flutter_shadcn_kit/registry/components/layout/app/app.dart';
import 'package:flutter_shadcn_kit/registry/components/display/empty_state/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/utility/shadcn_localizations/shadcn_localizations.dart';
import 'package:flutter_shadcn_kit/registry/shared/theme/theme.dart' as shadcn;

void main() {
  runApp(const _RegistryApp());
}

class _RegistryApp extends StatelessWidget {
  const _RegistryApp();

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      title: 'File Diff Viewer Preview',
      theme: const shadcn.ThemeData(),
      localizationsDelegates: ShadcnLocalizations.localizationsDelegates,
      supportedLocales: ShadcnLocalizations.supportedLocales,
      home: const FileDiffViewerPreview(),
    );
  }
}
