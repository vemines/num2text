/// Holds language-specific information about a currency's units and separators.
///
/// This class provides the necessary textual components (like "dollar", "dollars",
/// "cent", "cents", "and") for formatting numbers as currency amounts in words
/// using the `currency: true` option in language-specific [BaseOptions].
///
/// It handles singular and various plural forms required by different languages,
/// especially Slavic languages which have complex declension rules based on number.
class CurrencyInfo {
  /// The singular form of the main currency unit (e.g., "dollar", "euro", "lek").
  /// Used when the count is 1.
  final String mainUnitSingular;

  /// The standard plural form of the main currency unit (e.g., "dollars", "euros", "lekë").
  /// Used for counts 0 and 2+ in many languages.
  /// May be null if the singular form is always used or if specific plural forms
  /// ([mainUnitPlural2To4], [mainUnitPluralGenitive]) cover all other cases.
  final String? mainUnitPlural;

  /// The specific plural form for counts ending in 2, 3, or 4 (excluding 12, 13, 14).
  /// Primarily used in Slavic languages (e.g., Russian "рубля", Polish "złote", Czech "koruny").
  /// This often corresponds to the Nominative Plural case.
  final String? mainUnitPlural2To4;

  /// The specific plural form (often Genitive Plural) for counts ending in 0, 1 (sometimes, e.g., Lithuanian > 10), 5-9, and 11-19.
  /// Primarily used in Slavic languages (e.g., Russian "рублей", Polish "złotych", Czech "korun").
  final String? mainUnitPluralGenitive;

  /// The singular form of the fractional currency subunit (e.g., "cent", "qindarkë", "kopek").
  /// Used when the subunit count is 1. Can be null if the currency has no subunit.
  final String? subUnitSingular;

  /// The standard plural form of the fractional currency subunit (e.g., "cents", "qindarka", "kopeks").
  /// Used for subunit counts 0 and 2+ in many languages.
  /// May be null if the singular form is always used or specific plural forms cover other cases.
  final String? subUnitPlural;

  /// The specific plural form of the subunit for counts ending in 2, 3, or 4 (excluding 12-14).
  /// Primarily used in Slavic languages (e.g., Russian "копейки", Polish "grosze").
  /// Often Nominative Plural.
  final String? subUnitPlural2To4;

  /// The specific plural form (often Genitive Plural) of the subunit for counts ending in 0, 1 (sometimes), 5-9, 11-19.
  /// Primarily used in Slavic languages (e.g., Russian "копеек", Polish "groszy").
  final String? subUnitPluralGenitive;

  /// The word(s) used to separate the main unit amount from the subunit amount
  /// (e.g., "and", "et", "und", "и", "με", "con"). Can be null if no separator is used.
  final String? separator;

  /// Creates a const instance defining currency unit names and separators.
  ///
  /// Provide the required [mainUnitSingular] and optionally other forms based
  /// on the language's grammatical rules for currency plurals.
  const CurrencyInfo({
    required this.mainUnitSingular,
    this.mainUnitPlural,
    this.mainUnitPlural2To4,
    this.mainUnitPluralGenitive,
    this.subUnitSingular,
    this.subUnitPlural,
    this.subUnitPlural2To4,
    this.subUnitPluralGenitive,
    this.separator,
  });

  // --- Consolidated Currency Definitions ---
  // (Comments for each currency are reviewed below)

  /// Albanian Lek (ALL) currency details for Albanian (`Lang.SQ`).
  static const CurrencyInfo all = CurrencyInfo(
    mainUnitSingular: "lek", // 1 lek
    mainUnitPlural: "lekë", // 0, 2+ lekë
    subUnitSingular: "qindarkë", // 1 qindarkë
    subUnitPlural: "qindarka", // 0, 2+ qindarka
    // separator: null (usually omitted)
  );

  /// Armenian Dram (AMD) currency details for Armenian (`Lang.HY`).
  static const CurrencyInfo amd = CurrencyInfo(
    mainUnitSingular: "դրամ", // Dram (singular/plural same)
    mainUnitPlural: "դրամ",
    subUnitSingular: "լումա", // Luma (singular/plural same)
    subUnitPlural: "լումա",
    separator: "և", // "yev" (and)
  );

  /// Azerbaijani Manat (AZN) currency details for Azerbaijani (`Lang.AZ`).
  static const CurrencyInfo azn = CurrencyInfo(
    mainUnitSingular: "manat", // Manat (singular/plural same)
    mainUnitPlural: "manat",
    subUnitSingular: "qəpik", // Qepik (singular/plural same)
    subUnitPlural: "qəpik",
    // separator: null (usually omitted)
  );

