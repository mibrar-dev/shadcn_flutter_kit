// Tests for the `formatter` component.

import 'package:flutter/services.dart';
import 'package:flutter_shadcn_kit/registry/components/formatter/formatter.dart';
import 'package:flutter_test/flutter_test.dart';

TextEditingValue _value(String text, [int? baseOffset]) {
  return TextEditingValue(
    text: text,
    selection: TextSelection.collapsed(offset: baseOffset ?? text.length),
  );
}

void main() {
  test('uppercase / lowercase keep the selection', () {
    const up = ToUpperCaseTextFormatter();
    final upResult = up.formatEditUpdate(_value('ab', 2), _value('aBc', 3));
    expect(upResult.text, 'ABC');
    expect(upResult.selection.baseOffset, 3);
    const down = ToLowerCaseTextFormatter();
    expect(down.formatEditUpdate(_value(''), _value('AbC')).text, 'abc');
  });

  test('integerOnly clamps and allows a leading minus', () {
    final f = IntegerTextFormatter(min: 0, max: 100);
    expect(f.formatEditUpdate(_value(''), _value('42')).text, '42');
    expect(f.formatEditUpdate(_value(''), _value('999')).text, '100');
    expect(f.formatEditUpdate(_value(''), _value('-5')).text, '0');
    // A partial minus sign is preserved.
    expect(f.formatEditUpdate(_value(''), _value('-')).text, '-');
  });

  test('NumberTextFormatter clamps and formats decimals', () {
    final f = NumberTextFormatter(min: 0, max: 3, decimalDigits: 2);
    expect(f.formatEditUpdate(_value(''), _value('1.5')).text, '1.50');
    expect(f.formatEditUpdate(_value(''), _value('4')).text, '3.00');
    final free = NumberTextFormatter();
    expect(free.formatEditUpdate(_value(''), _value('0.5')).text, '0.5');
  });

  test('HexTextFormatter keeps prefix semantics and validates digits', () {
    final withHash = HexTextFormatter(hashPrefix: true);
    expect(withHash.formatEditUpdate(_value(''), _value('a1')).text, '#a1');
    expect(
      withHash.formatEditUpdate(_value('#a1'), _value('#a1g')).text,
      '#a1',
    );
    final without = HexTextFormatter();
    expect(without.formatEditUpdate(_value(''), _value('#ab')).text, 'ab');
  });

  test('TimeFormatter pads left and truncates to length', () {
    const f2 = TimeFormatter(length: 2);
    expect(f2.formatEditUpdate(_value(''), _value('7')).text, '07');
    expect(f2.formatEditUpdate(_value(''), _value('123')).text, '23');
    const f4 = TimeFormatter(length: 4);
    expect(f4.formatEditUpdate(_value(''), _value('830')).text, '0830');
  });

  test('MathExpressionFormatter evaluates expressions', () {
    const f = MathExpressionFormatter();
    expect(f.formatEditUpdate(_value(''), _value('1+2')).text, '3');
    expect(f.formatEditUpdate(_value(''), _value('2*3.5')).text, '7');
    expect(f.formatEditUpdate(_value(''), _value('abc')).text, '');
  });

  test('constraintToNewText clamps the selection offset', () {
    final v = _value('ab', 2);
    final clamped = constraintToNewText(
      const TextEditingValue(
        text: '',
        selection: TextSelection(baseOffset: 10, extentOffset: 10),
      ),
      'ab',
    );
    expect(clamped.baseOffset, 2);
    expect(v.text.length, 2);
  });
}
