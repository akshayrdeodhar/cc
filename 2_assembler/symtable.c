#include "symtable.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdlib.h>
#define MAX 100

void yyerror(const char *);

symentry table[MAX];
int len;

void syminit(void) {
	len = 0;
}

int symlookup(char *name) {
	int i;
	for (i = 0; i < len; i++) {
		if (table[i].key && !strcmp(table[i].key, name)) {
			return table[i].value;
		}
	}
	yyerror("too many labels");
	exit(1);

	/* will never get called */
	return -1;
}

void symtableadd(char *name, int address) {
	table[len].key = strdup(name);
	table[len++].value = address;
}
