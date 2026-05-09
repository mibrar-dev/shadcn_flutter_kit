// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _ChipInputPreviewState stores and manages mutable widget state.
class _ChipInputPreviewState extends State<ChipInputPreview> {
  /// Field storing `_suggestions` for this form implementation.
  List<String> _suggestions = [];
  final ChipEditingController<String> _controller = ChipEditingController();

  static const List<String> _availableSuggestions = [
    'hello world',
    'lorem ipsum',
    'do re mi',
    'foo bar',
    'flutter dart',
  ];

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      /// Triggers a rebuild after mutating local state.
      setState(() {
        final value = _controller.textAtCursor;
        if (value.isNotEmpty) {
          _suggestions = _availableSuggestions.where((element) {
            return element.startsWith(value);
          }).toList();
        } else {
          _suggestions = [];
        }
      });
    });
  }

  /// Releases resources owned by this state object.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoComplete(
              suggestions: _suggestions,
              child: ChipInput<String>(
                controller: _controller,
                onChipSubmitted: (value) {
                  /// Triggers a rebuild after mutating local state.
                  setState(() {
                    _suggestions = [];
                  });
                  return '@$value';
                },
                chipBuilder: (context, chip) {
                  return Text(chip);
                },
              ),
            ),
            const DensityGap(gap2xl),
            ListenableBuilder(
              listenable: _controller,
              builder: (context, child) {
                return Text('Current chips: ${_controller.chips.join(', ')}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
