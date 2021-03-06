// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// Generated by scripts/token_kind_gen.py.

class TokenKind {
  /** [TokenKind] representing end of file tokens. */
  static final int END_OF_FILE = 1;

  /** [TokenKind] representing ( tokens. */
  static final int LPAREN = 2;

  /** [TokenKind] representing ) tokens. */
  static final int RPAREN = 3;

  /** [TokenKind] representing [ tokens. */
  static final int LBRACK = 4;

  /** [TokenKind] representing ] tokens. */
  static final int RBRACK = 5;

  /** [TokenKind] representing { tokens. */
  static final int LBRACE = 6;

  /** [TokenKind] representing } tokens. */
  static final int RBRACE = 7;

  /** [TokenKind] representing : tokens. */
  static final int COLON = 8;

  /** [TokenKind] representing => tokens. */
  static final int ARROW = 9;

  /** [TokenKind] representing ; tokens. */
  static final int SEMICOLON = 10;

  /** [TokenKind] representing , tokens. */
  static final int COMMA = 11;

  /** [TokenKind] representing # tokens. */
  static final int HASH = 12;

  /** [TokenKind] representing #! tokens. */
  static final int HASHBANG = 13;

  /** [TokenKind] representing . tokens. */
  static final int DOT = 14;

  /** [TokenKind] representing ... tokens. */
  static final int ELLIPSIS = 15;

  /** [TokenKind] representing ++ tokens. */
  static final int INCR = 16;

  /** [TokenKind] representing -- tokens. */
  static final int DECR = 17;

  /** [TokenKind] representing ~ tokens. */
  static final int BIT_NOT = 18;

  /** [TokenKind] representing ! tokens. */
  static final int NOT = 19;

  /** [TokenKind] representing = tokens. */
  static final int ASSIGN = 20;

  /** [TokenKind] representing |= tokens. */
  static final int ASSIGN_OR = 21;

  /** [TokenKind] representing ^= tokens. */
  static final int ASSIGN_XOR = 22;

  /** [TokenKind] representing &= tokens. */
  static final int ASSIGN_AND = 23;

  /** [TokenKind] representing <<= tokens. */
  static final int ASSIGN_SHL = 24;

  /** [TokenKind] representing >>= tokens. */
  static final int ASSIGN_SAR = 25;

  /** [TokenKind] representing >>>= tokens. */
  static final int ASSIGN_SHR = 26;

  /** [TokenKind] representing += tokens. */
  static final int ASSIGN_ADD = 27;

  /** [TokenKind] representing -= tokens. */
  static final int ASSIGN_SUB = 28;

  /** [TokenKind] representing *= tokens. */
  static final int ASSIGN_MUL = 29;

  /** [TokenKind] representing /= tokens. */
  static final int ASSIGN_DIV = 30;

  /** [TokenKind] representing ~/= tokens. */
  static final int ASSIGN_TRUNCDIV = 31;

  /** [TokenKind] representing %= tokens. */
  static final int ASSIGN_MOD = 32;

  /** [TokenKind] representing ? tokens. */
  static final int CONDITIONAL = 33;

  /** [TokenKind] representing || tokens. */
  static final int OR = 34;

  /** [TokenKind] representing && tokens. */
  static final int AND = 35;

  /** [TokenKind] representing | tokens. */
  static final int BIT_OR = 36;

  /** [TokenKind] representing ^ tokens. */
  static final int BIT_XOR = 37;

  /** [TokenKind] representing & tokens. */
  static final int BIT_AND = 38;

  /** [TokenKind] representing << tokens. */
  static final int SHL = 39;

  /** [TokenKind] representing >> tokens. */
  static final int SAR = 40;

  /** [TokenKind] representing >>> tokens. */
  static final int SHR = 41;

  /** [TokenKind] representing + tokens. */
  static final int ADD = 42;

  /** [TokenKind] representing - tokens. */
  static final int SUB = 43;

  /** [TokenKind] representing * tokens. */
  static final int MUL = 44;

  /** [TokenKind] representing / tokens. */
  static final int DIV = 45;

  /** [TokenKind] representing ~/ tokens. */
  static final int TRUNCDIV = 46;

  /** [TokenKind] representing % tokens. */
  static final int MOD = 47;

  /** [TokenKind] representing == tokens. */
  static final int EQ = 48;

