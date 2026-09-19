// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chat.dart';

/// Returns [color] lightened by [amount] in HSL lightness.
///
/// Local equivalent of the upstream `lighten` helper, kept inside this
/// component so the shared color utilities stay untouched.
Color _chatReactionLighten(Color color, [double amount = 0.1]) {
  final hsl = HSLColor.fromColor(color);
  return hsl
      .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
      .toColor();
}

/// Returns [color] darkened by [amount] in HSL lightness.
///
/// Local equivalent of the upstream `darken` helper, kept inside this
/// component so the shared color utilities stay untouched.
Color _chatReactionDarken(Color color, [double amount = 0.1]) {
  final hsl = HSLColor.fromColor(color);
  return hsl
      .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
      .toColor();
}

/// The default pill that a [ChatReaction]'s badge sits in.
///
/// Draws a rounded, muted container with a border thick enough to read as a
/// cut-out against the bubble underneath. Pass any content — an emoji, a count,
/// a row of both.
///
/// ```dart
/// ChatReactionContainer(child: Text('🎉 3'));
/// ```
///
/// Override the look through [ChatReactionTheme.decoration] and
/// [ChatReactionTheme.containerPadding].
class ChatReactionContainer extends StatelessWidget implements Styleable<ChatReactionTheme> {
  /// The reaction content, typically an emoji and a count.
  final Widget child;

  /// Styling for this widget alone, overriding the ancestor theme.
  @override
  final ChatReactionTheme? theme;


  /// Creates a reaction pill around [child].
  const ChatReactionContainer({super.key, required this.child, this.theme});

  /// Builds the widget tree for chat reaction container.
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final theme = this.theme ?? ComponentTheme.maybeOf<ChatReactionTheme>(context);
    return Container(
      decoration:
          theme?.decoration ??
          BoxDecoration(
            borderRadius: t.borderRadiusLg * 12,
            color: _chatReactionLighten(t.colorScheme.muted, 0.05),
            border: Border.all(
              color: _chatReactionDarken(t.colorScheme.muted, 0.1),
              width: 3 * t.scaling,
            ),
          ),
      padding:
          theme?.containerPadding ??
          EdgeInsets.symmetric(
            horizontal: 6 * t.scaling,
            vertical: 4 * t.scaling,
          ),
      child: child,
    );
  }
}
