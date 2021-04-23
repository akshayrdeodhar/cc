%{
#include <stdio.h>
#include <math.h>
int yylex();
int yyerror(char *);

#define T_DOUBLE 201
#define T_INT 202

%}

%code requires {
#include "symtable.h"
typedef struct {
	double dval;
	int ival;
	int type;
}typedval;

typedval typed_add(typedval, typedval);
typedval typed_sub(typedval, typedval);
typedval typed_mul(typedval, typedval);
typedval typed_div(typedval, typedval);


}

%union {
	typedval val;
	symentry *symp;
}
	
	

%token <val> NUMBER
%token <symp> NAME

%type <val> expression

%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%%

statement_list: statement '\n'
			  | statement_list statement '\n'
			  ;

statement: NAME '=' expression {$1->ival= $3.ival; $1->dval = $3.dval; $1->type = $3.type;}
		 | expression {
			if ($1.type == T_INT) {
				printf("(%d, %s)\n", $1.ival, "T_INT");
			}
			else {
				printf("(%lf, %s)\n", $1.dval, "T_DOUBLE");
			}
		}
		;

expression: expression '+' expression {$$ = typed_add($1, $3);}
		  | expression '-' expression {$$ = typed_sub($1, $3);}
		  | expression '*' expression {$$ = typed_mul($1, $3);}
		  | expression '/' expression {$$ = typed_div($1, $3);}
		  | '-' expression %prec UMINUS {$$ = $2; $$.ival = -$$.ival; $$.dval = -$$.dval;}
		  | '(' expression ')' {$$ = $2;}
		  | NUMBER {$$ = $1;}
		  | NAME {$$.ival = $1->ival; $$.dval = $1->dval; $$.type = $1->type;}
		  | NAME '(' expression ')' {
				typedval result;
				double arg;
				if ($3.type == T_INT) {
					arg = (double)$3.ival;
				}
				else {
					arg = $3.dval;
				}
				result.type = T_DOUBLE;
				result.dval = $1->funcptr(arg);
				$$ = result;
		}
		  ;

%%

typedval typed_add(typedval arg1, typedval arg2) {
	typedval result;
	if (arg1.type == T_INT && arg2.type == T_INT) {
		result.type = T_INT;
		result.ival = arg1.ival + arg2.ival;
	}
	else if (arg1.type == T_INT && arg2.type == T_DOUBLE) {
		result.type = T_DOUBLE;
		result.dval = arg1.ival + arg2.dval;
	}
	else if (arg1.type == T_DOUBLE && arg2.type == T_INT) {
		result.type = T_DOUBLE;
		result.dval = arg1.dval + arg2.ival;
	}
	else {
		result.type = T_DOUBLE;
		result.dval = arg1.dval + arg2.dval;
	}
	return result;
}

typedval typed_sub(typedval arg1, typedval arg2) {
	typedval result;
	if (arg1.type == T_INT && arg2.type == T_INT) {
		result.type = T_INT;
		result.ival = arg1.ival - arg2.ival;
	}
	else if (arg1.type == T_INT && arg2.type == T_DOUBLE) {
		result.type = T_DOUBLE;
		result.dval = arg1.ival - arg2.dval;
	}
	else if (arg1.type == T_DOUBLE && arg2.type == T_INT) {
		result.type = T_DOUBLE;
		result.dval = arg1.dval - arg2.ival;
	}
	else {
		result.type = T_DOUBLE;
		result.dval = arg1.dval - arg2.dval;
	}
	return result;
}

typedval typed_div(typedval arg1, typedval arg2) {
	typedval result;
	if ((arg2.type == T_INT && arg2.ival == 0) ||
		(arg2.type == T_DOUBLE && arg2.dval == 0)) {
		yyerror("divide by 0");
	}
	if (arg1.type == T_INT && arg2.type == T_INT) {
		result.type = T_DOUBLE;
		result.ival = arg1.ival / arg2.ival;
	}
	else if (arg1.type == T_INT && arg2.type == T_DOUBLE) {
		result.type = T_DOUBLE;
		result.dval = arg1.ival / arg2.dval;
	}
	else if (arg1.type == T_DOUBLE && arg2.type == T_INT) {
		result.type = T_DOUBLE;
		result.dval = arg1.dval / arg2.ival;
	}
	else {
		result.type = T_DOUBLE;
		result.dval = arg1.dval / arg2.dval;
	}
	return result;
}

typedval typed_mul(typedval arg1, typedval arg2) {
	typedval result;
	if (arg1.type == T_INT && arg2.type == T_INT) {
		result.type = T_INT;
		result.ival = arg1.ival * arg2.ival;
	}
	else if (arg1.type == T_INT && arg2.type == T_DOUBLE) {
		result.type = T_DOUBLE;
		result.dval = arg1.ival * arg2.dval;
	}
	else if (arg1.type == T_DOUBLE && arg2.type == T_INT) {
		result.type = T_DOUBLE;
		result.dval = arg1.dval * arg2.ival;
	}
	else {
		result.type = T_DOUBLE;
		result.dval = arg1.dval * arg2.dval;
	}
	return result;
}

int main() {
	addfunc("sin", sin);
	addfunc("cos", cos);
	addfunc("tan", tan);
	addfunc("sqrt", sqrt);
	yyparse();
	return 0;
}