  /** [TokenKind] representing != tokens. */
  static final int NE = 49;

  /** [TokenKind] representing === tokens. */
  static final int EQ_STRICT = 50;

  /** [TokenKind] representing !== tokens. */
  static final int NE_STRICT = 51;

  /** [TokenKind] representing < tokens. */
  static final int LT = 52;

  /** [TokenKind] representing > tokens. */
  static final int GT = 53;

  /** [TokenKind] representing <= tokens. */
  static final int LTE = 54;

  /** [TokenKind] representing >= tokens. */
  static final int GTE = 55;

  /** [TokenKind] representing [] tokens. */
  static final int INDEX = 56;

  /** [TokenKind] representing []= tokens. */
  static final int SETINDEX = 57;

  /** [TokenKind] representing string tokens. */
  static final int STRING = 58;

  /** [TokenKind] representing string part tokens. */
  static final int STRING_PART = 59;

  /** [TokenKind] representing integer tokens. */
  static final int INTEGER = 60;

  /** [TokenKind] representing hex integer tokens. */
  static final int HEX_INTEGER = 61;

  /** [TokenKind] representing double tokens. */
  static final int DOUBLE = 62;

  /** [TokenKind] representing whitespace tokens. */
  static final int WHITESPACE = 63;

  /** [TokenKind] representing comment tokens. */
  static final int COMMENT = 64;

  /** [TokenKind] representing error tokens. */
  static final int ERROR = 65;

  /** [TokenKind] representing incomplete string tokens. */
  static final int INCOMPLETE_STRING = 66;

  /** [TokenKind] representing incomplete comment tokens. */
  static final int INCOMPLETE_COMMENT = 67;

  /** [TokenKind] representing incomplete multiline string dq tokens. */
  static final int INCOMPLETE_MULTILINE_STRING_DQ = 68;

  /** [TokenKind] representing incomplete multiline string sq tokens. */
  static final int INCOMPLETE_MULTILINE_STRING_SQ = 69;

  /** [TokenKind] representing identifier tokens. */
  static final int IDENTIFIER = 70;

  /** [TokenKind] representing pseudo-keyword 'abstract' tokens. */
  static final int ABSTRACT = 71;

  /** [TokenKind] representing pseudo-keyword 'assert' tokens. */
  static final int ASSERT = 72;

  /** [TokenKind] representing pseudo-keyword 'call' tokens. */
  static final int CALL = 73;

  /** [TokenKind] representing pseudo-keyword 'factory' tokens. */
  static final int FACTORY = 74;

  /** [TokenKind] representing pseudo-keyword 'get' tokens. */
  static final int GET = 75;

  /** [TokenKind] representing pseudo-keyword 'implements' tokens. */
  static final int IMPLEMENTS = 76;

  /** [TokenKind] representing pseudo-keyword 'import' tokens. */
  static final int IMPORT = 77;

  /** [TokenKind] representing pseudo-keyword 'interface' tokens. */
  static final int INTERFACE = 78;

  /** [TokenKind] representing pseudo-keyword 'library' tokens. */
  static final int LIBRARY = 79;

  /** [TokenKind] representing pseudo-keyword 'native' tokens. */
  static final int NATIVE = 80;

  /** [TokenKind] representing pseudo-keyword 'negate' tokens. */
  static final int NEGATE = 81;

  /** [TokenKind] representing pseudo-keyword 'operator' tokens. */
  static final int OPERATOR = 82;

  /** [TokenKind] representing pseudo-keyword 'set' tokens. */
  static final int SET = 83;

  /** [TokenKind] representing pseudo-keyword 'source' tokens. */
  static final int SOURCE = 84;

  /** [TokenKind] representing pseudo-keyword 'static' tokens. */
  static final int STATIC = 85;

  /** [TokenKind] representing pseudo-keyword 'typedef' tokens. */
  static final int TYPEDEF = 86;

  /** [TokenKind] representing keyword 'await' tokens. */
  static final int AWAIT = 87;

  /** [TokenKind] representing keyword 'break' tokens. */
  static final int BREAK = 88;

  /** [TokenKind] representing keyword 'case' tokens. */
  static final int CASE = 89;

  /** [TokenKind] representing keyword 'catch' tokens. */
  static final int CATCH = 90;

