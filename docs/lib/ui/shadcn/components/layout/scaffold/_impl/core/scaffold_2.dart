// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../scaffold.dart';

/// Scaffold defines a reusable type for this registry module.
class Scaffold extends StatefulWidget {
  /// Header widgets displayed at the top of the scaffold.
  final List<Widget> headers;

  /// Footer widgets displayed at the bottom of the scaffold.
  final List<Widget> footers;

  /// Main content widget.
  final Widget child;

  /// Loading progress value (0.0 to 1.0).
  final double? loadingProgress;

  /// Whether loading indicator shows indeterminate progress.
  final bool loadingProgressIndeterminate;

  /// Whether header floats above content (takes no layout space).
  final bool floatingHeader;

  /// Whether footer floats above content (takes no layout space).
  final bool floatingFooter;

  /// Background color for header section.
  final Color? headerBackgroundColor;

  /// Background color for footer section.
  final Color? footerBackgroundColor;

  /// Background color for the scaffold.
  final Color? backgroundColor;

  /// Whether to show loading sparks effect.
  final bool? showLoadingSparks;

  /// Whether to resize when keyboard appears.
  final bool? resizeToAvoidBottomInset;

  /// Creates a [Scaffold].
  const Scaffold({
    super.key,
    required this.child,
    this.headers = const [],
    this.footers = const [],
    this.loadingProgress,
    this.loadingProgressIndeterminate = false,
    this.floatingHeader = false,
    this.floatingFooter = false,
    this.backgroundColor,
    this.headerBackgroundColor,
    this.footerBackgroundColor,
    this.showLoadingSparks,
    this.resizeToAvoidBottomInset,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<Scaffold> createState() => ScaffoldState();
}
