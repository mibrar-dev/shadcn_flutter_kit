// ISO country reference data for `country_flag` (and later `phone_input`).
//
// Pure data file: exempt from the ~400-line component budget per the batch
// orchestrator note. Names, ISO codes, dial codes and currencies are derived
// from `package:phonecodes` (Copyright 2023 Sreelal TS, BSD-3-Clause); the
// dependency itself is banned, so the table lives here as plain const data.
// Non-ISO network entries (satellite/international networks) are excluded.
// Duplicate dial/code rows keep source order: first match wins, matching the
// old lookup behaviour.

import 'phone_number.dart';

/// One row of the [countryTable]: display name, ISO code, dial code and
/// ISO 4217 currency code for a country.
class CountryInfo {
  /// Creates a country info row.
  const CountryInfo(
    this.code,
    this.dialCode,
    this.currencyCode,
    this.name, {
    this.primary = false,
  });

  /// ISO 3166-1 alpha-2 code, e.g. `US`.
  final String code;

  /// International dial code with `+` prefix, e.g. `+1`.
  final String dialCode;

  /// ISO 4217 currency code, e.g. `USD`.
  final String currencyCode;

  /// English display name, e.g. `United States`.
  final String name;

  /// Whether this row is the primary country of a shared dial code.
  ///
  /// Typed-prefix detection uses it as the tie-break between rows that share
  /// a dial code (`+1` → `US`, `+44` → `GB`, `+590` → `GP`, ...); a current
  /// selection sharing the code still wins.
  final bool primary;

  /// This row as the minimal [Country] value type.
  Country get country => Country(dialCode: dialCode, code: code);

  @override
  bool operator ==(Object other) {
    return other is CountryInfo &&
        other.code == code &&
        other.dialCode == dialCode &&
        other.currencyCode == currencyCode &&
        other.name == name &&
        other.primary == primary;
  }

  @override
  int get hashCode => Object.hash(code, dialCode, currencyCode, name, primary);

  @override
  String toString() => name;
}

