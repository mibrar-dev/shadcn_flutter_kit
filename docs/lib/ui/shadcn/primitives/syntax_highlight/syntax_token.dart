// The token model shared by the syntax scanners and the span builder.
//
// A tokenizer emits [SyntaxToken]s for the ranges it recognizes; everything
// else is plain. Tokens never overlap (the lexer resolves overlaps by rule
// priority) and never extend past the end of the input, so spans built from
// them concatenate back to the source exactly — selection and copy keep
// yielding the plain text.

import '../../theme/syntax_colors.dart';

/// One recognized range of source text.
class SyntaxToken {
  /// Creates a token of [kind] covering `[start, end)`.
  const SyntaxToken(this.kind, this.start, this.end);

  /// The token kind (picked up by [SyntaxColors.colorFor]).
  final SyntaxTokenKind kind;

  /// Start offset in the source.
  final int start;

  /// End offset (exclusive) in the source.
  final int end;

  @override
  String toString() => '${kind.name}($start-$end)';
}
