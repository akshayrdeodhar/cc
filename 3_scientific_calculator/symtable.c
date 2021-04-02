#include "symtable.h"
#include <string.h>
#include <stdlib.h>
#define MAX 100

void yyerror(const char *);

symentry table[MAX];

symentry *symlookup(char *name) {
		int i;
		for (i = 0; i < MAX; i++) {
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
