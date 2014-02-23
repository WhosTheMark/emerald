all: a.out
a.out: lexer.l
	 flex lexer.l
	 cc lex.yy.c -lfl
	 
clean: 
	rm a.out lex.yy.c