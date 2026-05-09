// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart'
    hide Theme, TextField, ErrorWidgetBuilder;

import 'command_dialog.dart';
import '../state/command_state.dart';

/// Command palette with search input, results, and keyboard handling.
class Command extends StatefulWidget {
  const Command({
    super.key,
    required this.builder,
    this.autofocus = true,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.emptyBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.searchPlaceholder,
  });

  /// Search results builder.
  final CommandBuilder builder;

  /// Auto-focus the search field.
  final bool autofocus;

  /// Debounce delay for search input.
  final Duration debounceDuration;

  /// Empty state builder override.
  final WidgetBuilder? emptyBuilder;

  /// Error builder override.
  final ErrorWidgetBuilder? errorBuilder;

  /// Loading state builder.
  final WidgetBuilder? loadingBuilder;

  /// Optional surface opacity override.
  final double? surfaceOpacity;

  /// Optional surface blur override.
  final double? surfaceBlur;

  /// Placeholder widget for the search input.
  final Widget? searchPlaceholder;

  @override
  /// Executes `createState` behavior for this component/composite.
  State<Command> createState() => CommandState();
}
