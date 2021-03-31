%{
#include "y.tab.h"
extern int yylval;
%}

number [0-9]+
whitespace [ \t]+
eol \n

%%

{number} {yylval = atoi(yytext); return NUMBER;}
{whitespace} ; /* whitespace is ignored */
{eol} {return 0;} /* represents the logical end of input */
. {return yytext[0];} /* Everything else is an error, send the first character */



