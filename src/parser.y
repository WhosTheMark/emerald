
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
%token tk_negation  tk_minus  tk_power  tk_multi  tk_division  tk_mod  
%token tk_plus  tk_lessThan  tk_lessEq  tk_moreThan  tk_moreEq  tk_equal  
%token tk_notEqual  tk_and  tk_or  tk_asignment  tk_range  tk_dot  tk_semicolon  
%token tk_LParenthesis  tk_RParenthesis  tk_LCurly  tk_RCurly  tk_LBracket  
%token tk_RBracket  tk_comma  tk_int  tk_float  tk_identifier  tk_string  tk_char  


%%
   start: tk_semicolon ;

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
