// Per-language token-kind goldens for the script family: JavaScript,
// TypeScript, JSX/TSX, Python and Bash.
//
// Edge cases pinned here: template literals with `${}` interpolation and
// escaped delimiters, raw and prefixed Python strings, escapes inside strings,
// the shebang-as-comment rule, `#` inside strings, shell variables and
// arithmetic, and the JSX/TSX shared rule list.

import 'package:flutter_shadcn_kit/registry/primitives/syntax_highlight/syntax_language.dart';
import 'package:flutter_test/flutter_test.dart';

import 'syntax_highlight_support.dart';

void main() {
  group('javascript', () {
    test('representative snippet', () {
      const code = r'''
// line comment
/* block
   comment */
import { readFile } from 'node:fs';
const tpl = `hi ${user.name} end`;
function greet(name: string, n = 0xFF) {
  return name ?? 'anon';
}
export default greet;
''';
      expectGolden(
        code,
        SyntaxLanguage.javascript,
        kinds('''
        comment comment keyword keyword string keyword operator string operator
        variable operator string keyword function operator type operator number
        keyword operator string keyword keyword
        '''),
      );
    });

    test('template literal escapes, and a regex is plain', () {
      const code =
          'const a = `x\\`y \${z} w`;\nconst b = "a\\"b";\nconst c = /re/g;\n';
      expectGolden(
        code,
        SyntaxLanguage.javascript,
        kinds('''
        keyword operator string operator operator string keyword operator string
        keyword operator operator operator
        '''),
      );
    });

    test('member access beats the call-site function rule', () {
      const code = 'const v = a.b.c(d);\nlet o = {k: 1};\n';
      expectGolden(
        code,
        SyntaxLanguage.javascript,
        kinds(
          'keyword operator variable variable keyword operator operator number',
        ),
      );
    });
  });

  group('typescript', () {
    test('representative snippet', () {
      const code = r'''
export interface Button {
  readonly label: string;
  count?: number;
}
type Size = keyof typeof sizes;
enum Dir { Up, Down }
const b = {} as Button;
class Btn implements Button {
  label = 'x';
}
''';
      expectGolden(
        code,
        SyntaxLanguage.typescript,
        kinds('''
        keyword keyword type keyword operator type operator type type operator
        keyword keyword keyword type type type keyword operator keyword type
        keyword type keyword type operator string
        '''),
      );
    });

    test('generics, arrow types and satisfies', () {
      const code =
          'const x = <T,>(v: T): T => v;\ntype A = {a: 1};\nconst b = {} satisfies A;\n';
      expectGolden(
        code,
        SyntaxLanguage.typescript,
        kinds('''
        keyword operator operator type operator operator type operator type
        operator type operator operator number keyword operator keyword type
        '''),
      );
    });
  });

  group('jsx / tsx', () {
    const code = 'const el = <Button onClick={fn} cls="x">Hi</Button>;';

    test('jsx tags, attributes and expression containers', () {
      expectGolden(
        code,
        SyntaxLanguage.jsx,
        kinds('''
        keyword attribute operator tag attribute operator attribute operator
        string operator type tag operator
        '''),
      );
    });

    test('jsx and tsx share one rule list', () {
      // The keyword set of both branches of the old `_jsxRules(typescript:)`
      // helper was byte-identical, so both languages tokenize identically.
      expect(
        kindSequence(code, SyntaxLanguage.jsx),
        kindSequence(code, SyntaxLanguage.tsx),
      );
      const tsOnly = 'const x = <T,>(v: T): T => v;\n<div a: number = {1}/>;';
      expect(
        kindSequence(tsOnly, SyntaxLanguage.jsx),
        kindSequence(tsOnly, SyntaxLanguage.tsx),
      );
      expectRoundTrip(tsOnly, SyntaxLanguage.tsx);
    });
  });

  group('python', () {
    test('representative snippet', () {
      const code = r'''
# comment
@app.route('/')
def f(x):
    """Doc
    string."""
    MAX = 1_000
    return f'v{x}' + rb'raw'
''';
      expectGolden(
        code,
        SyntaxLanguage.python,
        kinds('''
        comment annotation variable string keyword function string constant
        number keyword string string
        '''),
      );
    });

    test('docstrings, escapes and prefixed strings', () {
      const code =
          'def f():\n    """Doc\n    """\n    s = "a\\"b"\n    t = rb"x"\n    u = 0x1F + 1e3 + 3j\n';
      expectGolden(
        code,
        SyntaxLanguage.python,
        kinds('keyword function string string string number number'),
      );
    });

    test('decorator arguments and members', () {
      const code = '@app.route("/x", methods=["GET"])\ndef g():\n    pass\n';
      expectGolden(
        code,
        SyntaxLanguage.python,
        kinds('annotation variable string string keyword function keyword'),
      );
    });

    test('self is a variable, hex literals are plain', () {
      const code =
          'class A:\n    def m(self, *a, **k):\n        return self.x\n';
      expectGolden(
        code,
        SyntaxLanguage.python,
        kinds('keyword keyword function variable keyword variable variable'),
      );
      expectGolden(
        'u = 0x1F + 1e3 + 3j\n',
        SyntaxLanguage.python,
        kinds('number number'),
      );
    });
  });

  group('bash', () {
    test('representative snippet', () {
      const code = r'''
#!/bin/bash
# comment
set -e
export PATH="$HOME/bin"
echo "hello # not a comment"
flutter pub get --verbose
''';
      expectGolden(
        code,
        SyntaxLanguage.bash,
        kinds('''
        comment comment keyword constant keyword string keyword string keyword
        constant
        '''),
      );
    });

    test('shell variables, arithmetic, backticks and heredocs', () {
      const code =
          r'X=1'
          '\n'
          r'Y="${X}"'
          '\n'
          r'Z=$((1 + 2))'
          '\n'
          r'A=`echo hi`'
          '\n'
          'cat <<EOF\nplain '
          r'$X'
          '\nEOF\n';
      expectGolden(
        code,
        SyntaxLanguage.bash,
        kinds('''
        number string operator operator operator number number operator
        operator keyword keyword operator operator variable
        '''),
      );
    });

    test('quotes swallow the next comment marker', () {
      const code = "echo 'it'\\''s'\necho \"a # b\"\n";
      expectGolden(
        code,
        SyntaxLanguage.bash,
        kinds('keyword string string keyword string'),
      );
    });
  });
}
