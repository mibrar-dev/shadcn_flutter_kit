// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../utility/shadcn_localizations/shadcn_localizations.dart';
import 'app.dart';

class AppPreview extends StatelessWidget {
  const AppPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      title: 'ShadcnApp Preview',
      localizationsDelegates: ShadcnLocalizations.localizationsDelegates,
      supportedLocales: ShadcnLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: const Scaffold(
        child: Center(child: Text('ShadcnApp is wired and running.')),
      ),
    );
  }
}
