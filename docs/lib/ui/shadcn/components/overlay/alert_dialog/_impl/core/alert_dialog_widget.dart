// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../alert_dialog.dart';

/// A modal dialog component for displaying alerts, confirmations, and other
/// focused modal interactions.
///
/// Provides a configurable header, content area, and action row while keeping
/// the same polished styling as the rest of the registry (blurred backdrop,
/// rounded container, spacing/gap helpers).
class AlertDialog extends StatefulWidget {
  /// Optional leading widget, typically an icon or graphic.
  final Widget? leading;

  /// Optional trailing widget for additional header controls.
  final Widget? trailing;

  /// Optional title widget displayed at the start of the dialog body.
  final Widget? title;

  /// Optional content widget placed below the title.
  final Widget? content;

  /// Optional list of action buttons displayed at the bottom of the dialog.
  final List<Widget>? actions;

  /// Optional blur radius for the modal surface.
  final double? surfaceBlur;

  /// Optional opacity for the modal surface.
  final double? surfaceOpacity;

  /// Optional barrier color for the backdrop.
  final Color? barrierColor;

  /// Optional padding inside the modal container.
  final EdgeInsetsGeometry? padding;

  const AlertDialog({
    super.key,
    this.leading,
    this.title,
    this.content,
    this.actions,
    this.trailing,
    this.surfaceBlur,
    this.surfaceOpacity,
    this.barrierColor,
    this.padding,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<AlertDialog> createState() => _AlertDialogState();
}
