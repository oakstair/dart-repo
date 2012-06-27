// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.


#library('bidi_format_test');

#import('../../../lib/i18n/bidi_formatter.dart');
#import('../../../lib/i18n/bidi_utils.dart');
#import('../../../lib/unittest/unittest.dart');

/**
 * Tests the bidirectional text formatting library.
 */
main() {
  var LRM = BidiUtils.LRM;
  var RLM = BidiUtils.RLM;
  var LRE = BidiUtils.LRE;
  var RLE = BidiUtils.RLE;
  var PDF = BidiUtils.PDF;
  var LTR = TextDirection.LTR;
  var RTL = TextDirection.RTL;
  var UNKNOWN = TextDirection.UNKNOWN;
  var he = '\u05e0\u05e1';
  var en = 'abba';
  var html = '&lt;';
  var longEn = 'abba sabba gabba ';
  var longHe = '\u05e0 \u05e1 \u05e0 ';
  var ltrFmt = new BidiFormatter.LTR();  // LTR context
  var rtlFmt = new BidiFormatter.RTL();  // RTL context
  var unkFmt = new BidiFormatter.UNKNOWN();  // unknown context

  test('estimateDirection', () {
    expect(ltrFmt.estimateDirection(''), equals(UNKNOWN));
    expect(rtlFmt.estimateDirection(''), equals(UNKNOWN));
    expect(unkFmt.estimateDirection(''), equals(UNKNOWN));
    expect(ltrFmt.estimateDirection(en), equals(LTR));
    expect(rtlFmt.estimateDirection(en), equals(LTR));
    expect(unkFmt.estimateDirection(en), equals(LTR));
    expect(ltrFmt.estimateDirection(he), equals(RTL));
    expect(rtlFmt.estimateDirection(he), equals(RTL));
    expect(unkFmt.estimateDirection(he), equals(RTL));

    // Text contains HTML or HTML-escaping.
    expect(ltrFmt.estimateDirection(
        '<some sort of tag/>$he &amp;', false), equals(LTR));
    expect(ltrFmt.estimateDirection(
        '<some sort of tag/>$he &amp;', true), equals(RTL));
  });

  test('wrapWithSpan', () {
    // Test overall dir matches context dir (LTR), no dirReset.
    expect(ltrFmt.wrapWithSpan(en, true, false), equals(en));
    // Test overall dir matches context dir (LTR), dirReset.
    expect(ltrFmt.wrapWithSpan(en, true, true), equals(en));
    // Test overall dir matches context dir (RTL), no dirReset'.
    expect(rtlFmt.wrapWithSpan(he, true, false), equals(he));
    // Test overall dir matches context dir (RTL), dirReset.
    expect(rtlFmt.wrapWithSpan(he, true, true), equals(he));
    // Test overall dir (RTL) doesn't match context dir (LTR), no dirReset.
    expect(ltrFmt.wrapWithSpan(he, true, false),
        equals('<span dir=rtl>$he</span>'));
    // Test overall dir (RTL) doesn't match context dir (LTR), dirReset.
    expect(ltrFmt.wrapWithSpan(he, true, true),
        equals('<span dir=rtl>$he</span>$LRM'));
    // Test overall dir (LTR) doesn't match context dir (RTL), no dirReset.
    expect(rtlFmt.wrapWithSpan(en, true, false),
        equals('<span dir=ltr>$en</span>'));
    // Test overall dir (LTR) doesn't match context dir (RTL), dirReset.
    expect(rtlFmt.wrapWithSpan(en, true, true),
        equals('<span dir=ltr>$en</span>$RLM'));
    // Test overall dir (LTR) doesn't match context dir (unknown), no dirReset.
    expect(unkFmt.wrapWithSpan(en, true, false),
        equals('<span dir=ltr>$en</span>'));
    // Test overall dir (RTL) doesn't match context dir (unknown), dirReset.
    expect(unkFmt.wrapWithSpan(he, true, true),
        equals('<span dir=rtl>$he</span>'));
    // Test overall dir (neutral) doesn't match context dir (LTR), dirReset.
    expect(ltrFmt.wrapWithSpan('', true, true), equals(''));
    
    // Test exit dir (but not overall dir) is opposite to context dir, dirReset.
    expect(ltrFmt.wrapWithSpan('$longEn$he$html', true, true),
        equals('$longEn$he$html$LRM'));
    // Test overall dir (but not exit dir) is opposite to context dir, dirReset.
    expect(rtlFmt.wrapWithSpan('$longEn$he', true, true),
        equals('<span dir=ltr>$longEn$he</span>$RLM'));

    // Test input is plain text (not escaped).
    expect(ltrFmt.wrapWithSpan('<br>$en', false, false),
        equals('&lt;br&gt;$en'));

    var ltrAlwaysSpanFmt = new BidiFormatter.LTR(true);
    var rtlAlwaysSpanFmt = new BidiFormatter.RTL(true);
    var unkAlwaysSpanFmt = new BidiFormatter.UNKNOWN(true);

    // Test alwaysSpan, overall dir matches context dir (LTR), no dirReset.
    expect(ltrAlwaysSpanFmt.wrapWithSpan(en, true, false),
        equals('<span>$en</span>'));
    // Test alwaysSpan, overall dir matches context dir (LTR), dirReset.
    expect(ltrAlwaysSpanFmt.wrapWithSpan(en, true, true),
        equals('<span>$en</span>'));
    // Test alwaysSpan, overall dir matches context dir (RTL), no dirReset.
    expect(rtlAlwaysSpanFmt.wrapWithSpan(he, true, false),
        equals('<span>$he</span>'));
    // Test alwaysSpan, overall dir matches context dir (RTL), dirReset.
    expect(rtlAlwaysSpanFmt.wrapWithSpan(he, true, true),
        equals('<span>$he</span>'));

    // Test alwaysSpan, overall dir (RTL) doesn't match context dir (LTR),
    // no dirReset.
    expect(ltrAlwaysSpanFmt.wrapWithSpan(he, true, false),
        equals('<span dir=rtl>$he</span>'));
    // Test alwaysSpan, overall dir (RTL) doesn't match context dir (LTR),
    // dirReset.
    expect(ltrAlwaysSpanFmt.wrapWithSpan(he, true, true),
        equals('<span dir=rtl>$he</span>$LRM'));
    // Test alwaysSpan, overall dir (neutral) doesn't match context dir (LTR),
    // dirReset
    expect(ltrAlwaysSpanFmt.wrapWithSpan('', true, true),
        equals('<span></span>'));

    // Test overall dir matches context dir (LTR.
    expect(ltrFmt.wrapWithSpan(en, direction : TextDirection.LTR), equals(en));
    // Test overall dir (but not exit dir) supposedly matches context dir (LTR).
    expect(ltrFmt.wrapWithSpan(he, direction : TextDirection.LTR),
        equals('$he$LRM'));
    // Test overall dir matches context dir (RTL.
    expect(rtlFmt.wrapWithSpan(he, direction : TextDirection.RTL), equals(he));
    // Test overall dir (but not exit dir) supposedly matches context dir (RTL).
    expect(rtlFmt.wrapWithSpan(en, direction : TextDirection.RTL),
      equals('$en$RLM'));

    // Test overall dir (RTL) doesn't match context dir (LTR).
    expect(ltrFmt.wrapWithSpan(he, direction : TextDirection.RTL),
        equals('<span dir=rtl>$he</span>$LRM'));
    // Test supposed overall dir (RTL) doesn't match context dir (LTR).
    expect(ltrFmt.wrapWithSpan(en, direction : TextDirection.RTL),
        equals('<span dir=rtl>$en</span>$LRM'));
    // Test overall dir (LTR) doesn't match context dir (RTL).
    expect(rtlFmt.wrapWithSpan(en, direction : TextDirection.LTR),
        equals('<span dir=ltr>$en</span>$RLM'));
    // Test supposed overall dir (LTR) doesn't match context dir (RTL).
    expect(rtlFmt.wrapWithSpan(he, direction : TextDirection.LTR),
        equals('<span dir=ltr>$he</span>$RLM'));
    // Test supposed overall dir (LTR) doesn't match context dir (unknown).
    expect(unkFmt.wrapWithSpan(he, direction : TextDirection.LTR),
        equals('<span dir=ltr>$he</span>'));
    // Test supposed overall dir (neutral) doesn't match context dir (LTR).
    expect(ltrFmt.wrapWithSpan(he, direction : TextDirection.UNKNOWN),
        equals('$he$LRM'));
  });

  test('wrapWithUnicode', () {
    // Test overall dir matches context dir (LTR), no dirReset.
    expect(ltrFmt.wrapWithUnicode(en, true, false), equals(en));
    // Test overall dir matches context dir (LTR), dirReset.
    expect(ltrFmt.wrapWithUnicode(en, true, true), equals(en));
    // Test overall dir matches context dir (RTL), no dirReset.
    expect(rtlFmt.wrapWithUnicode(he, true, false), equals(he));
    // Test overall dir matches context dir (RTL), dirReset.
    expect(rtlFmt.wrapWithUnicode(he, true, true), equals(he));

    // Test overall dir (RTL) doesn't match context dir (LTR), no dirReset.
    expect(ltrFmt.wrapWithUnicode(he, true, false), equals('$RLE$he$PDF'));
    // Test overall dir (RTL) doesn't match context dir (LTR), dirReset.
    expect(ltrFmt.wrapWithUnicode(he, true, true), equals('$RLE$he$PDF$LRM'));
    // Test overall dir (LTR) doesn't match context dir (RTL), no dirReset.
    expect(rtlFmt.wrapWithUnicode(en, true, false), equals('$LRE$en$PDF'));
    // Test overall dir (LTR) doesn't match context dir (RTL), dirReset.
    expect(rtlFmt.wrapWithUnicode(en, true, true), equals('$LRE$en$PDF$RLM'));
    // Test overall dir (LTR) doesn't match context dir (unknown), no dirReset.
    expect(unkFmt.wrapWithUnicode(en, true, false), equals('$LRE$en$PDF'));
    // Test overall dir (RTL) doesn't match context dir (unknown), dirReset.
    expect(unkFmt.wrapWithUnicode(he, true, true), equals('$RLE$he$PDF'));
    // Test overall dir (neutral) doesn't match context dir (LTR), dirReset.
    expect(ltrFmt.wrapWithUnicode('', true, true), equals(''));

    // Test exit dir (but not overall dir) is opposite to context dir, dirReset.
    expect(ltrFmt.wrapWithUnicode('$longEn$he$html', true, true),
        equals('$longEn$he$html$LRM'));
    // Test overall dir (but not exit dir) is opposite to context dir, dirReset.
    expect(rtlFmt.wrapWithUnicode('$longEn$he', true, true),
        equals('$LRE$longEn$he$PDF$RLM'));

    // Test overall dir matches context dir (LTR).
    expect(ltrFmt.wrapWithUnicode(en,
        direction : TextDirection.LTR), equals(en));
    // Test overall dir (but not exit dir) supposedly matches context dir (LTR).
    expect(ltrFmt.wrapWithUnicode(he, direction : TextDirection.LTR),
        equals('$he$LRM'));
    // Test overall dir matches context dir (RTL).
    expect(rtlFmt.wrapWithUnicode(he,
        direction : TextDirection.RTL), equals(he));
    // Test overall dir (but not exit dir) supposedly matches context dir (RTL).
    expect(rtlFmt.wrapWithUnicode(en, direction : TextDirection.RTL),
        equals('$en$RLM'));

    // Test overall dir (RTL) doesn't match context dir (LTR).
    expect(ltrFmt.wrapWithUnicode(he, direction : TextDirection.RTL),
        equals('$RLE$he$PDF$LRM'));
    // Test supposed overall dir (RTL) doesn't match context dir (LTR).
    expect(ltrFmt.wrapWithUnicode(en, direction : TextDirection.RTL),
        equals('$RLE$en$PDF$LRM'));
    // Test overall dir (LTR) doesn't match context dir (RTL).
    expect(rtlFmt.wrapWithUnicode(en, direction : TextDirection.LTR),
        equals('$LRE$en$PDF$RLM'));
    // Test supposed overall dir (LTR) doesn't match context dir (RTL).
    expect(rtlFmt.wrapWithUnicode(he, direction : TextDirection.LTR),
        equals('$LRE$he$PDF$RLM'));
    // Test supposed overall dir (LTR) doesn't match context dir (unknown).
    expect(unkFmt.wrapWithUnicode(he, direction : TextDirection.LTR),
        equals('$LRE$he$PDF'));
    // Test supposed overall dir (neutral) doesn't match context dir (LTR).
    expect(ltrFmt.wrapWithUnicode(he, direction : TextDirection.UNKNOWN),
        equals('$he$LRM'));
  });
}