  /** [TokenKind] representing keyword 'class' tokens. */
  static final int CLASS = 91;

  /** [TokenKind] representing keyword 'const' tokens. */
  static final int CONST = 92;

  /** [TokenKind] representing keyword 'continue' tokens. */
  static final int CONTINUE = 93;

  /** [TokenKind] representing keyword 'default' tokens. */
  static final int DEFAULT = 94;

  /** [TokenKind] representing keyword 'do' tokens. */
  static final int DO = 95;

  /** [TokenKind] representing keyword 'else' tokens. */
  static final int ELSE = 96;

  /** [TokenKind] representing keyword 'extends' tokens. */
  static final int EXTENDS = 97;

  /** [TokenKind] representing keyword 'false' tokens. */
  static final int FALSE = 98;

  /** [TokenKind] representing keyword 'final' tokens. */
  static final int FINAL = 99;

  /** [TokenKind] representing keyword 'finally' tokens. */
  static final int FINALLY = 100;

  /** [TokenKind] representing keyword 'for' tokens. */
  static final int FOR = 101;

  /** [TokenKind] representing keyword 'if' tokens. */
  static final int IF = 102;

  /** [TokenKind] representing keyword 'in' tokens. */
  static final int IN = 103;

  /** [TokenKind] representing keyword 'is' tokens. */
  static final int IS = 104;

  /** [TokenKind] representing keyword 'new' tokens. */
  static final int NEW = 105;

  /** [TokenKind] representing keyword 'null' tokens. */
  static final int NULL = 106;

  /** [TokenKind] representing keyword 'return' tokens. */
  static final int RETURN = 107;

  /** [TokenKind] representing keyword 'super' tokens. */
  static final int SUPER = 108;

  /** [TokenKind] representing keyword 'switch' tokens. */
  static final int SWITCH = 109;

  /** [TokenKind] representing keyword 'this' tokens. */
  static final int THIS = 110;

  /** [TokenKind] representing keyword 'throw' tokens. */
  static final int THROW = 111;

  /** [TokenKind] representing keyword 'true' tokens. */
  static final int TRUE = 112;

  /** [TokenKind] representing keyword 'try' tokens. */
  static final int TRY = 113;

  /** [TokenKind] representing keyword 'var' tokens. */
  static final int VAR = 114;

  /** [TokenKind] representing keyword 'void' tokens. */
  static final int VOID = 115;

  /** [TokenKind] representing keyword 'while' tokens. */
  static final int WHILE = 116;

