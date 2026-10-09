// Clipboard serialization for a token field.
//
// A token occupies a private-use code unit in the controller text, so the
// default copy would put an invisible character on the system clipboard. These
// types convert a selection into printable text and back, so copying a chip
// yields the value behind it and a custom handler can round-trip chips.
//
// Ported from `components/form/chip_input/_impl/utils/chip_clipboard_handler.dart`
// (345 lines). `DecoratedChipClipboardHandler` and its prefix/suffix/escape
// grammar had no caller in this repo and are not part of the target design; see
// the component README.

import 'package:flutter/services.dart';

/// One piece of a copied selection: either a token or a run of plain text.
sealed class TokenFragment<T> {
  const TokenFragment();
}

/// A run of plain text, free of token code units.
final class TokenTextFragment<T> extends TokenFragment<T> {
  /// Creates a text fragment.
  const TokenTextFragment(this.text);

  /// The text.
  final String text;

  @override
  String toString() => 'TokenTextFragment("$text")';
}

/// A token carried across the clipboard.
final class TokenValueFragment<T> extends TokenFragment<T> {
  /// Creates a token fragment.
  const TokenValueFragment(this.value);

  /// The token value.
  final T value;

  @override
  String toString() => 'TokenValueFragment($value)';
}

/// Converts a token selection to and from the system clipboard.
///
/// [serialize] receives the selection as fragments — plain text runs and tokens
/// — so a handler can render each token however it likes. [deserialize] parses
/// clipboard text back into fragments to insert.
abstract class TokenClipboardHandler<T> {
  /// Const constructor for subclasses.
  const TokenClipboardHandler();

  /// Converts pasted clipboard [content] into fragments to insert.
  List<TokenFragment<T>> deserializeClipboard(String content);

  /// Converts the selected [content] into a string for the clipboard.
  String serializeClipboard(List<TokenFragment<T>> content);
}

/// The default [TokenClipboardHandler]: tokens serialize with [chipSerializer]
/// (or `toString`) and pasted text stays plain text.
///
/// Two adjacent tokens are separated by [chipSeparator], so a copy of
/// `["ab", "cd"]` is `ab, cd` rather than the unreadable `abcd` the old default
/// produced.
///
/// Give [chipDeserializer] to read pasted text back as chips: the content is
/// split on [chipSeparator] and every piece runs through the parser, so a
/// round-trip of `ab, cd` produces two tokens again instead of one string.
class PlainTokenClipboardHandler<T> extends TokenClipboardHandler<T> {
  /// Creates a plain-text handler.
  const PlainTokenClipboardHandler({
    this.chipSerializer,
    this.chipSeparator = ', ',
    this.chipDeserializer,
  });

  /// Converts a chip value into its clipboard string; defaults to `toString`.
  final String Function(T value)? chipSerializer;

  /// Written between two adjacent chips on copy, and the split point on paste.
  final String chipSeparator;

  /// Turns a pasted piece back into a chip value; null rejects the piece, which
  /// then stays plain text. Null (the default) skips the split entirely and
  /// pastes [content] verbatim.
  final T? Function(String text)? chipDeserializer;

  @override
  List<TokenFragment<T>> deserializeClipboard(String content) {
    if (content.isEmpty) {
      return const <Never>[];
    }
    if (chipDeserializer == null || chipSeparator.isEmpty) {
      return <TokenFragment<T>>[TokenTextFragment<T>(content)];
    }
    final List<TokenFragment<T>> out = <TokenFragment<T>>[];
    for (final String raw in content.split(chipSeparator)) {
      final String piece = raw.trim();
      if (piece.isEmpty) {
        continue;
      }
      final T? value = chipDeserializer!(piece);
      out.add(
        value == null
            ? TokenTextFragment<T>(piece)
            : TokenValueFragment<T>(value),
      );
    }
    return out;
  }

  @override
  String serializeClipboard(List<TokenFragment<T>> content) {
    final StringBuffer buffer = StringBuffer();
    TokenFragment<T>? previous;
    for (final TokenFragment<T> fragment in content) {
      switch (fragment) {
        case TokenValueFragment<T>(:final T value):
          if (previous is TokenValueFragment<T> && chipSeparator.isNotEmpty) {
            buffer.write(chipSeparator);
          }
          buffer.write(chipSerializer?.call(value) ?? value.toString());
        case TokenTextFragment<T>(:final String text):
          buffer.write(text);
      }
      previous = fragment;
    }
    return buffer.toString();
  }
}

/// Serializes [fragments] with [handler] and writes them to the system
/// clipboard. Nothing is written when the serialization comes out empty.
Future<void> copyTokenClipboard<T>(
  TokenClipboardHandler<T> handler,
  List<TokenFragment<T>> fragments,
) async {
  final String text = handler.serializeClipboard(fragments);
  if (text.isNotEmpty) {
    await Clipboard.setData(ClipboardData(text: text));
  }
}

/// Reads the system clipboard's plain text and turns it into [fragments] with
/// [handler]; null when the clipboard is empty or unreadable.
Future<List<TokenFragment<T>>?> pasteTokenClipboard<T>(
  TokenClipboardHandler<T> handler,
) async {
  final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
  final String? content = data?.text;
  if (content == null || content.isEmpty) {
    return null;
  }
  return handler.deserializeClipboard(content);
}
