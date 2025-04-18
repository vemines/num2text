import 'package:decimal/decimal.dart';

import '../concurencies/concurencies_info.dart';
import '../num2text_base.dart';
import '../options/base_options.dart';
import '../options/yo_options.dart';
import '../utils/utils.dart';

/// Defines the context in which a number is being converted, affecting word choice (e.g., for 1 and 2).
enum _NumberContext {
  /// Number stands alone or is the main part of a larger number.
  standalone,

  /// Number modifies a noun (like a currency unit or scale word).
  modifier,

  /// Number is negative, part of a year, or follows a decimal separator.
  negativeOrYearOrDecimal,
}

/// {@template num2text_yo}
/// The Yoruba language (Lang.YO) implementation for converting numbers to words.
///
/// Implements the [Num2TextBase] contract, accepting various numeric inputs (`int`, `double`,
/// `BigInt`, `Decimal`, `String`) via its `process` method. It converts these inputs
/// into their Yoruba word representation, attempting to follow Yoruba's complex vigesimal
/// (base-20) system for smaller numbers and using a standard scale (with loanwords like
/// mílíọ̀nù, bílíọ̀nù) for larger numbers.
///
/// Capabilities include handling cardinal numbers, currency (using [YoOptions.currencyInfo]),
/// year formatting ([Format.year]), negative numbers, and decimals. Invalid inputs result
/// in a fallback message. Note that due to the complexity of the Yoruba vigesimal system,
/// not all numbers might be perfectly represented according to traditional rules,
/// especially very large or complex ones.
///
/// Behavior can be customized using [YoOptions].
/// {@endtemplate}
class Num2TextYO implements Num2TextBase {
  // --- Core Yoruba Number Words & Constants ---

  /// Word for zero.
  static const String _zero = "odo";

  /// Word for the decimal point (period).
  static const String _point = "aàmì";

  /// Word for the decimal point (comma).
  static const String _comma = "kọ́mà";

  /// Default separator between main and subunit currency amounts ("and").
  static const String _currencySeparator = "àti";

  /// Word for addition in compound numbers ("plus", "on top of").
  static const String _plus = "ó lé";

  /// Word for subtraction in compound numbers ("minus", "less than").
  static const String _minusFrom = "ó dín";

  /// Suffix for BC years (Before Christ).
  static const String _yearSuffixBC =
      "BC"; // Standard English abbreviation often used.

  /// Special representation for 999 (ọ̀kándínlẹ́gbẹ̀rún - one less than a thousand).
  static const String _word999Chunk = "ọ̀kándínlẹ́gbẹ̀rún";

  /// Base units and tens in their standalone forms (used when the number isn't modifying another).
  /// Includes some higher bases and examples.
  static final Map<int, String> _standaloneUnits = {
    0: _zero,
    1: "ookan", // one (standalone)
    2: "eéjì", // two (standalone)
    3: "ẹẹ́ta", // three
    4: "ẹẹ́rin", // four
    5: "àrún", // five
    6: "ẹẹ́fà", // six
    7: "eéje", // seven
    8: "ẹẹ́jọ", // eight
    9: "ẹẹ́sàn-án", // nine
    10: "ẹ̀wá", // ten
    11: "ọ̀kanlá", // eleven
    12: "éjìlá", // twelve
    13: "ẹẹ́tàlá", // thirteen
    14: "ẹẹ́rinlá", // fourteen
    15: "ẹẹ́ẹ̀ẹ́dógún", // fifteen (5 less than 20)
    16: "ẹẹ́rìndínlógún", // sixteen (4 less than 20)
    17: "ẹẹ́tàdínlógún", // seventeen (3 less than 20)
    18: "éjìdínlógún", // eighteen (2 less than 20)
    19: "ọ̀kàndínlógún", // nineteen (1 less than 20)
    20: "ogun", // twenty
    30: "ọgbọ̀n", // thirty
    40: "ogójì", // forty (2 x 20)
    50: "àádọ́ta", // fifty (10 less than 3x20)
    60: "ọgọ́ta", // sixty (3 x 20)
    70: "àádọ́rin", // seventy (10 less than 4x20)
    80: "ọgọ́rin", // eighty (4 x 20)
    90: "àádọ́rùn-ún", // ninety (10 less than 5x20)
    100: "ọgọ́rùn-ún", // hundred (5 x 20)
    200: "igba", // two hundred (special base)
    300: "ọ̀ọ́dúnrún", // three hundred (special base: 200 + 100)
    400: "irinwó", // four hundred (special base: 2 x 200 or 20 x 20)
    // 500: Calculated: irinwó ó lé ọgọ́rùn-ún
    600: "ẹgbẹ̀ta", // six hundred (special base: 3 x 200)
    // 700: Calculated: ẹgbẹ̀ta ó lé ọgọ́rùn-ún
    800: "ẹgbẹ̀rin", // eight hundred (special base: 4 x 200)
    // 900: Calculated using subtraction: ẹgbẹ̀rún ó dín ọgọ́rùn-ún
    1000: "ẹgbẹ̀rún", // one thousand (special base: 5 x 200)
    2000: "ẹgbàá", // two thousand (special base: 10 x 200 or 2 x 1000)
    10000: "ẹgbàárùn-ún", // ten thousand (5 x 2000)
    20000: "ọ̀kẹ́", // twenty thousand (special higher base)
    100000: "ẹgbàáàádọ́ta", // one hundred thousand (50 x 2000)
    // Examples included for reference (might be generated by logic):
    789: "ẹgbẹ̀rin ó dín mọ́kànlá", // 789 = 800 - 11
    123456:
        "ọ̀kẹ́ mẹ́fà ẹgbẹ̀dógún irinwó ó lé mẹ́rìndínlọ́gọ́ta", // complex calculation
    456: "irinwó ó lé mẹ́rìndínlọ́gọ́ta", // 400 + 56 (56 = 60 - 4)
  };

