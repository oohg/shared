/*
Get Regional Configuration Info
adapted from
http://www.codeguru.com/forum/showthread.php?t=351810
see also
http://vbnet.mvps.org/index.html?code/locale/localedates.htm
*/

#include "oohg.ch"

#define LOCALE_ILANGUAGE              0x00000001   // Language identifier. The maximum characters allowed is five.
#define LOCALE_SLANGUAGE              0x00000002   // Full localized name of language. This name is based on the localization of the product, thus the value changes for each localized version.
#define LOCALE_SENGLANGUAGE           0x00001001   // Full English name of the language from the International Organization for Standardization (ISO) Standard 639. This is always restricted to characters that can be mapped into the ASCII 127-character subset. This is not always equivalent to the English version of LOCALE_SLANGUAGE.
#define LOCALE_SABBREVLANGNAME        0x00000003   // Abbreviated name of the language. In most cases it is created by taking the two-letter language abbreviation from the ISO Standard 639 and adding a third letter, as appropriate, to indicate the sublanguage.
#define LOCALE_SNATIVELANGNAME        0x00000004   // Native name of language.

#define LOCALE_ICOUNTRY               0x00000005   // Country/region code, based on international phone codes, also referred to as IBM country codes. The maximum characters allowed is six.
#define LOCALE_SCOUNTRY               0x00000006   // Full localized name of the country/region. This is based on the localization of the product, thus it changes for each localized version.
#define LOCALE_SENGCOUNTRY            0x00001002   // Full English name of the country/region. This is always restricted to characters that can be mapped into the ASCII 127-character subset.
#define LOCALE_SABBREVCTRYNAME        0x00000007   // Abbreviated name of the country/region from the ISO Standard 3166.
#define LOCALE_SNATIVECTRYNAME        0x00000008   // Native name of the country/region.

#define LOCALE_IDEFAULTLANGUAGE       0x00000009   // Language identifier for the principal language spoken in this locale. This is provided so partially specified locales can be completed with default values. The maximum characters allowed is five.
#define LOCALE_IDEFAULTCOUNTRY        0x0000000A   // Code for the principal country/region in this locale. This is provided so that partially specified locales can be completed with default values. The maximum characters allowed is six.
#define LOCALE_IDEFAULTCODEPAGE       0x0000000B   // Original equipment manufacturer (OEM) code page associated with the country/region. If the locale does not use an OEM code page, the value is 1.The maximum characters allowed is six.
#define LOCALE_IDEFAULTANSICODEPAGE   0x00001004   // American National Standards Institute (ANSI) code page associated with this locale. If the locale does not use an ANSI code page, the value is 0. The maximum characters allowed is six.
#define LOCALE_IDEFAULTMACCODEPAGE    0x00001011   // Default Macintosh code page associated with the locale. If the locale does not use a Macintosh code page, the value is 2. The maximum characters allowed is six.

#define LOCALE_SLIST                  0x0000000C   // Character(s) used to separate list items, for example, a comma is used in many locales. The maximum number of characters allowed for this string is four, including a terminating null character.
#define LOCALE_IMEASURE               0x0000000D   // System of measurement. This value is 0 if the metric system (Syst‚me International d'Unit‚s, or S.I.) is used, and 1 if the U.S. system is used. The maximum characters allowed is two.
#define LOCALE_SDECIMAL               0x0000000E   // Character(s) used as the decimal separator. The maximum allowed is four.
#define LOCALE_STHOUSAND              0x0000000F   // Character(s) used to separate groups of digits to the left of the decimal. The maximum allowed is four.
#define LOCALE_SGROUPING              0x00000010   // Sizes for each group of digits to the left of the decimal. An explicit size is needed for each group, and sizes are separated by semicolons. If the last value is zero, the preceding value is repeated. For example, to group thousands, specify 3;0. Indic locales group the first thousand and then group by hundreds - for example 12,34,56,789, which is represented by 3;2;0.
#define LOCALE_IDIGITS                0x00000011   // Number of fractional digits. The maximum allowed is two.
#define LOCALE_ILZERO                 0x00000012   // Specifier for leading zeros in decimal fields. The maximum allowed is two.
#define LOCALE_INEGNUMBER             0x00001010   // Negative number mode, that is, the format for a negative number.
#define LOCALE_SNATIVEDIGITS          0x00000013   // Native equivalents to ASCII zero through 9.

#define LOCALE_SCURRENCY              0x00000014   // String used as the local symbol. The maximum number of characters allowed is six.
#define LOCALE_SINTLSYMBOL            0x00000015   // Three characters of the international monetary symbol specified in ISO 4217 followed by the character separating this string from the amount.
#define LOCALE_SMONDECIMALSEP         0x00000016   // Character(s) used as the  decimal separator. The maximum characters allowed is four.
#define LOCALE_SMONTHOUSANDSEP        0x00000017   // Character(s) used as the  separator between groups of digits to the left of the decimal. The maximum number of characters allowed is four.
#define LOCALE_SMONGROUPING           0x00000018   // Sizes for each group of  digits to the left of the decimal. An explicit size is needed for each group, and sizes are separated by semicolons. If the last value is zero, the preceding value is repeated. For example, to group thousands, specify 3;0. Indic languages group the first thousand and then group by hundreds - for example, 12,34,56,789, which is represented by 3;2;0. The maximum characters allowed is four.
#define LOCALE_ICURRDIGITS            0x00000019   // Number of fractional digits for the local format. The maximum characters allowed is three.
#define LOCALE_IINTLCURRDIGITS        0x0000001A   // Number of fractional digits for the international format. The maximum characters allowed is three.
#define LOCALE_ICURRENCY              0x0000001B   // Position of the symbol in the positive currency mode. The maximum characters allowed is two.
#define LOCALE_INEGCURR               0x0000001C   // Negative currency mode. The maximum characters allowed is three.

