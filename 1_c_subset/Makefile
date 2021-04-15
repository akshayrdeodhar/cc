clexer: lex.yy.c
	clang lex.yy.c -lfl -o clexer

lex.yy.c: clexer.l
	flex clexer.l

clean:
	rm lex.yy.c clexer