  /// Bosnia and Herzegovina Convertible Mark (BAM) currency details for Bosnian (`Lang.BS`).
  static const CurrencyInfo bam = CurrencyInfo(
    mainUnitSingular: "konvertibilna marka", // 1 (feminine)
    mainUnitPlural2To4: "konvertibilne marke", // 2-4 (Nom. Pl.)
    mainUnitPluralGenitive: "konvertibilnih maraka", // 0, 5+ (Gen. Pl.)
    subUnitSingular: "fening", // 1 (masculine)
    // Note: Bosnian pluralization for 'fening' can be complex/varied.
    // Using Gen. Sg. form 'feninga' for 2-4 Nom. Pl. is common.
    subUnitPlural2To4: "feninga", // 2-4 (Nom. Pl. often uses Gen. Sg. form)
    subUnitPluralGenitive: "feninga", // 0, 5+ (Gen. Pl.)
    separator: "i", // "i" (and)
  );

  // Inside the CurrencyInfo class, add this static const:

  /// Turkmenistani Manat (TMT) currency details for Turkmen (`Lang.TK`).
  /// Note: Subunits (teňňe) are rarely used in word conversions.
  static const CurrencyInfo tmt = CurrencyInfo(
    mainUnitSingular: "manat", // Singular/plural same
    mainUnitPlural: "manat",
    subUnitSingular: "teňňe", // Subunit
    subUnitPlural: "teňňe",
  );

  /// Bangladeshi Taka (BDT) currency details for Bengali (`Lang.BN`).
  static const CurrencyInfo bdt = CurrencyInfo(
    mainUnitSingular: "টাকা", // Taka (singular/plural same)
    mainUnitPlural: "টাকা",
    subUnitSingular: "পয়সা", // Poisha (singular/plural same)
    subUnitPlural: "পয়সা",
    // separator: null (usually omitted)
  );

  /// Bulgarian Lev (BGN) currency details for Bulgarian (`Lang.BG`).
  static const CurrencyInfo bgn = CurrencyInfo(
    mainUnitSingular: "лев", // 1 lev
    mainUnitPlural: "лева", // 0, 2+ leva
    subUnitSingular: "стотинка", // 1 stotinka
    subUnitPlural: "стотинки", // 0, 2+ stotinki
    separator: "и", // "i" (and)
  );

  /// Brazilian Real (BRL) currency details for Portuguese (`Lang.PT`).
  static const CurrencyInfo brl = CurrencyInfo(
    mainUnitSingular: "real", // 1 real
    mainUnitPlural: "reais", // 0, 2+ reais
    subUnitSingular: "centavo", // 1 centavo
    subUnitPlural: "centavos", // 0, 2+ centavos
    separator: "e", // "e" (and)
  );

  /// Belarusian Ruble (BYN) currency details for Belarusian (`Lang.BE`).
  static const CurrencyInfo byn = CurrencyInfo(
    mainUnitSingular: "рубель", // 1 rubel (Nom. Sg.)
    mainUnitPlural2To4: "рублі", // 2-4 rubli (Nom. Pl.)
    mainUnitPluralGenitive: "рублёў", // 0, 5+ rublyow (Gen. Pl.)
    subUnitSingular: "капейка", // 1 kapeyka (Nom. Sg.)
    subUnitPlural2To4: "капейкі", // 2-4 kapeyki (Nom. Pl.)
    subUnitPluralGenitive: "капеек", // 0, 5+ kapeyek (Gen. Pl.)
    // separator: null (usually omitted)
  );

  /// Chinese Yuan Renminbi (CNY) currency details for Chinese (`Lang.ZH`).
  static const CurrencyInfo cny = CurrencyInfo(
    mainUnitSingular: "元", // Yuan (singular/plural same)
    mainUnitPlural: "元",
    subUnitSingular:
        "角", // Jiao (1/10) - Or 分 (Fen, 1/100) for smaller amounts.
    subUnitPlural: "角", // Jiao (plural same)
    // separator: null (usually omitted, structure handled differently)
  );

  /// Czech Koruna (CZK) currency details for Czech (`Lang.CS`).
  static const CurrencyInfo czk = CurrencyInfo(
    mainUnitSingular: "koruna česká", // 1 koruna (feminine, Nom. Sg.)
    mainUnitPlural2To4: "koruny české", // 2-4 koruny (Nom. Pl.)
    mainUnitPluralGenitive: "korun českých", // 0, 5+ korun (Gen. Pl.)
    subUnitSingular:
        "haléř", // 1 haléř (masculine, Nom. Sg.) - Note: Haléře are obsolete.
    subUnitPlural2To4: "haléře", // 2-4 haléře (Nom. Pl.)
    subUnitPluralGenitive: "haléřů", // 0, 5+ haléřů (Gen. Pl.)
    separator: "a", // "a" (and)
  );

  /// Danish Krone (DKK) currency details for Danish (`Lang.DA`).
  static const CurrencyInfo dkk = CurrencyInfo(
    mainUnitSingular: "krone", // 1 krone
    mainUnitPlural: "kroner", // 0, 2+ kroner
    subUnitSingular: "øre", // 1 øre (singular/plural same)
    subUnitPlural: "øre", // 0, 2+ øre
    separator: "og", // "og" (and)
  );

