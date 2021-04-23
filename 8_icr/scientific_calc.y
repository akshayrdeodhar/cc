%{
	#include <stdio.h>
	#include <math.h>
	#include "symtable.h"
	int yylex();
	int yyerror(char *);
	int count;
%}

%union {
	int tag;
	double dval;
	symentry *symp;
}

%token <dval> NUMBER
%token <symp> NAME

%type <tag> expression
%type <tag> mulexp
%type <tag> primary

%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%%

statement_list: statement '\n'
			  | statement_list statement '\n'
			  ;

statement: NAME '=' expression {printf("copy\t%%t%d\t%s\t%s\n", $3, "", $1->key);}
		 | expression {printf("write\t%%t%d\n", $1);}
		 ;

expression: expression '+' mulexp {$$ = count++; printf("add\t%%t%d\t%%%d\t%%t%d\n", $1, $3, $$);}
		  | expression '-' mulexp {$$ = count++; printf("sub\t%%t%d\t%%t%d\t%%t%d\n", $1, $3, $$);}
		  | mulexp {$$ = $1;}
		  ;

mulexp: mulexp '*' primary {$$ = count++; printf("mul\t%%t%d\t%%t%d\t%%t%d\n", $1, $3, $$);}
      | mulexp '/' primary {
				if ($3 == 0) {
					yyerror("divide by zero");
				}
				else {	
					$$ = count++; printf("div\t%%t%d\t%d\t%%t%d\n", $1, $3, $$);
				}
			}
      | primary {$$ = $1;}

primary:  '-' primary {$$ = count++; $$ = count++; printf("sub\t%d\t%%t%d\t%%t%d\n", 0, $2, $$);}
	| '(' expression ')' {$$ = $2;}
	| NUMBER {$$ = count++; printf("copy\t%lf\t%s\t%%t%d\n", $1, "", $$);}
	| NAME {$$ = count++; printf("copy\t%s\t%s\t%%t%d\n", $1->key, "", $$);}
	| NAME '(' expression ')' {$$ = count++; printf("call\t%s\t%%t%d\t%%t%d\n", $1->key, $3, $$);}
		  ;

%%

int main() {
	count = 0;
	addfunc("sin", sin);
	addfunc("cos", cos);
	addfunc("tan", tan);
	addfunc("sqrt", sqrt);
	printf("operation\tin1\tin2\tout1\n");
	yyparse();
	return 0;
}