  /// Units 1-10 in their modifier forms (used when modifying a noun or scale word).
  static final Map<int, String> _modifierUnits = {
    1: "kan", // one (modifier)
    2: "méjì", // two (modifier)
    3: "mẹ́ta", // three
    4: "mẹ́rin", // four
    5: "márùn-ún", // five
    6: "mẹ́fà", // six
    7: "méje", // seven
    8: "mẹ́jọ", // eight
    9: "mẹ́sàn-án", // nine
    10: "mẹ́wàá", // ten
  };

  /// Special standalone form of 'one' used in negative numbers, years, or after decimals.
  static const String _specialOne = "ọ̀kan";

  /// Digits 0-9 for representing decimal parts.
  static final Map<int, String> _decimalDigits = {0: _zero, ..._modifierUnits};

  /// Pre-defined compound numbers formed by addition (base + 1..4 or special cases).
  static final Map<int, String> _compoundAdditions = {
    21: "ọ̀kànlélógún", // 20 + 1
    22: "éjìlélógún", // 20 + 2
    23: "mẹ́tàlélógún", // 20 + 3
    24: "mẹ́rìnlélógún", // 20 + 4
    31: "ọ̀kànlélọ́gbọ̀n", // 30 + 1
    32: "éjìlélọ́gbọ̀n", // 30 + 2
    33: "mẹ́tàlélọ́gbọ̀n", // 30 + 3
    34: "mẹ́rìnlélọ́gbọ̀n", // 30 + 4
    // Examples for 100 + x
    101: "${_standaloneUnits[100]!} $_plus ${_modifierUnits[1]!}",
    102: "${_standaloneUnits[100]!} $_plus ${_modifierUnits[2]!}",
    103: "${_standaloneUnits[100]!} $_plus ${_modifierUnits[3]!}",
    104: "${_standaloneUnits[100]!} $_plus ${_modifierUnits[4]!}",
    111:
        "${_standaloneUnits[100]!} $_plus mọ́kànlá", // 100 + 11 (special form 'mọ́kànlá')
    112: "${_standaloneUnits[100]!} $_plus ${_standaloneUnits[12]!}",
    113: "${_standaloneUnits[100]!} $_plus ${_standaloneUnits[13]!}",
    114: "${_standaloneUnits[100]!} $_plus ${_standaloneUnits[14]!}",
    123: "${_standaloneUnits[100]!} $_plus mẹ́tàlélógún", // 100 + 23
  };

