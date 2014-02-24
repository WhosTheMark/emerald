%option yylineno

%{

#include <stdio.h>
#include "parser.tab.h"

%}

DIGIT [0-9]

%%

boolbasaur      { return tk_boolType; }

intmonchan      { return tk_intType; }

charizard       { return tk_charType; }

floatzel        { return tk_floatType; }

onix            { return tk_stringType; }

registeer       { return tk_structType; }

unown           { return tk_unionType; }

voidporeon      { return tk_voidType; }

if              { return tk_if; }

else            { return tk_else; }

for             { return tk_for; }

from            { return tk_from; }

to              { return tk_to; }

by              { return tk_by; }

while           { return tk_while; }

read            { return tk_read; }

print           { return tk_print; }

println         { return tk_println; }

BOOM            { return tk_break; }

continue        { return tk_continue; }

switch          { return tk_switch; }

case            { return tk_case; }

default         { return tk_default; }

return          { return tk_return; }

const           { return tk_const; }

var             { return tk_var; }

true            { return tk_true; }

false           { return tk_false; }

"!"             { return tk_negation; }

"-"             { return tk_minus; }

"^"             { return tk_power; }

"*"             { return tk_multi; }

"/"             { return tk_division; }

"%"             { return tk_mod; }

"+"             { return tk_plus; }

"<"             { return tk_lessThan; }

"<="            { return tk_lessEq; }

">"             { return tk_moreThan; }

">="            { return tk_moreEq; }

"="             { return tk_equal; }

"!="            { return tk_notEqual; }

"&&"            { return tk_and; }

"||"            { return tk_or; }

":="            { return tk_asignment; }

".."            { return tk_range; }

"."             { return tk_dot; }

";"             { printf("hola"); return tk_semicolon; }

"("             { return tk_LParenthesis; }

")"             { return tk_RParenthesis; }

"{"             { return tk_LCurly; }

"}"             { return tk_RCurly; }

"["             { return tk_LBracket; }

"]"             { return tk_RBracket; }

","             { return tk_comma; }

{DIGIT}+                  { yylval.intNum = atoi(yytext); return tk_int; }

{DIGIT}+.{DIGIT}+         { yylval.floatNum = atof(yytext); return tk_float;}

[a-zA-Z_][a-zA-Z0-9_]*    { yylval.ident = yytext; return tk_identifier;}

#(.|[^\n])*               { /* Comentario simple */ }

\"(\\.|[^\"\\])*\"        { yylval.str = yytext; return tk_string; }

\'(\\.|[^\'\\])\'         { yylval.chars = yytext[1]; return tk_char; }

[\n \t]                   {}

\/\*([^*]|\*+[^/*])*\*+\/ { /* Cometario en bloque */ }

.                       { /*yyerror("KABOOM: %s\n", *yytext);*/}

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




























   