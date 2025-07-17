# Num2Text 0.0.4

[![pub package](https://img.shields.io/pub/v/num2text.svg)](https://pub.dev/packages/num2text)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Dart library for converting numbers (integers, doubles, BigInt, Decimal, Numeric String) into their word representations (cardinal form) across a wide range of languages.

**Currently supports up to 70 languages!**

## Features

- **Multi-Language Support:** Convert numbers to words in 70 languages (see list below).
- **Flexible Input:** Handles `int`, `double`, `BigInt`, `String` (if parsable), and `Decimal` types.
- **Large Numbers:** Handles large integer parts up to **24 digits** (up to sextillions in the English short scale). Support may vary slightly by language implementation.
- **Rich Formatting Options:**
  - Currency formatting with language-specific unit names and plurals ([CurrencyInfo]).
  - Year formatting (e.g., "nineteen eighty-four", "2024 AD/BC").
  - Decimal handling (e.g., "one point five", "dix virgule cinq").
  - Negative number prefixes.
  - Language-specific grammatical features (gender, case, specific connectors like 'and'/'le').
- **Error Handling:** Optional fallback for invalid inputs.
- **Well-Tested:** Each language has dedicated tests (see Testing section).

## Installation

Add this to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  num2text: ^0.0.3 # Use the latest version
  decimal: ^2.3.3 # Optional dependency
```

Then run `dart pub get` or `flutter pub get`.

## Basic Usage

Import the library:

```dart
import 'package:num2text/num2text.dart';
```

Create an instance and convert:

```dart
// 1. Create an instance (defaults to English)
final num2text = Num2Text(); // Or Num2Text(initialLang: Lang.EN)

// 2. Basic conversion (English)
print(num2text.convert(123));           // Output: one hundred twenty-three
print(num2text.convert(1045.67));        // Output: one thousand forty-five point six seven
print(num2text(1000000));               // Callable instance: one million

// 3. Change language using enum
num2text.setLang(Lang.VI); // Switch to Vietnamese
print(num2text.convert(987));           // Output: chín trăm tám mươi bảy

num2text.setLang(Lang.ES); // Switch to Spanish
print(num2text.convert(25));            // Output: veinticinco

// 4. Change language using string code
num2text.setLangByCode('fr'); // Switch to French
print(num2text.convert(42));            // Output: quarante-deux

// 5. Safely change language with fallback
num2text.setLangByCodeSafe('xyz');      // Invalid code, falls back to English
print(num2text.convert(42));            // Output: forty-two

// 6. Get all available language codes
print(LangExtension.availableCodes);    // ['en', 'et', 'vi', 'af', ...]
```

## Using Options

Customize output with language-specific options:

```dart
// English with British 'and' and GBP currency
num2text.setLang(Lang.EN);
print(num2text.convert(123, options: EnOptions(includeAnd: true)));
// Output: one hundred and twenty-three

print(num2text.convert(135.75, options: EnOptions(
  currency: true,
  currencyInfo: CurrencyInfo.gbp, // Use British Pound info
  includeAnd: true,
)));
// Output: one hundred and thirty-five pounds and seventy-five pence

// Vietnamese with 'lẻ' and year format
num2text.setLang(Lang.VI);
print(num2text.convert(105, options: ViOptions(useLe: true)));
// Output: một trăm lẻ năm
print(num2text(2024, options: ViOptions(format: Format.year)));
// Output: hai nghìn không trăm hai mươi tư

// Spanish with Euro currency
num2text.setLang(Lang.ES);
print(num2text(1.50, options: EsOptions(
  currency: true,
  currencyInfo: CurrencyInfo.eurEs, // Use Euro (Spanish) info
)));
// Output: un euro con cincuenta céntimos

// Polish with Złoty currency (demonstrates complex plurals)
num2text.setLang(Lang.PL);
print(num2text(123.45, options: PlOptions(currency: true))); // Uses PLN by default
// Output: sto dwadzieścia trzy złote i czterdzieści pięć groszy
print(num2text(5, options: PlOptions(currency: true)));
// Output: pięć złotych
```

## Supported Languages

The library currently supports the following 70 languages. Each language has specific options available (e.g., `EnOptions`, `ViOptions`) and is tested individually. For complete usage examples of a specific language, including all options, please check the corresponding test file listed in the table.

| Language        | Enum Value (`Lang.XX`) | Test File Location             |
| :-------------- | :--------------------- | :----------------------------- |
| Afrikaans       | `Lang.AF`              | `test/lang/lang_af_test.dart`  |
| Amharic         | `Lang.AM`              | `test/lang/lang_am_test.dart`  |
| Arabic          | `Lang.AR`              | `test/lang/lang_ar_test.dart`  |
| Azerbaijani     | `Lang.AZ`              | `test/lang/lang_az_test.dart`  |
| Belarusian      | `Lang.BE`              | `test/lang/lang_be_test.dart`  |
| Bulgarian       | `Lang.BG`              | `test/lang/lang_bg_test.dart`  |
| Bengali         | `Lang.BN`              | `test/lang/lang_bn_test.dart`  |
| Bosnian         | `Lang.BS`              | `test/lang/lang_bs_test.dart`  |
| Czech           | `Lang.CS`              | `test/lang/lang_cs_test.dart`  |
| Danish          | `Lang.DA`              | `test/lang/lang_da_test.dart`  |
| German          | `Lang.DE`              | `test/lang/lang_de_test.dart`  |
| Greek           | `Lang.EL`              | `test/lang/lang_el_test.dart`  |
| English         | `Lang.EN`              | `test/lang/lang_en_test.dart`  |
| Spanish         | `Lang.ES`              | `test/lang/lang_es_test.dart`  |
| Estonian        | `Lang.ET`              | `test/lang/lang_et_test.dart`  |
| Persian (Farsi) | `Lang.FA`              | `test/lang/lang_fa_test.dart`  |
| Finnish         | `Lang.FI`              | `test/lang/lang_fi_test.dart`  |
| Filipino        | `Lang.FIL`             | `test/lang/lang_fil_test.dart` |
| French          | `Lang.FR`              | `test/lang/lang_fr_test.dart`  |
| Hausa           | `Lang.HA`              | `test/lang/lang_ha_test.dart`  |
| Hebrew          | `Lang.HE`              | `test/lang/lang_he_test.dart`  |
| Hindi           | `Lang.HI`              | `test/lang/lang_hi_test.dart`  |
| Croatian        | `Lang.HR`              | `test/lang/lang_hr_test.dart`  |
| Hungarian       | `Lang.HU`              | `test/lang/lang_hu_test.dart`  |
| Armenian        | `Lang.HY`              | `test/lang/lang_hy_test.dart`  |
| Indonesian      | `Lang.ID`              | `test/lang/lang_id_test.dart`  |
| Igbo            | `Lang.IG`              | `test/lang/lang_ig_test.dart`  |
| Icelandic       | `Lang.IS`              | `test/lang/lang_is_test.dart`  |
| Italian         | `Lang.IT`              | `test/lang/lang_it_test.dart`  |
| Japanese        | `Lang.JA`              | `test/lang/lang_ja_test.dart`  |
| Georgian        | `Lang.KA`              | `test/lang/lang_ka_test.dart`  |
| Kazakh          | `Lang.KK`              | `test/lang/lang_kk_test.dart`  |
| Khmer           | `Lang.KM`              | `test/lang/lang_km_test.dart`  |
| Korean          | `Lang.KO`              | `test/lang/lang_ko_test.dart`  |
| Kyrgyz          | `Lang.KY`              | `test/lang/lang_ky_test.dart`  |
| Lao             | `Lang.LO`              | `test/lang/lang_lo_test.dart`  |
| Lithuanian      | `Lang.LT`              | `test/lang/lang_lt_test.dart`  |
| Latvian         | `Lang.LV`              | `test/lang/lang_lv_test.dart`  |
| Macedonian      | `Lang.MK`              | `test/lang/lang_mk_test.dart`  |
| Mongolian       | `Lang.MN`              | `test/lang/lang_mn_test.dart`  |
| Malay           | `Lang.MS`              | `test/lang/lang_ms_test.dart`  |
| Maltese         | `Lang.MT`              | `test/lang/lang_mt_test.dart`  |
| Burmese         | `Lang.MY`              | `test/lang/lang_my_test.dart`  |
| Nepali          | `Lang.NE`              | `test/lang/lang_ne_test.dart`  |
| Dutch           | `Lang.NL`              | `test/lang/lang_nl_test.dart`  |
| Norwegian       | `Lang.NO`              | `test/lang/lang_no_test.dart`  |
| Polish          | `Lang.PL`              | `test/lang/lang_pl_test.dart`  |
| Portuguese      | `Lang.PT`              | `test/lang/lang_pt_test.dart`  |
| Romanian        | `Lang.RO`              | `test/lang/lang_ro_test.dart`  |
| Russian         | `Lang.RU`              | `test/lang/lang_ru_test.dart`  |
| Sinhala         | `Lang.SI`              | `test/lang/lang_si_test.dart`  |
| Slovak          | `Lang.SK`              | `test/lang/lang_sk_test.dart`  |
| Slovenian       | `Lang.SL`              | `test/lang/lang_sl_test.dart`  |
| Albanian        | `Lang.SQ`              | `test/lang/lang_sq_test.dart`  |
| Serbian         | `Lang.SR`              | `test/lang/lang_sr_test.dart`  |
| Swedish         | `Lang.SV`              | `test/lang/lang_sv_test.dart`  |
| Swahili         | `Lang.SW`              | `test/lang/lang_sw_test.dart`  |
| Tamil           | `Lang.TA`              | `test/lang/lang_ta_test.dart`  |
| Tajik           | `Lang.TG`              | `test/lang/lang_tg_test.dart`  |
| Thai            | `Lang.TH`              | `test/lang/lang_th_test.dart`  |
| Turkmen         | `Lang.TK`              | `test/lang/lang_tk_test.dart`  |
| Turkish         | `Lang.TR`              | `test/lang/lang_tr_test.dart`  |
| Ukrainian       | `Lang.UK`              | `test/lang/lang_uk_test.dart`  |
| Urdu            | `Lang.UR`              | `test/lang/lang_ur_test.dart`  |
| Uzbek           | `Lang.UZ`              | `test/lang/lang_uz_test.dart`  |
| Vietnamese      | `Lang.VI`              | `test/lang/lang_vi_test.dart`  |
| Xhosa           | `Lang.XH`              | `test/lang/lang_xh_test.dart`  |
| Yoruba          | `Lang.YO`              | `test/lang/lang_yo_test.dart`  |
| Chinese         | `Lang.ZH`              | `test/lang/lang_zh_test.dart`  |
| Zulu            | `Lang.ZU`              | `test/lang/lang_zu_test.dart`  |

## Testing

The library includes comprehensive tests for each supported language. You can find the language-specific tests under the `test/lang/` directory, following the pattern `lang_xx_test.dart` (e.g., `test/lang/lang_en_test.dart`, `test/lang/lang_vi_test.dart`).

## API Documentation

Full API documentation is available [on pub.dev](https://pub.dev/documentation/num2text/latest/) once published.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests on [GitHub](https://github.com/vemines/num2text).
