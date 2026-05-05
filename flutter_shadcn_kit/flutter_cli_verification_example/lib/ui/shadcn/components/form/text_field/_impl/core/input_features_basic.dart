part of '../../text_field.dart';

/// Position where an input feature is displayed.
///
/// Determines whether an input feature (icon, button, widget) appears on
/// the leading (left/start) or trailing (right/end) side of the input.
enum InputFeaturePosition {
  /// Display the feature on the leading side.
  leading,

  /// Display the feature on the trailing side.
  trailing,
}

/// A callback that provides suggestions based on a query string.
///
/// Parameters:
/// - [query] (`String`): The current input text to generate suggestions for.
///
/// Returns: `FutureOr<Iterable<String>>` — The list of suggestion strings.
typedef SuggestionBuilder = FutureOr<Iterable<String>> Function(String query);
