// Dart source literal helpers for the docs codegen (`gen_docs_data.dart`).
//
// Kept tiny and dependency-free so every renderer escapes strings the same
// way; generated files must survive `dart format` and normal escape rules
// (`$`, `'`, `\`) without any post-processing.

/// Single-quoted Dart string literal for one line of [value].
///
/// Escapes `\`, `'` and `$`; newlines are emitted as `\n` escapes so a literal
/// never accidentally spans lines.
String dartString(String value) {
  final String escaped = value
      .replaceAll(r'\', r'\\')
      .replaceAll("'", r"\'")
      .replaceAll(r'$', r'\$')
      .replaceAll('\r\n', r'\n')
      .replaceAll('\n', r'\n')
      .replaceAll('\r', r'\n');
  return "'$escaped'";
}

/// Like [dartString], but prefers double quotes when the value contains `'`
/// and no `"`, `$` or newline (keeps generated import/description lines
/// readable).
String dartStringSmart(String value) {
  if (value.contains("'") &&
      !value.contains('"') &&
      !value.contains(r'$') &&
      !value.contains('\n') &&
      !value.contains('\r')) {
    final String escaped = value.replaceAll(r'\', r'\\');
    return '"$escaped"';
  }
  return dartString(value);
}

/// A Dart literal for a multi-line code block that preserves [code] verbatim.
///
/// Uses a raw triple-quoted string when the content allows it (the common
/// case); falls back to a fully escaped single-quoted string otherwise. Raw
/// string literals do not interpolate `$`, which is what code snippets need.
String dartCodeString(String code) {
  if (!code.contains("'''") && !code.endsWith("'")) {
    return "r'''$code'''";
  }
  return dartString(code);
}

/// `<indent>key: value,` line helper for generated const maps.
String mapEntry(String key, String value, {String indent = '  '}) =>
    '$indent${dartString(key)}: $value,';

/// Renders `head(args)` plus [suffix] on one line when everything fits in 80
/// columns, otherwise one argument per line with a trailing comma and the
/// closing parenthesis back at [indent]. [appended] is the number of
/// characters that follow on the same line (e.g. `,` of an enclosing list).
///
/// This mirrors the tall `dart format` style for plain calls; renderers use it
/// so the emitted files are format-clean without running the formatter.
String callExpr(
  String head,
  List<String> args, {
  String indent = '',
  String suffix = '',
  int appended = 0,
}) {
  final String flat = '$head(${args.join(', ')})$suffix';
  if (!flat.contains('\n') && indent.length + flat.length + appended <= 80) {
    return flat;
  }
  final String body = args.map((String arg) => '$indent  $arg,').join('\n');
  return '$head(\n$body\n$indent)$suffix';
}

/// Like [callExpr] for list literals (`head[items]`).
String listExpr(
  String head,
  List<String> items, {
  String indent = '',
  int appended = 0,
}) {
  if (items.isEmpty) {
    return '$head[]';
  }
  final String flat = '$head[${items.join(', ')}]';
  if (!flat.contains('\n') && indent.length + flat.length + appended <= 80) {
    return flat;
  }
  final String body = items.map((String item) => '$indent  $item,').join('\n');
  return '$head[\n$body\n$indent]';
}

/// A list literal of single-quoted strings.
String stringList(
  Iterable<String> values, {
  String indent = '',
  int appended = 0,
  String head = '<String>',
}) => listExpr(
  head,
  values.map(dartString).toList(growable: false),
  indent: indent,
  appended: appended,
);