#define LOCALE_SDATE                  0x0000001D   // Characters used for the date separator.
#define LOCALE_STIME                  0x0000001E   // Characters used for the time separator.
#define LOCALE_SSHORTDATE             0x0000001F   // Short Date_Time formatting strings for this locale.
#define LOCALE_SLONGDATE              0x00000020   // Long Date_Time formatting strings for this locale.
#define LOCALE_STIMEFORMAT            0x00001003   // Time-formatting string.
#define LOCALE_IDATE                  0x00000021   // Short Date format-ordering specifier.
#define LOCALE_ILDATE                 0x00000022   // Long Date format ordering specifier. Value can be any of the valid LOCALE_IDATE settings.
#define LOCALE_ITIME                  0x00000023   // Time format specification. It is preferred for your application to use the LOCALE_STIMEFORMAT constant instead of LOCALE_ITIME.
#define LOCALE_ITIMEMARKPOSN          0x00001005   // Whether the time marker string (AM|PM) precedes or follows the time string. 0 Suffix (9:15 AM). 1 Prefix (AM 9:15).
#define LOCALE_ICENTURY               0x00000024   // Whether to use full 4-digit century.
#define LOCALE_ITLZERO                0x00000025   // Whether to use leading zeros in time fields.
#define LOCALE_IDAYLZERO              0x00000026   // Whether to use leading zeros in day fields.
#define LOCALE_IMONLZERO              0x00000027   // Whether to use leading zeros in month fields.
#define LOCALE_S1159                  0x00000028   // String for the AM designator.
#define LOCALE_S2359                  0x00000029   // String for the PM designator

#define LOCALE_ICALENDARTYPE          0x00001009   // Type of calendar specifier
#define LOCALE_IOPTIONALCALENDAR      0x0000100B   // Additional calendar types specifier
#define LOCALE_IFIRSTDAYOFWEEK        0x0000100C   // First day of week specifier
#define LOCALE_IFIRSTWEEKOFYEAR       0x0000100D   // First week of year specifier

#define LOCALE_SDAYNAME1              0x0000002A   // Long name for Monday
#define LOCALE_SDAYNAME2              0x0000002B   // Long name for Tuesday
#define LOCALE_SDAYNAME3              0x0000002C   // Long name for Wednesday
#define LOCALE_SDAYNAME4              0x0000002D   // Long name for Thursday
#define LOCALE_SDAYNAME5              0x0000002E   // Long name for Friday
#define LOCALE_SDAYNAME6              0x0000002F   // Long name for Saturday
#define LOCALE_SDAYNAME7              0x00000030   // Long name for Sunday
#define LOCALE_SABBREVDAYNAME1        0x00000031   // Abbreviated name for Monday
#define LOCALE_SABBREVDAYNAME2        0x00000032   // Abbreviated name for Tuesday
#define LOCALE_SABBREVDAYNAME3        0x00000033   // Abbreviated name for Wednesday
#define LOCALE_SABBREVDAYNAME4        0x00000034   // Abbreviated name for Thursday
#define LOCALE_SABBREVDAYNAME5        0x00000035   // Abbreviated name for Friday
#define LOCALE_SABBREVDAYNAME6        0x00000036   // Abbreviated name for Saturday
#define LOCALE_SABBREVDAYNAME7        0x00000037   // Abbreviated name for Sunday
#define LOCALE_SMONTHNAME1            0x00000038   // Long name for January
#define LOCALE_SMONTHNAME2            0x00000039   // Long name for February
#define LOCALE_SMONTHNAME3            0x0000003A   // Long name for March
#define LOCALE_SMONTHNAME4            0x0000003B   // Long name for April
#define LOCALE_SMONTHNAME5            0x0000003C   // Long name for May
#define LOCALE_SMONTHNAME6            0x0000003D   // Long name for June
#define LOCALE_SMONTHNAME7            0x0000003E   // Long name for July
#define LOCALE_SMONTHNAME8            0x0000003F   // Long name for August
#define LOCALE_SMONTHNAME9            0x00000040   // Long name for September
#define LOCALE_SMONTHNAME10           0x00000041   // Long name for October
#define LOCALE_SMONTHNAME11           0x00000042   // Long name for November
#define LOCALE_SMONTHNAME12           0x00000043   // Long name for December
#define LOCALE_SMONTHNAME13           0x0000100E   // Long name for 13th month (if exists)
#define LOCALE_SABBREVMONTHNAME1      0x00000044   // Abbreviated name for January
#define LOCALE_SABBREVMONTHNAME2      0x00000045   // Abbreviated name for February
#define LOCALE_SABBREVMONTHNAME3      0x00000046   // Abbreviated name for March
#define LOCALE_SABBREVMONTHNAME4      0x00000047   // Abbreviated name for April
#define LOCALE_SABBREVMONTHNAME5      0x00000048   // Abbreviated name for May
#define LOCALE_SABBREVMONTHNAME6      0x00000049   // Abbreviated name for June
#define LOCALE_SABBREVMONTHNAME7      0x0000004A   // Abbreviated name for July
#define LOCALE_SABBREVMONTHNAME8      0x0000004B   // Abbreviated name for August
#define LOCALE_SABBREVMONTHNAME9      0x0000004C   // Abbreviated name for September
#define LOCALE_SABBREVMONTHNAME10     0x0000004D   // Abbreviated name for October
#define LOCALE_SABBREVMONTHNAME11     0x0000004E   // Abbreviated name for November
#define LOCALE_SABBREVMONTHNAME12     0x0000004F   // Abbreviated name for December
#define LOCALE_SABBREVMONTHNAME13     0x0000100F   // Abbreviated name for 13th month (if exists)

