LIBS = -ly -ll
CC = gcc -g
LEX = flex
YACC = bison


sql1:	sql1.o scn1.o
	${CC} -o $@ sql1.o scn1.o ${LIBS}

sql1.c sql1.h:	sql1.y
	${YACC} -y -d -t sql1.y
	mv y.tab.h sql1.h
	mv y.tab.c sql1.c

scn1.o:	sql1.h scn1.c
	${CC} -c scn1.c

sql1.o: sql1.c sql1.h
	${CC} -c sql1.c

scn1.c: scn1.l
	${LEX} scn1.l 
	mv lex.yy.c scn1.c

clean:
	rm *.c *.o *.out *.h *~ sql1 sql1.output
