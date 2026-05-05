part of '../../text_field.dart';

/// _AutoCompleteItemState stores and manages mutable widget state.
class _AutoCompleteItemState extends State<_AutoCompleteItem> {
  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return SelectedButton(
      value: widget.selected,
      alignment: AlignmentDirectional.centerStart,
      onChanged: (value) {
        widget.onSelected();
      },
      child: Text(widget.suggestion),
    );
  }

  /// Reacts to widget configuration updates from the parent.
  @override
  void didUpdateWidget(covariant _AutoCompleteItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (!mounted) {
          return;
        }
        if (widget.selected) {
          Scrollable.ensureVisible(context);
        }
      });
    }
  }
}