  /// Ethiopian Birr (ETB) currency details for Amharic (`Lang.AM`).
  static const CurrencyInfo etb = CurrencyInfo(
    mainUnitSingular: "ብር", // Birr (singular/plural same)
    mainUnitPlural: "ብር",
    subUnitSingular: "ሳንቲም", // Santim (singular/plural same)
    subUnitPlural: "ሳንቲም",
    separator: "ከ", // "ke" (with/and)
  );

  /// Euro (EUR) currency details for German (`Lang.DE`).
  static const CurrencyInfo eurDe = CurrencyInfo(
    mainUnitSingular: "Euro", // Singular/plural same
    mainUnitPlural: "Euro",
    subUnitSingular: "Cent", // Singular/plural same
    subUnitPlural: "Cent",
    separator: "und", // "und" (and)
  );

  /// Euro (EUR) currency details for Greek (`Lang.EL`).
  static const CurrencyInfo eurEl = CurrencyInfo(
    mainUnitSingular: "ευρώ", // 1 euro (singular/plural same)
    mainUnitPlural: "ευρώ", // 0, 2+ euro
    subUnitSingular: "λεπτό", // 1 lepto
    subUnitPlural: "λεπτά", // 0, 2+ lepta
    separator: "και", // "kai" (and)
  );

  /// Euro (EUR) currency details for Spanish (`Lang.ES`).
  static const CurrencyInfo eurEs = CurrencyInfo(
    mainUnitSingular: "euro", // 1 euro
    mainUnitPlural: "euros", // 0, 2+ euros
    subUnitSingular: "céntimo", // 1 céntimo
    subUnitPlural: "céntimos", // 0, 2+ céntimos
    separator: "con", // "con" (with) - common separator
  );

  /// Euro (EUR) currency details for Finnish (`Lang.FI`). Finnish uses grammatical cases.
  static const CurrencyInfo eurFi = CurrencyInfo(
    mainUnitSingular: "euro", // 1 (Nominative Sg.)
    mainUnitPlural: "euroa", // 0, 2+ (Partitive Pl.)
    subUnitSingular: "sentti", // 1 (Nominative Sg.)
    subUnitPlural: "senttiä", // 0, 2+ (Partitive Pl.)
    separator: "ja", // "ja" (and)
  );

  /// Euro (EUR) currency details for French (`Lang.FR`).
  static const CurrencyInfo eurFr = CurrencyInfo(
    mainUnitSingular: "euro", // 1 euro
    mainUnitPlural: "euros", // 0, 2+ euros
    subUnitSingular: "centime", // 1 centime
    subUnitPlural: "centimes", // 0, 2+ centimes
    separator: "et", // "et" (and)
  );

  /// British Pound Sterling (GBP) currency details for English (`Lang.EN`).
  /// Note: Added because it's used in `Num2Text` examples.
  static const CurrencyInfo gbp = CurrencyInfo(
    mainUnitSingular: "pound", // 1 pound
    mainUnitPlural: "pounds", // 0, 2+ pounds
    subUnitSingular: "penny", // 1 penny
    subUnitPlural: "pence", // 0, 2+ pence
    separator: "and", // "and" (common usage)
  );

  /// Euro (EUR) currency details for Croatian (`Lang.HR`).
  static const CurrencyInfo eurHr = CurrencyInfo(
    mainUnitSingular: "euro", // 1 (Nom. Sg.)
    // Croatian often uses Gen. Pl. form for plurals after numbers >= 5
    mainUnitPlural:
        "eura", // 0, 2+ (Gen. Pl. form often used, covers multiple cases)
    subUnitSingular: "cent", // 1 (Nom. Sg.)
    subUnitPlural: "centi", // 0, 2+ (Gen. Pl. form often used)
    separator: "i", // "i" (and)
  );

  /// Euro (EUR) currency details for Italian (`Lang.IT`).
  static const CurrencyInfo eurIt = CurrencyInfo(
    mainUnitSingular: "euro", // Singular/plural same
    mainUnitPlural: "euro",
    subUnitSingular: "centesimo", // 1 centesimo
    subUnitPlural: "centesimi", // 0, 2+ centesimi
    separator: "e", // "e" (and)
  );

  /// Euro (EUR) currency details for Lithuanian (`Lang.LT`). Requires multiple plural forms.
  static const CurrencyInfo eurLt = CurrencyInfo(
    mainUnitSingular: "euras", // 1 euras (Nom. Sg.)
    mainUnitPlural: "eurai", // 2-9 eurai (Nom. Pl.)
    mainUnitPluralGenitive:
        "eurų", // 0, 10+, or when ending in 11-19 (Gen. Pl.)
    subUnitSingular: "centas", // 1 centas (Nom. Sg.)
    subUnitPlural: "centai", // 2-9 centai (Nom. Pl.)
    subUnitPluralGenitive:
        "centų", // 0, 10+, or when ending in 11-19 (Gen. Pl.)
    // Separator often implicit or context-dependent in Lithuanian
  );

