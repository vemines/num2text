import 'lang/lang.dart';
import 'lang_enum.dart';
import 'num2text_base.dart';
import 'options/base_options.dart';

/// **Num2Text: Convert Numbers to Words**
///
/// The main entry point for converting numbers (integers, doubles, BigInt, Decimal)
/// into their linguistic word representation (cardinal form) across various languages.
///
/// This class manages language-specific conversion logic. You create an instance,
/// optionally set a language, and then use the `convert` (or `call`) method
/// to perform the conversion.
///
/// **Core Features:**
/// *   Supports multiple languages via the [Lang] enum.
/// *   Handles different number types consistently using `Decimal` internally.
/// *   Allows customization through language-specific [BaseOptions] subclasses
///     (e.g., [EnOptions], [ViOptions]) for features like currency formatting,
///     year formatting, grammatical variations, etc.
/// *   Provides an optional fallback mechanism for conversion errors.
///
/// **Example Usage:**
/// ```dart
/// // 1. Create an instance (defaults to English)
/// final num2text = Num2Text();
///
/// // 2. Basic conversion (English)
/// print(num2text.convert(123));           // Output: one hundred twenty-three
/// print(num2text.convert(1045.67));        // Output: one thousand forty-five point six seven
///
/// // 3. Use English options (e.g., British 'and', USD currency)
/// print(num2text.convert(123, options: EnOptions(includeAnd: true))); // Output: one hundred and twenty-three
/// print(num2text.convert(50.99, options: EnOptions(currency: true))); // Output: fifty dollars and ninety-nine cents
///
/// // 4. Change language
/// num2text.setLang(Lang.VI); // Switch to Vietnamese
///
/// // 5. Basic conversion (Vietnamese)
/// print(num2text.convert(987));           // Output: chín trăm tám mươi bảy
///
/// // 6. Use Vietnamese options (e.g., currency, alternative 'lẻ')
/// print(num2text.convert(105, options: ViOptions(useLe: true)));       // Output: một trăm lẻ năm
/// print(num2text.convert(25000.5, options: ViOptions(currency: true))); // Output: hai mươi lăm nghìn đồng (subunit is skiped)
/// print(num2text(2024, options: ViOptions(format: Format.year))); // Output: hai nghìn không trăm hai mươi tư
///
/// // 7. Switch to another language (Spanish) and use options
/// num2text.setLang(Lang.ES);
/// print(num2text(15, options: EsOptions(currency: true, currencyInfo: CurrencyInfo.eurEs))); // Output: quince euros
/// print(num2text(1001.5, options: EsOptions(currency: true, currencyInfo: CurrencyInfo.eurEs))); // Output: mil un euros con cincuenta céntimos
///
/// // 8. Change language using string code
/// num2text.setLangByCode('fr'); // Switch to French
/// print(num2text(42)); // Output: quarante-deux
///
/// // 9. Safely change language with fallback
/// num2text.setLangByCodeSafe('xyz'); // Invalid code, falls back to English
/// print(num2text(42)); // Output: forty-two
///
/// // 10. Using the callable instance syntax
/// print(num2text(1_000_000)); // Output: un millón
///
/// // 11. Switch back to English and use GBP currency
/// num2text.setLang(Lang.EN);
/// // Use includeAnd: true for typical British English currency phrasing
/// print(num2text(135.75, options: EnOptions(currency: true, currencyInfo: CurrencyInfo.gbp, includeAnd: true)));
/// // Output: one hundred and thirty-five pounds and seventy-five pence
/// print(num2text(1.01, options: EnOptions(currency: true, currencyInfo: CurrencyInfo.gbp, includeAnd: true)));
/// // Output: one pound and one penny
/// ```
class Num2Text {
  /// The currently active language used for conversions.
  Lang _currentLang;

  /// An optional string returned if any error occurs during conversion.
  /// If `null`, errors might throw exceptions or be handled by the specific converter.
  final String? fallbackOnError;

  /// A map storing initialized instances of language-specific converters, keyed by [Lang].
  final Map<Lang, Num2TextBase> _converters = {};

  /// Creates a `Num2Text` instance, ready for number-to-word conversions.
  ///
  /// - [initialLang]: The language to use for conversions initially. Defaults to [Lang.EN] (English).
  ///   An [ArgumentError] is thrown if this language isn't supported (i.e., not registered).
  /// - [fallbackOnError]: A string to return if conversion fails (e.g., due to invalid input
  ///   or internal errors). If `null`, errors are handled by the underlying converter, potentially
  ///   throwing an exception or returning a default error message.
  Num2Text({Lang initialLang = Lang.EN, this.fallbackOnError})
      : _currentLang = initialLang {
    _registerConverters();
    // Ensure the selected initial language has a registered converter.
    if (!_converters.containsKey(_currentLang)) {
      throw ArgumentError('Initial language $_currentLang is not supported.');
    }
  }

