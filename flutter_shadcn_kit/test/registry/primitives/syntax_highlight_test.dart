// Unit tests for the syntax highlighter: language aliases, content guessing,
// per-language token goldens (representative snippets), string interpolation
// (Dart `$x`/`${}`, JS template literals), multi-line strings/comments, raw
// strings and escapes, span reconstruction, and a no-throw fuzz over random
// text plus every .dart file in the registry.

import 'dart:io';
import 'dart:math';

import 'package:flutter/widgets.dart';

import 'package:flutter_shadcn_kit/registry/primitives/syntax_highlight/syntax_highlight.dart';
import 'package:flutter_shadcn_kit/registry/theme/syntax_colors.dart';
import 'package:flutter_test/flutter_test.dart';

/// The token kind covering [offset], or null for plain text.
SyntaxTokenKind? kindAt(String code, SyntaxLanguage language, int offset) {
  for (final token in tokenize(code, language)) {
    if (offset >= token.start && offset < token.end) return token.kind;
  }
  return null;
}

/// The token kind covering the first char of [substring].
SyntaxTokenKind? kindOf(
  String code,
  SyntaxLanguage language,
  String substring,
) {
  final index = code.indexOf(substring);
  if (index < 0) fail('substring not found in code: $substring');
  return kindAt(code, language, index);
}

/// Asserts the spans concatenate back to [code] exactly and the tokens are
/// sorted, non-overlapping and in bounds — the contract that keeps
/// selection/copy plain.
void expectReconstruction(String code, SyntaxLanguage language) {
  final tokens = tokenize(code, language);
  var lastEnd = 0;
  for (final token in tokens) {
    expect(token.start, greaterThanOrEqualTo(lastEnd), reason: 'overlap');
    expect(token.end, lessThanOrEqualTo(code.length), reason: 'out of bounds');
    expect(token.end, greaterThan(token.start), reason: 'empty token');
    lastEnd = token.end;
  }
  final spans = buildSyntaxSpans(
    code: code,
    language: language,
    base: const TextStyle(),
    colors: SyntaxColors.light,
  );
  final buffer = StringBuffer();
  for (final span in spans) {
    buffer.write(span.text);
  }
  expect(buffer.toString(), code);
}

