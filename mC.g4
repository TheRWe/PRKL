grammar mC;

start: statement* EOF;

statement:
	ParCurBeg statement* ParCurEnd
	| expression Semicolon
	| stIf
	| stWhile
	| stDoWhile
	| stFor;

stIf:
	If ParRoundBeg expression ParRoundEnd statement (
		Else statement
	)?;
stWhile: While ParRoundBeg expression ParRoundEnd statement;
stDoWhile:
	Do statement While ParRoundBeg expression ParRoundEnd Semicolon;
stFor:
	For ParRoundBeg expression? Semicolon expression? Semicolon expression? ParRoundEnd statement;

value: expression | String;

// operators by precedence 
expression:
	fncCall
	// ++ -- - + ! ~
	| ((OpInc | OpDec) Variable)
	| ((OpPlus | OpMinus | OpBitNeg | OpNeg) expression)
	//    * / %
	| expression (OpMul | OpDiv | OpMod) expression
	//    + -
	| expression (OpPlus | OpMinus) expression
	// << >> 
	| expression (OpBitShiftLeft | OpBitShiftRight) expression
	// == != 
	| expression (OpEq | OpEqNot) expression
	// < > <= >= 
	| expression (OpGt | OpGte | OpLt | OpLte) expression
	// & 
	| expression (OpBitAnd) expression
	// ^ 
	| expression (OpBitXor) expression
	// | 
	| expression (OpBitOr) expression
	// && 
	| expression (OpAnd) expression
	// || 
	| expression (OpOr) expression
	// assigns
	| Variable opAssingAny expression
	| Boolean
	| number
	| String
	| Char
	| Variable;

arguments: (expression (Comma expression)*)?;

fncCall: Variable ParRoundBeg arguments ParRoundEnd;

opAssingAny:
	OpAssign
	| OpAssignMul
	| OpAssignDiv
	| OpAssignMod
	| OpAssignPlus
	| OpAssignMinus
	| OpAssignShiftLeft
	| OpAssignShiftRight
	| OpAssignAnd
	| OpAssignOr
	| OpAssignXor;

Boolean: (True | False);
number: (NumberPrefBin | NumberPrefHex)? Digits+;


/*
 * Lexer
 */

Ws: [ ] -> skip;
Nl: [\n\r] -> skip;

CommentMlBeg: '\\*';
CommentMlEnd: '*\\';
CommentSl: '//';

Comment: (CommentMlBeg .*? CommentMlEnd | CommentSl .*? Nl) -> skip;

String: '"' ('\\"' | .)*? '"';
Char: '\'' ('\\' . | .) '\'';

// special symbols
Semicolon: ';';
Colon: ':';
Comma: ',';


// - operators
OpInc: '++';
OpDec: '--';
OpNeg: '!';

OpPlus: '+';
OpMinus: '-';
OpMul: '*';
OpDiv: '/';
OpMod: '%';

OpEq: '==';
OpEqNot: '!=';
OpLt: '<';
OpGt: '>';
OpLte: '<=';
OpGte: '>=';

OpBitShiftLeft: '<<';
OpBitShiftRight: '>>';
OpBitNeg: '~';
OpBitAnd: '&';
OpBitXor: '^';
OpBitOr: '|';

OpAnd: '&&' | 'and' | 'AND';
// todo: priorita ?
OpOr: '||' | 'or' | 'OR';

OpAssign: '=';
OpAssignMul: '*=';
OpAssignDiv: '/=';
OpAssignMod: '%=';
OpAssignPlus: '+=';
OpAssignMinus: '-=';
OpAssignShiftLeft: '<<=';
OpAssignShiftRight: '>>=';
OpAssignAnd: '&=';
OpAssignOr: '|=';
OpAssignXor: '^=';

// - parenthesis
ParCurBeg: '{';
ParCurEnd: '}';
ParRoundBeg: '(';
ParRoundEnd: ')';
ParSquareBeg: '[';
ParSquareEnd: ']';

// keywords
If: 'if' | 'IF';
Else: 'else' | 'ELSE';
For: 'for' | 'FOR';
While: 'while' | 'WHILE';
Do: 'do' | 'DO';
True: 'true' | 'TRUE';
False: 'false' | 'FALSE';


NumberPrefBin: '0' ('b' | 'B');
NumberPrefHex: '0' ('x' | 'X');

Digits: [0-9]+;

fragment AZ: [a-zA-Z];

Variable: AZ (AZ | Digits)*;

