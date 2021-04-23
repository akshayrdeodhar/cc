%{
extern int yyval;
%}

number [0-9]+
whitespace [ \t]+
eol \n

%%

{number} {yyval = atoi(yytext); return 1;}
{whitespace} ; /* whitespace is ignored */
{eol} {return 0;} /* represents the logical end of input */
. {return yytext[0];} /* Everything else is an error, send the first character */

%%


int yyval;
int main(void) {
		int retval;
		yyval = -1;
		while (yyval != 0) {
				retval = yylex();
				printf("%s: %d\n", yytext, yyval);
		}
		return 0;
}