void main() {
  group('language ids', () {
    test('aliases map to languages', () {
      expect(syntaxLanguageFromId('dart'), SyntaxLanguage.dart);
      expect(syntaxLanguageFromId('js'), SyntaxLanguage.javascript);
      expect(syntaxLanguageFromId('javascript'), SyntaxLanguage.javascript);
      expect(syntaxLanguageFromId('ts'), SyntaxLanguage.typescript);
      expect(syntaxLanguageFromId('tsx'), SyntaxLanguage.tsx);
      expect(syntaxLanguageFromId('jsx'), SyntaxLanguage.jsx);
      expect(syntaxLanguageFromId('py'), SyntaxLanguage.python);
      expect(syntaxLanguageFromId('python'), SyntaxLanguage.python);
      expect(syntaxLanguageFromId('json'), SyntaxLanguage.json);
      expect(syntaxLanguageFromId('jsonc'), SyntaxLanguage.json);
      expect(syntaxLanguageFromId('yml'), SyntaxLanguage.yaml);
      expect(syntaxLanguageFromId('yaml'), SyntaxLanguage.yaml);
      expect(syntaxLanguageFromId('sh'), SyntaxLanguage.bash);
      expect(syntaxLanguageFromId('zsh'), SyntaxLanguage.bash);
      expect(syntaxLanguageFromId('shell'), SyntaxLanguage.bash);
      expect(syntaxLanguageFromId('html'), SyntaxLanguage.html);
      expect(syntaxLanguageFromId('css'), SyntaxLanguage.css);
      expect(syntaxLanguageFromId('kt'), SyntaxLanguage.kotlin);
      expect(syntaxLanguageFromId('kotlin'), SyntaxLanguage.kotlin);
      expect(syntaxLanguageFromId('swift'), SyntaxLanguage.swift);
      expect(syntaxLanguageFromId('md'), SyntaxLanguage.markdown);
      expect(syntaxLanguageFromId('markdown'), SyntaxLanguage.markdown);
    });

    test('unknown, empty and null ids are plain', () {
      expect(syntaxLanguageFromId(null), isNull);
      expect(syntaxLanguageFromId(''), isNull);
      expect(syntaxLanguageFromId('   '), isNull);
      expect(syntaxLanguageFromId('brainfuck'), isNull);
      expect(
        syntaxLanguageFromId('DART'),
        SyntaxLanguage.dart,
      ); // case-insensitive
    });
  });

  group('content guessing', () {
    test('fence tag wins', () {
      expect(syntaxLanguageGuess('```python\nx = 1'), SyntaxLanguage.python);
      expect(syntaxLanguageGuess('~~~js\nvar x'), SyntaxLanguage.javascript);
    });

    test('strong content signals', () {
      expect(
        syntaxLanguageGuess("import 'package:flutter/widgets.dart';"),
        SyntaxLanguage.dart,
      );
      expect(syntaxLanguageGuess('void main() {}'), SyntaxLanguage.dart);
      expect(syntaxLanguageGuess('#!/bin/bash\necho hi'), SyntaxLanguage.bash);
      expect(syntaxLanguageGuess('<!DOCTYPE html>'), SyntaxLanguage.html);
      expect(
        syntaxLanguageGuess('def f(x):\n    return x'),
        SyntaxLanguage.python,
      );
      expect(
        syntaxLanguageGuess('const x = () => 1;'),
        SyntaxLanguage.javascript,
      );
      expect(syntaxLanguageGuess('{"a": 1}'), SyntaxLanguage.json);
    });

    test('ambiguous text stays plain', () {
      expect(syntaxLanguageGuess('hello world'), isNull);
      expect(syntaxLanguageGuess(''), isNull);
      expect(syntaxLanguageGuess('just some words, no signals.'), isNull);
    });
  });

  group('goldens', () {
    test('dart', () {
      const code = '''
// line comment
/* block
   comment */
final x = 42;
const flag = true;
const s = 'hi';
const raw = r'a\\b';
class Foo extends Bar {
  void run() => print(s);
}
''';
      expect(
        kindOf(code, SyntaxLanguage.dart, '// line comment'),
        SyntaxTokenKind.comment,
      );
      expect(
        kindOf(code, SyntaxLanguage.dart, 'block'),
        SyntaxTokenKind.comment,
      );
      expect(
        kindOf(code, SyntaxLanguage.dart, 'final'),
        SyntaxTokenKind.keyword,
      );
      expect(kindOf(code, SyntaxLanguage.dart, '42'), SyntaxTokenKind.number);
      expect(kindOf(code, SyntaxLanguage.dart, "'hi'"), SyntaxTokenKind.string);
      expect(
        kindOf(code, SyntaxLanguage.dart, "r'a\\b'"),
        SyntaxTokenKind.string,
      );
      expect(kindOf(code, SyntaxLanguage.dart, 'Foo'), SyntaxTokenKind.type);
      expect(kindOf(code, SyntaxLanguage.dart, 'Bar'), SyntaxTokenKind.type);
      expect(
        kindOf(code, SyntaxLanguage.dart, 'print'),
        SyntaxTokenKind.function,
      );
      expect(
        kindOf(code, SyntaxLanguage.dart, 'void'),
        SyntaxTokenKind.keyword,
      );
      expect(
        kindOf(code, SyntaxLanguage.dart, 'true'),
        SyntaxTokenKind.constant,
      );
    });

    test('dart string interpolation', () {
      const code = "final s = 'a \$b \${c + 1} d';";
      expect(kindOf(code, SyntaxLanguage.dart, "'a "), SyntaxTokenKind.string);
      expect(kindOf(code, SyntaxLanguage.dart, 'b'), SyntaxTokenKind.variable);
      // Bare identifiers stay plain (no semantic analysis); operators and
      // literals inside the interpolation body are tokenized.
      expect(kindOf(code, SyntaxLanguage.dart, 'c'), isNull);
      expect(kindOf(code, SyntaxLanguage.dart, '+'), SyntaxTokenKind.operator);
      expect(kindOf(code, SyntaxLanguage.dart, '1'), SyntaxTokenKind.number);
      expect(kindOf(code, SyntaxLanguage.dart, " d'"), SyntaxTokenKind.string);
    });

    test('dart multiline string', () {
      const code = 'const s = """one\ntwo\nthree""";';
      expect(kindOf(code, SyntaxLanguage.dart, 'one'), SyntaxTokenKind.string);
      expect(kindOf(code, SyntaxLanguage.dart, 'two'), SyntaxTokenKind.string);
      expect(
        kindOf(code, SyntaxLanguage.dart, 'three'),
        SyntaxTokenKind.string,
      );
    });

    test('javascript / typescript', () {
      const code = '''
// comment
const x = `tpl \${user.name} end`;
function f(a) { return a ?? 2; }
interface I { readonly k: string }
''';
      expect(
        kindOf(code, SyntaxLanguage.javascript, '// comment'),
        SyntaxTokenKind.comment,
      );
      expect(
        kindOf(code, SyntaxLanguage.javascript, 'const'),
        SyntaxTokenKind.keyword,
      );
      expect(
        kindOf(code, SyntaxLanguage.javascript, 'tpl '),
        SyntaxTokenKind.string,
      );
      // Template-literal interpolation: the member is a variable token.
      expect(
        kindOf(code, SyntaxLanguage.javascript, '.name'),
        SyntaxTokenKind.variable,
      );
      expect(
        kindOf(code, SyntaxLanguage.javascript, 'function'),
        SyntaxTokenKind.keyword,
      );
      expect(
        kindOf(code, SyntaxLanguage.javascript, 'f(a)'),
        SyntaxTokenKind.function,
      );
      expect(
        kindOf(code, SyntaxLanguage.javascript, '??'),
        SyntaxTokenKind.operator,
      );
      expect(
        kindOf(code, SyntaxLanguage.typescript, 'interface'),
        SyntaxTokenKind.keyword,
      );
      expect(
        kindOf(code, SyntaxLanguage.typescript, 'readonly'),
        SyntaxTokenKind.keyword,
      );
      expect(
        kindOf(code, SyntaxLanguage.typescript, 'string'),
        SyntaxTokenKind.type,
      );
    });

    test('jsx basics', () {
      const code = 'const el = <Button onClick={fn}>Hi</Button>;';
      expect(kindOf(code, SyntaxLanguage.jsx, '<Button'), SyntaxTokenKind.tag);
      expect(
        kindOf(code, SyntaxLanguage.jsx, 'onClick'),
        SyntaxTokenKind.attribute,
      );
      // Expression containers ({…}) are not tokenized in jsx basics.
      expect(kindOf(code, SyntaxLanguage.jsx, 'fn'), isNull);
      expect(
        kindOf(code, SyntaxLanguage.jsx, '</Button>'),
        SyntaxTokenKind.tag,
      );
    });

    test('python', () {
      const code = '''
# comment
@app.route('/')
def f(x):
    return x + 1
''';
      expect(
        kindOf(code, SyntaxLanguage.python, '# comment'),
        SyntaxTokenKind.comment,
      );
      expect(
        kindOf(code, SyntaxLanguage.python, '@app'),
        SyntaxTokenKind.annotation,
      );
      expect(
        kindOf(code, SyntaxLanguage.python, 'def'),
        SyntaxTokenKind.keyword,
      );
      expect(
        kindOf(code, SyntaxLanguage.python, 'f(x)'),
        SyntaxTokenKind.function,
      );
      expect(
        kindOf(code, SyntaxLanguage.python, 'return'),
        SyntaxTokenKind.keyword,
      );
      expect(kindOf(code, SyntaxLanguage.python, '1'), SyntaxTokenKind.number);
    });

    test('json', () {
      const code = '{"key": 1, "other": true, "nested": {"a": null}}';
      expect(
        kindOf(code, SyntaxLanguage.json, '"key"'),
        SyntaxTokenKind.attribute,
      );
      expect(kindOf(code, SyntaxLanguage.json, '1'), SyntaxTokenKind.number);
      expect(
        kindOf(code, SyntaxLanguage.json, 'true'),
        SyntaxTokenKind.constant,
      );
      expect(
        kindOf(code, SyntaxLanguage.json, '"nested"'),
        SyntaxTokenKind.attribute,
      );
      expect(
        kindOf(code, SyntaxLanguage.json, 'null'),
        SyntaxTokenKind.constant,
      );
    });

    test('yaml', () {
      const code = '''
# comment
key: value
num: 3
list:
  - a
''';
      expect(
        kindOf(code, SyntaxLanguage.yaml, '# comment'),
        SyntaxTokenKind.comment,
      );
      expect(
        kindOf(code, SyntaxLanguage.yaml, 'key'),
        SyntaxTokenKind.variable,
      );
      expect(
        kindOf(code, SyntaxLanguage.yaml, 'num'),
        SyntaxTokenKind.variable,
      );
      expect(kindOf(code, SyntaxLanguage.yaml, '3'), SyntaxTokenKind.number);
    });

    test('bash', () {
      const code = '''
#!/bin/bash
flutter pub get --verbose
echo "hello # not a comment"
''';
      expect(
        kindOf(code, SyntaxLanguage.bash, '#!/bin/bash'),
        SyntaxTokenKind.comment,
      );
      expect(
        kindOf(code, SyntaxLanguage.bash, 'flutter'),
        SyntaxTokenKind.keyword,
      );
      expect(
        kindOf(code, SyntaxLanguage.bash, '--verbose'),
        SyntaxTokenKind.constant,
      );
      expect(
        kindOf(code, SyntaxLanguage.bash, '"hello # not a comment"'),
        SyntaxTokenKind.string,
      );
    });

    test('html', () {
      const code = '<!DOCTYPE html>\n<div class="x">hi</div>';
      expect(
        kindOf(code, SyntaxLanguage.html, '<!DOCTYPE'),
        SyntaxTokenKind.keyword,
      );
      expect(kindOf(code, SyntaxLanguage.html, '<div'), SyntaxTokenKind.tag);
      expect(
        kindOf(code, SyntaxLanguage.html, 'class'),
        SyntaxTokenKind.attribute,
      );
      expect(kindOf(code, SyntaxLanguage.html, '"x"'), SyntaxTokenKind.string);
      expect(kindOf(code, SyntaxLanguage.html, '</div>'), SyntaxTokenKind.tag);
    });

    test('css', () {
      const code = '''
/* comment */
.btn, #id:hover {
  color: #fff;
  margin: 10px;
}
''';
      expect(
        kindOf(code, SyntaxLanguage.css, '/* comment */'),
        SyntaxTokenKind.comment,
      );
      expect(kindOf(code, SyntaxLanguage.css, '.btn'), SyntaxTokenKind.type);
      expect(
        kindOf(code, SyntaxLanguage.css, ':hover'),
        SyntaxTokenKind.annotation,
      );
      expect(
        kindOf(code, SyntaxLanguage.css, 'color'),
        SyntaxTokenKind.variable,
      );
      expect(
        kindOf(code, SyntaxLanguage.css, '#fff'),
        SyntaxTokenKind.constant,
      );
      expect(kindOf(code, SyntaxLanguage.css, '10px'), SyntaxTokenKind.number);
    });

    test('kotlin', () {
      const code = '''
fun main() {
  val x = 1
  // comment
}
''';
      expect(
        kindOf(code, SyntaxLanguage.kotlin, 'fun'),
        SyntaxTokenKind.keyword,
      );
      expect(
        kindOf(code, SyntaxLanguage.kotlin, 'main'),
        SyntaxTokenKind.function,
      );
      expect(
        kindOf(code, SyntaxLanguage.kotlin, 'val'),
        SyntaxTokenKind.keyword,
      );
      expect(kindOf(code, SyntaxLanguage.kotlin, '1'), SyntaxTokenKind.number);
      expect(
        kindOf(code, SyntaxLanguage.kotlin, '// comment'),
        SyntaxTokenKind.comment,
      );
    });

    test('swift', () {
      const code = '''
func f() -> Int {
  return 1
}
''';
      expect(
        kindOf(code, SyntaxLanguage.swift, 'func'),
        SyntaxTokenKind.keyword,
      );
      expect(
        kindOf(code, SyntaxLanguage.swift, 'f()'),
        SyntaxTokenKind.function,
      );
      expect(kindOf(code, SyntaxLanguage.swift, 'Int'), SyntaxTokenKind.type);
      expect(
        kindOf(code, SyntaxLanguage.swift, 'return'),
        SyntaxTokenKind.keyword,
      );
      expect(kindOf(code, SyntaxLanguage.swift, '1'), SyntaxTokenKind.number);
    });

    test('markdown', () {
      const code = '''
# Title
**bold** and `code`
- item
''';
      expect(
        kindOf(code, SyntaxLanguage.markdown, '# Title'),
        SyntaxTokenKind.keyword,
      );
      expect(
        kindOf(code, SyntaxLanguage.markdown, '**bold**'),
        SyntaxTokenKind.constant,
      );
      expect(
        kindOf(code, SyntaxLanguage.markdown, '`code`'),
        SyntaxTokenKind.string,
      );
      expect(
        kindOf(code, SyntaxLanguage.markdown, '- item'),
        SyntaxTokenKind.operator,
      );
    });
  });

  group('span building', () {
    test('tokens get their kind color, gaps get the base style', () {
      const code = 'final x = 1;';
      final plain = SyntaxColors.light.plain;
      final spans = buildSyntaxSpans(
        code: code,
        language: SyntaxLanguage.dart,
        base: TextStyle(color: plain),
        colors: SyntaxColors.light,
      );
      final buffer = StringBuffer();
      Color? colorOf(String text) {
        for (final span in spans) {
          if (span.text == text) return span.style?.color;
        }
        return null;
      }

      for (final span in spans) {
        buffer.write(span.text);
      }
      expect(buffer.toString(), code);
      expect(colorOf('final'), SyntaxColors.light.keyword);
      expect(colorOf(' x '), SyntaxColors.light.plain);
      expect(colorOf('1'), SyntaxColors.light.number);
    });

    test('null language yields one plain span', () {
      final plain = SyntaxColors.light.plain;
      final spans = buildSyntaxSpans(
        code: 'anything {}',
        language: null,
        base: TextStyle(color: plain),
        colors: SyntaxColors.light,
      );
      expect(spans.length, 1);
      expect(spans.single.text, 'anything {}');
      expect(spans.single.style?.color, plain);
    });

    test('empty code yields one empty span', () {
      final spans = buildSyntaxSpans(
        code: '',
        language: SyntaxLanguage.dart,
        base: const TextStyle(),
        colors: SyntaxColors.light,
      );
      expect(spans.length, 1);
      expect(spans.single.text, '');
    });
  });

  group('fuzz', () {
    test('random text never throws and reconstructs', () {
      final random = Random(42);
      const charset = 'abcXYZ019 \t\n\'"`\\/\$@{}[]()#<!>.:;,=+-*&|?%_~^';
      for (var i = 0; i < 500; i++) {
        final length = random.nextInt(200);
        final code = String.fromCharCodes(
          List<int>.generate(
            length,
            (_) => charset.codeUnitAt(random.nextInt(charset.length)),
          ),
        );
        for (final language in SyntaxLanguage.values) {
          expectReconstruction(code, language);
        }
      }
    });

    test('pathological inputs never throw', () {
      // Not const: string repetition is not a constant expression in Dart.
      final inputs = <String>[
        '\${' * 500,
        '\$' * 500,
        "'" * 500,
        '"' * 500,
        '`' * 500,
        '///' * 300,
        '/*' * 300,
        '"""' * 300,
        '\\' * 500,
        '<' * 500,
        '#' * 500,
        '\n' * 500,
        '﻿' * 100,
        'é😀' * 100,
      ];
      for (final code in inputs) {
        for (final language in SyntaxLanguage.values) {
          expectReconstruction(code, language);
        }
      }
    });

    test('every registry .dart file tokenizes without throwing', () {
      final dir = Directory('lib/registry');
      final files = dir
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .toList();
      expect(files, isNotEmpty);
      for (final file in files) {
        final code = file.readAsStringSync();
        expectReconstruction(code, SyntaxLanguage.dart);
      }
    });
  });
}
