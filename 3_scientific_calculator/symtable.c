#include "symtable.h"
#include <string.h>
#include <stdlib.h>
#define MAX 100

void yyerror(const char *);

symentry table[MAX];

symentry *symlookup(char *name) {
		int i;
		for (i = 0; i < MAX; i++) {
				/*
				if (table[i].funcptr) {
						// ignore function pointers- they can be
						// distinguished from names based on whether 
						// funcptr is set 
						continue; 
				}
				*/
				/* I'LL DO YOU ONE BETTER- THEY CAN SHARE THE SAME ENTRY! */

				if (table[i].key && !strcmp(table[i].key, name)) {
						return &table[i];
				}
				
				if (!table[i].key) {
						table[i].key = strdup(name);
						return &table[i];
				}
		}
		yyerror("too many variables");
		exit(1);

		/* will never get called */
		return NULL;
}

void addfunc(char *funcname, double (*fn)()) {
		int i;
		symentry *symp = symlookup(funcname);
		symp->funcptr = fn;
}