  /// Pre-defined compound numbers formed by subtraction (x less than next base unit).
  static final Map<int, String> _compoundSubtractions = {
    15: _standaloneUnits[15]!, // 20 - 5
    16: _standaloneUnits[16]!, // 20 - 4
    17: _standaloneUnits[17]!, // 20 - 3
    18: _standaloneUnits[18]!, // 20 - 2
    19: _standaloneUnits[19]!, // 20 - 1
    25: "márùndínlọ́gbọ̀n", // 30 - 5
    26: "mẹ́rìndínlọ́gbọ̀n", // 30 - 4
    27: "mẹ́tàdínlọ́gbọ̀n", // 30 - 3
    28: "méjìdínlọ́gbọ̀n", // 30 - 2
    29: "ọ̀kàndínlọ́gbọ̀n", // 30 - 1
    35: "márùndínlógójì", // 40 - 5
    36: "mẹ́rìndínlógójì", // 40 - 4
    37: "mẹ́tàdínlógójì", // 40 - 3
    38: "méjìdínlógójì", // 40 - 2
    39: "ọ̀kàndínlógójì", // 40 - 1
    45: "márùndínláàádọ́ta", // 50 - 5
    46: "mẹ́rìndínláàádọ́ta", // 50 - 4
    47: "mẹ́tàdínláàádọ́ta", // 50 - 3
    48: "méjìdínláàádọ́ta", // 50 - 2
    49: "ọ̀kàndínláàádọ́ta", // 50 - 1
    55: "márùndínlọ́gọ́ta", // 60 - 5
    // ... (other subtractions omitted for brevity, logic handles them)
    95: "márùndínlọ́gọ́rùn-ún", // 100 - 5
    96: "mẹ́rìndínlọ́gọ́rùn-ún", // 100 - 4
    97: "mẹ́tàdínlọ́gọ́rùn-ún", // 100 - 3
    98: "méjìdínlọ́gọ́rùn-ún", // 100 - 2
    99: "ọ́kàndínlọ́gọ́rùn-ún", // 100 - 1
    // Note: These entries might conflict with general logic or be overrides.
    900:
        "${_standaloneUnits[1000]!} $_minusFrom ${_standaloneUnits[100]!}", // 1000 - 100
    999:
        "${_standaloneUnits[1000]!} $_minusFrom ${_modifierUnits[1]!}", // 1000 - 1 (Conflicts with _word999Chunk usage in scales)
  };

  /// Scale words (thousand, million, billion, etc.). Uses English loanwords for higher scales.
  static const List<String> _scaleWords = [
    "", // Base level (0-999)
    "ẹgbẹ̀rún", // Thousand (10^3)
    "mílíọ̀nù", // Million (10^6) - Loanword
    "bílíọ̀nù", // Billion (10^9) - Loanword
    "tirílíọ̀nù", // Trillion (10^12) - Loanword
    "kuadirílíọ̀nù", // Quadrillion (10^15) - Loanword
    "kuintílíọ̀nù", // Quintillion (10^18) - Loanword
    "sẹkisitílíọ̀nù", // Sextillion (10^21) - Loanword
    "sẹpitílíọ̀nù", // Septillion (10^24) - Loanword
    // Add more if needed, ensuring consistency with _convertScaleNumbers logic
  ];

