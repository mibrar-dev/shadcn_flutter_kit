// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _AutocompletePreviewState stores and manages mutable widget state.
class _AutocompletePreviewState extends State<AutocompletePreview> {
  final List<String> suggestions = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Grape',
    'Kiwi',
    'Lemon',
    'Mango',
    'Orange',
    'Peach',
    'Pear',
    'Pineapple',
    'Strawberry',
    'Watermelon',
  ];

  /// Field storing `_currentSuggestions` for this form implementation.
  List<String> _currentSuggestions = [];
  final TextEditingController _controller = TextEditingController();

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 400,
              child: shadcn.AutoComplete(
                suggestions: _currentSuggestions,
                child: TextField(
                  controller: _controller,
                  placeholder: const Text('Type to search...'),
                  onChanged: (value) {
                    final query = value.trim().toLowerCase();

                    /// Triggers a rebuild after mutating local state.
                    setState(() {
                      if (query.isEmpty) {
                        _currentSuggestions = [];
                      } else {
                        _currentSuggestions = suggestions
                            .where((item) => item.toLowerCase().contains(query))
                            .toList();
                      }
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Releases resources owned by this state object.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
