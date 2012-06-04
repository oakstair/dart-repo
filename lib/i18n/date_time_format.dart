/**
 * Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 *
 * DateTimeFormat is for formatting and parsing dates in a locale-sensitive 
 * manner. 
 * It allows the user to choose from a set of standard date time formats as well
 * as specify a customized pattern under certain locales. Date elements that
 * vary across locales include month name, weekname, field, order, etc.
 * //TODO(efortuna): Customized pattern system -- suggested by i18n needs
 * // feedback on appropriateness.
 * We also allow the user to use any customized pattern to parse or format 
 * date-time strings under certain locales. Date elements that vary across 
 * locales include month name, weekname, field, order, etc.
 *
 * This library uses the ICU/JDK date/time pattern specification as described
 * below.
 *
 * Time Format Syntax: To specify the time format use a time pattern string.
 * In this pattern, following letters are reserved as pattern letters, which
 * are defined in the following manner:
 *
 *     Symbol   Meaning                Presentation        Example
 *     ------   -------                ------------        -------
 *     G        era designator         (Text)              AD
 *     y#       year                   (Number)            1996
 *     M        month in year          (Text & Number)     July & 07
 *     d        day in month           (Number)            10
 *     h        hour in am/pm (1~12)   (Number)            12
 *     H        hour in day (0~23)     (Number)            0
 *     m        minute in hour         (Number)            30
 *     s        second in minute       (Number)            55
 *     S        fractional second      (Number)            978
 *     E        day of week            (Text)              Tuesday
 *     D        day in year            (Number)            189
 *     a        am/pm marker           (Text)              PM
 *     k        hour in day (1~24)     (Number)            24
 *     K        hour in am/pm (0~11)   (Number)            0
 *     z        time zone              (Text)              Pacific Standard Time
 *     Z        time zone (RFC 822)    (Number)            -0800
 *     v        time zone (generic)    (Text)              Pacific Time
 *     '        escape for text        (Delimiter)         'Date='
 *     ''       single quote           (Literal)           'o''clock'
 *
 * Items marked with '#' work differently than in Java.
 *
 * The count of pattern letters determine the format.
 * (Text): 4 or more pattern letters--use full form,
 *         less than 4--use short or abbreviated form if one exists.
 *         In parsing, we will always try long format, then short.
 *         (e.g., "EEEE" produces "Monday", "EEE" produces "Mon")
 *
 * (Number): the minimum number of digits. Shorter numbers are zero-padded to
 * this amount (e.g. if "m" produces "6", "mm" produces "06"). Year is handled
 * specially; that is, if the count of 'y' is 2, the Year will be truncated to
 * 2 digits. (e.g., if "yyyy" produces "1997", "yy" produces "97".) Unlike other
 * fields, fractional seconds are padded on the right with zero.
 *
 * (Text & Number): 3 or over, use text, otherwise use number.
 *
 * Any characters that not in the pattern will be treated as quoted text. For
 * instance, characters like ':', '.', ' ', '#' and '@' will appear in the
 * resulting time text even they are not embraced within single quotes. In our
 * current pattern usage, we didn't use up all letters. But those unused
 * letters are strongly discouraged to be used as quoted text without quote.
 * That's because we may use other letter for pattern in future.
 *
 * Examples Using the US Locale:
 *
 *     Format Pattern                         Result
 *     --------------                         -------
 *     "yyyy.MM.dd G 'at' HH:mm:ss vvvv"->1996.07.10 AD at 15:08:56 Pacific Time
 *     "EEE, MMM d, ''yy"               ->Wed, July 10, '96
 *     "h:mm a"                         ->12:08 PM
 *     "hh 'o''clock' a, zzzz"          ->12 o'clock PM, Pacific Daylight Time
 *     "K:mm a, vvv"                    ->0:00 PM, PT
 *     "yyyyy.MMMMM.dd GGG hh:mm aaa"   ->01996.July.10 AD 12:08 PM
 *
 * When parsing a date string using the abbreviated year pattern ("yy"),
 * DateTimeParse must interpret the abbreviated year relative to some
 * century. It does this by adjusting dates to be within 80 years before and 20
 * years after the time the parse function is called. For example, using a
 * pattern of "MM/dd/yy" and a DateTimeParse instance created on Jan 1, 1997,
 * the string "01/11/12" would be interpreted as Jan 11, 2012 while the string
 * "05/04/64" would be interpreted as May 4, 1964. During parsing, only
 * strings consisting of exactly two digits, as defined by {@link
 * java.lang.Character#isDigit(char)}, will be parsed into the default
 * century. Any other numeric string, such as a one digit string, a three or
 * more digit string will be interpreted as its face value.
 *
 * If the year pattern does not have exactly two 'y' characters, the year is
 * interpreted literally, regardless of the number of digits. So using the
 * pattern "MM/dd/yyyy", "01/11/12" parses to Jan 11, 12 A.D.
 *
 * When numeric fields abut one another directly, with no intervening
 * delimiter characters, they constitute a run of abutting numeric fields. Such
 * runs are parsed specially. For example, the format "HHmmss" parses the input
 * text "123456" to 12:34:56, parses the input text "12345" to 1:23:45, and
 * fails to parse "1234". In other words, the leftmost field of the run is
 * flexible, while the others keep a fixed width. If the parse fails anywhere in
 * the run, then the leftmost field is shortened by one character, and the
 * entire run is parsed again. This is repeated until either the parse succeeds
 * or the leftmost field is one character in length. If the parse still fails at
 * that point, the parse of the run fails.
 */

