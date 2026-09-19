// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chip_input.dart';

/// Handles serialization of [ChipInput] content to and from the clipboard.
///
/// When content is copied out of a [ChipInput], the selection is provided as a
/// list of [InlineSpan]s in which chips appear as [ChipSpan]s.
/// [serializeClipboard] turns that into a plain [String] for the system
/// clipboard, and [deserializeClipboard] turns pasted text back into spans so
/// that chips can be reconstructed on paste.
///
/// Note: chips render as [ChipSpan]s (a [WidgetSpan] subclass), so the span
/// lists use [InlineSpan] rather than [TextSpan]; a [ChipSpan] is not a
/// [TextSpan].
///
/// Upstream parity: ported from `chip_input.dart` upstream.
abstract class ClipboardHandler<T> {
  /// Const constructor for subclasses.
  const ClipboardHandler();

  /// Converts pasted clipboard [content] into a list of spans to insert.
  ///
  /// Returned [ChipSpan]s are inserted as chips, while [TextSpan]s (and their
  /// text descendants) are inserted as plain text.
  List<InlineSpan> deserializeClipboard(String content);

  /// Converts the selected [content] into a plain string for the clipboard.
  ///
  /// Chips are provided as [ChipSpan]s so [ChipSpan.value] can be serialized
  /// instead of the internal placeholder character.
  String serializeClipboard(List<InlineSpan> content);
}

/// Default [ClipboardHandler] that serializes chips with [chipSerializer] (or
/// [Object.toString]) and pastes clipboard text as plain text.
///
/// Upstream parity: ported from `chip_input.dart` upstream.
class DefaultChipClipboardHandler<T> extends ClipboardHandler<T> {
  /// Converts a chip value into its clipboard string representation.
  ///
  /// Falls back to [Object.toString] when null.
  final String Function(T value)? chipSerializer;

  /// Separator inserted between two adjacent chips when serializing.
  final String chipSeparator;

  /// Creates a [DefaultChipClipboardHandler].
  const DefaultChipClipboardHandler({
    this.chipSerializer,
    this.chipSeparator = '',
  });

  @override
  List<InlineSpan> deserializeClipboard(String content) {
    return [TextSpan(text: content)];
  }

  @override
  String serializeClipboard(List<InlineSpan> content) {
    final buffer = StringBuffer();
    InlineSpan? previous;
    for (final span in content) {
      if (span is ChipSpan<T>) {
        if (previous is ChipSpan<T> && chipSeparator.isNotEmpty) {
          buffer.write(chipSeparator);
        }
        buffer.write(chipSerializer?.call(span.value) ?? span.value.toString());
      } else if (span is TextSpan) {
        buffer.write(span.text ?? '');
      }
      previous = span;
    }
    return buffer.toString();
  }
}

/// A [ClipboardHandler] that decorates chips with a [prefix] and/or [suffix].
///
/// On copy, each chip is written as `prefix + value + suffix`. On paste, the
/// same delimiters are detected to reconstruct chips, so tokens such as
/// `@username` (prefix `@`, no suffix) or `${variable}` (prefix `${`, suffix
/// `}`) round-trip as chips instead of plain text.
///
/// When [suffix] is null or empty, a chip token runs from [prefix] up to the
/// start of the next [prefix] (or the end of the string), so chip values may
/// contain whitespace but any plain text following a chip is absorbed into it.
/// When both delimiters are present, a token runs from [prefix] up to the first
/// following [suffix], which unambiguously supports chips mixed with plain text.
///
/// Providing a [delimiter] writes that separator between adjacent chips on copy
/// and treats it as an explicit token boundary on paste. This disambiguates
/// prefix-only mode: e.g. with `prefix: '@'` and `delimiter: ', '`, three chips
/// serialize as `@hello world, @something, @a` and paste back as three chips
/// even though the values contain whitespace.
///
/// Reconstructing chips on paste requires [chipDeserializer] to turn the inner
/// text back into a value of type [T]. When it is null, pasted text is inserted
/// verbatim as plain text (copy still applies the decoration). For string
/// chips, pass `chipDeserializer: (inner) => inner`.
///
/// When [escapeDecoration] is true, occurrences of the [prefix], [suffix] and
/// [escapeCharacter] inside chip values (and inside surrounding plain text) are
/// escaped on copy and unescaped on paste. This avoids ambiguity such as a chip
/// value `@chip` with prefix `@` serializing to `@@chip` and being read back as
/// the plain text `@` followed by a chip `chip`; with escaping it serializes to
/// `@\@chip` and round-trips as the single chip `@chip`.
///
/// Upstream parity: ported from `chip_input.dart` upstream.
class DecoratedChipClipboardHandler<T> extends ClipboardHandler<T> {
  /// Text prepended to each chip value when serializing, and used as the
  /// opening delimiter when detecting chips on paste.
  final String? prefix;