/// Every ISO country with its dial and currency codes, in source order.
const List<CountryInfo> countryTable = <CountryInfo>[
  CountryInfo('AF', '+93', 'AFN', 'Afghanistan'),
  CountryInfo('AL', '+355', 'ALL', 'Albania'),
  CountryInfo('DZ', '+213', 'DZD', 'Algeria'),
  CountryInfo('AS', '+1684', 'USD', 'American Samoa'),
  CountryInfo('AD', '+376', 'EUR', 'Andorra'),
  CountryInfo('AO', '+244', 'AOA', 'Angola'),
  CountryInfo('AI', '+1264', 'XCD', 'Anguilla'),
  CountryInfo('AG', '+1268', 'XCD', 'Antigua and Barbuda'),
  CountryInfo('AR', '+54', 'ARS', 'Argentina'),
  CountryInfo('AM', '+374', 'AMD', 'Armenia'),
  CountryInfo('AW', '+297', 'AWG', 'Aruba'),
  CountryInfo('AU', '+61', 'AUD', 'Australia', primary: true),
  CountryInfo('AT', '+43', 'EUR', 'Austria'),
  CountryInfo('AZ', '+994', 'AZN', 'Azerbaijan'),
  CountryInfo('BS', '+1242', 'BSD', 'Bahamas'),
  CountryInfo('BH', '+973', 'BHD', 'Bahrain'),
  CountryInfo('BD', '+880', 'BDT', 'Bangladesh'),
  CountryInfo('BB', '+1246', 'BBD', 'Barbados'),
  CountryInfo('BY', '+375', 'BYN', 'Belarus'),
  CountryInfo('BE', '+32', 'EUR', 'Belgium'),
  CountryInfo('BZ', '+501', 'BZD', 'Belize'),
  CountryInfo('BJ', '+229', 'XOF', 'Benin'),
  CountryInfo('BM', '+1441', 'BMD', 'Bermuda'),
  CountryInfo('BT', '+975', 'BMD', 'Bhutan'),
  CountryInfo('BO', '+591', 'BOB', 'Bolivia'),
  CountryInfo('BA', '+387', 'BAM', 'Bosnia and Herzegovina'),
  CountryInfo('BW', '+267', 'BWP', 'Botswana'),
  CountryInfo('BR', '+55', 'BRL', 'Brazil'),
  CountryInfo('IO', '+246', 'GBP', 'British Indian Ocean Territory'),
  CountryInfo('VG', '+1284', 'USD', 'British Virgin Islands'),
  CountryInfo('BN', '+673', 'BND', 'Brunei'),
  CountryInfo('BG', '+359', 'BGN', 'Bulgaria'),
  CountryInfo('BF', '+226', 'XOF', 'Burkina Faso'),
  CountryInfo('BI', '+257', 'BIF', 'Burundi'),
  CountryInfo('KH', '+855', 'KHR', 'Cambodia'),
  CountryInfo('CM', '+237', 'XAF', 'Cameroon'),
  CountryInfo('CA', '+1', 'CAD', 'Canada'),
  CountryInfo('CV', '+238', 'CVE', 'Cape Verde'),
  CountryInfo('KY', '+1345', 'KYD', 'Cayman Islands'),
  CountryInfo('CF', '+236', 'XAF', 'Central African Republic'),
  CountryInfo('TD', '+235', 'XAF', 'Chad'),
  CountryInfo('CL', '+56', 'CLP', 'Chile'),
  CountryInfo('CN', '+86', 'CNY', 'China'),
  CountryInfo('CX', '+61', 'AUD', 'Christmas Island'),
  CountryInfo('CC', '+61', 'AUD', 'Cocos Islands'),
  CountryInfo('CO', '+57', 'COP', 'Colombia'),
  CountryInfo('KM', '+269', 'KMF', 'Comoros'),
  CountryInfo('CK', '+682', 'NZD', 'Cook Islands'),
  CountryInfo('CR', '+506', 'CRC', 'Costa Rica'),
  CountryInfo('HR', '+385', 'HRK', 'Croatia'),
  CountryInfo('CU', '+53', 'CUP', 'Cuba'),
  CountryInfo('CW', '+599', 'ANG', 'Curacao'),
  CountryInfo('CY', '+357', 'EUR', 'Cyprus'),
  CountryInfo('CZ', '+420', 'CZK', 'Czech Republic'),
  CountryInfo('CD', '+243', 'CDF', 'Democratic Republic of the Congo'),
  CountryInfo('DK', '+45', 'DKK', 'Denmark'),
  CountryInfo('DJ', '+253', 'DJF', 'Djibouti'),
  CountryInfo('DM', '+1767', 'XCD', 'Dominica'),
  CountryInfo('DO', '+1809', 'DOP', 'Dominican Republic'),
  CountryInfo('DO', '+1829', 'DOP', 'Dominican Republic'),
  CountryInfo('DO', '+1849', 'DOP', 'Dominican Republic'),
  CountryInfo('EC', '+593', 'USD', 'Ecuador'),
  CountryInfo('EG', '+20', 'EGP', 'Egypt'),
  CountryInfo('SV', '+503', 'USD', 'El Salvador'),
  CountryInfo('GQ', '+240', 'XAF', 'Equatorial Guinea'),
  CountryInfo('ER', '+291', 'ERN', 'Eritrea'),
  CountryInfo('EE', '+372', 'EUR', 'Estonia'),
  CountryInfo('ET', '+251', 'ETB', 'Ethiopia'),
  CountryInfo('FK', '+500', 'FKP', 'Falkland Islands'),
  CountryInfo('FO', '+298', 'DKK', 'Faroe Islands'),
  CountryInfo('FJ', '+679', 'FJD', 'Fiji'),
  CountryInfo('FI', '+358', 'EUR', 'Finland', primary: true),
  CountryInfo('FR', '+33', 'EUR', 'France'),
  CountryInfo('GF', '+594', 'EUR', 'French Guiana'),
  CountryInfo('PF', '+689', 'XPF', 'French Polynesia'),
  CountryInfo('GA', '+241', 'XAF', 'Gabon'),
  CountryInfo('GM', '+220', 'GMD', 'Gambia'),
  CountryInfo('GE', '+995', 'GEL', 'Georgia'),
  CountryInfo('DE', '+49', 'EUR', 'Germany'),
  CountryInfo('GH', '+233', 'GHS', 'Ghana'),
  CountryInfo('GI', '+350', 'GIP', 'Gibraltar'),
  CountryInfo('GR', '+30', 'EUR', 'Greece'),
  CountryInfo('GL', '+299', 'DKK', 'Greenland'),
  CountryInfo('GD', '+1473', 'XCD', 'Grenada'),
  CountryInfo('GP', '+590', 'EUR', 'Guadeloupe', primary: true),
  CountryInfo('GU', '+1671', 'USD', 'Guam'),
  CountryInfo('GT', '+502', 'GTQ', 'Guatemala'),
  CountryInfo('GG', '+44', 'GGP', 'Guernsey'),
  CountryInfo('GN', '+224', 'GNF', 'Guinea'),
  CountryInfo('GW', '+245', 'XOF', 'Guinea-Bissau'),
  CountryInfo('GY', '+592', 'GYD', 'Guyana'),
  CountryInfo('HT', '+509', 'HTG', 'Haiti'),
  CountryInfo('HN', '+504', 'HNL', 'Honduras'),
  CountryInfo('HK', '+852', 'HKD', 'Hong Kong'),
  CountryInfo('HU', '+36', 'HUF', 'Hungary'),
  CountryInfo('IS', '+354', 'ISK', 'Iceland'),
  CountryInfo('IN', '+91', 'INR', 'India'),
  CountryInfo('ID', '+62', 'IDR', 'Indonesia'),
  CountryInfo('IR', '+98', 'IRR', 'Iran'),
  CountryInfo('IQ', '+964', 'IQD', 'Iraq'),
  CountryInfo('IE', '+353', 'EUR', 'Ireland'),
  CountryInfo('IL', '+972', 'ILS', 'Israel'),
  CountryInfo('IT', '+39', 'EUR', 'Italy'),
  CountryInfo('JM', '+1876', 'JMD', 'Jamaica'),
  CountryInfo('JP', '+81', 'JPY', 'Japan'),
  CountryInfo('JE', '+44', 'JEP', 'Jersey'),
  CountryInfo('JO', '+962', 'JOD', 'Jordan'),
  CountryInfo('KZ', '+7', 'KZT', 'Kazakhstan'),
  CountryInfo('KE', '+254', 'KES', 'Kenya'),
  CountryInfo('KI', '+686', 'USD', 'Kiribati'),
  CountryInfo('XK', '+383', 'EUR', 'Kosovo'),
  CountryInfo('KW', '+965', 'KWD', 'Kuwait'),
  CountryInfo('KG', '+996', 'KGS', 'Kyrgyzstan'),
  CountryInfo('LA', '+856', 'LAK', 'Laos'),
  CountryInfo('LV', '+371', 'EUR', 'Latvia'),
  CountryInfo('LB', '+961', 'LBP', 'Lebanon'),
  CountryInfo('LS', '+266', 'LSL', 'Lesotho'),
  CountryInfo('LR', '+231', 'LRD', 'Liberia'),
  CountryInfo('LY', '+218', 'LYD', 'Libya'),
  CountryInfo('LI', '+423', 'CHF', 'Liechtenstein'),
  CountryInfo('LT', '+370', 'EUR', 'Lithuania'),
  CountryInfo('LU', '+352', 'EUR', 'Luxembourg'),
  CountryInfo('MO', '+853', 'MOP', 'Macau'),
  CountryInfo('MK', '+389', 'MKD', 'Macedonia'),
  CountryInfo('MG', '+261', 'MGA', 'Madagascar'),
  CountryInfo('MW', '+265', 'MWK', 'Malawi'),
  CountryInfo('MY', '+60', 'MYR', 'Malaysia'),
  CountryInfo('MV', '+960', 'MVR', 'Maldives'),
  CountryInfo('ML', '+223', 'XOF', 'Mali'),
  CountryInfo('MT', '+356', 'EUR', 'Malta'),
  CountryInfo('MH', '+692', 'USD', 'Marshall Islands'),
  CountryInfo('MQ', '+596', 'EUR', 'Martinique'),
  CountryInfo('MR', '+222', 'MRU', 'Mauritania'),
  CountryInfo('MU', '+230', 'MUR', 'Mauritius'),
  CountryInfo('YT', '+262', 'EUR', 'Mayotte'),
  CountryInfo('MX', '+52', 'MXN', 'Mexico'),
  CountryInfo('FM', '+691', 'USD', 'Micronesia'),
  CountryInfo('MD', '+373', 'MDL', 'Moldova'),
  CountryInfo('MC', '+377', 'EUR', 'Monaco'),
  CountryInfo('MN', '+976', 'MNT', 'Mongolia'),
  CountryInfo('ME', '+382', 'EUR', 'Montenegro'),
  CountryInfo('MS', '+1664', 'XCD', 'Montserrat'),
  CountryInfo('MA', '+212', 'MAD', 'Morocco'),
  CountryInfo('MZ', '+258', 'MZN', 'Mozambique'),
  CountryInfo('MM', '+95', 'MMK', 'Myanmar'),
  CountryInfo('NA', '+264', 'NAD', 'Namibia'),
  CountryInfo('NR', '+674', 'USD', 'Nauru'),
  CountryInfo('NP', '+977', 'NPR', 'Nepal'),
  CountryInfo('NL', '+31', 'EUR', 'Netherlands'),
  CountryInfo('NC', '+687', 'XPF', 'New Caledonia'),
  CountryInfo('NZ', '+64', 'NZD', 'New Zealand', primary: true),
  CountryInfo('NI', '+505', 'NIO', 'Nicaragua'),
  CountryInfo('NE', '+227', 'XOF', 'Niger'),
  CountryInfo('NG', '+234', 'NGN', 'Nigeria'),
  CountryInfo('NU', '+683', 'NZD', 'Niue'),
  CountryInfo('NF', '+672', 'AUD', 'Norfolk Island'),
  CountryInfo('KP', '+850', 'KPW', 'North Korea'),
  CountryInfo('MP', '+1670', 'USD', 'Northern Mariana Islands'),
  CountryInfo('NO', '+47', 'NOK', 'Norway', primary: true),
  CountryInfo('OM', '+968', 'OMR', 'Oman'),
  CountryInfo('PK', '+92', 'PKR', 'Pakistan'),
  CountryInfo('PW', '+680', 'USD', 'Palau'),
  CountryInfo('PS', '+970', 'ILS', 'Palastinian Territories'),
  CountryInfo('PA', '+507', 'USD', 'Panama'),
  CountryInfo('PG', '+675', 'PGK', 'Papua New Guinea'),
  CountryInfo('PY', '+595', 'PYG', 'Paraguay'),
  CountryInfo('PE', '+51', 'PEN', 'Peru'),
  CountryInfo('PH', '+63', 'PHP', 'Philippines'),
  CountryInfo('PN', '+64', 'NZD', 'Pitcairn Islands'),
  CountryInfo('PL', '+48', 'PLN', 'Poland'),
  CountryInfo('PT', '+351', 'EUR', 'Portugal'),
  CountryInfo('PR', '+1787', 'USD', 'Puerto Rico'),
  CountryInfo('PR', '+1939', 'USD', 'Puerto Rico'),
  CountryInfo('QA', '+974', 'QAR', 'Qatar'),
  CountryInfo('CG', '+242', 'XAF', 'Republic of the Congo'),
  CountryInfo('RE', '+262', 'EUR', 'Réunion', primary: true),
  CountryInfo('RO', '+40', 'RON', 'Romania'),
  CountryInfo('RU', '+7', 'RUB', 'Russia', primary: true),
  CountryInfo('RW', '+250', 'RWF', 'Rwanda'),
  CountryInfo('BL', '+590', 'EUR', 'Saint Barthélemy'),
  CountryInfo('SH', '+290', 'SHP', 'Saint Helena'),
  CountryInfo('SH', '+247', 'SHP', 'Saint Helena'),
  CountryInfo('KN', '+1869', 'XCD', 'Saint Kitts and Nevis'),
  CountryInfo('LC', '+1758', 'XCD', 'Saint Lucia'),
  CountryInfo('MF', '+590', 'EUR', 'Saint Martin'),
  CountryInfo('PM', '+508', 'EUR', 'Saint Pierre and Miquelon'),
  CountryInfo('VC', '+1784', 'XCD', 'Saint Vincent and the Grenadines'),
  CountryInfo('WS', '+685', 'WST', 'Samoa'),
  CountryInfo('SM', '+378', 'EUR', 'San Marino'),
  CountryInfo('ST', '+239', 'STD', 'São Tomé and Príncipe'),
  CountryInfo('SA', '+966', 'SAR', 'Saudi Arabia'),
  CountryInfo('SN', '+221', 'XOF', 'Senegal'),
  CountryInfo('RS', '+381', 'RSD', 'Serbia'),
  CountryInfo('SC', '+248', 'SCR', 'Seychelles'),
  CountryInfo('SL', '+232', 'SLL', 'Sierra Leone'),
  CountryInfo('SG', '+65', 'SGD', 'Singapore'),
  CountryInfo('SX', '+1721', 'ANG', 'Sint Maarten'),
  CountryInfo('SK', '+421', 'EUR', 'Slovakia'),
  CountryInfo('SI', '+386', 'EUR', 'Slovenia'),
  CountryInfo('SB', '+677', 'SBD', 'Solomon Islands'),
  CountryInfo('SO', '+252', 'SOS', 'Somalia'),
  CountryInfo('ZA', '+27', 'ZAR', 'South Africa'),
  CountryInfo(
    'GS',
    '+500',
    'GBP',
    'South Georgia and the South Sandwich Islands',
  ),
  CountryInfo('KR', '+82', 'KRW', 'South Korea'),
  CountryInfo('SS', '+211', 'SSP', 'South Sudan'),
  CountryInfo('ES', '+34', 'EUR', 'Spain'),
  CountryInfo('LK', '+94', 'LKR', 'Sri Lanka'),
  CountryInfo('SD', '+249', 'SDG', 'Sudan'),
  CountryInfo('SR', '+597', 'SRD', 'Suriname'),
  CountryInfo('SJ', '+47', 'NOK', 'Svalbard and Jan Mayen'),
  CountryInfo('SZ', '+268', 'SZL', 'Swaziland'),
  CountryInfo('SE', '+46', 'SEK', 'Sweden'),
  CountryInfo('CH', '+41', 'CHF', 'Switzerland'),
  CountryInfo('SY', '+963', 'SYP', 'Syria'),
  CountryInfo('TW', '+886', 'TWD', 'Taiwan'),
  CountryInfo('TJ', '+992', 'TJS', 'Tajikistan'),
  CountryInfo('TZ', '+255', 'TZS', 'Tanzania'),
  CountryInfo('TH', '+66', 'THB', 'Thailand'),
  CountryInfo('TL', '+670', 'USD', 'Timor-Leste'),
  CountryInfo('TG', '+228', 'XOF', 'Togo'),
  CountryInfo('TK', '+690', 'NZD', 'Tokelau'),
  CountryInfo('TO', '+676', 'TOP', 'Tonga'),
  CountryInfo('TT', '+1868', 'TTD', 'Trinidad and Tobago'),
  CountryInfo('TN', '+216', 'TND', 'Tunisia'),
  CountryInfo('TR', '+90', 'TRY', 'Turkey'),
  CountryInfo('TM', '+993', 'TMT', 'Turkmenistan'),
  CountryInfo('TC', '+1649', 'USD', 'Turks and Caicos Islands'),
  CountryInfo('TV', '+688', 'USD', 'Tuvalu'),
  CountryInfo('UG', '+256', 'UGX', 'Uganda'),
  CountryInfo('UA', '+380', 'UAH', 'Ukraine'),
  CountryInfo('AE', '+971', 'AED', 'United Arab Emirates'),
  CountryInfo('GB', '+44', 'GBP', 'United Kingdom', primary: true),
  CountryInfo('US', '+1', 'USD', 'United States', primary: true),
  CountryInfo('UY', '+598', 'UYU', 'Uruguay'),
  CountryInfo('UZ', '+998', 'UZS', 'Uzbekistan'),
  CountryInfo('VU', '+678', 'VUV', 'Vanuatu'),
  CountryInfo('VE', '+58', 'VEF', 'Venezuela'),
  CountryInfo('VN', '+84', 'VND', 'Vietnam'),
  CountryInfo('VI', '+1340', 'USD', 'Virgn Islands, U.S.'),
  CountryInfo('WF', '+681', 'XPF', 'Wallis and Futuna'),
  CountryInfo('YE', '+967', 'YER', 'Yemen'),
  CountryInfo('ZM', '+260', 'ZMW', 'Zambia'),
  CountryInfo('ZW', '+263', 'ZWD', 'Zimbabwe'),
  CountryInfo('AX', '+358', 'EUR', 'Åland Islands'),
];

