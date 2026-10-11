// Per-language token-kind goldens for the markup and data family: HTML, CSS,
// JSON, YAML and Markdown.
//
// Edge cases pinned here: multi-line comments and doctype, bare attributes,
// embedded script/style text, pseudo-classes and units, `!important`, JSON keys
// vs values and escapes, YAML block scalars and anchors, and Markdown fenced
// blocks, images and thematic breaks.

import 'package:flutter_shadcn_kit/registry/primitives/syntax_highlight/syntax_language.dart';
import 'package:flutter_test/flutter_test.dart';

import 'syntax_highlight_support.dart';

void main() {
  group('html', () {
    test('representative snippet', () {
      const code = r'''
<!DOCTYPE html>
<!-- block
     comment -->
<div class="x" data-y='z'>hi &amp; bye</div>
<img src="a.png"/>
''';
      expectGolden(
        code,
        SyntaxLanguage.html,
        kinds('''
        keyword comment tag attribute string attribute string operator constant
        tag operator tag attribute string operator
        '''),
      );
    });

    test('unclosed tags and bare attribute values', () {
      const code = '<div class=x>\ntext\n<p>\n';
      expectGolden(
        code,
        SyntaxLanguage.html,
        kinds('tag attribute operator tag operator'),
      );
    });

    test('script and style bodies are not tokenized as code', () {
      const code =
          '<script>var a = "b";</script>\n<style>.a{color:red}</style>\n';
      expectGolden(
        code,
        SyntaxLanguage.html,
        kinds('''
        tag operator attribute string tag operator tag operator tag operator
        '''),
      );
    });
  });

  group('css', () {
    test('representative snippet', () {
      const code = r'''
/* comment */
@media (min-width: 40rem) {
  .btn, #id:hover::after {
    color: #fff;
    margin: 10px !important;
    content: "\2014";
  }
}
''';
      expectGolden(
        code,
        SyntaxLanguage.css,
        kinds('''
        comment annotation operator variable operator number operator operator
        type annotation annotation operator variable operator constant operator
        variable operator number annotation operator variable operator string
        operator operator operator
        '''),
      );
    });

    test('pseudo-classes, units and attribute selectors', () {
      const code =
          'a:hover{color:#abc;margin:1.5rem 2px}\ninput[type="text"]{width:50%}\n';
      expectGolden(
        code,
        SyntaxLanguage.css,
        kinds('''
        type annotation operator variable operator constant operator variable
        operator number number operator type operator variable operator number
        operator operator
        '''),
      );
    });

    test('keyframes and var() are annotation-shaped', () {
      const code =
          '@keyframes k{from{opacity:0}to{opacity:1}}\n.a{color:var(--x)}\n';
      expectGolden(
        code,
        SyntaxLanguage.css,
        kinds('''
        annotation operator operator variable operator number operator operator
        variable operator number operator operator type operator variable
        annotation operator
        '''),
      );
    });
  });

  group('json', () {
    test('representative snippet', () {
      const code = '''
{
  "key": 1,
  "nested": {"a": null, "b": true},
  "esc": "a\\"b",
  "neg": -2.5e3,
  "list": [1, 2.5, "s", false]
}
''';
      expectGolden(
        code,
        SyntaxLanguage.json,
        kinds('''
        operator attribute operator number operator attribute operator operator
        attribute operator constant operator attribute operator constant
        operator operator attribute operator string operator attribute operator
        number operator attribute operator operator number operator number
        operator string operator constant operator operator
        '''),
      );
    });

    test('escapes, exponents and empty containers', () {
      const code = r'{"a": "b\"c", "u": "A", "n": -0.5, "e": 1e-3, "z": []}';
      expectGolden(
        code,
        SyntaxLanguage.json,
        kinds('''
        operator attribute operator string operator attribute operator string
        operator attribute operator number operator attribute operator number
        operator attribute operator operator operator operator
        '''),
      );
    });
  });

  group('yaml', () {
    test('representative snippet', () {
      const code = r'''
# comment
name: kit
version: 3
flags: [a, b]
quoted: "a: b"
tpl: "${HOME}/x"
enabled: yes
---
''';
      expectGolden(
        code,
        SyntaxLanguage.yaml,
        kinds('''
        comment variable operator variable operator number variable operator
        operator operator operator variable operator string variable operator
        string variable operator constant operator
        '''),
      );
    });
    test('quoted values, including a colon inside the value', () {
      const code = 'a: "x"\nb: \'y\'\nc: "a: b"\n';
      expectGolden(
        code,
        SyntaxLanguage.yaml,
        kinds(
          'variable operator string variable operator string variable operator '
          'string',
        ),
      );
    });

    test('escaped and doubled quotes stay inside one string token', () {
      const code = 'k: "a\\"b"\nj: \'it\'\'s\'\n';
      expectGolden(
        code,
        SyntaxLanguage.yaml,
        kinds('variable operator string variable operator string'),
      );
    });

    test('block scalars and anchors', () {
      const code = 'x: |\n  line1\n  line2\ny: &a 1\nz: *a\n';
      expectGolden(
        code,
        SyntaxLanguage.yaml,
        kinds('''
        variable operator operator variable operator operator number variable
        operator operator
        '''),
      );
    });
  });

  group('markdown', () {
    test('representative snippet', () {
      const code = '''
# Title
Setext
------
```dart
final x = 1;
```
- **bold** and `code` and [link](http://x.y)
> quote
---
''';
      expectGolden(
        code,
        SyntaxLanguage.markdown,
        kinds('''
        keyword operator string operator constant string tag comment operator
        '''),
      );
    });

    test('nested list markers and images', () {
      const code = '- a\n  - b\n- [x] c\n![alt](img.png)\n';
      expectGolden(
        code,
        SyntaxLanguage.markdown,
        kinds('operator operator operator tag'),
      );
    });

    test('tilde fences and inline urls', () {
      const code = '~~~\ncode\n~~~\nsee http://a.b now\n';
      expectGolden(code, SyntaxLanguage.markdown, kinds('string attribute'));
    });
  });
}
