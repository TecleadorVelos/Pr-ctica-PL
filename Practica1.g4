grammar Practica1;

program: dcllist funlist sentlist EOF;

dcllist: | dcl dcllist;
funlist: | funcdef funlist ;
sentlist: mainhead '{' code '}';


// ------------------------------- Parte declaracion de variables globales
dcl: ctelist | varlist;

ctelist: '#define' CONST_DEF_IDENTIFIER simpvalue ctelist_prima ;
ctelist_prima: | '#define'CONST_DEF_IDENTIFIER simpvalue ctelist_prima ;

simpvalue: NUMERIC_INTEGER_CONST | NUMERIC_REAL_CONST| STRING_CONST;

varlist: vardef ';' varlist_prima ;
varlist_prima: | vardef ';' varlist_prima ;

vardef:  tbas IDENTIFIER | tbas IDENTIFIER '=' simpvalue;
tbas: 'integer' | 'float' | 'string' | tvoid | struct;
tvoid: 'void';
struct: 'struct' '{' varlist '}';

//----------------------------------Parte declaracion de funciones de programa
funcdef: funchead '{' code '}';
funchead: tbas IDENTIFIER '(' typedef1 ')';
typedef1:  | typedef2;
typedef2: tbas IDENTIFIER typedef2_prima ;
typedef2_prima:  | ',' tbas IDENTIFIER typedef2_prima ;

//-----------------------------------Parte declaracion de sentencias pprincipal
mainhead: tvoid 'Main' '(' typedef1 ')';
code:  | sent code;
sent: asig ';' | funccall ';' | vardef ';' | if | while | dowhile | for;
asig: IDENTIFIER '=' exp;

exp: factor exp_prima;
exp_prima: | op factor exp_prima ;

op: '+' | '-' | '*' | 'DIV' | 'MOD';
factor: simpvalue | '(' exp ')' | funccall;
funccall: IDENTIFIER subpparamlist | CONST_DEF_IDENTIFIER subpparamlist;
subpparamlist: | '(' explist ')';
explist: exp | exp ',' explist;

if: 'if' expcond '{' code '}' else ;
else: 'else' '{' code '}' | 'else' if | ;
while: 'while' '(' expcond ')' '{' code '}' ;
dowhile: 'do' '{' code '}' 'while' '(' expcond ')' ';' ;
for: 'for' '(' vardef ';' expcond ';' asig ')' '{' code '}'
    | 'for' '(' asig ';' expcond ';' asig ')' '{' code '}' ;

//expcond: expcond oplog expcond | factorcond ; version no LL1

expcond: factorcond expcond2 ;
expcond2: oplog factorcond expcond2 | ;
oplog: '||' | '&' ;
factorcond: exp opcomp exp | '(' expcond ')' | '!' factorcond ;
opcomp: '<' | '>' | '<=' | '>=' | '==' ;

//------------Parte Analizador Lexico
IDENTIFIER: (([a-z] | '_')('_' | [0-9] | [a-zA-Z])*([0-9] | [a-zA-Z])+ | [a-z]) ;
CONST_DEF_IDENTIFIER: ([A-Z] | '_')[A-Z0-9]+('_' | [A-Z0-9])* ;

NUMERIC_INTEGER_CONST:  ('+'|'-')?[0-9]+ ;
NUMERIC_REAL_CONST: (('+'|'-')?[0-9]+'.'[0-9]+ |('+'|'-')?'.'[0-9]+ |('+'|'-')?[0-9]+('e'|'E')('+'|'-')?[0-9]+ |
                    (('+'|'-')?[0-9]+'.'[0-9]+ |('+'|'-')?'.'[0-9]+)('e'|'E')('+'|'-')?[0-9]+) ;


STRING_CONST: (('"' ( CONTENIDO_SIN_COMILLAD| '\\"')* '"') | ('\'' (CONTENIDO_SIN_COMILLAN | '\\\'')* '\'')) ;

COMENTARIO: ( ('//'.+[\n]) | ('/*'.+'*/')) -> skip; //comentario esta bien

IGNORE : [' '\t\r\n] -> skip ;
ERROR: . {System.err.println("Error lexico detectado en la línea " + String.valueOf(getLine()) +
                           " y columna " + String.valueOf(getCharPositionInLine()) + ". Encontrado '"+getText()+"'");};


//Fragmentos

fragment CONTENIDO_SIN_COMILLAD:  ~["\t\r\n];
fragment CONTENIDO_SIN_COMILLAN:  ~['\t\r\n];
