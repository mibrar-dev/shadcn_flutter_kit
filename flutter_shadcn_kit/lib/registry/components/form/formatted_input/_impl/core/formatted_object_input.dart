// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../formatted_input.dart';

/// A formatted input widget that works with complex objects.
///
/// [FormattedObjectInput] extends formatted input functionality to handle
/// objects of type [T], converting between the object and its formatted
/// string representation. It can optionally display a popup for advanced editing.
///
/// Example:
/// ```dart
/// FormattedObjectInput<DateTime>(
///   converter: dateConverter,
///   parts: [
///     InputPart.editable(length: 2, width: 30), // Month
///     InputPart.static('/'),
///     InputPart.editable(length: 2, width: 30), // Day
///   ],
///   popupBuilder: (context, controller) => CalendarWidget(),
/// )
/// ```
class FormattedObjectInput<T> extends StatefulWidget
    with ControlledComponent<T?>
    implements Styleable<FormattedInputTheme> {
  /// The initial value of the input.
  @override
  final T? initialValue;

  /// Called when the value changes.
  @override
  final ValueChanged<T?>? onChanged;

  /// Called when the individual parts change.
  final ValueChanged<List<String>>? onPartsChanged;

  /// Builder for creating a custom popup widget.
  final FormattedInputPopupBuilder<T>? popupBuilder;

  /// Whether the input is enabled.
  @override
  final bool enabled;

  /// Optional controller for external control.
  @override
  final ComponentController<T?>? controller;

  /// Converter between the object type and string parts.
  final BiDirectionalConvert<T?, List<String?>> converter;

  /// The input parts that make up the formatted input.
  final List<InputPart> parts;

  /// Alignment of the popover relative to the anchor.
  final AlignmentGeometry? popoverAlignment;

  /// Anchor alignment for popover positioning.
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Offset for the popover position.
  final Offset? popoverOffset;

  /// Upstream-parity overlay configuration override for the popup.
  ///
  /// Accepted and stored for API compatibility. The registry popup is always
  /// presented via [PopoverController] with the `popover*` parameters above,
  /// which has no `OverlayConfiguration` concept, so this value cannot be
  /// honored.
  @Deprecated(
    'Stored for upstream parity only; use popoverAlignment/popoverAnchorAlignment/popoverOffset instead.',
  )
  final Object? overlayConfiguration;

  /// Upstream-parity adaptive overlay flag for the popup.
  ///
  /// Accepted and stored for API compatibility. The registry popup always
  /// presents as an anchored popover, so this value cannot be honored.
  @Deprecated(
    'Stored for upstream parity only; the registry popup is never adaptive.',
  )
  final bool? adaptiveOverlay;

  /// Icon displayed in the popover trigger.
  final Widget? popoverIcon;

  /// Styling for this widget alone, overriding the ancestor theme.
  @override
  final FormattedInputTheme? theme;

  /// Creates a [FormattedObjectInput].
  const FormattedObjectInput({
    super.key,
    this.initialValue,
    this.onChanged,
    this.popupBuilder,
    this.enabled = true,
    this.controller,
    required this.converter,
    required this.parts,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.popoverOffset,
    this.overlayConfiguration,
    this.adaptiveOverlay,
    this.popoverIcon,
    this.onPartsChanged,
    this.theme,
  });

  /// Creates the `State` object for this widget.
  @override
  State<FormattedObjectInput<T>> createState() =>
      _FormattedObjectInputState<T>();
}
