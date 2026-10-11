// Per-language token-kind goldens for the C-like family (Dart, Kotlin, Swift).
//
// Every test pins the exact kind sequence of a representative snippet plus the
// edge cases the shared `syntax_scanners_c_like.dart` rules must survive:
// multi-line strings and comments, raw strings, escapes, annotations and
// interpolation.

import 'package:flutter_shadcn_kit/registry/primitives/syntax_highlight/syntax_language.dart';
import 'package:flutter_test/flutter_test.dart';

import 'syntax_highlight_support.dart';

void main() {
  group('dart', () {
    test('representative snippet', () {
      const code = r'''
// line comment
/* block
   comment */
@override
class Foo extends Bar with Mix {
  static const MAX = 42;
  final String name;
  const Foo(this.name);
  void run() {
    final raw = r'a\b';
    final s = 'hi $name ${count + 1}';
    final esc = "quote \" newline \n";
    print(s);
  }
}
''';
      expectGolden(
        code,
        SyntaxLanguage.dart,
        kinds('''
        comment comment annotation keyword type keyword type keyword type keyword
        keyword constant operator number keyword type keyword type keyword
        variable keyword function keyword operator string keyword operator string
        operator variable string operator operator number operator string keyword
        operator string function
        '''),
      );
    });

    test('identifier and expression interpolation, in one string', () {
      const code = "final s = 'a \$b \${c + 1} d';";
      expectGolden(
        code,
        SyntaxLanguage.dart,
        kinds('''
        keyword operator string operator variable string operator operator
        number operator string
        '''),
      );
    });

    test('escaped dollar never starts an interpolation', () {
      const code = r"final s = 'a \$b \$x';";
      expectGolden(code, SyntaxLanguage.dart, kinds('keyword operator string'));
    });

    test('ALL_CAPS names are constants, mixed case stays type', () {
      const code = 'const MAX = 1; const MAX_SIZE = 2; const Foo = 3;';
      expectGolden(
        code,
        SyntaxLanguage.dart,
        kinds(
          'keyword constant operator number keyword constant operator number '
          'keyword type operator number',
        ),
      );
    });

    test('ALL_CAPS stops at the first lowercase letter', () {
      const code = 'HTML HTMLParser URL Abc AB';
      expectGolden(
        code,
        SyntaxLanguage.dart,
        kinds('constant type constant type type'),
      );
    });

    test('raw and adjacent triple-quoted strings', () {
      const code = 'const s = r"""a\nb""" + "x";';
      expectGolden(
        code,
        SyntaxLanguage.dart,
        kinds('keyword operator string operator string'),
      );
    });

    test('unterminated string and doc comments', () {
      const code = "const s = 'abc\nconst t = 2;";
      expectGolden(
        code,
        SyntaxLanguage.dart,
        kinds('keyword operator keyword operator number'),
      );
      const docs = '/// doc\n//! lib\n/** api */\nint x = 1;';
      expectGolden(
        docs,
        SyntaxLanguage.dart,
        kinds('comment comment comment operator number'),
      );
    });

    test('nested quotes inside an interpolation still round-trip', () {
      const code = r"const s = '${a['k']}';";
      expectRoundTrip(code, SyntaxLanguage.dart);
      expectKinds(
        code,
        SyntaxLanguage.dart,
        kinds('keyword operator string operator string'),
      );
    });
  });

  group('kotlin', () {
    test('representative snippet', () {
      const code = r'''
package a.b
import kotlin.math.max
// line
/* block
   comment */
@Inject
class Foo(private val n: Int) : Base() {
  fun run(): Int {
    val x = 0xFF
    return max(x, 1)
  }
}
''';
      expectGolden(
        code,
        SyntaxLanguage.kotlin,
        kinds('''
        keyword variable keyword variable variable comment comment annotation
        keyword type keyword keyword type type keyword function type keyword
        number keyword function number
        '''),
      );
    });

    test('block comments do not nest, escapes and triple quotes', () {
      const code = '/* a /* b */ c */\nval s = "a\\"b"\nval t = """x\ny"""\n';
      expectGolden(
        code,
        SyntaxLanguage.kotlin,
        kinds('comment keyword string keyword string'),
      );
    });

    test('lambdas, safe calls and call sites', () {
      const code =
          'val f = { x: Int -> x + 1 }\nval y = a?.b\nval z = listOf(1, 2)\n';
      expectGolden(
        code,
        SyntaxLanguage.kotlin,
        kinds(
          'keyword type number keyword variable keyword function number number',
        ),
      );
    });
  });

  group('swift', () {
    test('representative snippet', () {
      const code = r'''
import Foundation
// line
/* block
   comment */
@objc final class Foo: NSObject {
  let name: String = "x"
  var n = 1_000
  func run() -> Int {
    let s = """
    multi
    """
    return n
  }
}
''';
      expectGolden(
        code,
        SyntaxLanguage.swift,
        kinds('''
        keyword type comment comment annotation keyword keyword type type keyword
        type string keyword number keyword function type keyword string keyword
        '''),
      );
    });

    test('multi-line strings and backslash interpolation', () {
      const code = 'let s = """a\nb"""\nlet t = "v\\(x) y"\n';
      expectGolden(
        code,
        SyntaxLanguage.swift,
        kinds('keyword string keyword string'),
      );
    });

    test('raw string delimiters are only partly consumed', () {
      const code =
          r'let u = #"raw \#(x)"#'
          '\n';
      expectGolden(code, SyntaxLanguage.swift, kinds('keyword string'));
    });

    test('optionals and generic parameters', () {
      const code = 'let v: Int? = nil\nfunc g<T>(_ x: T) -> T { x }\n';
      expectGolden(
        code,
        SyntaxLanguage.swift,
        kinds('keyword type keyword keyword type type type'),
      );
    });
  });
}
