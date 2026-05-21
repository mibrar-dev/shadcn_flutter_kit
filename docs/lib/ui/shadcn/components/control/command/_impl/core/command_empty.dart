// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../../../shared/localizations/shadcn_localizations.dart';
import '../../../../../shared/primitives/text.dart';
import '../../../../../shared/utils/util.dart';

/// Default empty state shown when no command results match.
class CommandEmpty extends StatelessWidget {
  /// Creates a command empty state widget.
  const CommandEmpty({super.key});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final localizations = ShadcnLocalizations.of(context);
    return Center(
      child: Text(localizations.commandEmpty).withPadding(vertical: 24).small(),
    );
  }
}
