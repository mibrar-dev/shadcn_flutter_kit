// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../drawer.dart';

/// Type alias for `BackdropBuilder` used by public or internal APIs.
typedef BackdropBuilder =
    Widget Function(
      BuildContext context,
      Widget child,
      Animation<double> animation,
      int stackIndex,
    );

/// Builder function for drawer modal barriers.
///
/// Creates an optional barrier widget that appears over the backdrop when
/// the drawer is modal. Typically used for dimming and dismissal handling.
///
/// Parameters:
/// - [context] (BuildContext): Build context
/// - [child] (Widget): Content behind the barrier
/// - [animation] (`Animation<double>`): Animation value from 0 (closed) to 1 (open)
/// - [stackIndex] (int): Index of the drawer in the stack
///
/// Returns the barrier widget or null if no barrier needed.
typedef BarrierBuilder =
    Widget? Function(
      BuildContext context,
      Widget child,
      Animation<double> animation,
      int stackIndex,
    );

/// Data class representing a drawer overlay entry in the stack.
///
/// Encapsulates all configuration and state needed to render a single
/// drawer overlay, including builders, animation, theming, and positioning.
