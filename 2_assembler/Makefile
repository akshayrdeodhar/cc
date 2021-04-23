tas: lex.yy.o y.tab.o symtable.o
	clang lex.yy.o y.tab.o symtable.o -lfl -ly -lm -g -fsanitize=address -o tas 

lex.yy.c: assembler.l 
	flex assembler.l

.PHONY: yaccop

yaccop: assembler.y symtable.h
	bison -y -d -t -g assembler.y

y.tab.h: yaccop

y.tab.c: yaccop

lex.yy.o: lex.yy.c y.tab.h
	clang -c lex.yy.c

y.tab.o: y.tab.c y.tab.h
	clang -c y.tab.c 

symtable.o: symtable.c symtable.h
	clang -c symtable.c

.PHONY: clean
clean: 
	rm *.o y.tab.c y.tab.h lex.yy.c calc parser.png y.dot *~ \.*un~
