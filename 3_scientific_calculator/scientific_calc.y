%{
	#include <stdio.h>
	#include <math.h>
	#include "symtable.h"
	int yylex();
	int yyerror(char *);
%}

%union {
	double dval;
	symentry *symp;
}

%token <dval> NUMBER
%token <symp> NAME

%type <dval> expression

%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%%

statement_list: statement '\n'
			  | statement_list statement '\n'
			  ;

statement: NAME '=' expression {$1->value = $3;}
		 | expression {printf("%lf\n", $1);}
		 ;

expression: expression '+' expression {$$ = $1 + $3;}
		  | expression '-' expression {$$ = $1 - $3;}
		  | expression '*' expression {$$ = $1 * $3;}
		  | expression '/' expression
		  	{ 
				if ($3 == 0) {
					yyerror("divide by zero");
				}
				else {	
					$$ = $1 / $3;
				}
			}
		  | '-' expression %prec UMINUS {$$ = - $2;}
		  | '(' expression ')' {$$ = $2;}
		  | NUMBER {$$ = $1;}
		  | NAME {$$ = $1->value;}
		  | NAME '(' expression ')' {$$ = $1->funcptr($3);}
		  ;

%%

int main() {
	addfunc("sin", sin);
	addfunc("cos", cos);
	addfunc("tan", tan);
	addfunc("sqrt", sqrt);
	yyparse();
	return 0;
}