  /// Euro (EUR) currency details for Latvian (`Lang.LV`).
  static const CurrencyInfo eurLv = CurrencyInfo(
    mainUnitSingular: "eiro", // Singular/plural same (loanword handling)
    mainUnitPlural: "eiro",
    subUnitSingular: "cents", // 1 cents (Nom. Sg.)
    subUnitPlural: "centi", // 0, 2+ centi (Nom. Pl.)
    separator: "un", // "un" (and)
  );

  /// Euro (EUR) currency details for Maltese (`Lang.MT`).
  static const CurrencyInfo eurMt = CurrencyInfo(
    mainUnitSingular: "ewro", // 1 ewro (Singular/plural same)
    mainUnitPlural: "ewro", // 0, 2+ ewro
    subUnitSingular: "ċenteżmu", // 1 ċenteżmu
    subUnitPlural: "ċenteżmi", // 0, 2+ ċenteżmi
    separator: "u", // "u" (and)
  );

  /// Euro (EUR) currency details for Dutch (`Lang.NL`).
  static const CurrencyInfo eurNl = CurrencyInfo(
    mainUnitSingular: "euro", // Singular/plural same
    mainUnitPlural: "euro",
    subUnitSingular: "cent", // Singular/plural same
    subUnitPlural: "cent",
    separator: "en", // "en" (and)
  );

  /// Euro (EUR) currency details for Portuguese (`Lang.PT`).
  static const CurrencyInfo eurPt = CurrencyInfo(
    mainUnitSingular: "euro", // 1 euro
    mainUnitPlural: "euros", // 0, 2+ euros
    subUnitSingular: "cêntimo", // 1 cêntimo
    subUnitPlural: "cêntimos", // 0, 2+ cêntimos
    separator: "e", // "e" (and)
  );

  /// Euro (EUR) currency details for Slovak (`Lang.SK`). Requires multiple plural forms.
  static const CurrencyInfo eurSk = CurrencyInfo(
    mainUnitSingular: "euro", // 1 euro (Nom. Sg.)
    mainUnitPlural2To4: "eurá", // 2-4 eurá (Nom. Pl.)
    mainUnitPluralGenitive: "eur", // 0, 5+ eur (Gen. Pl.)
    subUnitSingular: "cent", // 1 cent (Nom. Sg.)
    subUnitPlural2To4: "centy", // 2-4 centy (Nom. Pl.)
    subUnitPluralGenitive: "centov", // 0, 5+ centov (Gen. Pl.)
    separator: "a", // "a" (and)
  );

  /// Euro (EUR) currency details for Slovenian (`Lang.SL`). Requires dual and plural forms.
  static const CurrencyInfo eurSl = CurrencyInfo(
    mainUnitSingular: "evro", // 1 evro (Nom. Sg.)
    // Note: Slovenian has dual form for 2, plural for 3-4, gen. pl. for 5+
    // This simplifies by using one field for 2-4 range. Implementation needs care.
    mainUnitPlural2To4: "evra", // 2 (Dual Nom.), 3-4 (Nom. Pl.)
    mainUnitPluralGenitive: "evrov", // 0, 5+ evrov (Gen. Pl.)
    subUnitSingular: "cent", // 1 cent (Nom. Sg.)
    subUnitPlural2To4: "centa", // 2 (Dual Nom.), 3-4 (Nom. Pl.)
    subUnitPluralGenitive: "centov", // 0, 5+ centov (Gen. Pl.)
    separator: "in", // "in" (and)
  );

  /// Georgian Lari (GEL) currency details for Georgian (`Lang.KA`).
  static const CurrencyInfo gel = CurrencyInfo(
    mainUnitSingular: "ლარი", // Lari (singular/plural same)
    mainUnitPlural: "ლარი",
    subUnitSingular: "თეთრი", // Tetri (singular/plural same)
    subUnitPlural: "თეთრი",
    separator: "და", // "da" (and)
  );

  /// Hungarian Forint (HUF) currency details for Hungarian (`Lang.HU`).
  static const CurrencyInfo huf = CurrencyInfo(
    mainUnitSingular: "forint", // Singular/plural same
    mainUnitPlural: "forint",
    subUnitSingular: "fillér", // Historically used, largely obsolete subunit.
    subUnitPlural: "fillér", // Plural same.
    // separator: null (usually omitted)
  );

  /// Indonesian Rupiah (IDR) currency details for Indonesian (`Lang.ID`).
  static const CurrencyInfo idr = CurrencyInfo(
    mainUnitSingular: "rupiah", // Singular/plural same
    mainUnitPlural: "rupiah",
    subUnitSingular: "sen", // Largely unused historical subunit.
    subUnitPlural: "sen", // Plural same.
    separator: "dan", // "dan" (and)
  );

