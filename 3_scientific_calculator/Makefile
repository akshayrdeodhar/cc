calc: lex.yy.o y.tab.o
	clang lex.yy.o y.tab.o -lfl -ly -o calc

lex.yy.c: scientific_calc.l
	flex scientific_calc.l

.PHONY: yaccop

yaccop: scientific_calc.y
	bison -y -d scientific_calc.y

y.tab.h: yaccop

y.tab.c: yaccop

lex.yy.o: lex.yy.c y.tab.h
	clang -c lex.yy.c

y.tab.o: y.tab.c y.tab.h
	clang -c y.tab.c 

.PHONY: clean
clean: 
	rm *.o y.tab.c y.tab.h lex.yy.c calc
