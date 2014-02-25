%option yylineno

%{

#include <stdio.h>
#include "parser.tab.hh"

extern "C" {int yylex(&YYLTYPE, &semantic_type);}
extern YYLTYPE yylloc;
extern semantic_type yylval;

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

"%"             { yylval.strOp = yytext; return tk_mod; }

"<"             { yylval.strOp = yytext; return tk_lessThan; }

"<="            { yylval.strOp = yytext; return tk_lessEq; }

">"             { yylval.strOp = yytext; return tk_moreThan; }

">="            { yylval.strOp = yytext; return tk_moreEq; }

"!="            { yylval.strOp = yytext; return tk_notEqual; }

"&&"            { yylval.strOp = yytext; return tk_and; }

"||"            { yylval.strOp = yytext; return tk_or; }

":="            { yylval.strOp = yytext; return tk_asignment; }

".."            { yylval.strOp = yytext; return tk_range; }

"."             { yylval.strOp = yytext; return tk_dot; }

";"             { return tk_semicolon; }

","             { return tk_comma; }

"!" | "-" |
"^" | "*" |            
"/" | "=" |            
"+" | "(" |            
")" | "{" |          
"}" | "[" |          
"]"             { yylval.strOp = yytext; return yytext[0]; }


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
/*
int yywrap() {return 1; }


*/























   