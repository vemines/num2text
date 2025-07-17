import '../concurencies/concurencies_info.dart';
import 'base_options.dart';

/// Options specific to the Estonian (`Lang.ET`) language version.
class EtOptions extends BaseOptions {
  /// Determines if "pKr" (pärast Kristust - after Christ, AD/CE) suffix is added
  /// for positive years when using [Format.year]. BC/BCE ("eKr") is typically handled internally.
  /// Defaults to `false`.
  final bool includeAD;

  /// The prefix word used for negative numbers when *not* using [Format.year].
  /// Defaults to `"miinus"`.
  final String negativePrefix;

  /// Specifies the currency details (unit names in appropriate cases, separator) to use when `currency` is `true`.
  /// Defaults to [CurrencyInfo.eurEt] (Euro - Estonian terms).
  final CurrencyInfo currencyInfo;

  /// Creates Estonian-specific options.
  const EtOptions({
    this.includeAD = false,
    this.negativePrefix = "miinus",
    this.currencyInfo = CurrencyInfo.eurEt,
    super.currency = false,
    super.format, // Inherited: special format context (e.g., Format.year)
    super.decimalSeparator = DecimalSeparator.comma, // Default word: "koma"
    super.round = false, // Inherited: round the number
  });
}