  /// Text appended to each chip value when serializing, and used as the
  /// closing delimiter when detecting chips on paste.
  final String? suffix;

  /// Converts a chip value into the inner text placed between [prefix] and
  /// [suffix]. Falls back to [Object.toString] when null.
  final String Function(T value)? chipSerializer;

  /// Converts the inner text of a detected token back into a chip value.
  ///
  /// When null, paste does not reconstruct chips and inserts plain text.
  final T Function(String inner)? chipDeserializer;

  /// Whether to escape [prefix], [suffix] and [escapeCharacter] occurrences so
  /// that delimiter characters appearing inside values or plain text do not get
  /// mistaken for chip boundaries when deserializing.
  final bool escapeDecoration;

  /// The character sequence used to escape delimiters when [escapeDecoration]
  /// is true. Defaults to a backslash.
  final String escapeCharacter;

  /// Separator written between adjacent chips on copy and consumed as a token
  /// boundary on paste. When null or empty, no separator is used.
  final String? delimiter;

  /// Whether to also escape plain (non-chip) text so that it is not accidentally
  /// split on a [delimiter] or mistaken for a chip because it happens to contain
  /// the [prefix]/[suffix].
  ///
  /// Requires [escapeDecoration]. Defaults to false, in which case plain text is
  /// copied verbatim and delimiter/prefix/suffix sequences appearing in it may
  /// be reinterpreted as chip boundaries on paste.
  final bool escapeNonChip;

  /// Creates a [DecoratedChipClipboardHandler].
  const DecoratedChipClipboardHandler({
    this.prefix,
    this.suffix,
    this.chipSerializer,
    this.chipDeserializer,
    this.escapeDecoration = true,
    this.escapeCharacter = r'\',
    this.delimiter,
    this.escapeNonChip = false,
  });

  /// Escapes [escapeCharacter], [prefix], [suffix] and [delimiter] occurrences
  /// in [value] by prefixing each with [escapeCharacter].
  String _escape(String value, String p, String s) {
    final esc = escapeCharacter;
    if (esc.isEmpty) return value;
    final d = delimiter ?? '';
    final buffer = StringBuffer();
    int i = 0;
    while (i < value.length) {
      if (value.startsWith(esc, i)) {
        buffer.write(esc);
        buffer.write(esc);
        i += esc.length;
      } else if (p.isNotEmpty && value.startsWith(p, i)) {
        buffer.write(esc);
        buffer.write(p);
        i += p.length;
      } else if (s.isNotEmpty && value.startsWith(s, i)) {
        buffer.write(esc);
        buffer.write(s);
        i += s.length;
      } else if (d.isNotEmpty && value.startsWith(d, i)) {
        buffer.write(esc);
        buffer.write(d);
        i += d.length;
      } else {
        buffer.write(value[i]);
        i++;
      }
    }
    return buffer.toString();
  }

  /// Reads the literal value of an escape sequence in [content] starting at
  /// [pos], where [content] starts with [escapeCharacter] at [pos]. Returns the
  /// unescaped literal and the index just past the consumed sequence.
  (String, int) _readEscaped(String content, int pos, String p, String s) {
    final esc = escapeCharacter;
    final d = delimiter ?? '';
    final int i = pos + esc.length;
    if (i >= content.length) {
      // Dangling escape character: drop it.
      return ('', i);
    }
    if (p.isNotEmpty && content.startsWith(p, i)) {
      return (p, i + p.length);
    }
    if (s.isNotEmpty && content.startsWith(s, i)) {
      return (s, i + s.length);
    }
    if (d.isNotEmpty && content.startsWith(d, i)) {
      return (d, i + d.length);
    }
    if (content.startsWith(esc, i)) {
      return (esc, i + esc.length);
    }
    return (content[i], i + 1);
  }