  /// Israeli New Shekel (ILS) currency details for Hebrew (`Lang.HE`). Note gender differences.
  static const CurrencyInfo ils = CurrencyInfo(
    mainUnitSingular: "שקל חדש", // 1 shekel hadash (masculine)
    mainUnitPlural: "שקלים חדשים", // 0, 2+ shkalim hadashim (masculine)
    subUnitSingular: "אגורה", // 1 agora (feminine)
    subUnitPlural: "אגורות", // 0, 2+ agorot (feminine)
    separator: "ו", // "ve" (and) - often attached as prefix
  );

  /// Indian Rupee (INR) currency details for Hindi (`Lang.HI`).
  static const CurrencyInfo inrHi = CurrencyInfo(
    mainUnitSingular: "रुपया", // 1 rupaya
    mainUnitPlural: "रुपये", // 0, 2+ rupaye
    subUnitSingular: "पैसा", // 1 paisa
    subUnitPlural: "पैसे", // 0, 2+ paise
    separator: "और", // "aur" (and)
  );

  /// Indian Rupee (INR) currency details for Tamil (`Lang.TA`).
  static const CurrencyInfo inrTa = CurrencyInfo(
    mainUnitSingular: "ரூபாய்", // Rūbāy (singular/plural same)
    mainUnitPlural: "ரூபாய்",
    subUnitSingular: "பைசா", // Paisā (singular/plural same)
    subUnitPlural: "பைசா",
    // Separator might be "மற்றும்" (maṟṟum - and) but often omitted/implicit
  );

  /// Iranian Rial (IRR) currency details for Persian (`Lang.FA`).
  static const CurrencyInfo irr = CurrencyInfo(
    mainUnitSingular: "ریال", // Rial (singular/plural same)
    mainUnitPlural: "ریال",
    separator: "و", // "va" (and)
  );

  /// Icelandic Króna (ISK) currency details for Icelandic (`Lang.IS`).
  static const CurrencyInfo isk = CurrencyInfo(
    mainUnitSingular: "króna", // 1 króna (feminine)
    mainUnitPlural: "krónur", // 0, 2+ krónur
    // No common subunit (aurar deprecated and withdrawn from circulation).
    // separator: null (not applicable without subunit)
  );

  /// Japanese Yen (JPY) currency details for Japanese (`Lang.JA`).
  static const CurrencyInfo jpy = CurrencyInfo(
    mainUnitSingular: "円", // En (singular/plural same)
    mainUnitPlural: "円",
    // No common subunit (sen deprecated).
    // separator: null (not applicable without subunit)
  );

  /// Kyrgyzstani Som (KGS) currency details for Kyrgyz (`Lang.KY`).
  static const CurrencyInfo kgs = CurrencyInfo(
    mainUnitSingular: "сом", // Som (singular/plural same)
    mainUnitPlural: "сом",
    subUnitSingular: "тыйын", // Tyiyn (singular/plural same)
    subUnitPlural: "тыйын",
    // separator: null (usually omitted)
  );

  /// Cambodian Riel (KHR) currency details for Khmer (`Lang.KM`).
  static const CurrencyInfo khr = CurrencyInfo(
    mainUnitSingular: "រៀល", // Riel (singular/plural same)
    mainUnitPlural: "រៀល",
    subUnitSingular: "សេន", // Sen (1/100) - (singular/plural same)
    subUnitPlural: "សេន",
    // separator: null (usually omitted)
  );

  /// South Korean Won (KRW) currency details for Korean (`Lang.KO`).
  static const CurrencyInfo krw = CurrencyInfo(
    mainUnitSingular: "원", // Won (singular/plural same)
    mainUnitPlural: "원",
    // No common subunit (jeon deprecated).
    // separator: null (not applicable without subunit)
  );

  /// Kazakhstani Tenge (KZT) currency details for Kazakh (`Lang.KK`).
  static const CurrencyInfo kzt = CurrencyInfo(
    mainUnitSingular: "теңге", // Tenge (singular/plural same)
    mainUnitPlural: "теңге",
    subUnitSingular: "тиын", // Tiyn (singular/plural same)
    subUnitPlural: "тиын",
    // separator: null (usually omitted)
  );

  /// Lao Kip (LAK) currency details for Lao (`Lang.LO`).
  static const CurrencyInfo lak = CurrencyInfo(
    mainUnitSingular: "ກີບ", // Kip (singular/plural same)
    mainUnitPlural: "ກີບ",
    subUnitSingular: "ອັດ", // Att (1/100), largely unused/historical.
    subUnitPlural: "ອັດ", // Plural same.
    // separator: null (usually omitted)
  );

  /// Sri Lankan Rupee (LKR) currency details for Sinhala (`Lang.SI`).
  static const CurrencyInfo lkr = CurrencyInfo(
    mainUnitSingular: "රුපියල", // 1 rupiyala
    mainUnitPlural: "රුපියල්", // 0, 2+ rupiyal
    subUnitSingular: "සතය", // 1 sataya
    subUnitPlural: "සත", // 0, 2+ sata
    // Separator often implicit/omitted
  );

