import 'package:decimal/decimal.dart';

import '../concurencies/concurencies_info.dart';
import '../num2text_base.dart';
import '../options/base_options.dart';
import '../options/fr_options.dart';
import '../utils/utils.dart';

/// {@template num2text_fr}
/// Converts numbers to French words (`Lang.FR`).
///
/// Implements [Num2TextBase] for French, handling various numeric types.
/// Supports cardinal numbers, decimals, negatives, currency, years, and large numbers (short scale + milliard).
/// Handles French specifics: hyphens, "et un", plural 's' on "cent"/"vingt".
/// Customizable via [FrOptions]. Returns a fallback string on error.
/// {@endtemplate}
class Num2TextFR implements Num2TextBase {
  // --- Constants ---
  static const String _zero = "zéro";
  static const String _point = "point"; // Decimal separator '.'
  static const String _comma = "virgule"; // Decimal separator ',' (standard)
  static const String _and = "et"; // Used for *et-un
  static const String _hyphen = "-";
  static const String _hundred = "cent"; // Takes 's' sometimes
  static const String _thousand = "mille"; // Invariable
  static const String _yearSuffixBC = "av. J.-C."; // Before Christ
  static const String _yearSuffixAD = "ap. J.-C."; // After Christ

  // 0-16
  static const List<String> _wordsUnder20 = [
    "zéro",
    "un",
    "deux",
    "trois",
    "quatre",
    "cinq",
    "six",
    "sept",
    "huit",
    "neuf",
    "dix",
    "onze",
    "douze",
    "treize",
    "quatorze",
    "quinze",
    "seize",
  ];
  // 10, 20, ..., 60
  static const List<String> _wordsTens = [
    "",
    "dix",
    "vingt",
    "trente",
    "quarante",
    "cinquante",
    "soixante",
  ];
  // Scale words [singular, plural] by exponent (10^exponent)
  static const Map<int, List<String>> _scaleWordsByExponent = {
    6: ["million", "millions"], // 10^6
    9: ["milliard", "milliards"], // 10^9
    12: ["billion", "billions"], // 10^12
    15: ["billiard", "billiards"], // 10^15
    18: ["trillion", "trillions"], // 10^18
    21: ["trilliard", "trilliards"], // 10^21
    24: ["quadrillion", "quadrillions"], // 10^24
  };
  // Scale words [singular, plural] by group index (0=units, 1=thousands, 2=millions...)
  static final Map<int, List<String>> _scaleWordsByIndex = {
    1: [_thousand, _thousand], // Group 1: mille (invariable)
    for (var entry in _scaleWordsByExponent.entries)
      (entry.key ~/ 3): entry.value,
  };

