CCC = g++
CCFLAGS= -O2
LEX = flex
LFLAGS= -8
YACC = bison
YFLAGS= -d -t -y

emerald: y.tab.o lex.yy.o ast.o
	${CCC} ${CCFLAGS} lex.yy.o y.tab.o -o emerald -lfl

ast.o: ast.cpp ast.h
	${CCC} -c ast.cpp

y.tab.o: parser.y
	${YACC} ${YFLAGS} parser.y
	${CCC} ${CCFLAGS} y.tab.c -c
	
lex.yy.o: lexer.l
	${LEX} ${LFLAGS} lexer.l
	${CCC} ${CCFLAGS} lex.yy.c -c
	
clean:
	rm a.out lex.yy.c y.tab.* *.o 