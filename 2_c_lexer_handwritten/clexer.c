#include <stdio.h>

#define MAX 100

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
		int ival;
		double dval;
		char *str;
}tokval;

static tokval lval;

int lex() {
		static int state = 0;
		static int len = 0;
		static char str[MAX];
		char c;

		c = getchar();

		if (c == EOF) {
				return 0;
		}

		switch(state) {
				case 0:
						if (isalpha(c) || c == '_') {
								state = 1;
								str[len++] = 


int main(void) {
