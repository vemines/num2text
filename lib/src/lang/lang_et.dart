import 'package:decimal/decimal.dart';

import '../concurencies/concurencies_info.dart';
import '../num2text_base.dart';
import '../options/base_options.dart';
import '../options/et_options.dart';
import '../utils/utils.dart';

/// {@template num2text_et}
/// Converts numbers to Estonian words (`Lang.ET`).
///
/// Implements [Num2TextBase] for Estonian, handling various numeric types.
/// Supports cardinal numbers, decimals, negatives, currency, years, and large numbers.
/// Returns a fallback string on error.
/// {@endtemplate}
class Num2TextET implements Num2TextBase {
  // --- Constants ---
  static const String _hundred = "sada";
  static const String _zero = "null";
  static const String _point = "koma";
  static const String _comma = "koma";
  static const String _yearSuffixBC = "eKr";
  static const String _yearSuffixAD = "pKr";
  static const String _currencySeparator =
      "ja"; // Default currency unit separator
  static const String _defaultNaN = "Ei ole number"; // Default error fallback

  static const List<String> _wordsUnder20 = [
    "null",
    "üks",
    "kaks",
    "kolm",
    "neli",
    "viis",
    "kuus",
    "seitse",
    "kaheksa",
    "üheksa",
    "kümme",
    "üksteist",
    "kaksteist",
    "kolmteist",
    "neliteist",
    "viisteist",
    "kuusteist",
    "seitseteist",
    "kaheksateist",
    "üheksateist",
  ];
  static const List<String> _wordsTens = [
    "",
    "",
    "kakskümmend",
    "kolmkümmend",
    "nelikümmend",
    "viiskümmend",
    "kuuskümmend",
    "seitsekümmend",
    "kaheksakümmend",
    "üheksakümmend",
  ];
  static const List<String> _scaleWords = [
    "",
    "tuhat",
    "miljon",
    "miljard",
    "triljon",
    "kvadriljon",
    "kvintiljon",
    "sekstiljon",
    "septiljon",
    "oktiljon",
    "noniljon",
    "detsiljon",
    "undetsiljon",
    "duodetsiljon",
    "tredetsiljon",
    "kvattuordetsiljon",
    "kvindetsiljon",
  ];

  /// Processes the given [number] into Estonian words.
  ///
  /// {@template num2text_process_intro}
  /// Normalizes input (`int`, `double`, `BigInt`, `Decimal`, `String`) to [Decimal].
  /// {@endtemplate}
  ///
  /// {@template num2text_process_options}
  /// Uses [BaseOptions] for customization (currency, year format, decimals, etc.).
  /// Defaults apply if [options] is null.
  /// {@endtemplate}
  ///
  /// {@template num2text_process_errors}
  /// Handles `Infinity`, `NaN`. Returns [fallbackOnError] or "Ei ole number" on failure.
  /// {@endtemplate}
  ///
  /// @param number The number to convert.
  /// @param options Optional [BaseOptions] settings.
  /// @param fallbackOnError Optional error string.
  /// @return The number as Estonian words or an error string.
  @override
  String process(
      dynamic number, BaseOptions? options, String? fallbackOnError) {
    final EtOptions etOptions =
        options is EtOptions ? options : const EtOptions();
    final String errorFallback = fallbackOnError ?? _defaultNaN;

    if (number is double) {
      if (number.isInfinite) {
        return number.isNegative ? "Negatiivne lõpmatus" : "Lõpmatus";
      }
      if (number.isNaN) return errorFallback;
    }

    try {
      final normalizedNumber = Utils.normalizeNumber(number);
      if (normalizedNumber == null) return errorFallback;

      // Handle simple cases
      if (normalizedNumber == Decimal.zero) {
        if (etOptions.currency) {
          return "$_zero ${etOptions.currencyInfo.mainUnitPlural ?? etOptions.currencyInfo.mainUnitSingular}";
        }
        return _zero;
      }

      final bool isNegative = normalizedNumber.isNegative;
      final Decimal absValue =
          isNegative ? -normalizedNumber : normalizedNumber;
      String result;

      if (etOptions.format == Format.year) {
        result = _handleYearFormat(
            normalizedNumber.truncate().toBigInt(), etOptions);
      } else {
        result = etOptions.currency
            ? _handleCurrency(absValue, etOptions)
            : _handleStandardNumber(absValue, etOptions);

        if (isNegative) {
          result = "${etOptions.negativePrefix} $result";
        }
      }

      return result.trim();
    } catch (e) {
      return errorFallback;
    }
  }

  /// Converts a decimal number to standard Estonian word format
  String _handleStandardNumber(Decimal absValue, EtOptions options) {
    final BigInt integerPart = absValue.truncate().toBigInt();

    // Convert integer part
    final String integerWords = _convertIntegerPart(integerPart);

    // Handle decimal part if present
    String result = integerWords;
    if (_hasDecimalPart(absValue)) {
      // Use decimal separator according to options
      String separator = _comma;
      if (options.decimalSeparator == DecimalSeparator.period) {
        separator = _point;
      }

      String fractionalPartStr = _getFractionalPartStr(absValue);

      // Convert each digit individually
      String fractionalResult = "";
      for (int i = 0; i < fractionalPartStr.length; i++) {
        if (i > 0) fractionalResult += " ";
        int digit = int.parse(fractionalPartStr[i]);
        fractionalResult += _wordsUnder20[digit];
      }

      result += " $separator $fractionalResult";
    }

    return result;
  }

