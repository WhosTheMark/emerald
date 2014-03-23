
%{
#include <string>
#include "scanner.hpp"
#include <stdio.h>
#include "parser.tab.h"

typedef yy::Parser::token token;

#define strToken(s) ( new std::string(s) )
#define YY_USER_ACTION yylloc->columns(yyleng);

%}

%option yylineno
%option debug
%option nodefault
%option yyclass="Scanner"
%option noyywrap
%option c++

DIGIT [0-9]

%%

%{
   yylloc->step();
%}

boolbasaur      { yylval->ids = strToken(yytext); return token::tk_boolType; }

intmonchan      { yylval->ids = strToken(yytext); return token::tk_intType; }

charizard       { yylval->ids = strToken(yytext); return token::tk_charType; }

floatzel        { yylval->ids = strToken(yytext); return token::tk_floatType; }

onix            { yylval->ids = strToken(yytext); return token::tk_stringType; }

registeer       { yylval->ids = strToken(yytext); return token::tk_structType; }

unown           { yylval->ids = strToken(yytext); return token::tk_unionType; }

voidporeon      { yylval->ids = strToken(yytext); return token::tk_voidType; }

if              { return token::tk_if; }

else            { return token::tk_else; }

elsif           { return token::tk_elsif; }

for             { return token::tk_for; }

from            { return token::tk_from; }

to              { return token::tk_to; }

by              { return token::tk_by; }

while           { return token::tk_while; }

BOOM            { return token::tk_break; }

continue        { return token::tk_continue; }

switch          { return token::tk_switch; }

case            { return token::tk_case; }

default         { return token::tk_default; }

return          { return token::tk_return; }

const           { return token::tk_const; }

var             { return token::tk_var; }

true            { return token::tk_true; }

false           { return token::tk_false; }

tag             { return token::tk_tag; }

"%"             { yylval->strOp = yytext; return token::tk_mod; }

"<"             { yylval->strOp = yytext; return token::tk_lessThan; }

"<="            { yylval->strOp = yytext; return token::tk_lessEq; }

">"             { yylval->strOp = yytext; return token::tk_moreThan; }

">="            { yylval->strOp = yytext; return token::tk_moreEq; }

"!="            { yylval->strOp = yytext; return token::tk_notEqual; }

"&&"            { yylval->strOp = yytext; return token::tk_and; }

"||"            { yylval->strOp = yytext; return token::tk_or; }

":="            { yylval->strOp = yytext; return token::tk_asignment; }

".."            { yylval->strOp = yytext; return token::tk_range; }

"."             { yylval->strOp = yytext; return token::tk_dot; }

";"             { return token::tk_semicolon; }

","             { return token::tk_comma; } 

":"             { return token::tk_colon; }

"->"            { return token::tk_arrow; }

"!" | 
"-" |
"^" | 
"*" |            
"/" | 
"=" |            
"+" | 
"(" |            
")" | 
"{" |          
"}" | 
"[" |          
"]"             { yylval->strOp = yytext; return yytext[0]; }


{DIGIT}+                  { yylval->intNum = atoi(yytext); return token::tk_int; }

{DIGIT}+\.{DIGIT}+        { yylval->floatNum = atof(yytext); return token::tk_float;}

[a-zA-Z_][a-zA-Z0-9_]*    { yylval->ident = strToken(yytext); return token::tk_identifier;}

#(.|[^\n])*               { yylloc->lines(1); /* Comentario simple */ }

\"(\\.|[^\"\\])*\"        { yylval->str = yytext; return token::tk_string; }

\'(\\.|[^\'\\])\'         { yylval->chars = yytext[1]; return token::tk_char; }

\n                        { yylloc->lines(1); }

[ \t]                     { yylloc->step(); }

\/\*([^*]|\*+[^/*])*\*+\/ { yylloc->step(); /* Cometario en bloque */ }

.                       { std::cout << "Error: " << yytext << "\n"; /*yyerror("KABOOM: %s\n", *yytext);*/}

%%
/*
main(int argc, char **argv) {

   if(argc > 1) 
      if(!(yyin = fopen(argv[1], "r"))){
         perror(argv[1]);
         return(-1);
      }
      
      
    yylex();
    fclose(yyin);
    
}*/
/*
int yywrap() {return 1; }


*/

//#undef yyFlexLexer























   