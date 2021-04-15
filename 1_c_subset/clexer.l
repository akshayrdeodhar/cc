%{
#include <stdio.h>
#include <stdlib.h>

#define COMPARISON 101
#define ASSIGNMENT 102
#define OPERATOR 103
#define KEYWORD 104
#define IDENTIFIER 105
#define INTEGER 106
#define REAL 107
#define OPENPAREN 108
#define CLOSEPAREN 109
#define CURLYOPEN 110
#define CURLYCLOSE 111
#define SEMICOLON 112
#define STRING 113
#define ERROR 666

typedef union {
	double dval;
	int ival;
	char *str;
}valtype;

valtype yylval;



%}

%%


"==" |
"<=" |
">=" |
"<"  |
">"  	{return COMPARISON; }

=	{return ASSIGNMENT; }

[,+\-*/\%] {return OPERATOR; }

"int" |
"double" |
"float" |
"if" |
"else" |
"return" |
"const" |
"struct" |
"typedef" |
"void" |
"char"  {return KEYWORD; }

\(	{return OPENPAREN; }

\) 	{return CLOSEPAREN; }

\{	{return CURLYOPEN; }

\}	{return CURLYCLOSE; }
	
;	{return SEMICOLON; }

[a-zA-Z_][a-zA-Z1-9]* {yylval.str = strdup(yytext); return IDENTIFIER; }

-?[0-9]+	{yylval.ival = atoi(yytext); return INTEGER; }

-?[0-9]*"."[0-9]+[eE][+-]?[0-9]+ {yylval.dval = atof(yytext); return REAL; }

[ \t\n] {; /* ignore whitespace */ }

\$	{return 0; }

\".*\"  {return STRING; }

.	{return ERROR; }


%%


int main(void) {
	int token_type;
	while((token_type = yylex())) {
		switch (token_type) {
			case COMPARISON:
				printf("COMPARISON: %s\n", yytext);
				break;
			case ASSIGNMENT:
				printf("ASSIGNMENT\n");
				break;
			case OPERATOR:
				printf("OPERATOR: %c\n", yytext[0]);
				break;	
			case KEYWORD:
				printf("KEYWORD: %s\n", yytext);
				break;
			case IDENTIFIER:
				printf("IDENTIFIER: %s\n", yylval.str);
				break;
			case INTEGER:
				printf("INTEGER: %d\n", yylval.ival);
				break;
			case REAL:
				printf("REAL: %lf\n", yylval.dval);
				break;
			case OPENPAREN:
				printf("OPENPAREN\n");
				break;
			case CLOSEPAREN:
				printf("CLOSEPAREN\n");
				break;
			case CURLYOPEN:
				printf("CURLYOPEN\n");
				break;
			case CURLYCLOSE:
				printf("CURLYCLOSE\n");
				break;
			case SEMICOLON:
				printf("SEMICOLON\n");
				break;
			case STRING:
				printf("STRING: \"%s\"\n", yytext);
				break;
			default:
				printf("INVALID TOKEN: %s\n EXITING NOW\n", yytext);
				return 1;
				break;
		}
	}
	return 0;
}
