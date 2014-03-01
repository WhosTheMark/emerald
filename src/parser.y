%skeleton "lalr1.cc"
%require "2.7"
%debug
%defines
%define parser_class_name "Parser"

%code requires{
   class Driver;
   class Scanner;
}

%lex-param { Scanner &scanner }
%parse-param { Scanner &scanner }

%lex-param { Driver &driver }
%parse-param { Driver &driver }

%code{

   #include <iostream>
   #include <cstdlib>
   #include <fstream>
   #include <math.h>
   #include "driver.hpp"
   
   static int yylex(yy::Parser::semantic_type *yylval, 
                    Scanner &scanner, Driver &driver);
   //#include <stdio.h>
   //void yyerror (char const *);
   //int yylex();
   //extern FILE *yyin;

}

%union{
   
   int intNum;
   float floatNum;
   char* ident;
   char* str;
   char chars; 
   char* strOp;
   int token;

}

%type <intNum> tk_int EXPR NUMBER


%token tk_boolType tk_intType  tk_charType  tk_floatType  
%token tk_stringType  tk_structType  tk_unionType  tk_voidType  
%token tk_if  tk_else tk_elsif tk_for  tk_from  tk_to  tk_by  tk_while  
%token tk_read  tk_print  tk_println  tk_break  tk_continue  tk_switch  
%token tk_case  tk_default  tk_return  tk_const  tk_var  tk_true  tk_false   
%token tk_lessThan  tk_lessEq  tk_moreThan  tk_moreEq  tk_equal tk_mod  
%token tk_notEqual  tk_and  tk_or  tk_asignment  tk_range  tk_dot  tk_semicolon  
%token tk_comma  tk_int  tk_float  tk_identifier  tk_string  tk_char  

%left tk_or
%left tk_and
%nonassoc '=' tk_notEqual
%nonassoc tk_moreEq tk_moreThan tk_lessEq tk_lessThan tk_range
%left '+' '-'
%left '*' '/' tk_mod
%right '^'
%nonassoc '!' UMINUS 
%left tk_dot
%right '['
%nonassoc IFPREC
%nonassoc tk_elsif
%nonassoc tk_else 

%%
   START
      : STMT { /*std::cout << "Result: " << $1 << "\n";*/ } ; 
   
   EXPR
      : EXPR '+' EXPR { $$ = $1 + $3; }
      | EXPR '-' EXPR { $$ = $1 - $3; }
      | EXPR '*' EXPR { $$ = $1 * $3; }
      | EXPR '/' EXPR { $$ = $1 / $3; }
      | EXPR '^' EXPR { $$ = pow($1,$3); } 
      | EXPR '=' EXPR
      | EXPR '[' EXPR ']'  {$$ = pow($1,$3); std::cout << "[\n"; }
      | EXPR tk_range EXPR 
      | EXPR tk_mod EXPR
      | EXPR tk_and EXPR
      | EXPR tk_or EXPR
      | EXPR tk_lessEq EXPR
      | EXPR tk_moreEq EXPR
      | EXPR tk_lessThan EXPR
      | EXPR tk_moreThan EXPR
      | EXPR tk_notEqual EXPR 
      | EXPR tk_dot tk_identifier
      | tk_identifier '(' ARGS ')' // lista de expresiones
      | '!' EXPR
      | '-' EXPR %prec UMINUS  { $$ = -$2; }
      | '(' EXPR ')' { $$ = $2; }
      | NUMBER
      | BOOLEAN 
      | tk_identifier 
      | tk_char 
      | tk_string ; 
      
   NUMBER
      : tk_int { $$ = $1; std::cout << $1 << "\n"; }
      | tk_float ;  
         
   BOOLEAN
      : tk_true 
      | tk_false ;
      
   ARGS
      : /* vacio */
      | ARGSLIST ;
      
   ARGSLIST
      : EXPR
      | ARGSLIST tk_comma EXPR ;

   STMT
      : IFSTMT 
      | ASIGNMENT ;
      
   ASIGNMENT
      : tk_identifier tk_asignment EXPR ;
      
   IFSTMT
      : tk_if EXPR STMT %prec IFPREC
      | tk_if EXPR STMT IFLIST ;
      
   IFLIST
      : tk_else STMT 
      | tk_elsif EXPR STMT 
      | tk_elsif EXPR STMT IFLIST ;
    

     
 
       
   //FOR: tk_for tk_identifier tk_from   

%%

void yy::Parser::error(const yy::Parser::location_type &l, const std::string &err_msg) {
   std::cerr << "Error: " << err_msg << "\n";
}

#include "scanner.hpp"
static int yylex(yy::Parser::semantic_type *yylval, Scanner &scanner, Driver &driver) {
   return scanner.yylex(yylval);
}


/*
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
*/