  /// Macedonian Denar (MKD) currency details for Macedonian (`Lang.MK`).
  static const CurrencyInfo mkd = CurrencyInfo(
    mainUnitSingular: "денар", // 1 denar
    mainUnitPlural: "денари", // 0, 2+ denari
    subUnitSingular:
        "дени", // 1 deni (singular/plural same - subunit largely historical)
    subUnitPlural: "дени", // 0, 2+ deni
    separator: "и", // "i" (and)
  );

  /// Myanmar Kyat (MMK) currency details for Burmese (`Lang.MY`).
  static const CurrencyInfo mmk = CurrencyInfo(
    mainUnitSingular: "ကျပ်", // Kyat (singular/plural same)
    mainUnitPlural: "ကျပ်",
    subUnitSingular: "ပြား", // Pya (singular/plural same)
    subUnitPlural: "ပြား",
    // separator: null (usually omitted)
  );

  /// Mongolian Tögrög (MNT) currency details for Mongolian (`Lang.MN`).
  static const CurrencyInfo mnt = CurrencyInfo(
    mainUnitSingular: "төгрөг", // Tögrög (singular/plural same)
    mainUnitPlural: "төгрөг",
    subUnitSingular: "мөнгө", // Möngö (1/100), largely unused/historical.
    subUnitPlural: "мөнгө", // Plural same.
    // separator: null (usually omitted)
  );

  /// Malaysian Ringgit (MYR) currency details for Malay (`Lang.MS`).
  static const CurrencyInfo myr = CurrencyInfo(
    mainUnitSingular: "ringgit", // Singular/plural same
    mainUnitPlural: "ringgit",
    subUnitSingular: "sen", // Singular/plural same
    subUnitPlural: "sen",
    separator: "dan", // "dan" (and)
  );

  /// Nigerian Naira (NGN) currency details for Hausa (`Lang.HA`).
  static const CurrencyInfo ngnHa = CurrencyInfo(
    mainUnitSingular: "Naira", // Singular/plural same (loanword)
    mainUnitPlural: "Naira",
    subUnitSingular: "kobo", // Singular/plural same (loanword)
    subUnitPlural: "kobo",
    separator: "da", // "da" (and/with)
  );

  /// Nigerian Naira (NGN) currency details for Igbo (`Lang.IG`).
  static const CurrencyInfo ngnIg = CurrencyInfo(
    mainUnitSingular: "Naira", // Singular/plural same (loanword)
    mainUnitPlural: "Naira",
    subUnitSingular: "Kobo", // Singular/plural same (loanword)
    subUnitPlural: "Kobo",
    separator: "na", // "na" (and)
  );

  /// Nigerian Naira (NGN) currency details for Yoruba (`Lang.YO`).
  static const CurrencyInfo ngnYo = CurrencyInfo(
    mainUnitSingular: "náírà", // Naira (singular/plural same)
    mainUnitPlural: "náírà",
    subUnitSingular: "kọ́bọ̀", // Kobo (singular/plural same)
    subUnitPlural: "kọ́bọ̀",
    // Separator often implicit or uses "àti" (and)
  );

  /// Norwegian Krone (NOK) currency details for Norwegian (`Lang.NO`).
  static const CurrencyInfo nok = CurrencyInfo(
    mainUnitSingular: "krone", // 1 krone
    mainUnitPlural: "kroner", // 0, 2+ kroner
    subUnitSingular: "øre", // 1 øre (singular/plural same)
    subUnitPlural: "øre", // 0, 2+ øre
    separator: "og", // "og" (and)
  );

  /// Nepalese Rupee (NPR) currency details for Nepali (`Lang.NE`).
  static const CurrencyInfo npr = CurrencyInfo(
    mainUnitSingular: "रुपैयाँ", // Rupaiyan (singular/plural same)
    mainUnitPlural: "रुपैयाँ",
    subUnitSingular: "पैसा", // Paisa (singular/plural same)
    subUnitPlural: "पैसा",
    separator: "र", // " ra " (and) - Requires spaces around it for clarity
  );

  /// Philippine Peso (PHP) currency details for Filipino (`Lang.FIL`).
  static const CurrencyInfo php = CurrencyInfo(
    mainUnitSingular: "piso", // Singular/plural same
    mainUnitPlural: "piso",
    subUnitSingular: "sentimo", // Singular/plural same
    subUnitPlural: "sentimo",
    separator: "at", // "at" (and)
  );

  /// Pakistani Rupee (PKR) currency details for Urdu (`Lang.UR`).
  static const CurrencyInfo pkr = CurrencyInfo(
    mainUnitSingular: "روپیہ", // 1 rupiya
    mainUnitPlural: "روپے", // 0, 2+ rupaye
    subUnitSingular: "پیسہ", // 1 paisa
    subUnitPlural: "پیسے", // 0, 2+ paise
    separator: "اور", // "aur" (and)
  );

