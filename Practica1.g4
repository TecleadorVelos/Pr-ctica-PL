grammar Practica1;

program: dcllist funlist sentlist EOF;

dcllist: | dcl dcllist;
funlist: | funcdef funlist ;
sentlist: mainhead '{' code '}';


// ------------------------------- Parte declaracion de variables globales
dcl: ctelist | varlist;

ctelist: '#define' CONST_DEF_IDENTIFIER simpvalue ctelist_prima ;  
ctelist_prima: '#define'CONST_DEF_IDENTIFIER simpvalue ctelist_prima | ʎ ;

simpvalue: NUMERIC_INTEGER_CONST | NUMERIC_REAL_CONST| STRING_CONST;

varlist: vardef ';' varlist_prima ;
varlist_prima: vardef ';' varlist_prima | ʎ ;

vardef:  tbas IDENTIFIER | tbas IDENTIFIER '=' simpvalue;
tbas: 'integer' | 'float' | 'string' | tvoid ;
tvoid: 'void';

//----------------------------------Parte declaracion de funciones de programa
funcdef: funchead '{' code '}';
funchead: tbas IDENTIFIER '(' typedef1 ')';
typedef1:  | typedef2;
typedef2: tbas IDENTIFIER typedef2_prima ;
typedef2_prima: ʎ | ',' tbas IDENTIFIER typedef2_prima ;

//-----------------------------------Parte declaracion de sentencias pprincipal
mainhead: tvoid 'Main' '(' typedef1 ')';
code:  | sent code;
sent: asig ';' | funccall ';' | vardef ';';
asig: IDENTIFIER '=' exp;

exp: factor exp_prima;
exp_prima: op factor expr_prima | ʎ ;

op: '+' | '-' | '*' | 'DIV' | 'MOD';
factor: simpvalue | '(' exp ')' | funccall;
funccall: IDENTIFIER subpparamlist | CONST_DEF_IDENTIFIER subpparamlist;
subpparamlist: | '(' explist ')';
explist: exp | exp ',' explist;




//------------Parte Analizador Lexico
IDENTIFIER: ([a-z] | '_')('_' | [a-z0-9])*[a-z0-9]('_' | [a-z0-9])* {System.out.println("Identifier detectado"+ getText());};
CONST_DEF_IDENTIFIER: ([A-Z] | '_')[A-Z0-9]+('_' | [A-Z0-9])* {System.out.println("Constante detectado"+ getText());};

NUMERIC_INTEGER_CONST:  ('+'|'-')?[0-9]+ {System.out.println("Constante numerica detectada"+ getText());};
NUMERIC_REAL_CONST: (('+'|'-')?[0-9]+'.'[0-9]+ |('+'|'-')?'.'[0-9]+ |('+'|'-')?[0-9]+('e'|'E')('+'|'-')?[0-9]+ |
                    (('+'|'-')?[0-9]+'.'[0-9]+ |('+'|'-')?'.'[0-9]+)('e'|'E')('+'|'-')?[0-9]+) {System.out.println("Constante real detectada"+ getText());};
STRING_CONST: (('\''( . | '\'')+'\'') | ('"'( ('\\"')|(.) )+'"')) {System.out.println("Constante literal detectada"+ getText());};
COMENTARIO: ( ('//'.+[\n])| ('/*'.+'*/')) {System.out.println("Comentario detectado"+ getText());};

IGNORE : [' '\r\n] -> skip ;



