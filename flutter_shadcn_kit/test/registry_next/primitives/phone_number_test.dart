import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/phone_number.dart';

void main() {
  const us = Country(dialCode: '+1', code: 'US');
  const gb = Country(dialCode: '+44', code: 'GB');
  const gbNoPlus = Country(dialCode: '44', code: 'GB');

  test('fullNumber and value require a country', () {
    const number = PhoneNumber(us, '5551234567');
    expect(number.fullNumber, '+15551234567');
    expect(number.fullCodeNumber, '+15551234567');
    expect(number.value, '+15551234567');
    expect(number.toString(), '+15551234567');

    const unknown = PhoneNumber(null, '555');
    expect(unknown.fullNumber, '555');
    expect(unknown.fullCodeNumber, '555');
    expect(unknown.value, isNull);

    const empty = PhoneNumber(us, '');
    expect(empty.value, isNull);
    expect(empty.toString(), '');
  });

  test('fullCodeNumber normalises a dial code without a plus', () {
    const number = PhoneNumber(gbNoPlus, '7700900123');
    expect(number.fullCodeNumber, '+447700900123');
    expect(number.fullNumber, '447700900123');
  });

  test('withCountry returns a copy', () {
    const number = PhoneNumber(us, '123');
    final moved = number.withCountry(gb);
    expect(moved.country, gb);
    expect(moved.number, '123');
    expect(number.country, us);
  });

  test('equality is value based', () {
    expect(const PhoneNumber(us, '1'), const PhoneNumber(us, '1'));
    expect(
      const PhoneNumber(us, '1').hashCode,
      const PhoneNumber(us, '1').hashCode,
    );
    expect(const PhoneNumber(us, '1'), isNot(const PhoneNumber(gb, '1')));
    expect(const PhoneNumber(us, '1'), isNot(const PhoneNumber(us, '2')));
    expect(const Country(dialCode: '+1', code: 'US'), us);
  });
}