#define LOCALE_SPOSITIVESIGN          0x00000050   // String value for the positive sign. The maximum allowed is five.
#define LOCALE_SNEGATIVESIGN          0x00000051   // String value for the negative sign. The maximum allowed is five.
#define LOCALE_IPOSSIGNPOSN           0x00000052   // Formatting index for positive values.
#define LOCALE_INEGSIGNPOSN           0x00000053   // Formatting index for negative values.
#define LOCALE_IPOSSYMPRECEDES        0x00000054   // If the monetary symbol precedes, 1. If it succeeds a positive amount, 0.
#define LOCALE_IPOSSEPBYSPACE         0x00000055   // If the monetary symbol is separated by a space from a positive amount, 1. Otherwise, 0.
#define LOCALE_INEGSYMPRECEDES        0x00000056   // If the monetary symbol precedes, 1. If it succeeds a negative amount, 0.
#define LOCALE_INEGSEPBYSPACE         0x00000057   // If the monetary symbol is separated by a space from a negative amount, 1. Otherwise, 0.

#define LOCALE_FONTSIGNATURE          0x00000058   // A specific bit pattern that determines the relationship between the character coverage needed to support the locale and the font contents. Note that LOCALE_FONTSIGNATURE data takes a different form from all other locale information. All other locale information can be expressed in a string form or as a number. LOCALE_FONTSIGNATURE data is retrieved in a LOCALESIGNATURE structure.
#define LOCALE_SISO639LANGNAME        0x00000059   // The abbreviated name of the language based entirely on the ISO Standard 639 values.
#define LOCALE_SISO3166CTRYNAME       0x0000005A   // Country/region name, based on ISO Standard 3166.
#define LOCALE_IDEFAULTEBCDICCODEPAGE 0x00001012   // Default EBCDIC code page associated with the locale. The maximum characters allowed is six. Windows 2000 only.
#define LOCALE_IPAPERSIZE             0x0000100A   // Default paper size associated with the locale. The size typically has one of the following values, although it can be set to any of the defined paper sizes that are understood by the spooler.
#define LOCALE_SENGCURRNAME           0x00001007   // English name of currency
#define LOCALE_SNATIVECURRNAME        0x00001008   // The native name of the currency associated with the locale. Windows 2000 only
#define LOCALE_SYEARMONTH             0x00001006   // Year month format string
#define LOCALE_SSORTNAME              0x00001013   // The full localized name of the sort for the specified locale identifier, dependent on the language of the shell. Windows 2000 only
#define LOCALE_IDIGITSUBSTITUTION     0x00001014   // The shape of digits. For example, Arabic, Thai, and Indic digits have classical shapes different from European digits. For locales with LOCALE_SNATIVEDIGITS specified as values other than ASCII 0-9, this value specifies whether preference should be given to those other digits for display purposes. For example, if a value of 2 is chosen, the digits specified by LOCALE_SNATIVEDIGITS are always used. If a 1 is chosen, the ASCII 0-9 digits are always used. If a 0 is chosen, ASCII is used in some circumstances and the digits specified by LOCALE_SNATIVEDIGITS are used in others, depending on the context.
/*
0 = Context-based substitution. Digits are displayed based on the previous text in the same output. European digits follow Latin scripts, Arabic-Indic digits follow Arabic text, and other national digits follow text written in various other scripts. When there is no preceding text, the locale and the displayed reading order determine digit substitution, as shown in the following table.
Locale     Reading order   Digits used
------     -------------   --------------------
Arabic     Right-to-left   Arabic-Indic
Thai       Left-to-right   Thai digits
All others Any             No substitution used

1 = No substitution used. Full Unicode compatibility

2 = Native digit substitution. National shapes are displayed according to LOCALE_SNATIVEDIGITS.
*/


PROCEDURE Main

  local Ventana
  
  define window Ventana obj Ventana ;
    at 0,0 width 308 height 300 ;
    title "Locale Info" ;
    main ;
    on init GetData(Ventana) ;
    on size PaintWindow(Ventana)
    
    @ 10, 10 richeditbox Datos ;
      value "" ;
      readonly ;
      backcolor WHITE ;
      font "courier new" size 10 ;
      width 280;
      height 200
  end window
  
  Ventana:center()
  Ventana:activate()

return

static function PaintWindow (Ventana)

  with object Ventana
    if :width < 408
      :width := 408
    endif

    if :height < 400
      :height := 400
    endif

    :Datos:width  := :width - 28
    :Datos:height := :height - 68

    :redraw()
  end

return (nil)

