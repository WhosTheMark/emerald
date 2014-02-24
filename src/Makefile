all: a.out
a.out: lexer.l parser.y
	bison -d parser.y --report=all
	flex lexer.l
	cc -o $@ parser.tab.c lex.yy.c -lfl
	 
clean: 
	rm a.out lex.yy.c parser.tab.c parser.tab.h