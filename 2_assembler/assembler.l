%{
#include "symtable.h"
#include "y.tab.h"
#include <math.h>
extern char *yytext;
extern int address;
extern int pass;
%}

%%

[a-zA-Z]+:	{if (pass == 1) {yytext[strlen(yytext) - 1] = '\0'; symtableadd(yytext, address);} return LABEL; }
add		{return ADD; }
sub		{return SUB; }
mul		{return MUL; }
jmp		{return JMP; }
jz		{return JZ; }
load		{return LOAD; }
store		{return STORE; }
stop		{return STOP; }
mov		{return MOV; }
[0-9]+		{yylval = atoi(yytext); return NUM; }
[a-z]r		{yylval = yytext[0] - 'a'; return REG; }
[a-zA-Z]+	{yylval = symlookup(yytext); return JMPLABEL; }
,		{return ','; }
\n		{return '\n'; }
[ \t]		{;}