  static String kindToString(int kind) {
    switch(kind) {
      case TokenKind.END_OF_FILE: return "end of file";
      case TokenKind.LPAREN: return "(";
      case TokenKind.RPAREN: return ")";
      case TokenKind.LBRACK: return "[";
      case TokenKind.RBRACK: return "]";
      case TokenKind.LBRACE: return "{";
      case TokenKind.RBRACE: return "}";
      case TokenKind.COLON: return ":";
      case TokenKind.ARROW: return "=>";
      case TokenKind.SEMICOLON: return ";";
      case TokenKind.COMMA: return ",";
      case TokenKind.HASH: return "#";
      case TokenKind.HASHBANG: return "#!";
      case TokenKind.DOT: return ".";
      case TokenKind.ELLIPSIS: return "...";
      case TokenKind.INCR: return "++";
      case TokenKind.DECR: return "--";
      case TokenKind.BIT_NOT: return "~";
      case TokenKind.NOT: return "!";
      case TokenKind.ASSIGN: return "=";
      case TokenKind.ASSIGN_OR: return "|=";
      case TokenKind.ASSIGN_XOR: return "^=";
      case TokenKind.ASSIGN_AND: return "&=";
      case TokenKind.ASSIGN_SHL: return "<<=";
      case TokenKind.ASSIGN_SAR: return ">>=";
      case TokenKind.ASSIGN_SHR: return ">>>=";
      case TokenKind.ASSIGN_ADD: return "+=";
      case TokenKind.ASSIGN_SUB: return "-=";
      case TokenKind.ASSIGN_MUL: return "*=";
      case TokenKind.ASSIGN_DIV: return "/=";
      case TokenKind.ASSIGN_TRUNCDIV: return "~/=";
      case TokenKind.ASSIGN_MOD: return "%=";
      case TokenKind.CONDITIONAL: return "?";
      case TokenKind.OR: return "||";
      case TokenKind.AND: return "&&";
      case TokenKind.BIT_OR: return "|";
      case TokenKind.BIT_XOR: return "^";
      case TokenKind.BIT_AND: return "&";
      case TokenKind.SHL: return "<<";
      case TokenKind.SAR: return ">>";
      case TokenKind.SHR: return ">>>";
      case TokenKind.ADD: return "+";
      case TokenKind.SUB: return "-";
      case TokenKind.MUL: return "*";
      case TokenKind.DIV: return "/";
      case TokenKind.TRUNCDIV: return "~/";
      case TokenKind.MOD: return "%";
      case TokenKind.EQ: return "==";
      case TokenKind.NE: return "!=";
      case TokenKind.EQ_STRICT: return "===";
      case TokenKind.NE_STRICT: return "!==";
      case TokenKind.LT: return "<";
      case TokenKind.GT: return ">";
      case TokenKind.LTE: return "<=";
      case TokenKind.GTE: return ">=";
      case TokenKind.INDEX: return "[]";
      case TokenKind.SETINDEX: return "[]=";
      case TokenKind.STRING: return "string";
      case TokenKind.STRING_PART: return "string part";
      case TokenKind.INTEGER: return "integer";
      case TokenKind.HEX_INTEGER: return "hex integer";
      case TokenKind.DOUBLE: return "double";
      case TokenKind.WHITESPACE: return "whitespace";
      case TokenKind.COMMENT: return "comment";
      case TokenKind.ERROR: return "error";
      case TokenKind.INCOMPLETE_STRING: return "incomplete string";
      case TokenKind.INCOMPLETE_COMMENT: return "incomplete comment";
      case TokenKind.INCOMPLETE_MULTILINE_STRING_DQ: return "incomplete multiline string dq";
      case TokenKind.INCOMPLETE_MULTILINE_STRING_SQ: return "incomplete multiline string sq";
      case TokenKind.IDENTIFIER: return "identifier";
      case TokenKind.ABSTRACT: return "pseudo-keyword 'abstract'";
      case TokenKind.ASSERT: return "pseudo-keyword 'assert'";
      case TokenKind.CALL: return "pseudo-keyword 'call'";
      case TokenKind.FACTORY: return "pseudo-keyword 'factory'";
      case TokenKind.GET: return "pseudo-keyword 'get'";
      case TokenKind.IMPLEMENTS: return "pseudo-keyword 'implements'";
      case TokenKind.IMPORT: return "pseudo-keyword 'import'";
      case TokenKind.INTERFACE: return "pseudo-keyword 'interface'";
      case TokenKind.LIBRARY: return "pseudo-keyword 'library'";
      case TokenKind.NATIVE: return "pseudo-keyword 'native'";
      case TokenKind.NEGATE: return "pseudo-keyword 'negate'";
      case TokenKind.OPERATOR: return "pseudo-keyword 'operator'";
      case TokenKind.SET: return "pseudo-keyword 'set'";
      case TokenKind.SOURCE: return "pseudo-keyword 'source'";
      case TokenKind.STATIC: return "pseudo-keyword 'static'";
      case TokenKind.TYPEDEF: return "pseudo-keyword 'typedef'";
      case TokenKind.AWAIT: return "keyword 'await'";
      case TokenKind.BREAK: return "keyword 'break'";
      case TokenKind.CASE: return "keyword 'case'";
      case TokenKind.CATCH: return "keyword 'catch'";
      case TokenKind.CLASS: return "keyword 'class'";
      case TokenKind.CONST: return "keyword 'const'";
      case TokenKind.CONTINUE: return "keyword 'continue'";
      case TokenKind.DEFAULT: return "keyword 'default'";
      case TokenKind.DO: return "keyword 'do'";
      case TokenKind.ELSE: return "keyword 'else'";
      case TokenKind.EXTENDS: return "keyword 'extends'";
      case TokenKind.FALSE: return "keyword 'false'";
      case TokenKind.FINAL: return "keyword 'final'";
      case TokenKind.FINALLY: return "keyword 'finally'";
      case TokenKind.FOR: return "keyword 'for'";
      case TokenKind.IF: return "keyword 'if'";
      case TokenKind.IN: return "keyword 'in'";
      case TokenKind.IS: return "keyword 'is'";
      case TokenKind.NEW: return "keyword 'new'";
      case TokenKind.NULL: return "keyword 'null'";
      case TokenKind.RETURN: return "keyword 'return'";
      case TokenKind.SUPER: return "keyword 'super'";
      case TokenKind.SWITCH: return "keyword 'switch'";
      case TokenKind.THIS: return "keyword 'this'";
      case TokenKind.THROW: return "keyword 'throw'";
      case TokenKind.TRUE: return "keyword 'true'";
      case TokenKind.TRY: return "keyword 'try'";
      case TokenKind.VAR: return "keyword 'var'";
      case TokenKind.VOID: return "keyword 'void'";
      case TokenKind.WHILE: return "keyword 'while'";
      default: return "TokenKind(" + kind.toString() + ")";
    }
  }