  /// Initializes and registers instances of all supported language converters.
  ///
  /// This method populates the internal `_converters` map. It's called once
  /// during the instance creation. To add support for a new language,
  /// create its `Num2TextXX` class implementing [Num2TextBase] and register it here.
  void _registerConverters() {
    // This pattern assumes Num2TextXX classes exist in 'lang/lang.dart'
    _converters[Lang.AF] = Num2TextAF();
    _converters[Lang.AM] = Num2TextAM();
    _converters[Lang.AR] = Num2TextAR();
    _converters[Lang.AZ] = Num2TextAZ();
    _converters[Lang.BE] = Num2TextBE();
    _converters[Lang.BG] = Num2TextBG();
    _converters[Lang.BN] = Num2TextBN();
    _converters[Lang.BS] = Num2TextBS();
    _converters[Lang.CS] = Num2TextCS();
    _converters[Lang.DA] = Num2TextDA();
    _converters[Lang.DE] = Num2TextDE();
    _converters[Lang.EL] = Num2TextEL();
    _converters[Lang.EN] = Num2TextEN();
    _converters[Lang.ES] = Num2TextES();
    _converters[Lang.ET] = Num2TextET();
    _converters[Lang.FA] = Num2TextFA();
    _converters[Lang.FI] = Num2TextFI();
    _converters[Lang.FIL] = Num2TextFIL();
    _converters[Lang.FR] = Num2TextFR();
    _converters[Lang.HA] = Num2TextHA();
    _converters[Lang.HE] = Num2TextHE();
    _converters[Lang.HI] = Num2TextHI();
    _converters[Lang.HR] = Num2TextHR();
    _converters[Lang.HU] = Num2TextHU();
    _converters[Lang.HY] = Num2TextHY();
    _converters[Lang.ID] = Num2TextID();
    _converters[Lang.IG] = Num2TextIG();
    _converters[Lang.IS] = Num2TextIS();
    _converters[Lang.IT] = Num2TextIT();
    _converters[Lang.JA] = Num2TextJA();
    _converters[Lang.KA] = Num2TextKA();
    _converters[Lang.KK] = Num2TextKK();
    _converters[Lang.KM] = Num2TextKM();
    _converters[Lang.KO] = Num2TextKO();
    _converters[Lang.KY] = Num2TextKY();
    _converters[Lang.LO] = Num2TextLO();
    _converters[Lang.LT] = Num2TextLT();
    _converters[Lang.LV] = Num2TextLV();
    _converters[Lang.MK] = Num2TextMK();
    _converters[Lang.MN] = Num2TextMN();
    _converters[Lang.MS] = Num2TextMS();
    _converters[Lang.MT] = Num2TextMT();
    _converters[Lang.MY] = Num2TextMY();
    _converters[Lang.NE] = Num2TextNE();
    _converters[Lang.NL] = Num2TextNL();
    _converters[Lang.NO] = Num2TextNO();
    _converters[Lang.PL] = Num2TextPL();
    _converters[Lang.PT] = Num2TextPT();
    _converters[Lang.RO] = Num2TextRO();
    _converters[Lang.RU] = Num2TextRU();
    _converters[Lang.SI] = Num2TextSI();
    _converters[Lang.SK] = Num2TextSK();
    _converters[Lang.SL] = Num2TextSL();
    _converters[Lang.SQ] = Num2TextSQ();
    _converters[Lang.SR] = Num2TextSR();
    _converters[Lang.SV] = Num2TextSV();
    _converters[Lang.SW] = Num2TextSW();
    _converters[Lang.TA] = Num2TextTA();
    _converters[Lang.TG] = Num2TextTG();
    _converters[Lang.TH] = Num2TextTH();
    _converters[Lang.TK] = Num2TextTK();
    _converters[Lang.TR] = Num2TextTR();
    _converters[Lang.UK] = Num2TextUK();
    _converters[Lang.UR] = Num2TextUR();
    _converters[Lang.UZ] = Num2TextUZ();
    _converters[Lang.VI] = Num2TextVI();
    _converters[Lang.XH] = Num2TextXH();
    _converters[Lang.YO] = Num2TextYO();
    _converters[Lang.ZH] = Num2TextZH();
    _converters[Lang.ZU] = Num2TextZU();
    // Register future languages here
  }