  /// {@macro num2text_base_process}
  /// Converts the given [number] into French words.
  /// Uses [FrOptions] for customization (currency, year, decimals, AD/BC).
  /// Returns fallback string on error (e.g., "N'est Pas Un Nombre").
  @override
  String process(
      dynamic number, BaseOptions? options, String? fallbackOnError) {
    final FrOptions frOptions =
        options is FrOptions ? options : const FrOptions();

    if (number is double) {
      if (number.isInfinite)
        return number.isNegative ? "Moins L'infini" : "Infini";
      if (number.isNaN) return fallbackOnError ?? "N'est Pas Un Nombre";
    }

    final Decimal? decimalValue = Utils.normalizeNumber(number);
    if (decimalValue == null) return fallbackOnError ?? "N'est Pas Un Nombre";

    // Handle zero separately unless handled by currency/year formatters
    if (decimalValue == Decimal.zero &&
        frOptions.format != Format.year &&
        !frOptions.currency) {
      return _zero;
    }

    final bool isNegative = decimalValue.isNegative;
    final Decimal absValue = isNegative ? -decimalValue : decimalValue;

    String textResult;
    if (frOptions.format == Format.year) {
      // Year formatting handles its own sign (BC/AD)
      textResult = _handleYearFormat(
          decimalValue.truncate().toBigInt().toInt(), frOptions);
    } else {
      textResult = frOptions.currency
          ? _handleCurrency(absValue, frOptions)
          : _handleStandardNumber(absValue, frOptions);
      // Add negative prefix if applicable (not for years)
      if (isNegative && absValue != Decimal.zero) {
        textResult = "${frOptions.negativePrefix} $textResult";
      }
    }
    return textResult.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Formats an integer year as French words, optionally adding BC/AD.
  /// Years are converted as standard cardinal numbers.
  String _handleYearFormat(int year, FrOptions options) {
    final bool isNegative = year < 0;
    final int absYear = isNegative ? -year : year;
    if (absYear == 0) return _zero; // Handle year 0 if passed

    String yearText = _convertInteger(BigInt.from(absYear));

    if (isNegative)
      yearText += " $_yearSuffixBC";
    else if (options.includeAD) yearText += " $_yearSuffixAD";

    return yearText;
  }

  /// Formats a non-negative [Decimal] as French currency words.
  /// Handles main/sub units, rounding, plurals, and elision ("millions d'euros").
  String _handleCurrency(Decimal absValue, FrOptions options) {
    final CurrencyInfo info = options.currencyInfo;
    final Decimal val = options.round ? absValue.round(scale: 2) : absValue;
    final BigInt mainVal = val.truncate().toBigInt();
    final BigInt subVal = ((val - val.truncate()).abs() * Decimal.parse("100"))
        .truncate()
        .toBigInt();

    String mainPart = "";
    if (mainVal > BigInt.zero) {
      String mainText = _convertInteger(mainVal);
      String mainName = (mainVal == BigInt.one)
          ? info.mainUnitSingular
          : (info.mainUnitPlural ?? info.mainUnitSingular);
      String joiner = " ";
      // "de" after a scale noun, elided before a vowel
      // (e.g., "un million de francs", "deux millions d'euros")
      final bool endsWithScale = _scaleWordsByExponent.values
          .any((p) => mainText.endsWith(p[0]) || mainText.endsWith(p[1]));
      final bool startsVowel = mainName.isNotEmpty &&
          ['a', 'e', 'i', 'o', 'u', 'y', 'h', 'A', 'E', 'I', 'O', 'U', 'Y', 'H']
              .contains(mainName[0]);
      if (endsWithScale) joiner = startsVowel ? " d'" : " de ";
      mainPart = '$mainText$joiner$mainName';
    }

    String subPart = "";
    if (subVal > BigInt.zero && info.subUnitSingular != null) {
      String subText = _convertInteger(subVal);
      String subName = (subVal == BigInt.one)
          ? info.subUnitSingular!
          : (info.subUnitPlural ?? info.subUnitSingular!);
      subPart = '$subText $subName';
    }

    if (mainPart.isNotEmpty && subPart.isNotEmpty) {
      String sep = info.separator ?? _and;
      sep = ' ${sep.trim()} '; // Ensure spaces around separator
      return '$mainPart$sep$subPart';
    } else if (mainPart.isNotEmpty)
      return mainPart;
    else if (subPart.isNotEmpty)
      return subPart; // e.g., "un centime"
    else
      return "$_zero ${info.mainUnitSingular}"; // Zero case
  }

  /// Formats a non-negative standard [Decimal] number into French words.
  /// Fractional part read digit-by-digit after "virgule" or "point".
  String _handleStandardNumber(Decimal absValue, FrOptions options) {
    if (absValue == Decimal.zero) return _zero; // Handle exact zero input

    final BigInt integerPart = absValue.truncate().toBigInt();
    final Decimal fractionalPart = absValue - absValue.truncate();
    String integerWords = _convertInteger(integerPart);

    // Handle integer 0 when fraction exists (e.g., 0.5 -> "zéro virgule...")
    if (integerPart == BigInt.zero && fractionalPart > Decimal.zero) {
      integerWords = _zero;
    }

    String fractionalWords = '';
    if (fractionalPart > Decimal.zero) {
      String sepWord;
      switch (options.decimalSeparator) {
        case DecimalSeparator.period:
        case DecimalSeparator.point:
          sepWord = _point;
          break;
        default:
          sepWord = _comma;
          break; // Default to "virgule"
      }

      String digits = fractionalPart.toString().split('.').last;
      while (digits.endsWith('0') && digits.length > 1) {
        // Trim trailing zeros
        digits = digits.substring(0, digits.length - 1);
      }
      if (digits.isEmpty) digits = "0"; // Safety

      List<String> digitWords = digits.split('').map((d) {
        final int? i = int.tryParse(d);
        return (i != null && i >= 0 && i <= 9) ? _wordsUnder20[i] : '?';
      }).toList();

      String prefixSpace =
          integerWords == _zero ? "" : " "; // Avoid space after "zéro"
      fractionalWords = '$prefixSpace$sepWord ${digitWords.join(' ')}';
    }
    return '$integerWords$fractionalWords'.trim();
  }

  /// Converts a non-negative [BigInt] into French words (recursive core).
  /// Breaks into 3-digit chunks, applies scale words ("mille", "million", etc.).
  String _convertInteger(BigInt n) {
    if (n == BigInt.zero) return ""; // Zero is handled by callers in context
    if (n < BigInt.zero) throw ArgumentError("Input must be non-negative: $n");
    if (n < BigInt.from(1000))
      return _convertChunk(n.toInt(), isTerminalChunk: true);

    List<String> parts = [];
    BigInt remaining = n;
    final BigInt thousand = BigInt.from(1000);
    int groupIndex = 0;

    while (remaining > BigInt.zero) {
      int chunkValue = (remaining % thousand).toInt();
      remaining ~/= thousand;

      if (chunkValue > 0) {
        // "mille" is an adjective and blocks the plural 's'; scale nouns
        // ("million", "milliard"...) do not ("deux cent mille", "deux cents millions")
        bool isTerminalChunkForChunk = groupIndex != 1;
        String chunkText =
            _convertChunk(chunkValue, isTerminalChunk: isTerminalChunkForChunk);
        String? scaleWord;

        if (groupIndex > 0) {
          // Scale words apply from thousands onwards
          if (_scaleWordsByIndex.containsKey(groupIndex)) {
            final scaleNames = _scaleWordsByIndex[groupIndex]!;
            bool usePluralScale =
                chunkValue > 1 && groupIndex != 1; // group 1 = "mille"
            scaleWord = usePluralScale ? scaleNames[1] : scaleNames[0];

            // Special cases for '1' before scale words
            if (groupIndex == 1 && chunkValue == 1)
              chunkText = ""; // "mille", not "un mille"
            else if (chunkValue == 1 && groupIndex > 1)
              chunkText = "un"; // "un million"
          } else
            scaleWord = "[Scale?]";
        }

        String currentPart = chunkText;
        if (scaleWord != null && scaleWord.isNotEmpty) {
          currentPart += (chunkText.isNotEmpty ? " " : "") + scaleWord;
        }
        parts.insert(0, currentPart.trim());
      }
      groupIndex++;
    }
    return parts.join(' ').trim();
  }

  /// Converts a number 0-999 into French words.
  /// Handles 70-79, 90-99, hyphens, "et un", plural 's' on "cent"/"vingt".
  /// [isTerminalChunk]: True if the chunk is not followed by another numeral
  /// (units group, or group before a scale noun such as "million").
  String _convertChunk(int n, {required bool isTerminalChunk}) {
    if (n == 0) return "";
    if (n < 0 || n >= 1000) throw ArgumentError("Chunk must be 0-999: $n");

    List<String> words = [];
    int rem = n;

    // Hundreds
    int hundreds = rem ~/ 100;
    if (hundreds > 0) {
      bool centNeedsS = hundreds > 1 && (rem % 100 == 0) && isTerminalChunk;
      String centWord = _hundred + (centNeedsS ? "s" : "");
      if (hundreds == 1)
        words.add(_hundred);
      else
        words.add(
            "${_convertChunk(hundreds, isTerminalChunk: false)} $centWord"); // Multiplier never terminal here
      rem %= 100;
    }

    // Tens and Units (0-99)
    if (rem > 0) {
      if (words.isNotEmpty) words.add(" "); // Space after hundreds part

      if (rem < 17)
        words.add(_wordsUnder20[rem]);
      else if (rem < 20)
        words
            .add("${_wordsTens[1]}$_hyphen${_wordsUnder20[rem % 10]}"); // 17-19
      else if (rem < 70) {
        // 20-69
        int tens = rem ~/ 10, unit = rem % 10;
        words.add(_wordsTens[tens]);
        if (unit > 0) {
          if (unit == 1)
            words.add(" $_and ${_wordsUnder20[unit]}"); // et-un
          else
            words.add("$_hyphen${_wordsUnder20[unit]}");
        }
      } else if (rem < 80) {
        // 70-79
        int unitPart = rem - 60; // 10-19
        words.add(_wordsTens[6]); // soixante
        if (unitPart == 11)
          words.add(" $_and ${_wordsUnder20[11]}"); // et-onze
        else
          words.add(
              "$_hyphen${_convertChunk(unitPart, isTerminalChunk: false)}"); // Recursive for 10, 12-19
      } else {
        // 80-99
        String base = "quatre$_hyphen${_wordsTens[2]}"; // quatre-vingt
        if (rem == 80) {
          bool quatreVingtNeedsS = isTerminalChunk;
          words.add(base + (quatreVingtNeedsS ? "s" : "")); // quatre-vingts
        } else {
          // 81-99
          int unitPart = rem - 80; // 1-19
          words.add(
              "$base$_hyphen${_convertChunk(unitPart, isTerminalChunk: false)}"); // Recursive for 1-19
        }
      }
    }
    return words.join();
  }
}
