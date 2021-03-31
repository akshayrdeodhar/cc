%token NAME NUMBER
%{
	#include <stdio.h>
	int yylex();
	int yyerror(char *);
%}

%%

statement: NAME '=' expression
		 | expression {printf("%d\n", $1);}
		 ;

expression: expression '+' NUMBER {$$ = $1 + $3;}
		  | expression '-' NUMBER {$$ = $1 - $3;}
		  | NUMBER {$$ = $1;}
		  ;

%%

int main() {
	yyparse();
	return 0;
}