  bool _escaping(String p, String s) =>
      escapeDecoration &&
      escapeCharacter.isNotEmpty &&
      (p.isNotEmpty || s.isNotEmpty);

  @override
  String serializeClipboard(List<InlineSpan> content) {
    final buffer = StringBuffer();
    final p = prefix ?? '';
    final s = suffix ?? '';
    final d = delimiter ?? '';
    final escaping = _escaping(p, s);
    bool previousWasChip = false;
    for (final span in content) {
      if (span is ChipSpan<T>) {
        if (previousWasChip && d.isNotEmpty) {
          buffer.write(d);
        }
        final inner = chipSerializer?.call(span.value) ?? span.value.toString();
        buffer.write(p);
        buffer.write(escaping ? _escape(inner, p, s) : inner);
        buffer.write(s);
        previousWasChip = true;
      } else if (span is TextSpan) {
        final text = span.text ?? '';
        buffer.write(escaping && escapeNonChip ? _escape(text, p, s) : text);
        previousWasChip = false;
      }
    }
    return buffer.toString();
  }

  @override
  List<InlineSpan> deserializeClipboard(String content) {
    final parser = chipDeserializer;
    final p = prefix ?? '';
    final s = suffix ?? '';
    // Without a parser or an opening delimiter there is nothing to detect.
    if (parser == null || p.isEmpty) {
      return [TextSpan(text: content)];
    }
    final String d = delimiter ?? '';
    final bool escaping = _escaping(p, s);
    final List<InlineSpan> spans = [];
    final StringBuffer textBuffer = StringBuffer();

    void flushText() {
      if (textBuffer.isNotEmpty) {
        spans.add(TextSpan(text: textBuffer.toString()));
        textBuffer.clear();
      }
    }

    int i = 0;
    while (i < content.length) {
      // An escaped delimiter at the top level is literal text. Only unescape
      // here when plain text was escaped on copy ([escapeNonChip]); otherwise
      // the escape character is taken literally.
      if (escaping && escapeNonChip && content.startsWith(escapeCharacter, i)) {
        final (literal, next) = _readEscaped(content, i, p, s);
        textBuffer.write(literal);
        i = next;
        continue;
      }
      if (content.startsWith(p, i)) {
        final int innerStart = i + p.length;
        final StringBuffer inner = StringBuffer();
        int j = innerStart;
        bool closed = false;
        while (j < content.length) {
          if (escaping && content.startsWith(escapeCharacter, j)) {
            final (literal, next) = _readEscaped(content, j, p, s);
            inner.write(literal);
            j = next;
            continue;
          }
          if (s.isNotEmpty) {
            if (content.startsWith(s, j)) {
              j += s.length;
              closed = true;
              break;
            }
          } else if (d.isNotEmpty && content.startsWith(d, j)) {
            // No suffix: an explicit delimiter ends the token.
            break;
          } else if (content.startsWith(p, j)) {
            // No suffix: the token also ends at the start of the next prefixed
            // token, so adjacent chips such as `@test@hello@world` split back
            // into separate chips while values may still contain whitespace.
            break;
          }
          inner.write(content[j]);
          j++;
        }
        if (s.isNotEmpty && !closed) {
          // No closing delimiter: treat the prefix as literal text.
          textBuffer.write(p);
          i = innerStart;
          continue;
        }
        final String innerStr = inner.toString();
        if (innerStr.isEmpty) {
          // Empty token, e.g. an isolated delimiter: keep it as literal text.
          textBuffer.write(p);
          i = innerStart;
          continue;
        }
        flushText();
        spans.add(
          ChipSpan<T>(value: parser(innerStr), child: const SizedBox.shrink()),
        );
        i = j;
        // Consume a separator immediately following the chip, if present.
        if (d.isNotEmpty && content.startsWith(d, i)) {
          i += d.length;
        }
      } else {
        textBuffer.write(content[i]);
        i++;
      }
    }
    flushText();
    return spans;
  }
}