  /// Polish Złoty (PLN) currency details for Polish (`Lang.PL`). Requires multiple plural forms.
  static const CurrencyInfo pln = CurrencyInfo(
    mainUnitSingular: "złoty", // 1 złoty (Nom. Sg.)
    mainUnitPlural2To4: "złote", // 2-4 złote (Nom. Pl.)
    mainUnitPluralGenitive: "złotych", // 0, 5+ złotych (Gen. Pl.)
    subUnitSingular: "grosz", // 1 grosz (Nom. Sg.)
    subUnitPlural2To4: "grosze", // 2-4 grosze (Nom. Pl.)
    subUnitPluralGenitive: "groszy", // 0, 5+ groszy (Gen. Pl.)
    separator: "i", // "i" (and)
  );

  /// Romanian Leu (RON) currency details for Romanian (`Lang.RO`).
  static const CurrencyInfo ron = CurrencyInfo(
    mainUnitSingular: "leu", // 1 leu
    mainUnitPlural: "lei", // 0, 2+ lei
    subUnitSingular: "ban", // 1 ban
    subUnitPlural: "bani", // 0, 2+ bani
    separator: "și", // "și" (and)
  );

  /// Serbian Dinar (RSD) currency details for Serbian (`Lang.SR`). Note case similarities.
  static const CurrencyInfo rsd = CurrencyInfo(
    mainUnitSingular: "dinar", // 1 dinar (masculine, Nom. Sg.)
    // Serbian uses Gen. Sg. form 'dinara' for 2-4 Nom. Pl., and Gen. Pl. is also 'dinara' for 0, 5+
    mainUnitPlural2To4:
        "dinara", // 2-4 dinara (Nom. Pl., often same as Gen. Sg.)
    mainUnitPluralGenitive: "dinara", // 0, 5+ dinara (Gen. Pl.)
    subUnitSingular: "para", // 1 para (fem.)
    subUnitPlural2To4: "pare", // 2-4 pare (Nom. Pl.)
    subUnitPluralGenitive: "para", // 0, 5+ para (Gen. Pl. - same as Nom. Sg.)
    separator: "i", // "i" (and)
  );

  /// Russian Ruble (RUB) currency details for Russian (`Lang.RU`). Requires multiple plural forms.
  static const CurrencyInfo rub = CurrencyInfo(
    mainUnitSingular: "рубль", // 1 rubl' (Nom. Sg.)
    mainUnitPlural2To4: "рубля", // 2-4 rublya (Gen. Sg. form used for Nom. Pl.)
    mainUnitPluralGenitive: "рублей", // 0, 5+ rubley (Gen. Pl.)
    subUnitSingular: "копейка", // 1 kopeyka (Nom. Sg.)
    subUnitPlural2To4: "копейки", // 2-4 kopeyki (Nom. Pl.)
    subUnitPluralGenitive: "копеек", // 0, 5+ kopeyek (Gen. Pl.)
    // Separator often implicit/omitted
  );

  /// Saudi Riyal (SAR) currency details for Arabic (`Lang.AR`). Plurals often handled by number word agreement.
  static const CurrencyInfo sar = CurrencyInfo(
    mainUnitSingular:
        "ريال سعودي", // Riyal Saudi (singular/plural handled by grammar)
    mainUnitPlural: "ريال سعودي", // Base form, actual wording depends on number
    subUnitSingular: "هللة", // Halala (singular/plural handled by grammar)
    subUnitPlural: "هللة", // Base form
    separator: "و", // "wa" (and)
  );

  /// Swedish Krona (SEK) currency details for Swedish (`Lang.SV`).
  static const CurrencyInfo sek = CurrencyInfo(
    mainUnitSingular: "krona", // 1 krona
    mainUnitPlural: "kronor", // 0, 2+ kronor
    subUnitSingular:
        "öre", // 1 öre (singular/plural same) - Note: Öre are physically obsolete but used digitally.
    subUnitPlural: "öre", // 0, 2+ öre
    separator: "och", // "och" (and)
  );

  /// Thai Baht (THB) currency details for Thai (`Lang.TH`).
  static const CurrencyInfo thb = CurrencyInfo(
    mainUnitSingular: "บาท", // Baht (singular/plural same)
    mainUnitPlural: "บาท",
    subUnitSingular: "สตางค์", // Satang (singular/plural same)
    subUnitPlural: "สตางค์",
    // Separator often implicit/omitted
  );

  /// Tajikistani Somoni (TJS) currency details for Tajik (`Lang.TG`).
  static const CurrencyInfo tjs = CurrencyInfo(
    mainUnitSingular: "сомонӣ", // Somoni (singular/plural same)
    mainUnitPlural: "сомонӣ",
    subUnitSingular: "дирам", // Diram (singular/plural same)
    subUnitPlural: "дирам",
    separator: "ва", // "va" (and)
  );

