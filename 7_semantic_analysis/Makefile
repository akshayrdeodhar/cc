calc: lex.yy.o scientific_calc_semantic.tab.o symtable.o
	clang lex.yy.o scientific_calc_semantic.tab.o symtable.o -lfl -ly -lm -o calc 

lex.yy.c: scientific_calc_semantic.l symtable.h
	flex scientific_calc_semantic.l

.PHONY: yaccop

yaccop: scientific_calc_semantic.y symtable.h
	bison -d scientific_calc_semantic.y

scientific_calc_semantic.tab.h: yaccop

scientific_calc_semantic.tab.c: yaccop

lex.yy.o: lex.yy.c scientific_calc_semantic.tab.h
	clang -c lex.yy.c

scientific_calc_semantic.tab.o: scientific_calc_semantic.tab.c scientific_calc_semantic.tab.h
	clang -c scientific_calc_semantic.tab.c 

symtable.o: symtable.c symtable.h
	clang -c symtable.c

.PHONY: clean
clean: 
	rm *.o scientific_calc_semantic.tab.c scientific_calc_semantic.tab.h lex.yy.c calc parser.png y.dot *~ \.*un~
