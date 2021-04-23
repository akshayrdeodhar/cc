%{
#include "symtable.h"
#include "y.tab.h"
#include <math.h>
extern char *yytext;
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
{number} {yylval.dval = atof(yytext); return NUMBER;}
{whitespace} ; /* whitespace is ignored */
{eol} {return '\n';} /* represents the logical end of input */
{eoi} {return 0;}
{name} {return NAME;} /* The variable name is present in `yytext`. Return NAME */
. {return yytext[0];} /* Everything else is an error, send the first character */