  /// Converts a decimal value to Estonian currency format
  String _handleCurrency(Decimal absValue, EtOptions options) {
    final CurrencyInfo info = options.currencyInfo;
    final Decimal val = options.round ? absValue.round(scale: 2) : absValue;
    final BigInt mainVal = val.truncate().toBigInt();
    final BigInt subVal =
        ((val - val.truncate()) * Decimal.fromInt(100)).truncate().toBigInt();
    String result = '';

    if (mainVal > BigInt.zero) {
      String mainUnit = (mainVal == BigInt.one)
          ? info.mainUnitSingular
          : (info.mainUnitPlural ?? info.mainUnitSingular);
      result = '${_convertIntegerPart(mainVal)} $mainUnit';
    }

    if (subVal > BigInt.zero && info.subUnitSingular != null) {
      String subUnit = (subVal == BigInt.one)
          ? info.subUnitSingular!
          : (info.subUnitPlural ?? info.subUnitSingular!);
      String sep = info.separator ?? _currencySeparator;
      if (result.isNotEmpty) result += ' $sep ';
      result += '${_convertIntegerPart(subVal)} $subUnit';
    }

    return result;
  }

  /// Converts a year value to Estonian format with optional era suffixes
  String _handleYearFormat(BigInt yearValue, EtOptions options) {
    final bool isNegative = yearValue.isNegative;
    final BigInt absYear = isNegative ? -yearValue : yearValue;
    String yearText = _convertIntegerPart(absYear);

    if (isNegative) {
      yearText += " $_yearSuffixBC";
    } else if (options.includeAD && yearValue > BigInt.zero) {
      yearText += " $_yearSuffixAD";
    }

    return yearText;
  }

  /// Checks if the number has a decimal part
  bool _hasDecimalPart(Decimal number) {
    return number.toString().contains('.');
  }

  /// Gets the fractional part as a string
  String _getFractionalPartStr(Decimal number) {
    String numStr = number.toString();
    int dotIndex = numStr.indexOf('.');
    return dotIndex >= 0 ? numStr.substring(dotIndex + 1) : '';
  }

  /// Converts an integer to Estonian words.
  String _convertIntegerPart(BigInt number) {
    if (number == BigInt.zero) return _zero;
    if (number < BigInt.from(20)) {
      return _wordsUnder20[number.toInt()];
    }

    // Handle tens (20-99)
    if (number < BigInt.from(100)) {
      final int tens = (number ~/ BigInt.from(10)).toInt();
      final BigInt units = number % BigInt.from(10);

      if (units == BigInt.zero) {
        return _wordsTens[tens];
      } else {
        // In Estonian, units come after tens with a space
        return "${_wordsTens[tens]} ${_wordsUnder20[units.toInt()]}";
      }
    }

    // Handle hundreds (100-999)
    if (number < BigInt.from(1000)) {
      final int hundreds = (number ~/ BigInt.from(100)).toInt();
      final BigInt remainder = number % BigInt.from(100);

      // In Estonian, hundreds are combined with the word "sada" as a compound
      // e.g., "kakssada" (two hundred), "kolmsada" (three hundred)
      String result =
          hundreds == 1 ? _hundred : "${_wordsUnder20[hundreds]}$_hundred";

      if (remainder != BigInt.zero) {
        result += " ${_convertIntegerPart(remainder)}";
      }

      return result;
    }

    // Find the appropriate scale (thousand, million, etc.)
    int scaleIndex = 0;
    BigInt scaleDivider = BigInt.from(1);

    for (int i = 1; i < _scaleWords.length; i++) {
      final BigInt nextDivider = scaleDivider * BigInt.from(1000);
      if (number < nextDivider) break;
      scaleDivider = nextDivider;
      scaleIndex = i;
    }

    final BigInt quotient = number ~/ scaleDivider;
    final BigInt remainder = number % scaleDivider;

    String result = "";

    // Add scale word with correct grammatical form
    if (scaleIndex > 0) {
      if (quotient == BigInt.one) {
        result = scaleIndex == 1
            ? _scaleWords[scaleIndex] // "tuhat" for 1000
            : "${_convertIntegerPart(quotient)} ${_scaleWords[scaleIndex]}"; // "üks miljon"
      } else {
        // Use partitive case for numbers (e.g., "kaks tuhat", "viis miljonit")
        String scaleSuffix =
            scaleIndex >= 2 ? "it" : ""; // Add "it" to million and above
        result =
            "${_convertIntegerPart(quotient)} ${_scaleWords[scaleIndex]}$scaleSuffix";
      }
    } else {
      result = _convertIntegerPart(quotient);
    }

    if (remainder != BigInt.zero) {
      result += " ${_convertIntegerPart(remainder)}";
    }

    return result;
  }
}
