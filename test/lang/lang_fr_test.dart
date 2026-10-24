import 'package:flutter_test/flutter_test.dart';
import 'package:num2text/num2text.dart';

void main() {
  group('Num2Text French (FR)', () {
    final converter = Num2Text(initialLang: Lang.FR);
    final converterWithFallback =
        Num2Text(initialLang: Lang.FR, fallbackOnError: "Nombre Invalide");

    test('Basic Numbers (0 - 99)', () {
      expect(converter.convert(0), equals("zéro"));
      expect(converter.convert(10), equals("dix"));
      expect(converter.convert(11), equals("onze"));
      expect(converter.convert(13), equals("treize"));
      expect(converter.convert(15), equals("quinze"));
      expect(converter.convert(16), equals("seize"));
      expect(converter.convert(17), equals("dix-sept"));
      expect(converter.convert(20), equals("vingt"));
      expect(converter.convert(21), equals("vingt et un"));
      expect(converter.convert(27), equals("vingt-sept"));
      expect(converter.convert(30), equals("trente"));
      expect(converter.convert(54), equals("cinquante-quatre"));
      expect(converter.convert(68), equals("soixante-huit"));
      expect(converter.convert(70), equals("soixante-dix"));
      expect(converter.convert(71), equals("soixante et onze"));
      expect(converter.convert(80), equals("quatre-vingts"));
      expect(converter.convert(81), equals("quatre-vingt-un"));
      expect(converter.convert(90), equals("quatre-vingt-dix"));
      expect(converter.convert(91), equals("quatre-vingt-onze"));
      expect(converter.convert(99), equals("quatre-vingt-dix-neuf"));
    });

    test('Hundreds (100 - 999)', () {
      expect(converter.convert(100), equals("cent"));
      expect(converter.convert(101), equals("cent un"));
      expect(converter.convert(105), equals("cent cinq"));
      expect(converter.convert(110), equals("cent dix"));
      expect(converter.convert(111), equals("cent onze"));
      expect(converter.convert(121), equals("cent vingt et un"));
      expect(converter.convert(123), equals("cent vingt-trois"));
      expect(converter.convert(171), equals("cent soixante et onze"));
      expect(converter.convert(180), equals("cent quatre-vingts"));
      expect(converter.convert(181), equals("cent quatre-vingt-un"));
      expect(converter.convert(200), equals("deux cents"));
      expect(converter.convert(201), equals("deux cent un"));
      expect(converter.convert(321), equals("trois cent vingt et un"));
      expect(converter.convert(479), equals("quatre cent soixante-dix-neuf"));
      expect(converter.convert(596), equals("cinq cent quatre-vingt-seize"));
      expect(converter.convert(681), equals("six cent quatre-vingt-un"));
      expect(converter.convert(999), equals("neuf cent quatre-vingt-dix-neuf"));
    });

    test('Thousands (1000 - 999999)', () {
      expect(converter.convert(1000), equals("mille"));
      expect(converter.convert(1001), equals("mille un"));
      expect(converter.convert(1011), equals("mille onze"));
      expect(converter.convert(1110), equals("mille cent dix"));
      expect(converter.convert(1111), equals("mille cent onze"));
      expect(converter.convert(1200), equals("mille deux cents"));
      expect(converter.convert(2000), equals("deux mille"));
      expect(converter.convert(2468),
          equals("deux mille quatre cent soixante-huit"));
      expect(converter.convert(3579),
          equals("trois mille cinq cent soixante-dix-neuf"));
      expect(converter.convert(10000), equals("dix mille"));
      expect(converter.convert(10011), equals("dix mille onze"));
      expect(converter.convert(11100), equals("onze mille cent"));
      expect(converter.convert(12987),
          equals("douze mille neuf cent quatre-vingt-sept"));
      expect(converter.convert(45623),
          equals("quarante-cinq mille six cent vingt-trois"));
      expect(converter.convert(87654),
          equals("quatre-vingt-sept mille six cent cinquante-quatre"));
      expect(converter.convert(80000), equals("quatre-vingt mille"));
      expect(converter.convert(100000), equals("cent mille"));
      expect(converter.convert(180000), equals("cent quatre-vingt mille"));
      expect(converter.convert(200000), equals("deux cent mille"));
      expect(converter.convert(123456),
          equals("cent vingt-trois mille quatre cent cinquante-six"));
      expect(
          converter.convert(987654),
          equals(
              "neuf cent quatre-vingt-sept mille six cent cinquante-quatre"));
      expect(
          converter.convert(999999),
          equals(
              "neuf cent quatre-vingt-dix-neuf mille neuf cent quatre-vingt-dix-neuf"));
    });

    test('Negative Numbers', () {
      expect(converter.convert(-1), equals("moins un"));
      expect(converter.convert(-123), equals("moins cent vingt-trois"));
      expect(converter.convert(-123.456),
          equals("moins cent vingt-trois virgule quatre cinq six"));
      expect(
          converter.convert(-1,
              options: const FrOptions(negativePrefix: "négatif")),
          equals("négatif un"));
      expect(
          converter.convert(-123,
              options: const FrOptions(negativePrefix: "négatif")),
          equals("négatif cent vingt-trois"));
      expect(
          converter.convert(-123.456,
              options: const FrOptions(negativePrefix: "négatif")),
          equals("négatif cent vingt-trois virgule quatre cinq six"));
    });

    test('Decimals', () {
      expect(converter.convert(123.456),
          equals("cent vingt-trois virgule quatre cinq six"));
      expect(converter.convert(1.5), equals("un virgule cinq"));
      expect(converter.convert(1.05), equals("un virgule zéro cinq"));
      expect(converter.convert(879.465),
          equals("huit cent soixante-dix-neuf virgule quatre six cinq"));
      expect(converter.convert(1.5), equals("un virgule cinq"));
      expect(
          converter.convert(1.5,
              options:
                  const FrOptions(decimalSeparator: DecimalSeparator.point)),
          equals("un point cinq"));
      expect(
          converter.convert(1.5,
              options:
                  const FrOptions(decimalSeparator: DecimalSeparator.comma)),
          equals("un virgule cinq"));
      expect(
          converter.convert(1.5,
              options:
                  const FrOptions(decimalSeparator: DecimalSeparator.period)),
          equals("un point cinq"));
    });

    test('Year Formatting', () {
      expect(
          converter.convert(123, options: const FrOptions(format: Format.year)),
          equals("cent vingt-trois"));
      expect(
          converter.convert(498, options: const FrOptions(format: Format.year)),
          equals("quatre cent quatre-vingt-dix-huit"));
      expect(
          converter.convert(756, options: const FrOptions(format: Format.year)),
          equals("sept cent cinquante-six"));
      expect(
          converter.convert(1900,
              options: const FrOptions(format: Format.year)),
          equals("mille neuf cents"));
      expect(
          converter.convert(1999,
              options: const FrOptions(format: Format.year)),
          equals("mille neuf cent quatre-vingt-dix-neuf"));
      expect(
          converter.convert(2025,
              options: const FrOptions(format: Format.year)),
          equals("deux mille vingt-cinq"));
      expect(
          converter.convert(1900,
              options: const FrOptions(format: Format.year, includeAD: true)),
          equals("mille neuf cents ap. J.-C."));
      expect(
          converter.convert(1999,
              options: const FrOptions(format: Format.year, includeAD: true)),
          equals("mille neuf cent quatre-vingt-dix-neuf ap. J.-C."));
      expect(
          converter.convert(2025,
              options: const FrOptions(format: Format.year, includeAD: true)),
          equals("deux mille vingt-cinq ap. J.-C."));
      expect(
          converter.convert(-1, options: const FrOptions(format: Format.year)),
          equals("un av. J.-C."));
      expect(
          converter.convert(-100,
              options: const FrOptions(format: Format.year)),
          equals("cent av. J.-C."));
      expect(
          converter.convert(-100,
              options: const FrOptions(format: Format.year, includeAD: true)),
          equals("cent av. J.-C."));
      expect(
          converter.convert(-2025,
              options: const FrOptions(format: Format.year)),
          equals("deux mille vingt-cinq av. J.-C."));
      expect(
          converter.convert(-1000000,
              options: const FrOptions(format: Format.year)),
          equals("un million av. J.-C."));
    });

    test('Currency', () {
      expect(converter.convert(0, options: const FrOptions(currency: true)),
          equals("zéro euro"));
      expect(converter.convert(1, options: const FrOptions(currency: true)),
          equals("un euro"));
      expect(converter.convert(2, options: const FrOptions(currency: true)),
          equals("deux euros"));
      expect(converter.convert(5, options: const FrOptions(currency: true)),
          equals("cinq euros"));
      expect(converter.convert(10, options: const FrOptions(currency: true)),
          equals("dix euros"));
      expect(converter.convert(11, options: const FrOptions(currency: true)),
          equals("onze euros"));
      expect(converter.convert(1.5, options: const FrOptions(currency: true)),
          equals("un euro et cinquante centimes"));
      expect(
          converter.convert(123.45, options: const FrOptions(currency: true)),
          equals("cent vingt-trois euros et quarante-cinq centimes"));
      expect(
          converter.convert(10000000, options: const FrOptions(currency: true)),
          equals("dix millions d'euros"));
      expect(
          converter.convert(1000000, options: const FrOptions(currency: true)),
          equals("un million d'euros"));
      expect(
          converter.convert(1500000, options: const FrOptions(currency: true)),
          equals("un million cinq cent mille euros"));
      expect(
          converter.convert(2000003, options: const FrOptions(currency: true)),
          equals("deux millions trois euros"));
      const xof = CurrencyInfo(
        mainUnitSingular: "franc CFA",
        mainUnitPlural: "francs CFA",
        subUnitSingular: "centime",
        subUnitPlural: "centimes",
        separator: "et",
      );
      expect(
          converter.convert(1000000,
              options: const FrOptions(currency: true, currencyInfo: xof)),
          equals("un million de francs CFA"));
      expect(
          converter.convert(3000000000,
              options: const FrOptions(currency: true, currencyInfo: xof)),
          equals("trois milliards de francs CFA"));
      expect(converter.convert(0.01, options: const FrOptions(currency: true)),
          equals("un centime"));
      expect(converter.convert(0.5, options: const FrOptions(currency: true)),
          equals("cinquante centimes"));
      expect(converter.convert(1.01, options: const FrOptions(currency: true)),
          equals("un euro et un centime"));
      expect(converter.convert(2.02, options: const FrOptions(currency: true)),
          equals("deux euros et deux centimes"));
    });

    test('Scale Numbers', () {
      expect(converter.convert(BigInt.from(10).pow(6)), equals("un million"));
      expect(converter.convert(BigInt.from(2) * BigInt.from(10).pow(9)),
          equals("deux milliards"));
      expect(converter.convert(BigInt.from(3) * BigInt.from(10).pow(12)),
          equals("trois billions"));
      expect(converter.convert(BigInt.from(4) * BigInt.from(10).pow(15)),
          equals("quatre billiards"));
      expect(converter.convert(BigInt.from(5) * BigInt.from(10).pow(18)),
          equals("cinq trillions"));
      expect(converter.convert(BigInt.from(6) * BigInt.from(10).pow(21)),
          equals("six trilliards"));
      expect(converter.convert(BigInt.from(7) * BigInt.from(10).pow(24)),
          equals("sept quadrillions"));
      expect(
          converter.convert(BigInt.parse('9876543210123456789')),
          equals(
              "neuf trillions huit cent soixante-seize billiards cinq cent quarante-trois billions deux cent dix milliards cent vingt-trois millions quatre cent cinquante-six mille sept cent quatre-vingt-neuf"));
      expect(
          converter.convert(BigInt.parse('123456789123456789123456')),
          equals(
              'cent vingt-trois trilliards quatre cent cinquante-six trillions sept cent quatre-vingt-neuf billiards cent vingt-trois billions quatre cent cinquante-six milliards sept cent quatre-vingt-neuf millions cent vingt-trois mille quatre cent cinquante-six'));
      expect(
          converter.convert(BigInt.parse('999999999999999999999999')),
          equals(
              "neuf cent quatre-vingt-dix-neuf trilliards neuf cent quatre-vingt-dix-neuf trillions neuf cent quatre-vingt-dix-neuf billiards neuf cent quatre-vingt-dix-neuf billions neuf cent quatre-vingt-dix-neuf milliards neuf cent quatre-vingt-dix-neuf millions neuf cent quatre-vingt-dix-neuf mille neuf cent quatre-vingt-dix-neuf"));
      expect(converter.convert(BigInt.parse('1000002000003')),
          equals("un billion deux millions trois"));
      expect(converter.convert(BigInt.parse('5001000')),
          equals("cinq millions mille"));
      expect(converter.convert(BigInt.parse('1000000001')),
          equals("un milliard un"));
      expect(converter.convert(BigInt.parse('1001000000')),
          equals("un milliard un million"));
      expect(converter.convert(BigInt.parse('2001000')),
          equals("deux millions mille"));
      expect(
          converter.convert(1080000), equals("un million quatre-vingt mille"));
      expect(converter.convert(1200000), equals("un million deux cent mille"));
      expect(converter.convert(80000000), equals("quatre-vingts millions"));
      expect(converter.convert(200000001), equals("deux cents millions un"));
      expect(
          converter.convert(BigInt.parse('1000987600003')),
          equals(
              "un billion neuf cent quatre-vingt-sept millions six cent mille trois"));
    });

    test('Infinity And Invalid Input', () {
      expect(converter.convert(double.nan), equals("N'est Pas Un Nombre"));
      expect(converter.convert(double.infinity), equals("Infini"));
      expect(
          converter.convert(double.negativeInfinity), equals("Moins L'infini"));
      expect(converter.convert(null), equals("N'est Pas Un Nombre"));
      expect(converter.convert('abc'), equals("N'est Pas Un Nombre"));
      expect(converter.convert([]), equals("N'est Pas Un Nombre"));
      expect(converter.convert({}), equals("N'est Pas Un Nombre"));
      expect(converter.convert(Object()), equals("N'est Pas Un Nombre"));

      expect(
          converterWithFallback.convert(double.nan), equals("Nombre Invalide"));
      expect(converterWithFallback.convert(double.infinity), equals("Infini"));
      expect(converterWithFallback.convert(double.negativeInfinity),
          equals("Moins L'infini"));
      expect(converterWithFallback.convert(null), equals("Nombre Invalide"));
      expect(converterWithFallback.convert('abc'), equals("Nombre Invalide"));
      expect(converterWithFallback.convert([]), equals("Nombre Invalide"));
      expect(converterWithFallback.convert({}), equals("Nombre Invalide"));
      expect(
          converterWithFallback.convert(Object()), equals("Nombre Invalide"));
      expect(converterWithFallback.convert(123), equals("cent vingt-trois"));
    });
  });
}
