%{
	#include <stdio.h>
	#include <math.h>
	#include "symtable.h"
	int yylex();
	int yyerror(char *);
	extern int address;
	extern int pass;
	#define ADDRPRINT {printf("%d: ", address);}
%}


%token ADD
%token LABEL
%token SUB
%token MUL
%token JMP
%token JZ
%token LOAD
%token STORE
%token STOP
%token NUM
%token REG
%token MOV
%token JMPLABEL

%%

line_list: line 
	| LABEL '\n'
	| line_list line 
	| line_list LABEL '\n'
	| '\n'
	| line_list '\n'
	

line: opt_label ins '\n'

opt_label:
	 | LABEL
	;

ins: addreg 
   | addnum 
   | subreg
   | subnum
   | movnum
   | jmpplain
   | jmpcond
   | stopins
   | storereg
   | loadreg


addreg: ADD REG ',' REG 
	{
		if (pass == 2) {
			ADDRPRINT
			printf("%d %d %d\n", 1, $2, $4);
		}
		address += 3;
	}
       ;

addnum: ADD REG ',' NUM
	{
		if (pass == 2) {
			ADDRPRINT
			printf("%d %d %d\n", 2, $2, $4);
		}
		address += 3;
   	}
	;

subreg: SUB REG ',' REG
      	{
		if (pass == 2) {
			ADDRPRINT
			printf("%d %d %d\n", 3, $2, $4);
		}
		address += 3;
	}
	;

subnum: SUB REG ',' NUM
	{
		if (pass == 2) {
			ADDRPRINT
			printf("%d %d %d\n", 4, $2, $4);
		}
		address += 3;
   	}
	;

movnum: MOV REG ',' NUM
        {
		if (pass == 2) {
			ADDRPRINT
			printf("%d %d %d\n", 12, $2, $4);
		}
		address += 3;
	}
	;

jmpplain: JMP JMPLABEL
	{
		if (pass == 2) {
			ADDRPRINT
			printf("%d %d\n", 7, $2);
		}
		address += 2;
	}
	;

loadreg: LOAD REG
	{
		if (pass == 2) {
			ADDRPRINT
			printf("%d %d\n", 9, $2);
		}
		address += 2;
	}
	;

storereg: STORE REG
	 {
		if (pass == 2) {
			ADDRPRINT
			printf("%d %d\n", 10, $2);
		}
		address += 2;
	}
	;

stopins: STOP
       {
		if (pass == 2) {
			ADDRPRINT
			printf("%d\n", 11);
		}
		address += 1;
	}
	;


jmpcond: JZ REG ',' JMPLABEL
       {
		if (pass == 2) {
			ADDRPRINT
			printf("%d %d %d\n", 8, $2, $4);
		}
		address += 3;
	}


%%

int address;
int pass;

int main(int argc, char *argv[]) {
	extern FILE *yyin;
	extern int yydebug;

	yyin = fopen(argv[1], "r");

	address = 0;

	// First pass
	pass = 1;
	yyparse();

	fclose(yyin);


	// Second pass
	address = 0;
	pass = 2;
	yyin = fopen(argv[1], "r");


	yyparse();	

	return 0;
}
