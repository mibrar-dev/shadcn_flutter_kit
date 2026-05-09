// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../../shared/primitives/text.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/style_value.dart';

part '_impl/state/_code_snippet_state.dart';
part '_impl/themes/base/code_snippet_theme.dart';

/// Syntax highlighted code display with optional actions.
class CodeSnippet extends StatefulWidget {
  /// Constraints applied to the snippet area.
  final BoxConstraints? constraints;

  /// Additional action buttons rendered in the top-right corner.
  final List<Widget> actions;

  /// The widget that renders the code content (typically [Text]).
  final Widget code;

  /// Creates a code snippet display.
  const CodeSnippet({
    super.key,
    this.constraints,
    this.actions = const [],
    required this.code,
  });

  /// Creates the State object used by this code snippet widget.
  @override
  State<CodeSnippet> createState() => _CodeSnippetState();
}