#library('DateTimeFormat');

class DateTimeFormat {

  /** Definition of this object formats dates. */
  var formatDefinition;

  /**
   * String indicating a language code with which the message is to be
   * formatted (such as en-US).
   */
  String _locale;

  /** 
   * Date/Time format "skeleton" patterns. Also specifiable by String, but
   * written this way so that they can be discoverable via autocomplete.
   */
  static final String Hm = 'Hm';          // HH:mm
  static final String Hms = 'Hms';        // HH:mm:ss 
  static final String M = 'M';            // L
  static final String MEd = 'MEd';        // E, M/d
  static final String MMM = 'MMM';        // LLL
  static final String MMMEd = 'MMMEd';    // E, MMM d
  static final String MMMMEd = 'MMMMEd';  // E, MMMM d
  static final String MMMMd = 'MMMMd';    // MMMM d
  static final String MMMd = 'MMMd';      // MMM d
  static final String Md = 'Md';          // M/d
  static final String d = 'd';            // d
  static final String hm = 'hm';          // h:mm a
  static final String ms = 'ms';          // mm:ss
  static final String y = 'y';            // yyyy
  static final String yM = 'yM';          // M/yyyy
  static final String yMEd = 'yMEd';      // EEE, M/d/yyyy
  static final String yMMM = 'yMMM';      // MMM yyyy
  static final String yMMMEd = 'yMMMEd';  // EEE, MM d, yyyy
  static final String yMMMM = 'yMMMM';    // MMMM yyyy
  static final String yQ = 'yQ';          // Q yyyy
  static final String yQQQ = 'yQQQ';      // QQQ yyyy

  /** Date/Time format patterns. */
  // TODO(alanknight): There's a style question of whether to use fullDate or 
  // FULL_DATE naming conventions.
  static final int _fullDate = 0;
  static final int _longDate = 1;
  static final int _mediumDate = 2;
  static final int _shortDate = 3;
  static final int _fullTime = 4;
  static final int _longTime = 5;
  static final int _mediumTime = 6;
  static final int _shortTime = 7;
  static final int _fullDateTime = 8;
  static final int _longDateTime = 9;
  static final int _mediumDateTime = 10;
  static final int _shortDateTime = 11;
    
  /**
   * Named constructors for each of the above values.
   * These could probably be made shorter if we just set the format to the 
   * constant and the parsing was lazy.
   */
  DateTimeFormat.fullDate() : this.formatDefinition = _fullDate;
  DateTimeFormat.longDate() : this.formatDefinition = _longDate;
  DateTimeFormat.mediumDate() : this.formatDefinition = _mediumDate;
  DateTimeFormat.shortDate() : this.formatDefinition = _shortDate;
  DateTimeFormat.fullTime() : this.formatDefinition = _fullTime;
  DateTimeFormat.longTime() : this.formatDefinition = _longTime;
  DateTimeFormat.mediumTime() : this.formatDefinition = _mediumTime;
  DateTimeFormat.shortTime() : this.formatDefinition = _shortTime;
  DateTimeFormat.fullDateTime() : this.formatDefinition = _fullDateTime;
  DateTimeFormat.longDateTime() : this.formatDefinition = _longDateTime;
  DateTimeFormat.mediumDateTime() : this.formatDefinition = _mediumDateTime;
  DateTimeFormat.shortDateTime() : this.formatDefinition = _shortDateTime;
  
  /**
   * Constructor accepts a [formatDefinition], which can be a String, one of the
   * predefined static forms, or a custom date format using the syntax described
   * above. An optional [_locale] can be provided for specifics of the language
   * locale to be used, otherwise, we will attempt to infer it (acceptable if
   * Dart is running on the client, we can infer from the browser).
   */
  DateTimeFormat(this.formatDefinition, [this._locale]);

  /**
   * Given user input, attempt to parse the [inputString] into the anticipated
   * format.
   */
  String parse(String inputString) {
    return inputString;
  }

 /**
  * Format the given [date] object according to preset pattern and current 
  * locale and return a formated string for the given date.
  */
  String format(Date date, [TimeZone timeZone]) {
    // TODO(efortuna): optional TimeZone argument? TimeZone is deprecated...
    return date.toString();
  }
}
