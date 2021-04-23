%{
#include "scientific_calc_semantic.tab.h"
#include <math.h>
extern char *yytext;
#define T_DOUBLE 201
#define T_INT 202
#define YYSTYPE typedval;
%}

digit [0-9]
integer {digit}+
optional_fractional ((\.{integer})?)
optional_exponent (([eE][-+]?{integer})?)
number ({integer}?){optional_fractional}{optional_exponent}
whitespace [ \t]+
eol \n
eoi \$
letter_and_underscore [a-zA-Z_]
name {letter_and_underscore}({letter_and_underscore}|{digit})*

%%

{name} {yylval.symp = symlookup(yytext); return NAME;}
{integer} {yylval.val.ival= atoi(yytext); yylval.val.type = T_INT; return NUMBER;}
{number} {yylval.val.dval= atof(yytext); yylval.val.type = T_DOUBLE ; return NUMBER;}
{whitespace} ; /* whitespace is ignored */
{eol} {return '\n';} /* represents the logical end of input */
{eoi} {return 0;}
{name} {return NAME;} /* The variable name is present in `yytext`. Return NAME */
. {return yytext[0];} /* Everything else is an error, send the first character */

