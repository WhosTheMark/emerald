%skeleton "lalr1.cc"
%require "2.7"
%debug
%defines
%locations

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
   
   static int yylex(yy::Parser::semantic_type *yylval, yy::Parser::location_type *yylloc, Scanner &scanner, Driver &driver);
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

//%type <intNum> tk_int EXPR NUMBER


%token tk_boolType tk_intType  tk_charType  tk_floatType  
%token tk_stringType  tk_structType  tk_unionType  tk_voidType  
%token tk_if  tk_else tk_elsif tk_for  tk_from  tk_to  tk_by  tk_while  
%token tk_break  tk_continue  tk_switch  tk_colon tk_tag tk_arrow
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
      : DEFLIST { /*std::cout << "Result: " << $1 << "\n";*/ } ; 
   
   DEFLIST
      : DEFINITION
      | DEFINITION DEFLIST ;
   
   DEFINITION
      : FUNCDEF 
      | REGISTER
      | DECLARATION ;
      
   EXPR
      : EXPR '+' EXPR 
      | EXPR '-' EXPR 
      | EXPR '*' EXPR 
      | EXPR '/' EXPR 
      | EXPR '^' EXPR 
      | EXPR '=' EXPR
      | EXPR '[' EXPR ']' 
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
      | CONST 
      | FUNCCALL
      | tk_identifier  
      | tk_string ; 
      
   CONST
      : NUMBER
      | BOOLEAN
      | tk_char ;
      
   NUMBER
      : tk_int 
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

   INST
      : STMT 
      | BLOCK ;
      
   STMT
      : IFSTMT 
      | ASIGNMENT 
      | WHILESTMT 
      | FORSTMT 
      | FUNCCALL
      | BREAK 
      | CONTINUE 
      | LABEL 
      | RETURN 
      | SWITCHSTMT ;
      
   BLOCK
      : '{' STMTLIST '}' 
      | '{' DECLARELIST STMTLIST '}' ;

   STMTLIST
      : STMT   
      | STMT tk_semicolon STMTLIST ;
      
   ASIGNMENT
      : ASIGNLIST tk_asignment ARGSLIST ;
      
   ASIGNLIST
      : tk_identifier ARRDOT
      | tk_identifier ARRDOT tk_comma ASIGNLIST ;
      
   ARRDOT
      : /* vacio */
      | '[' EXPR ']' ARRDOT 
      | tk_dot tk_identifier ARRDOT ;      
      
   IFSTMT
      : tk_if EXPR INST %prec IFPREC
      | tk_if EXPR INST IFLIST ;
      
   IFLIST
      : tk_else INST 
      | tk_elsif EXPR INST 
      | tk_elsif EXPR INST IFLIST ;
    
   WHILESTMT
      : tk_while EXPR INST ;
      
   FORSTMT
      : tk_for tk_identifier tk_from EXPR tk_to EXPR tk_by EXPR INST
      | tk_for tk_identifier tk_from EXPR tk_to EXPR INST ;

   FUNCCALL
      : tk_identifier '(' ARGS ')' ;
      
   BREAK
      : tk_break
      | tk_break tk_identifier ;
      
   CONTINUE
      : tk_continue
      | tk_continue tk_identifier ;
      
   LABEL
      : tk_tag tk_colon tk_identifier ;
      
   RETURN
      : tk_return
      | tk_return EXPR ;
      
   SWITCHSTMT
      : tk_switch EXPR '{' CASE '}' ;
      
   CASE
      : tk_case CONST tk_arrow BLOCK
      | tk_case CONST tk_arrow BLOCK CASELIST ; 
      
   CASELIST
      : tk_default tk_arrow BLOCK 
      | tk_case CONST tk_arrow BLOCK
      | tk_case CONST tk_arrow BLOCK CASELIST ; 
      
   DECLARATION
      : TYPE IDLIST INITLIST tk_semicolon 
      | COMPLEXTYPE IDLIST INITLIST tk_semicolon;
      
   IDLIST   
      : tk_identifier ARRAYDECL
      | tk_identifier ARRAYDECL tk_comma IDLIST 
      | tk_const tk_identifier ARRAYDECL
      | tk_const tk_identifier ARRAYDECL tk_comma IDLIST ;
     
   ARRAYDECL
      : /* vacio */
      | '[' EXPR tk_range EXPR ']' ;
     
     
   DECLARELIST
      : DECLARATION 
      | DECLARELIST DECLARATION;
   
   INITLIST 
      : /* vacio */
      | tk_asignment ARGSLIST ;
      
   TYPE
      : tk_intType
      | tk_floatType
      | tk_boolType
      | tk_charType
      | tk_stringType;      
      
   COMPLEXTYPE
      : tk_unionType tk_identifier
      | tk_structType tk_identifier ;
     
   VAR
      : /* vacio */
      | tk_var ;
 
   REGISTER
      : tk_structType tk_identifier '{' DECLARELIST '}' ;
      
   FUNCDEF
      : TYPE tk_identifier '(' ')' BLOCK
      | tk_voidType tk_identifier '(' ')' BLOCK
      | TYPE tk_identifier '(' ARGSDEF ')' BLOCK 
      | tk_voidType tk_identifier '(' ARGSDEF ')' BLOCK ; 
      
   ARGSDEF
      : TYPE VAR tk_identifier
      | TYPE VAR tk_identifier tk_comma ARGSDEF ;
 
%%

void yy::Parser::error(const yy::Parser::location_type &l, const std::string &err_msg) {
   std::cerr << "Error: " << l << "\n";
}

#include "scanner.hpp"
static int yylex(yy::Parser::semantic_type *yylval, yy::Parser::location_type *yylloc, Scanner &scanner, Driver &driver) {
   return scanner.yylex(yylval,yylloc);
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