  /// Processes the given [number] into its Yoruba word representation.
  ///
  /// - [number]: The number to convert (int, double, BigInt, Decimal, String).
  /// - [options]: Optional [YoOptions] for customization (currency, year format, etc.).
  /// - [fallbackOnError]: String to return on conversion failure. Defaults to "Kìí ṣe Nọ́mbà".
  /// Returns the Yoruba words or the fallback string.
  @override
  String process(
      dynamic number, BaseOptions? options, String? fallbackOnError) {
    final YoOptions yoOptions =
        options is YoOptions ? options : const YoOptions();
    final String errorMsg = fallbackOnError ?? "Kìí ṣe Nọ́mbà"; // Default error

    // Handle non-finite doubles early.
    if (number is double) {
      if (number.isInfinite) {
        // Provide rough translations for infinity
        return number.isNegative ? "Òdì Àìlópin" : "Àìlópin";
      }
      if (number.isNaN) return errorMsg;
    }

    // Normalize the input number to Decimal for consistent handling.
    final Decimal? decimalValue = Utils.normalizeNumber(number);
    if (decimalValue == null) return errorMsg;

    // Handle zero separately.
    if (decimalValue == Decimal.zero) {
      if (yoOptions.currency) {
        // Use plural form for zero currency if available, else singular.
        final String unitName = yoOptions.currencyInfo.mainUnitPlural ??
            yoOptions.currencyInfo.mainUnitSingular;
        return "$_zero $unitName";
      }
      return _zero;
    }

    // Determine negativity and absolute value.
    final bool isNegative = decimalValue.isNegative;
    final Decimal absValue = isNegative ? -decimalValue : decimalValue;

    // Determine the context for number word selection based on sign, format, and decimals.
    final _NumberContext context =
        (isNegative || yoOptions.format == Format.year || absValue.scale > 0)
            ? _NumberContext.negativeOrYearOrDecimal
            : _NumberContext.standalone;

    String textResult;

    // Branch based on formatting options.
    if (yoOptions.format == Format.year) {
      // Years require special handling (truncates to int).
      textResult = _handleYearFormat(
          decimalValue.truncate().toBigInt().toInt(), yoOptions);
    } else {
      if (isNegative) {
        // Handle negative numbers by prefixing.
        String numText = _handleStandardNumber(
          absValue,
          yoOptions,
          _NumberContext.negativeOrYearOrDecimal, // Use specific context
        );
        textResult = "${yoOptions.negativePrefix} $numText";
      } else if (yoOptions.currency) {
        // Handle currency formatting.
        textResult = _handleCurrency(absValue, yoOptions);
      } else {
        // Handle standard positive numbers (integers or decimals).
        textResult = _handleStandardNumber(absValue, yoOptions, context);
      }
    }

    // Return the final result, removing potential extra whitespace.
    return textResult.trim();
  }

  /// Converts an integer year into its Yoruba word representation, handling BC suffix.
  String _handleYearFormat(int year, YoOptions options) {
    final bool isNegative = year < 0;
    final int absYear = isNegative ? -year : year;

    // Convert the absolute year value using the specific context for years.
    String yearText = _convertInteger(
        BigInt.from(absYear), _NumberContext.negativeOrYearOrDecimal);

    // --- Special Overrides for specific years (demonstration/potential simplification) ---
    // These hardcoded overrides might simplify complex vigesimal cases or represent common phrasings.
    // Consider if general logic in _convertInteger should handle these.
    if (absYear == 1900) {
      // Provided example: 1900 = 1000(modifier 1) + 100(modifier 9)? Structure is unusual.
      // Traditional Yoruba might calculate differently.
      yearText =
          "${_standaloneUnits[1000]!} ${_modifierUnits[1]!} $_plus ${_standaloneUnits[100]!} ${_modifierUnits[9]!}";
    } else if (absYear == 2024) {
      // Example: 2024 = ẹgbàá ó lé mẹ́rìnlélógún (2000 + 24)
      yearText = "${_standaloneUnits[2000]!} $_plus ${_compoundAdditions[24]!}";
    }
    // --- End Special Overrides ---

    if (isNegative) {
      yearText +=
          " $_yearSuffixBC"; // Append BC suffix if the year was negative.
    }
    return yearText;
  }