/// First [countryTable] row whose [CountryInfo.code] matches [code]
/// (case-insensitive), or null for unknown codes.
CountryInfo? countryInfoForCode(String code) {
  final String normalized = code.toUpperCase();
  for (final CountryInfo info in countryTable) {
    if (info.code == normalized) {
      return info;
    }
  }
  return null;
}

/// First [countryTable] row whose [CountryInfo.currencyCode] matches
/// [currencyCode] (case-insensitive), or null.
CountryInfo? countryInfoForCurrency(String currencyCode) {
  final String normalized = currencyCode.toUpperCase();
  for (final CountryInfo info in countryTable) {
    if (info.currencyCode == normalized) {
      return info;
    }
  }
  return null;
}

/// First [countryTable] row whose [CountryInfo.dialCode] matches [prefix]
/// (a leading `+` is optional), or null.
CountryInfo? countryInfoForDialCode(String prefix) {
  final String normalized = prefix.startsWith('+') ? prefix : '+$prefix';
  for (final CountryInfo info in countryTable) {
    if (info.dialCode == normalized) {
      return info;
    }
  }
  return null;
}

/// Regional-indicator emoji for an ISO [code] (e.g. `US` -> flag emoji).
/// Returns an empty string when [code] is not two ASCII letters.
String flagEmojiForCode(String code) {
  final String normalized = code.toUpperCase();
  if (normalized.length != 2) {
    return '';
  }
  final List<int> units = normalized.codeUnits;
  if (units.any((int unit) => unit < 0x41 || unit > 0x5A)) {
    return '';
  }
  return String.fromCharCodes(units.map((int unit) => 0x1F1E6 + unit - 0x41));
}