  /// Changes the active language for subsequent calls to `convert` or `call`.
  ///
  /// Throws an [ArgumentError] if the [newLang] is not supported (i.e., not registered).
  void setLang(Lang newLang) {
    if (!_converters.containsKey(newLang)) {
      throw ArgumentError('Language $newLang is not supported.');
    }
    _currentLang = newLang;
  }

  /// Changes the active language for subsequent calls using a language code string.
  ///
  /// The [langCode] should be a two-letter ISO 639-1 language code (e.g., 'en', 'fr', 'es').
  /// Case-insensitive.
  ///
  /// If the [langCode] is not supported, it will either:
  /// - Throw [ArgumentError] if [fallbackToDefault] is false
  /// - Use the fallback language (default: English) if [fallbackToDefault] is true
  ///
  /// Example:
  /// ```dart
  /// num2text.setLangByCode('fr'); // Switch to French
  /// num2text.setLangByCode('es'); // Switch to Spanish
  /// ```
  void setLangByCode(
    String langCode, {
    bool fallbackToDefault = false,
    Lang defaultLang = Lang.EN,
  }) {
    final lang = Lang.fromCode(langCode);
    if (lang == null) {
      if (fallbackToDefault) {
        setLang(defaultLang);
      } else {
        throw ArgumentError(
          'Language code "$langCode" is not supported. Available codes: ${Lang.availableCodes.join(', ')}',
        );
      }
    } else {
      setLang(lang);
    }
  }

  /// Changes the active language for subsequent calls using a language code string.
  ///
  /// Similar to [setLangByCode], but always falls back to the default language
  /// (English unless specified) if the provided language code is not supported.
  ///
  /// Example:
  /// ```dart
  /// num2text.setLangByCodeSafe('xyz'); // Invalid code, falls back to English
  /// num2text.setLangByCodeSafe('invalid', defaultLang: Lang.FR); // Falls back to French
  /// ```
  void setLangByCodeSafe(String langCode, {Lang defaultLang = Lang.EN}) {
    setLangByCode(langCode, fallbackToDefault: true, defaultLang: defaultLang);
  }

  /// Gets the currently active language ([Lang]) for conversions.
  Lang get currentLang => _currentLang;

  /// Internal getter to retrieve the appropriate language converter based on [_currentLang].
  ///
  /// Throws a [StateError] if no converter is found for the current language,
  /// although this should typically be prevented by checks in the constructor and [setLang].
  Num2TextBase get _currentConverter {
    final converter = _converters[_currentLang];
    if (converter == null) {
      // This state should be unreachable if constructor/setLang checks pass.
      throw StateError(
        'Internal error: No converter found for language $_currentLang.',
      );
    }
    return converter;
  }

  /// Converts the given [number] into its word representation using the currently active language.
  ///
  /// - [number]: The number to convert. Supports `int`, `double`, `BigInt`, `String` (if parsable),
  ///   and `Decimal` types. Invalid inputs (e.g., non-numeric strings, NaN, infinity)
  ///   will likely result in an error.
  /// - [options]: An optional instance of a [BaseOptions] subclass specific to the
  ///   current language (e.g., [EnOptions] for `Lang.EN`, [ViOptions] for `Lang.VI`).
  ///   These options allow customizing the output format (e.g., currency, year, specific grammar rules).
  ///   If `null`, default options for the language are used.
  ///
  /// Returns the word representation of the number as a [String].
  ///
  /// If an error occurs during conversion (e.g., invalid input, internal issue),
  /// it returns the [fallbackOnError] string if it was provided to the constructor.
  /// Otherwise, it returns a generic error message "Error occurred during conversion.".
  /// Consider using a `try-catch` block around calls if you need more specific error handling.
  String convert(dynamic number, {BaseOptions? options}) {
    try {
      // Delegate the conversion process to the language-specific converter.
      // Pass the number, options, and the fallback string.
      return _currentConverter.process(number, options, fallbackOnError);
    } catch (e) {
      // Basic error catching. Optionally log the error here:
      // print('Num2Text conversion error for language $_currentLang: $e');
      return 'Error occurred during conversion. ${e.toString()}'; // Return error message
    }
  }

  /// Convenience method to call the instance directly like a function.
  String call(dynamic number, {BaseOptions? options}) {
    return convert(number, options: options);
  }
}