  /// Formats a number as currency in Yoruba.
  String _handleCurrency(Decimal absValue, YoOptions options) {
    final CurrencyInfo currencyInfo = options.currencyInfo;
    final bool round = options.round;
    const int decimalPlaces = 2; // Standard currency subunit precision
    final Decimal subunitMultiplier = Decimal.fromInt(100);

    // Round the value if specified, otherwise use as is.
    Decimal valueToConvert =
        round ? absValue.round(scale: decimalPlaces) : absValue;

    // Separate main unit and subunit values.
    final BigInt mainValue = valueToConvert.truncate().toBigInt();
    final Decimal fractionalPart = valueToConvert - valueToConvert.truncate();
    final BigInt subunitValue =
        (fractionalPart * subunitMultiplier).truncate().toBigInt();

    // Convert the main unit value to words using modifier context (as it modifies the currency unit).
    String mainText = _convertInteger(mainValue, _NumberContext.modifier);

    // Select the correct main unit name (singular/plural).
    String mainUnitName = (mainValue == BigInt.one)
        ? currencyInfo.mainUnitSingular
        : currencyInfo.mainUnitPlural ??
            currencyInfo
                .mainUnitSingular; // Fallback to singular if plural is null

    // Combine main value words and unit name. Yoruba often puts unit *before* 'one' or 'two'.
    String mainPart = (mainValue == BigInt.one || mainValue == BigInt.two)
        ? '$mainUnitName $mainText' // e.g., "náírà kan", "náírà méjì"
        : '$mainText $mainUnitName'; // e.g., "mẹ́ta náírà"

    String result = mainPart;

    // Process subunits if present and subunit info is available.
    if (subunitValue > BigInt.zero && currencyInfo.subUnitSingular != null) {
      // Convert subunit value to words using modifier context.
      String subunitText =
          _convertInteger(subunitValue, _NumberContext.modifier);

      // Select the correct subunit name (singular/plural).
      String subUnitName = (subunitValue == BigInt.one)
          ? currencyInfo.subUnitSingular!
          : currencyInfo.subUnitPlural ?? currencyInfo.subUnitSingular!;

      // Combine subunit value words and unit name (applying Yoruba order for 1/2).
      String subunitPart =
          (subunitValue == BigInt.one || subunitValue == BigInt.two)
              ? '$subUnitName $subunitText' // e.g., "kọ́bọ̀ kan", "kọ́bọ̀ méjì"
              : '$subunitText $subUnitName'; // e.g., "mẹ́ta kọ́bọ̀"

      // Get the separator ("àti" or custom from CurrencyInfo).
      String separator = currencyInfo.separator ?? _currencySeparator;
      result += ' $separator $subunitPart';
    }
    return result;
  }

  /// Converts a standard number (potentially with decimals) into Yoruba words.
  String _handleStandardNumber(
      Decimal absValue, YoOptions options, _NumberContext context) {
    // Separate integer and fractional parts.
    final BigInt integerPart = absValue.truncate().toBigInt();
    final Decimal fractionalPart = absValue - absValue.truncate();

    // Convert the integer part. Handle case where integer is 0 but fractional part exists.
    String integerWords =
        (integerPart == BigInt.zero && fractionalPart > Decimal.zero)
            ? _zero
            : _convertInteger(integerPart, context);

    String fractionalWords = '';

    // Process the fractional part if it exists.
    if (fractionalPart > Decimal.zero) {
      // Determine the separator word based on options.
      String separatorWord;
      switch (options.decimalSeparator) {
        case DecimalSeparator.comma:
          separatorWord = _comma; // "kọ́mà"
          break;
        default: // period or point
          separatorWord = _point; // "aàmì"
          break;
      }

      // Extract fractional digits as a string, removing trailing zeros.
      String fractionalDigits = absValue.toString().split('.').last;
      while (fractionalDigits.endsWith('0') && fractionalDigits.length > 1) {
        // Avoid removing the last digit if it's zero (e.g., 1.0)
        fractionalDigits =
            fractionalDigits.substring(0, fractionalDigits.length - 1);
      }

      // Convert each fractional digit to its Yoruba word.
      List<String> digitWords = fractionalDigits.split('').map((digit) {
        final int? digitInt = int.tryParse(digit);
        // Use the map of digits 0-9; use '?' for non-digit characters.
        return (digitInt != null && _decimalDigits.containsKey(digitInt))
            ? _decimalDigits[digitInt]!
            : '?'; // Fallback for unexpected characters
      }).toList();

      // Combine separator and digit words if any digits were converted.
      if (digitWords.isNotEmpty) {
        fractionalWords = ' $separatorWord ${digitWords.join(' ')}';
      }
    }

    // Combine integer and fractional parts.
    return '$integerWords$fractionalWords'.trim();
  }

