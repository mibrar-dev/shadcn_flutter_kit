// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../drawer.dart';

/// DrawerEntryWidget defines a reusable type for this registry module.
class DrawerEntryWidget<T> extends StatefulWidget {
  /// Builder function for the drawer content.
  final DrawerBuilder builder;

  /// Backdrop widget (content behind the drawer).
  final Widget backdrop;

  /// Builder for transforming the backdrop.
  final BackdropBuilder backdropBuilder;

  /// Builder for the modal barrier.
  final BarrierBuilder barrierBuilder;

  /// Whether the drawer is modal (blocks interaction with backdrop).
  final bool modal;

  /// Captured theme data to apply within the drawer.
  final CapturedThemes? themes;

  /// Captured inherited data to propagate.
  final CapturedData? data;

  /// Completer for the drawer's result value.
  final Completer<T> completer;

  /// Position of the drawer (left, right, top, bottom, start, end).
  final OverlayPosition position;

  /// Index of this drawer in the stack.
  final int stackIndex;

  /// Total number of drawers in the stack.
  final int totalStack;

  /// Whether to apply safe area insets.
  final bool useSafeArea;

  /// Optional external animation controller.
  final AnimationController? animationController;

  /// Whether to automatically open on mount.
  final bool autoOpen;

  /// Creates a drawer entry widget.
  const DrawerEntryWidget({
    super.key,
    required this.builder,
    required this.backdrop,
    required this.backdropBuilder,
    required this.barrierBuilder,
    required this.modal,
    required this.themes,
    required this.completer,
    required this.position,
    required this.stackIndex,
    required this.totalStack,
    required this.data,
    required this.useSafeArea,
    required this.animationController,
    required this.autoOpen,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<DrawerEntryWidget<T>> createState() => DrawerEntryWidgetState<T>();
}

/// State class for [DrawerEntryWidget] managing drawer animations and lifecycle.
///
/// Handles animation control, focus management, and drawer dismissal.
/// Manages both internal and external animation controllers.
