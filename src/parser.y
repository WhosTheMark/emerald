
%{

#include <stdio.h>
void yyerror (char const *);
int yylex();
extern FILE *yyin;

%}

%union{
   
   int intNum;
   float floatNum;
   char* ident;
   char* str;
   char chars;  

}


%token tk_booltype tk_boolType  tk_intType  tk_charType  tk_floatType  
%token tk_stringType  tk_structType  tk_unionType  tk_voidType  
%token tk_if  tk_else  tk_for  tk_from  tk_to  tk_by  tk_while  
%token tk_read  tk_print  tk_println  tk_break  tk_continue  tk_switch  
%token tk_case  tk_default  tk_return  tk_const  tk_var  tk_true  tk_false   
%token tk_lessThan  tk_lessEq  tk_moreThan  tk_moreEq  tk_equal tk_mod  
%token tk_notEqual  tk_and  tk_or  tk_asignment  tk_range  tk_dot  tk_semicolon  
%token tk_comma  tk_int  tk_float  tk_identifier  tk_string  tk_char  

%left tk_or
%left tk_and
%nonassoc '=' tk_notEqual
%nonassoc tk_moreEq tk_moreThan tk_lessEq tk_lessThan
%left '+' '-'
%left '*' '/' tk_mod
%right '^'
%nonassoc '!' UMINUS 
%left tk_dot

%%
   START: EXPR ;
   
   EXPR: EXPR '+' EXPR 
       | EXPR '-' EXPR
       | EXPR '*' EXPR
       | EXPR '/' EXPR
       | EXPR '^' EXPR
       | EXPR '=' EXPR
       //| EXPR '[' EXPR ']'
       | EXPR tk_mod EXPR
       | EXPR tk_and EXPR
       | EXPR tk_or EXPR
       | EXPR tk_lessEq EXPR
       | EXPR tk_moreEq EXPR
       | EXPR tk_lessThan EXPR
       | EXPR tk_moreThan EXPR
       | EXPR tk_notEqual EXPR 
       | EXPR tk_dot tk_identifier
       | '!' EXPR
       | '-' EXPR %prec UMINUS  
       | '(' EXPR ')'
       | NUMBER
       | BOOLEAN 
       | tk_identifier 
       | tk_char 
       | tk_string ; 
       
   NUMBER: tk_int
         | tk_float ; 
         
   BOOLEAN: tk_true 
          | tk_false ;
       
   //FOR: tk_for tk_identifier tk_from   

%%

main(int argc, char **argv) {

   if(argc > 1) 
      if(!(yyin = fopen(argv[1], "r"))){
         perror(argv[1]);
         return(-1);
      }
      
      
    yyparse();
    fclose(yyin);
    
}


void yyerror(char const *s) {

  fprintf(stderr, "%s\n", s);
}
