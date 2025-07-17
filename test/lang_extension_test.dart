import 'package:flutter_test/flutter_test.dart';
import 'package:num2text/num2text.dart';

void main() {
  group('LangExtension Tests', () {
    test('toCode() returns lowercase code', () {
      expect(Lang.EN.toCode(), equals('en'));
      expect(Lang.FR.toCode(), equals('fr'));
      expect(Lang.DE.toCode(), equals('de'));
    });

    test('fromCode() converts string to Lang enum', () {
      expect(Lang.fromCode('en'), equals(Lang.EN));
      expect(Lang.fromCode('fr'), equals(Lang.FR));
      expect(Lang.fromCode('de'), equals(Lang.DE));
    });

    test('fromCode() handles uppercase codes', () {
      expect(Lang.fromCode('EN'), equals(Lang.EN));
      expect(Lang.fromCode('FR'), equals(Lang.FR));
      expect(Lang.fromCode('DE'), equals(Lang.DE));
    });

    test('fromCode() returns null for invalid codes', () {
      expect(Lang.fromCode('invalid'), isNull);
      expect(Lang.fromCode('123'), isNull);
      expect(Lang.fromCode(''), isNull);
    });

    test('fromCodeOrDefault() returns default for invalid codes', () {
      expect(Lang.fromCodeOrDefault('invalid'), equals(Lang.EN));
      expect(Lang.fromCodeOrDefault('123'), equals(Lang.EN));
      expect(Lang.fromCodeOrDefault(''), equals(Lang.EN));
    });

    test('fromCodeOrDefault() allows custom default', () {
      expect(
        Lang.fromCodeOrDefault('invalid', defaultLang: Lang.FR),
        equals(Lang.FR),
      );
      expect(
        Lang.fromCodeOrDefault('123', defaultLang: Lang.DE),
        equals(Lang.DE),
      );
    });

    test('availableCodes contains all supported languages', () {
      final codes = Lang.availableCodes;
      expect(codes, contains('en'));
      expect(codes, contains('fr'));
      expect(codes, contains('de'));
      expect(codes, contains('es'));
      expect(
        codes.length,
        equals(70),
      ); // Update this number if languages are added or removed
    });
  });

  group('Num2Text setLangByCode Tests', () {
    late Num2Text num2text;

    setUp(() {
      num2text = Num2Text();
    });

    test('setLangByCode() changes language', () {
      num2text.setLangByCode('fr');
      expect(num2text.currentLang, equals(Lang.FR));

      num2text.setLangByCode('de');
      expect(num2text.currentLang, equals(Lang.DE));
    });

    test('setLangByCode() handles uppercase codes', () {
      num2text.setLangByCode('FR');
      expect(num2text.currentLang, equals(Lang.FR));
    });

    test('setLangByCode() throws for invalid codes without fallback', () {
      expect(() => num2text.setLangByCode('invalid'), throwsArgumentError);
    });

    test('setLangByCode() uses fallback when specified', () {
      num2text.setLangByCode('invalid', fallbackToDefault: true);
      expect(num2text.currentLang, equals(Lang.EN));

      num2text.setLangByCode(
        'invalid',
        fallbackToDefault: true,
        defaultLang: Lang.DE,
      );
      expect(num2text.currentLang, equals(Lang.DE));
    });

    test('setLangByCodeSafe() always uses fallback', () {
      num2text.setLangByCodeSafe('invalid');
      expect(num2text.currentLang, equals(Lang.EN));

      num2text.setLangByCodeSafe('invalid', defaultLang: Lang.FR);
      expect(num2text.currentLang, equals(Lang.FR));
    });
  });
}