  static bool isIdentifier(int kind) {
    return kind >= IDENTIFIER && kind < AWAIT;
  }

  static int infixPrecedence(int kind) {
    switch(kind) {
      case ASSIGN: return 2;
      case ASSIGN_OR: return 2;
      case ASSIGN_XOR: return 2;
      case ASSIGN_AND: return 2;
      case ASSIGN_SHL: return 2;
      case ASSIGN_SAR: return 2;
      case ASSIGN_SHR: return 2;
      case ASSIGN_ADD: return 2;
      case ASSIGN_SUB: return 2;
      case ASSIGN_MUL: return 2;
      case ASSIGN_DIV: return 2;
      case ASSIGN_TRUNCDIV: return 2;
      case ASSIGN_MOD: return 2;
      case CONDITIONAL: return 3;
      case OR: return 4;
      case AND: return 5;
      case BIT_OR: return 6;
      case BIT_XOR: return 7;
      case BIT_AND: return 8;
      case SHL: return 11;
      case SAR: return 11;
      case SHR: return 11;
      case ADD: return 12;
      case SUB: return 12;
      case MUL: return 13;
      case DIV: return 13;
      case TRUNCDIV: return 13;
      case MOD: return 13;
      case EQ: return 9;
      case NE: return 9;
      case EQ_STRICT: return 9;
      case NE_STRICT: return 9;
      case LT: return 10;
      case GT: return 10;
      case LTE: return 10;
      case GTE: return 10;
      case IS: return 10;
      default: return -1;
    }
  }

  static String rawOperatorFromMethod(String name) {
    switch(name) {
      case ':bit_not': return '~';
      case ':bit_or': return '|';
      case ':bit_xor': return '^';
      case ':bit_and': return '&';
      case ':shl': return '<<';
      case ':sar': return '>>';
      case ':shr': return '>>>';
      case ':add': return '+';
      case ':sub': return '-';
      case ':mul': return '*';
      case ':div': return '/';
      case ':truncdiv': return '~/';
      case ':mod': return '%';
      case ':eq': return '==';
      case ':lt': return '<';
      case ':gt': return '>';
      case ':lte': return '<=';
      case ':gte': return '>=';
      case ':index': return '[]';
      case ':setindex': return '[]=';
      case ':ne': return '!=';
    }
  }

  static String binaryMethodName(int kind) {
    switch(kind) {
      case BIT_NOT: return ':bit_not';
      case BIT_OR: return ':bit_or';
      case BIT_XOR: return ':bit_xor';
      case BIT_AND: return ':bit_and';
      case SHL: return ':shl';
      case SAR: return ':sar';
      case SHR: return ':shr';
      case ADD: return ':add';
      case SUB: return ':sub';
      case MUL: return ':mul';
      case DIV: return ':div';
      case TRUNCDIV: return ':truncdiv';
      case MOD: return ':mod';
      case EQ: return ':eq';
      case LT: return ':lt';
      case GT: return ':gt';
      case LTE: return ':lte';
      case GTE: return ':gte';
      case INDEX: return ':index';
      case SETINDEX: return ':setindex';
    }
  }

  static String unaryMethodName(int kind) {
  }

  static int kindFromAssign(int kind) {
    if (kind == ASSIGN) return 0;
    if (kind > ASSIGN && kind <= ASSIGN_MOD) {
      return kind + (ADD - ASSIGN_ADD);
    }
    return -1;
  }
}