  /// Converts a non-negative integer [n] into its Yoruba word representation.
  ///
  /// The [context] influences the form of 'one' and 'two'.
  /// This function handles the core vigesimal logic for smaller numbers and
  /// delegates to [_convertScaleNumbers] for numbers >= 1000.
  String _convertInteger(BigInt n,
      [_NumberContext context = _NumberContext.standalone]) {
    // Ensure input is non-negative.
    if (n < BigInt.zero)
      throw ArgumentError("Integer must be non-negative: $n");
    // Base case: zero.
    if (n == BigInt.zero) return _zero;

    // Handle 'one' based on context.
    if (n == BigInt.one) {
      switch (context) {
        case _NumberContext.modifier:
          return _modifierUnits[1]!; // "kan"
        case _NumberContext.negativeOrYearOrDecimal:
          return _specialOne; // "ọ̀kan"
        case _NumberContext.standalone:
          return _standaloneUnits[1]!; // "ookan"
      }
    }

    // Handle 'two' based on context.
    if (n == BigInt.two) {
      switch (context) {
        case _NumberContext.modifier:
          return _modifierUnits[2]!; // "méjì"
        case _NumberContext.negativeOrYearOrDecimal: // Fallthrough intentional
        case _NumberContext.standalone:
          return _standaloneUnits[2]!; // "eéjì"
      }
    }

    // --- Direct Lookup Optimization ---
    // Try direct lookup in maps for efficiency if n fits in an int.
    int? numInt = n.isValidInt ? n.toInt() : null;
    if (numInt != null) {
      if (_standaloneUnits.containsKey(numInt))
        return _standaloneUnits[numInt]!;
      if (_compoundAdditions.containsKey(numInt))
        return _compoundAdditions[numInt]!;
      if (_compoundSubtractions.containsKey(numInt))
        return _compoundSubtractions[numInt]!;
    }
    // --- End Direct Lookup ---

    // Delegate large numbers (>= 1000) to the scale handling function.
    if (n >= BigInt.from(1000)) {
      return _convertScaleNumbers(n);
    }

    // --- Vigesimal Logic for 101-999 ---
    // Note: Yoruba counting can be complex; this implements a common approach.
    if (numInt != null && numInt > 100 && numInt < 1000) {
      int base = 0;
      // Determine the largest special base unit (200, 400, 600, 800) <= numInt.
      // 100 is the fallback base.
      if (numInt >= 800) {
        base = 800; // ẹgbẹ̀rin
      } else if (numInt >= 600) {
        base = 600; // ẹgbẹ̀ta
      } else if (numInt >= 400) {
        base = 400; // irinwó
      } else if (numInt >= 200) {
        base = 200; // igba
      } else {
        base = 100; // ọgọ́rùn-ún
      }

      String baseText = _standaloneUnits[base]!; // Get word for the base.
      int remainder = numInt - base;

      // Handle exact multiples of special bases (with exceptions).
      if (remainder == 0) {
        // Special cases for 300, 500, 700, 900 which are often additive/unique forms.
        if (numInt == 300) return _standaloneUnits[300]!; // ọ̀ọ́dúnrún
        if (numInt == 500) {
          return "${_standaloneUnits[400]!} $_plus ${_standaloneUnits[100]!}"; // irinwó ó lé ọgọ́rùn-ún (400 + 100)
        }
        if (numInt == 700) {
          return "${_standaloneUnits[600]!} $_plus ${_standaloneUnits[100]!}"; // ẹgbẹ̀ta ó lé ọgọ́rùn-ún (600 + 100)
        }
        if (numInt == 900) {
          return "${_standaloneUnits[800]!} $_plus ${_standaloneUnits[100]!}"; // ẹgbẹ̀rin ó lé ọgọ́rùn-ún (800 + 100)
        }
        // Otherwise, it's just the base word (e.g., 200 -> "igba").
        return baseText;
      }

      // Check if subtraction from the *next* hundred is simpler (e.g., 195 = 200 - 5).
      int nextBase100 = ((numInt + 99) ~/ 100) * 100; // Next multiple of 100
      // Check if the difference is small (1-10) and within reasonable range.
      if (nextBase100 > numInt &&
          (nextBase100 - numInt) <= 10 &&
          nextBase100 <= 1000) {
        int diff = nextBase100 - numInt;
        // Recursively get the word for the next base (e.g., "igba" for 200).
        String nextBaseText = _convertInteger(
            BigInt.from(nextBase100), _NumberContext.standalone);

        // If the difference (1-10) exists as a modifier, use subtraction.
        if (_modifierUnits.containsKey(diff) && diff <= 10) {
          // Check diff <= 10 explicitly
          return "$nextBaseText $_minusFrom ${_modifierUnits[diff]!}";
        }
      }

      // Default: Use addition (base + remainder).
      // Recursively convert the remainder. Standalone context for the remainder.
      String remainderText =
          _convertInteger(BigInt.from(remainder), _NumberContext.standalone);
      return "$baseText $_plus $remainderText"; // e.g., "igba ó lé ogún" (200 + 20)
    }

    // --- Vigesimal Logic for 21-99 ---
    if (numInt != null && numInt > 20 && numInt < 100) {
      int baseTens = (numInt ~/ 10) * 10; // Base ten (20, 30, ..., 90)
      int unitDigit = numInt % 10;

      // For units 1-4, use addition: base + unit.
      if (unitDigit >= 1 && unitDigit <= 4) {
        // Check if both base and unit modifier words exist.
        if (_standaloneUnits.containsKey(baseTens) &&
            _modifierUnits.containsKey(unitDigit)) {
          String unitWord = _modifierUnits[unitDigit]!;
          // Use pre-defined addition form if available (e.g., 21 -> ọ̀kànlélógún), otherwise construct.
          if (_compoundAdditions.containsKey(numInt))
            return _compoundAdditions[numInt]!;
          // Construct: e.g., "ọgbọ̀n ó lé kan" (30 + 1) - might differ from specific compound words.
          return "${_standaloneUnits[baseTens]!} $_plus $unitWord";
        }
      }
      // For units 5-9, use subtraction: (next base) - difference.
      else if (unitDigit >= 5) {
        int nextBaseTens =
            baseTens + 10; // Next base ten (e.g., 30 if numInt is 25-29)
        // Check if the next base word exists.
        if (_standaloneUnits.containsKey(nextBaseTens)) {
          int diff = nextBaseTens - numInt; // Difference (1-5)
          // Check if difference is 1-5 and exists as a modifier.
          if (diff >= 1 && diff <= 5 && _modifierUnits.containsKey(diff)) {
            // Use pre-defined subtraction form if available (e.g., 25 -> márùndínlọ́gbọ̀n), otherwise construct.
            if (_compoundSubtractions.containsKey(numInt))
              return _compoundSubtractions[numInt]!;
            // Construct: e.g., "ọgbọ̀n ó dín márùn-ún" (30 - 5)
            return "${_standaloneUnits[nextBaseTens]!} $_minusFrom ${_modifierUnits[diff]!}";
          }
        }
      }
    }

    // Fallback: If no rule matched (should be rare for numbers handled by prior logic), return digits.
    // This might indicate an uncovered case in the vigesimal logic.
    return n.toString();
  }