  /// Turkish Lira (TRY) currency details for Turkish (`Lang.TR`).
  static const CurrencyInfo tryTr = CurrencyInfo(
    mainUnitSingular: "Türk lirası", // Turkish lira (singular/plural same)
    mainUnitPlural: "Türk lirası",
    subUnitSingular: "kuruş", // Kuruş (singular/plural same)
    subUnitPlural: "kuruş",
    // Separator often implicit, or "virgül" (comma) sometimes used in writing amounts
  );

  /// Tanzanian Shilling (TZS) currency details for Swahili (`Lang.SW`).
  static const CurrencyInfo tzs = CurrencyInfo(
    mainUnitSingular: "shilingi", // Singular/plural same
    mainUnitPlural: "shilingi",
    subUnitSingular: "senti", // Singular/plural same
    subUnitPlural: "senti",
    separator: "na", // "na" (and/with)
  );

  /// Ukrainian Hryvnia (UAH) currency details for Ukrainian (`Lang.UK`). Requires multiple plural forms.
  static const CurrencyInfo uah = CurrencyInfo(
    mainUnitSingular: "гривня", // 1 hryvnia (Nom. Sg.)
    mainUnitPlural2To4: "гривні", // 2-4 hryvni (Nom. Pl.)
    mainUnitPluralGenitive: "гривень", // 0, 5+ hryven' (Gen. Pl.)
    subUnitSingular: "копійка", // 1 kopiyka (Nom. Sg.)
    subUnitPlural2To4: "копійки", // 2-4 kopiyky (Nom. Pl.)
    subUnitPluralGenitive: "копійок", // 0, 5+ kopiyok (Gen. Pl.)
    // Separator often implicit/omitted
  );

  /// United States Dollar (USD) currency details, commonly used for English (`Lang.EN`).
  static const CurrencyInfo usd = CurrencyInfo(
    mainUnitSingular: "dollar",
    mainUnitPlural: "dollars",
    subUnitSingular: "cent",
    subUnitPlural: "cents",
    separator: "and", // Common in speech, sometimes omitted in formal writing
  );

  /// Uzbekistani Som (UZS) currency details for Uzbek (`Lang.UZ`).
  static const CurrencyInfo uzs = CurrencyInfo(
    mainUnitSingular: "soʻm", // Som (or sum) - (singular/plural same)
    mainUnitPlural: "soʻm",
    subUnitSingular: "tiyin", // Tiyin (singular/plural same)
    subUnitPlural: "tiyin",
    // Separator often implicit/omitted
  );

  /// Vietnamese Đồng (VND) currency details for Vietnamese (`Lang.VI`).
  static const CurrencyInfo vnd = CurrencyInfo(
    mainUnitSingular: "đồng", // Singular/plural same
    mainUnitPlural: "đồng",
    // No commonly used subunit (hào/xu are deprecated/historical).
    // separator: null (not applicable without subunit)
  );

  /// South African Rand (ZAR) currency details for Afrikaans (`Lang.AF`).
  static const CurrencyInfo zar = CurrencyInfo(
    mainUnitSingular: "Rand", // Singular/plural same
    mainUnitPlural: "Rand",
    subUnitSingular: "sent", // Singular/plural same
    subUnitPlural: "sent",
    separator: "en", // "en" (and)
  );

  /// South African Rand (ZAR) currency details using Zulu (`Lang.ZU`) terms. Note plural prefixes.
  static const CurrencyInfo zarZu = CurrencyInfo(
    mainUnitSingular: "iRandi", // 1 Rand (class 9)
    mainUnitPlural: "amaRandi", // 0, 2+ Rand (class 6)
    subUnitSingular: "isenti", // 1 cent (class 7)
    subUnitPlural: "amasenti", // 0, 2+ cents (class 6)
    separator: "no", // "no" (and/with)
  );

  /// South African Rand (ZAR) currency details using Xhosa (`Lang.XH`) terms. Note plural prefixes.
  static const CurrencyInfo zarXh = CurrencyInfo(
    mainUnitSingular: "iRandi", // 1 Rand (class 9)
    mainUnitPlural: "iiRandi", // 0, 2+ Rand (class 10)
    subUnitSingular: "isenti", // 1 cent (class 7)
    subUnitPlural: "iisenti", // 0, 2+ cents (class 8 or 10, depends on context)
    separator: "ne", // "ne" (and/with)
  );

  /// Euro (EUR) currency details for Estonian (`Lang.ET`).
  static const CurrencyInfo eurEt = CurrencyInfo(
    mainUnitSingular: "euro", // 1 euro (singular/plural same)
    mainUnitPlural: "eurot", // 0, 2+ eurot (partitive case)
    subUnitSingular: "sent", // 1 sent
    subUnitPlural: "senti", // 0, 2+ senti (partitive case)
    separator: "ja", // "ja" (and)
  );
}