function GetData (Ventana)

  local LCID, r

  LCID := GetThreadLocale()       // or LCID := GetSystemDefaultLCID()

  with object Ventana
    :Datos:value := "The values displayed should correspond to the Codepage and Regional Settings for your system." + hb_osnewline() + hb_osnewline()

    :Datos:value += pad("Language Id: ", 50) + GetUserLocaleInfo(LCID, LOCALE_ILANGUAGE) + hb_osnewline()
    :Datos:value += pad("Localized name of language: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SLANGUAGE) + hb_osnewline()
    :Datos:value += pad("English name of language: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SENGLANGUAGE) + hb_osnewline()
    :Datos:value += pad("Abbreviated language name: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVLANGNAME) + hb_osnewline()
    :Datos:value += pad("Native name of language: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SNATIVELANGNAME) + hb_osnewline()

    :Datos:value += pad("Country code: ", 50) + GetUserLocaleInfo(LCID, LOCALE_ICOUNTRY) + hb_osnewline()
    :Datos:value += pad("Localized name of country: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SCOUNTRY) + hb_osnewline()
    :Datos:value += pad("English name of country: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SENGCOUNTRY) + hb_osnewline()
    :Datos:value += pad("Abbreviated country name: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVCTRYNAME) + hb_osnewline()
    :Datos:value += pad("Native name of country: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SNATIVECTRYNAME) + hb_osnewline()

    :Datos:value += pad("Default language id: ", 50) + GetUserLocaleInfo(LCID, LOCALE_IDEFAULTLANGUAGE) + hb_osnewline()
    :Datos:value += pad("Default country code: ", 50) + GetUserLocaleInfo(LCID, LOCALE_IDEFAULTCOUNTRY) + hb_osnewline()
    :Datos:value += pad("Default oem code page: ", 50) + GetUserLocaleInfo(LCID, LOCALE_IDEFAULTCODEPAGE) + hb_osnewline()
    :Datos:value += pad("Default ansi code page: ", 50) + GetUserLocaleInfo(LCID, LOCALE_IDEFAULTANSICODEPAGE) + hb_osnewline()
    :Datos:value += pad("Default mac code page: ", 50) + GetUserLocaleInfo(LCID, LOCALE_IDEFAULTMACCODEPAGE) + hb_osnewline()

    :Datos:value += pad("List item separator: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SLIST) + hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_IMEASURE)
    do case
    case r == "0"
      :Datos:value += pad("System of measurement: ", 50) + "0 - Metric"
    case r == "1"
      :Datos:value += pad("System of measurement: ", 50) + "1 - US"
    Endcase
    :Datos:value += hb_osnewline()

    :Datos:value += pad("Decimal separator: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SDECIMAL) + hb_osnewline()
    :Datos:value += pad("Thousand separator: ", 50) + GetUserLocaleInfo(LCID, LOCALE_STHOUSAND) + hb_osnewline()
    :Datos:value += pad("Digit grouping: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SGROUPING) + hb_osnewline()
    :Datos:value += pad("Number of fractional digits: ", 50) + GetUserLocaleInfo(LCID, LOCALE_IDIGITS) + hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_ILZERO)
    do case
    case r == "0"
      :Datos:value += pad("Leading zeros for decimal: ", 50) + "0 - No leading zeros"
    case r == "1"
      :Datos:value += pad("Leading zeros for decimal: ", 50) + "1 - Has leading zeros"
    Endcase
    :Datos:value += hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_INEGNUMBER)
    do case
    case r == "0"
      :Datos:value += pad("Negative number mode: ", 50) + "0 - Left parenthesis, number, right parenthesis, ie (1.1)"
    case r == "1"
      :Datos:value += pad("Negative number mode: ", 50) + "1 - Negative sign, number, ie -1.1"
    case r == "2"
      :Datos:value += pad("Negative number mode: ", 50) + "2 - Negative sign, space, number, ie - 1.1"
    case r == "3"
      :Datos:value += pad("Negative number mode: ", 50) + "3 - Number, negative sign, ie 1.1-"
    case r == "4"
      :Datos:value += pad("Negative number mode: ", 50) + "4 - Number, space, negative sign, ie 1.1 -"
    Endcase
    :Datos:value += hb_osnewline()

    :Datos:value += pad("Native ascii 0-9: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SNATIVEDIGITS) + hb_osnewline()
    :Datos:value += pad("Local monetary symbol: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SCURRENCY) + hb_osnewline()
    :Datos:value += pad("Intl monetary symbol: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SINTLSYMBOL) + hb_osnewline()
    :Datos:value += pad("Monetary decimal separator: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SMONDECIMALSEP) + hb_osnewline()
    :Datos:value += pad("Monetary thousand separator: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SMONTHOUSANDSEP) + hb_osnewline()
    :Datos:value += pad("Monetary grouping: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SMONGROUPING) + hb_osnewline()
    :Datos:value += pad("# local monetary digits: ", 50) + GetUserLocaleInfo(LCID, LOCALE_ICURRDIGITS) + hb_osnewline()
    :Datos:value += pad("# intl monetary digits: ", 50) + GetUserLocaleInfo(LCID, LOCALE_IINTLCURRDIGITS) + hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_ICURRENCY)
    do case
    case r == "0"
      :Datos:value += pad("Symbol position in positive currency mode: ", 50) + "0 - Prefix, no separation, ie $1.1"
    case r == "1"
      :Datos:value += pad("Negative number mode: ", 50) + "1 - Suffix, no separation, ie 1.1$"
    case r == "2"
      :Datos:value += pad("Negative number mode: ", 50) + "2 - Prefix, 1-character separation, ie $ 1.1"
    case r == "3"
      :Datos:value += pad("Negative number mode: ", 50) + "3 - Suffix, 1-character separation, ie 1.1 $"
    Endcase
    :Datos:value += hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_INEGCURR)
    do case
    case r == "0"
      :Datos:value += pad("Negative currency mode: ", 50) + "0 - L parenthesis, symbol, number, R parenthesis, ie ($1.1)"
    case r == "1"
      :Datos:value += pad("Negative currency mode: ", 50) + "1 - Neg sign, symbol, number, ie -$1.1"
    case r == "2"
      :Datos:value += pad("Negative currency mode: ", 50) + "2 - Symbol, neg sign, number, ie $-1.1"
    case r == "3"
      :Datos:value += pad("Negative currency mode: ", 50) + "3 - Symbol, number, neg sign, ie $1.1-"
    case r == "4"
      :Datos:value += pad("Negative currency mode: ", 50) + "4 - L parenthesis, number, symbol, R parenthesis, ie (1.1$)"
    case r == "5"
      :Datos:value += pad("Negative currency mode: ", 50) + "5 - Neg sign, number, symbol, ie -1.1$"
    case r == "6"
      :Datos:value += pad("Negative currency mode: ", 50) + "6 - Number, neg sign, symbol, ie 1.1-$"
    case r == "7"
      :Datos:value += pad("Negative currency mode: ", 50) + "7 - Number, symbol, neg sign, ie 1.1$-"
    case r == "8"
      :Datos:value += pad("Negative currency mode: ", 50) + "8 - Neg sign, number, space, symbol (like #5, but w/ space before symbol), ie -1.1 $"
    case r == "9"
      :Datos:value += pad("Negative currency mode: ", 50) + "9 - Neg sign, symbol, space, number (like #1, but w/ space after symbol), ie -$ 1.1"
    case r == "10"
      :Datos:value += pad("Negative currency mode: ", 50) + "10 - Number, space, symbol, neg sign (like #7, but w/ space before symbol), ie 1.1 $-"
    case r == "11"
      :Datos:value += pad("Negative currency mode: ", 50) + "11 - Symbol, space, number, neg sign (like #3, but w/ space after symbol), ie $ 1.1-"
    case r == "12"
      :Datos:value += pad("Negative currency mode: ", 50) + "12 - Symbol, space, neg sign, number (like #2, but w/ space after symbol), ie $ -1.1"
    case r == "13"
      :Datos:value += pad("Negative currency mode: ", 50) + "13 - Number, neg sign, space, symbol (like #6, but w/ space before symbol), ie 1.1- $"
    case r == "14"
      :Datos:value += pad("Negative currency mode: ", 50) + "14 - L parenthesis, symbol, space, number, R parenthesis (like #0, but w/ space after symbol), ie ($ 1.1)"
    case r == "15"
      :Datos:value += pad("Negative currency mode: ", 50) + "15 - L parenthesis, number, space, symbol, R parenthesis (like #4, but w/ space before symbol), ie (1.1 $)"
    Endcase
    :Datos:value += hb_osnewline()

    :Datos:value += pad("Date separator chr: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SDATE) + hb_osnewline()
    :Datos:value += pad("Time separator: ", 50) + GetUserLocaleInfo(LCID, LOCALE_STIME) + hb_osnewline()
    :Datos:value += pad("Short date format string: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SSHORTDATE) + hb_osnewline()
    :Datos:value += pad("Long date format string: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SLONGDATE) + hb_osnewline()
    :Datos:value += pad("Time format string: ", 50) + GetUserLocaleInfo(LCID, LOCALE_STIMEFORMAT) + hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_IDATE)
    do case
    case r == "0"
      :Datos:value += pad("Short date format ordering: ", 50) + "0 - Month/Day/Year"
    case r == "1"
      :Datos:value += pad("Short date format ordering: ", 50) + "1 - Day/Month/Year"
    case r == "2"
      :Datos:value += pad("Short date format ordering: ", 50) + "2 - Year/Month/Day"
    endcase
    :Datos:value += hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_ILDATE)
    Do case
    case r == "0"
      :Datos:value += pad("Long date format-ordering specifier: ", 50) + "0 - Month/Day/Year"
    case r == "1"
      :Datos:value += pad("Long date format-ordering specifier: ", 50) + "1 - Day/Month/Year"
    case r == "2"
      :Datos:value += pad("Long date format-ordering specifier: ", 50) + "2 - Year/Month/Day"
    Endcase
    :Datos:value += hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_ITIME)
    Do case
    case r == "0"
      :Datos:value += pad("Time format specifier: ", 50) + "0 - AM/PM 12-hour format"
    case r == "1"
      :Datos:value += pad("Time format specifier: ", 50) + "1 - 24-hour format"
    Endcase
    :Datos:value += hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_ITIMEMARKPOSN)
    Do case
    case r == "0"
      :Datos:value += pad("Time marker position: ", 50) + "0 - Suffix (9:15 AM)"
    case r == "1"
      :Datos:value += pad("Time marker position: ", 50) + "1 - Prefix (AM 9:15)"
    Endcase
    :Datos:value += hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_ICENTURY)
    Do case
    case r == "0"
      :Datos:value += pad("Century format specifier (short date): ", 50) + "0 - Two digit"
    case r == "1"
      :Datos:value += pad("Century format specifier (short date): ", 50) + "1 - Full century"
    Endcase
    :Datos:value += hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_ITLZERO)
    Do case
    case r == "0"
      :Datos:value += pad("Leading zeros in time field: ", 50) + "0 - No leading zeros"
    case r == "1"
      :Datos:value += pad("Leading zeros in time field: ", 50) + "1 - Leading zeros for hours"
    Endcase
    :Datos:value += hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_IDAYLZERO)
    Do case
    case r == "0"
      :Datos:value += pad("Leading zeros in day field (short date): ", 50) + "0 - No leading zeros"
    case r == "1"
      :Datos:value += pad("Leading zeros in day field (short date): ", 50) + "1 - Leading zeros for days"
    Endcase
    :Datos:value += hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_IMONLZERO)
    Do case
    case r == "0"
      :Datos:value += pad("Leading zeros in month field (short date): ", 50) + "0 - No leading zeros"
    case r == "1"
      :Datos:value += pad("Leading zeros in month field (short date): ", 50) + "1 - Leading zeros for months"
    Endcase
    :Datos:value += hb_osnewline()

    :Datos:value += pad("AM designator: ", 50) + GetUserLocaleInfo(LCID, LOCALE_S1159) + hb_osnewline()
    :Datos:value += pad("PM designator: ", 50) + GetUserLocaleInfo(LCID, LOCALE_S2359) + hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_ICALENDARTYPE)
    do case
    case r == "1"
      :Datos:value += pad("Current calendar type: ", 50) + "1 - Gregorian (localized)"
    case r == "2"
      :Datos:value += pad("Current calendar type: ", 50) + "2 - Gregorian (English strings always)"
    case r == "3"
      :Datos:value += pad("Current calendar type: ", 50) + "3 - Era: Year of the Emperor (Japan)"
    case r == "4"
      :Datos:value += pad("Current calendar type: ", 50) + "4 - Era: Year of Taiwan Region"
    case r == "5"
      :Datos:value += pad("Current calendar type: ", 50) + "5 - Tangun Era(Korea)"
    case r == "6"
      :Datos:value += pad("Current calendar type: ", 50) + "6 - Hijri (Arabic lunar)"
    case r == "7"
      :Datos:value += pad("Current calendar type: ", 50) + "7 - Thai"
    case r == "8"
      :Datos:value += pad("Current calendar type: ", 50) + "8 - Hebrew (Lunar)"
    case r == "9"
      :Datos:value += pad("Current calendar type: ", 50) + "9 - Gregorian Middle East French"
    case r == "10"
      :Datos:value += pad("Current calendar type: ", 50) + "10 - Gregorian Arabic calendar"
    case r == "11"
      :Datos:value += pad("Current calendar type: ", 50) + "11 - Gregorian Transliterated English"
    case r == "12"
      :Datos:value += pad("Current calendar type: ", 50) + "12 - Gregorian Transliterated French"
    endcase
    :Datos:value += hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_IOPTIONALCALENDAR)
    do case
    case r == "0"
      :Datos:value += pad("Additional calendar type: ", 50) + "0 - No additional types valid"
    case r == "1"
      :Datos:value += pad("Additional calendar type: ", 50) + "1 - Gregorian (localized)"
    case r == "2"
      :Datos:value += pad("Additional calendar type: ", 50) + "2 - Gregorian (English strings always)"
    case r == "3"
      :Datos:value += pad("Additional calendar type: ", 50) + "3 - Era: Year of the Emperor (Japan)"
    case r == "4"
      :Datos:value += pad("Additional calendar type: ", 50) + "4 - Era: Year of Taiwan Region"
    case r == "5"
      :Datos:value += pad("Additional calendar type: ", 50) + "5 - Tangun Era(Korea)"
    case r == "6"
      :Datos:value += pad("Additional calendar type: ", 50) + "6 - Hijri (Arabic lunar)"
    case r == "7"
      :Datos:value += pad("Additional calendar type: ", 50) + "7 - Thai"
    case r == "8"
      :Datos:value += pad("Additional calendar type: ", 50) + "8 - Hebrew (Lunar)"
    case r == "9"
      :Datos:value += pad("Additional calendar type: ", 50) + "9 - Gregorian Middle East French"
    case r == "10"
      :Datos:value += pad("Additional calendar type: ", 50) + "10 - Gregorian Arabic calendar"
    case r == "11"
      :Datos:value += pad("Additional calendar type: ", 50) + "11 - Gregorian Transliterated English"
    case r == "12"
      :Datos:value += pad("Additional calendar type: ", 50) + "12 - Gregorian Transliterated French"
    endcase
    :Datos:value += hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_IFIRSTDAYOFWEEK)
    do case
    case r == "0"
      :Datos:value += pad("Specifier for the first day in a week :", 50) + "0 - LOCALE_SDAYNAME1"
    case r == "1"
      :Datos:value += pad("Specifier for the first day in a week :", 50) + "1 - LOCALE_SDAYNAME2"
    case r == "2"
      :Datos:value += pad("Specifier for the first day in a week :", 50) + "2 - LOCALE_SDAYNAME3"
    case r == "3"
      :Datos:value += pad("Specifier for the first day in a week :", 50) + "3 - LOCALE_SDAYNAME4"
    case r == "4"
      :Datos:value += pad("Specifier for the first day in a week :", 50) + "4 - LOCALE_SDAYNAME5"
    case r == "5"
      :Datos:value += pad("Specifier for the first day in a week :", 50) + "5 - LOCALE_SDAYNAME6"
    case r == "6"
      :Datos:value += pad("Specifier for the first day in a week :", 50) + "6 - LOCALE_SDAYNAME7"
    endcase
    :Datos:value += hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_IFIRSTWEEKOFYEAR)
    do case
    case r == "0"
      :Datos:value += pad("Specifier for the first week of the year: ", 50) + "0 - Week containing 1/1 is first week of that year"
    case r == "1"
      :Datos:value += pad("Specifier for the first week of the year: ", 50) + "1 - First full week following 1/1 is first week of that year"
    case r == "2"
      :Datos:value += pad("Specifier for the first week of the year: ", 50) + "2 - First week containing at least four days is first week of that year"
    endcase
    :Datos:value += hb_osnewline()

    :Datos:value += pad("Long name for Monday: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SDAYNAME1) + hb_osnewline()
    :Datos:value += pad("Long name for Tuesday: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SDAYNAME2) + hb_osnewline()
    :Datos:value += pad("Long name for Wednesday: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SDAYNAME3) + hb_osnewline()
    :Datos:value += pad("Long name for Thursday: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SDAYNAME4) + hb_osnewline()
    :Datos:value += pad("Long name for Friday: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SDAYNAME5) + hb_osnewline()
    :Datos:value += pad("Long name for Saturday: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SDAYNAME6) + hb_osnewline()
    :Datos:value += pad("Long name for Sunday: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SDAYNAME7) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for Monday: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVDAYNAME1) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for Tuesday: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVDAYNAME2) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for Wednesday: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVDAYNAME3) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for Thursday: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVDAYNAME4) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for Friday: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVDAYNAME5) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for Saturday: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVDAYNAME6) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for Sunday: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVDAYNAME7) + hb_osnewline()
    :Datos:value += pad("Long name for January: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SMONTHNAME1) + hb_osnewline()
    :Datos:value += pad("Long name for February: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SMONTHNAME2) + hb_osnewline()
    :Datos:value += pad("Long name for March: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SMONTHNAME3) + hb_osnewline()
    :Datos:value += pad("Long name for April: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SMONTHNAME4) + hb_osnewline()
    :Datos:value += pad("Long name for May: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SMONTHNAME5) + hb_osnewline()
    :Datos:value += pad("Long name for June: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SMONTHNAME6) + hb_osnewline()
    :Datos:value += pad("Long name for July: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SMONTHNAME7) + hb_osnewline()
    :Datos:value += pad("Long name for August: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SMONTHNAME8) + hb_osnewline()
    :Datos:value += pad("Long name for September: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SMONTHNAME9) + hb_osnewline()
    :Datos:value += pad("Long name for October: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SMONTHNAME10) + hb_osnewline()
    :Datos:value += pad("Long name for November: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SMONTHNAME11) + hb_osnewline()
    :Datos:value += pad("Long name for December: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SMONTHNAME12) + hb_osnewline()
    :Datos:value += pad("Long name for 13th month (if exists): ", 50) + GetUserLocaleInfo(LCID, LOCALE_SMONTHNAME13) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for January: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVMONTHNAME1) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for February: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVMONTHNAME2) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for March: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVMONTHNAME3) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for April: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVMONTHNAME4) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for May: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVMONTHNAME5) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for June: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVMONTHNAME6) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for July: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVMONTHNAME7) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for August: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVMONTHNAME8) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for September: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVMONTHNAME9) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for October: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVMONTHNAME10) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for November: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVMONTHNAME11) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for December: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVMONTHNAME12) + hb_osnewline()
    :Datos:value += pad("Abbreviated name for 13th month (if exists): ", 50) + GetUserLocaleInfo(LCID, LOCALE_SABBREVMONTHNAME13) + hb_osnewline()

    :Datos:value += pad("Positive sign: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SPOSITIVESIGN) + hb_osnewline()
    :Datos:value += pad("Negative sign: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SNEGATIVESIGN) + hb_osnewline()
    
    r := GetUserLocaleInfo(LCID, LOCALE_IPOSSIGNPOSN)
    do case
    case r == "0"
      :Datos:value += pad("Positive sign position: ", 50) + "0 - Parentheses surround the amount and the monetary symbol"
    case r == "1"
      :Datos:value += pad("Positive sign position: ", 50) + "1 - The sign string precedes the amount and the monetary symbol"
    case r == "2"
      :Datos:value += pad("Positive sign position: ", 50) + "2 - The sign string precedes the amount and the monetary symbol"
    case r == "3"
      :Datos:value += pad("Positive sign position: ", 50) + "3 - The sign string precedes the amount and the monetary symbol"
    case r == "4"
      :Datos:value += pad("Positive sign position: ", 50) + "4 - The sign string precedes the amount and the monetary symbol"
    Endcase
    :Datos:value += hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_INEGSIGNPOSN)
    do case
    case r == "0"
      :Datos:value += pad("Negative sign position: ", 50) + "0 - Parentheses surround the amount and the monetary symbol"
    case r == "1"
      :Datos:value += pad("Negative sign position: ", 50) + "1 - The sign string precedes the amount and the monetary symbol"
    case r == "2"
      :Datos:value += pad("Negative sign position: ", 50) + "2 - The sign string precedes the amount and the monetary symbol"
    case r == "3"
      :Datos:value += pad("Negative sign position: ", 50) + "3 - The sign string precedes the amount and the monetary symbol"
    case r == "4"
      :Datos:value += pad("Negative sign position: ", 50) + "4 - The sign string precedes the amount and the monetary symbol"
    Endcase
    :Datos:value += hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_IPOSSYMPRECEDES)
    do case
    case r == "0"
      :Datos:value += pad("Monetary symbol position: ", 50) + "0 - precedes a positive amount"
    case r == "1"
      :Datos:value += pad("Monetary symbol position: ", 50) + "1 - succeeds a positive amount"
    Endcase
    :Datos:value += hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_IPOSSEPBYSPACE)
    do case
    case r == "0"
      :Datos:value += pad("Monetary symbol separation: ", 50) + "0 - None (positive amount)"
    case r == "1"
      :Datos:value += pad("Monetary symbol separation: ", 50) + "1 - With a space (positive amount)"
    Endcase
    :Datos:value += hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_INEGSYMPRECEDES)
    do case
    case r == "0"
      :Datos:value += pad("Monetary symbol position: ", 50) + "0 - precedes a negative amount"
    case r == "1"
      :Datos:value += pad("Monetary symbol position: ", 50) + "1 - succeeds a negative amount"
    Endcase
    :Datos:value += hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_INEGSEPBYSPACE)
    do case
    case r == "0"
      :Datos:value += pad("Monetary symbol separation: ", 50) + "0 - None (negative amount)"
    case r == "1"
      :Datos:value += pad("Monetary symbol separation: ", 50) + "1 - With a space (negative amount)"
    Endcase
    :Datos:value += hb_osnewline()

    :Datos:value += pad("Font signature: ", 50) + "THIS IS NOT SIMPLE - SEARCH THE INTERNET" + hb_osnewline()
*    :Datos:value += pad("Font signature: ", 50) + GetUserLocaleInfo(LCID, LOCALE_FONTSIGNATURE) + hb_osnewline()

    :Datos:value += pad("ISO abbreviated language name: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SISO639LANGNAME) + hb_osnewline()
    :Datos:value += pad("ISO abbreviated country name: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SISO3166CTRYNAME) + hb_osnewline()

    :Datos:value += pad("Default ebcdic code page: ", 50) + GetUserLocaleInfo(LCID, LOCALE_IDEFAULTEBCDICCODEPAGE) + hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_IPAPERSIZE)
    do case
    case r == "1"
      :Datos:value += pad("Default paper size: ", 50) + "1 - letter"
    case r == "5"
      :Datos:value += pad("Default paper size: ", 50) + "5 - legal"
    case r == "8"
      :Datos:value += pad("Default paper size: ", 50) + "8 = a3"
    case r == "9"
      :Datos:value += pad("Default paper size: ", 50) + "9 = a4"
    otherwise
      :Datos:value += pad("Default paper size: ", 50) + r
    Endcase
    :Datos:value += hb_osnewline()

    :Datos:value += pad("English name of currency: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SENGCURRNAME) + hb_osnewline()
    :Datos:value += pad("Native name of currency: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SNATIVECURRNAME) + hb_osnewline()

    :Datos:value += pad("Year month format string: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SYEARMONTH) + hb_osnewline()
    :Datos:value += pad("Sort name: ", 50) + GetUserLocaleInfo(LCID, LOCALE_SSORTNAME) + hb_osnewline()

    r := GetUserLocaleInfo(LCID, LOCALE_IDIGITSUBSTITUTION)
    do case
    case r == "0"
      :Datos:value += pad("Shape of digits: ", 50) + "0 - Context substitution"
    case r == "1"
      :Datos:value += pad("Shape of digits: ", 50) + "1 - No substitution"
    case r == "2"
      :Datos:value += pad("Shape of digits: ", 50) + "2 - Native substitution"
    Endcase
    :Datos:value += hb_osnewline()
  end with
  
return

Function GetUserLocaleInfo (dwLocaleID, dwLCType)

  local r, sReturn, ret := ""

//call the function passing the Locale type
//variable to retrieve the required size of
//the string buffer needed
  r := GetLocaleInfo(dwLocaleID, dwLCType, "", 0)

//if successful
  If r # 0

//pad the buffer with spaces
    sReturn := Space(r)

//and call again passing the buffer
    r := GetLocaleInfo(dwLocaleID, dwLCType, @sReturn, r)

//if successful
    If r # 0

//r holds the size of the string including the terminating null
      ret := Left(sReturn, r - 1)
    End If
   End If

return (ret)

#pragma BEGINDUMP

#include "windows.h"
#include "commctrl.h"
#include "hbapi.h"
#include "oohg.h"

HB_FUNC( GETLOCALEINFO )
{
   hb_retnl( GetLocaleInfo( hb_parnl(1), hb_parnl(2), hb_parc(3), hb_parnl(4) ));
}
HB_FUNC( GETTHREADLOCALE )
{
   hb_retnl( GetThreadLocale( ) );
}
HB_FUNC( GETSYSTEMDEFAULTLCID )
{
   hb_retnl( GetSystemDefaultLCID( ) );
}
HB_FUNC( GETUSERDEFAULTLCID )
{
   hb_retnl( GetUserDefaultLCID( ) );
}

#pragma ENDDUMP

// EOF