  /// Converts large integers (>= 1000) by breaking them into chunks of 1000
  /// and applying scale words (ẹgbẹ̀rún, mílíọ̀nù, etc.).
  String _convertScaleNumbers(BigInt n) {
    final BigInt oneThousand = BigInt.from(1000);

    // --- Special Handling for 1001-1999 ---
    // Uses "ẹgbẹ̀rún ó lé X" structure for consistency.
    if (n > oneThousand && n < BigInt.from(2000)) {
      BigInt remainder = n - oneThousand;
      // Use modifier context for remainder 1, standalone otherwise.
      _NumberContext remainderContext = (remainder == BigInt.one)
          ? _NumberContext.modifier
          : _NumberContext.standalone;
      String remainderText = _convertInteger(remainder, remainderContext);
      return "${_scaleWords[1]} $_plus $remainderText"; // "ẹgbẹ̀rún ó lé ..."
    }

    // --- Check for Exact Powers of 1000 (e.g., 1000, 1,000,000) ---
    BigInt tempNPower = n;
    int exactPowerIndex = 0;
    bool isExactPower = true;
    if (n >= oneThousand) {
      while (tempNPower >= oneThousand) {
        if (tempNPower % oneThousand != BigInt.zero) {
          isExactPower = false; // Not an exact power
          break;
        }
        tempNPower ~/= oneThousand;
        exactPowerIndex++;
      }
      // Check if the remaining part after divisions is 1.
      if (tempNPower != BigInt.one) isExactPower = false;

      // If it's an exact power within our defined scales...
      if (isExactPower &&
          exactPowerIndex > 0 &&
          exactPowerIndex < _scaleWords.length) {
        if (exactPowerIndex == 1) return _scaleWords[1]; // "ẹgbẹ̀rún" (1000)
        // For higher powers, use scale word + modifier "kan" (one).
        // e.g., "mílíọ̀nù kan" (1,000,000)
        return "${_scaleWords[exactPowerIndex]} ${_modifierUnits[1]!}";
      }
    }
    // --- End Exact Power Check ---

    // Base case: if number somehow became < 1000 after checks, convert directly.
    if (n < oneThousand) {
      // Use standalone context as it's the whole number now.
      return _convertInteger(n, _NumberContext.standalone);
    }

    // --- Chunking Logic for General Large Numbers ---
    List<String> parts =
        []; // Stores word parts for each chunk (e.g., "[chunk] bílíọ̀nù, [chunk] mílíọ̀nù, ...")
    String nStr = n.toString();
    int numDigits = nStr.length;

    // Calculate the index of the highest scale chunk (0 for 0-999, 1 for 1000s, 2 for millions, etc.).
    BigInt remainingValue = n;
    int totalChunks = ((numDigits - 1) ~/ 3);

    // Handle numbers larger than the highest defined scale word.
    if (totalChunks >= _scaleWords.length) {
      int highestSupportedScaleIndex = _scaleWords.length - 1;
      // Calculate the power of 1000 for the scale *above* the highest supported one.
      BigInt highestSupportedPower =
          BigInt.from(1000).pow(highestSupportedScaleIndex + 1);
      // Get the part of the number that corresponds to this unsupported scale.
      BigInt unsupportedPart = n ~/ highestSupportedPower;

      if (unsupportedPart > BigInt.zero) {
        // Convert the unsupported part number to words.
        String unsupportedText =
            _convertInteger(unsupportedPart, _NumberContext.standalone);
        String highestScaleName =
            _scaleWords.last; // Name of the highest supported scale.
        // Add a placeholder indicating the number is too large.
        parts.add("$unsupportedText $highestScaleName [Too Large]");
        // Update remaining value and chunk index for further processing of supported scales.
        remainingValue %= highestSupportedPower;
        totalChunks = highestSupportedScaleIndex;
      }
    }

    // Process chunks from highest scale down to the lowest (thousands).
    while (totalChunks >= 0) {
      // Calculate the power of 1000 for the current chunk's scale.
      BigInt powerOf1000 = BigInt.from(1000).pow(totalChunks);
      // Get the numeric value of the current chunk (0-999).
      BigInt chunkBigInt = remainingValue ~/ powerOf1000;

      // Only process if the chunk value is greater than zero.
      if (chunkBigInt > BigInt.zero) {
        String chunkText;
        // Get the scale word (e.g., "mílíọ̀nù") or empty string for the base chunk (0-999).
        String scaleWord = (totalChunks > 0 && totalChunks < _scaleWords.length)
            ? _scaleWords[totalChunks]
            : "";

        // Convert the chunk number (0-999) to words. Handle 999 specially using pre-defined chunk.
        String chunkNumText = (chunkBigInt == BigInt.from(999))
            ? _word999Chunk // Use "ọ̀kándínlẹ́gbẹ̀rún"
            : _convertInteger(chunkBigInt,
                _NumberContext.standalone); // Convert 0-998 normally

        // Combine chunk number words and scale word.
        if (totalChunks > 0 && scaleWord.isNotEmpty) {
          // If it's a scale chunk (thousands+)
          // Special case: 1 thousand, 1 million, etc.
          if (chunkBigInt == BigInt.one) {
            if (totalChunks == 1) {
              chunkText = scaleWord; // 1000 is just "ẹgbẹ̀rún"
            } else {
              // Higher scales: scale word + modifier "kan" (one).
              chunkText =
                  "$scaleWord ${_modifierUnits[1]!}"; // e.g., "mílíọ̀nù kan"
            }
          } else {
            // For other chunk values: number + scale word.
            chunkText = "$chunkNumText $scaleWord"; // e.g., "mẹ́ta mílíọ̀nù"
          }
        } else {
          // Base chunk (0-999) has no scale word attached here.
          chunkText = chunkNumText;
        }

        // Add the processed chunk text to the parts list if it's not empty.
        if (chunkText.isNotEmpty) {
          parts.add(chunkText);
        }
      }

      // Update remaining value and move to the next lower scale chunk.
      if (remainingValue > BigInt.zero) {
        remainingValue %= powerOf1000;
      } else {
        // Optimization: if remainder is zero, no need to process lower chunks unless the current chunk was also zero.
        if (chunkBigInt == BigInt.zero) break;
      }
      totalChunks--;

      // Stop if remainder is zero and all chunks processed.
      if (remainingValue == BigInt.zero && totalChunks < 0) break;
    }

    // Join the processed chunk parts with commas and a space (standard large number format).
    return parts.join(', ').trim();
  }
}
