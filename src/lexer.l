%{

#include <stdio.h>

%}

DIGIT [0-9]

%%

boolbasaur      { printf("boolType\n"); }

intmonchan      { printf("intType\n"); }

charizard       { printf("charType\n"); }

floatzel        { printf("floatType\n"); }

onix            { printf("stringType\n"); }

registeer       { printf("structType\n"); }

unown           { printf("unionType\n"); }

voidporeon      { printf("voidType\n"); }

if              { printf("if\n"); }

else            { printf("else\n"); }

for             { printf("for\n"); }

from            { printf("from\n"); }

to              { printf("to\n"); }

by              { printf("by\n"); }

while           { printf("while\n"); }

read            { printf("read\n"); }

print           { printf("print\n"); }

println         { printf("println\n"); }

BOOM            { printf("break\n"); }

continue        { printf("continue\n"); }

switch          { printf("switch\n"); }

case            { printf("case\n"); }

default         { printf("default\n"); }

return          { printf("return\n"); }

const           { printf("const\n"); }

var             { printf("var\n"); }

true            { printf("true\n"); }

false           { printf("false\n"); }

"!"             { printf("negation\n"); }

"-"             { printf("minus\n"); }

"^"             { printf("power\n"); }

"*"             { printf("multi\n"); }

"/"             { printf("division\n"); }

"%"             { printf("mod\n"); }

"+"             { printf("plus\n"); }

"<"             { printf("lessThan\n"); }

"<="            { printf("lessEq\n"); }

">"             { printf("moreThan\n"); }

">="            { printf("moreEq\n"); }

"="             { printf("equal\n"); }

"!="            { printf("notEqual\n"); }

"&&"            { printf("and\n"); }

"||"            { printf("or\n"); }

":="            { printf("asignment\n"); }

".."            { printf("range\n"); }

"."             { printf("dot\n"); }

";"             { printf("semicolon\n"); }

"("             { printf("LParenthesis\n"); }

")"             { printf("RParenthesis\n"); }

"{"             { printf("LCurly\n"); }

"}"             { printf("RCurly\n"); }

"["             { printf("LBracket\n"); }

"]"             { printf("RBracket\n"); }

","             { printf("comma\n"); }

{DIGIT}+                  { printf("%d\n", atoi(yytext)); }

{DIGIT}+.{DIGIT}+         { printf("%f\n", atof(yytext)); }

[a-zA-Z_][a-zA-Z0-9_]*    { printf("%s\n", yytext); }

#(.|[^\n])*               { printf("%s\n", yytext); }

\"(\\.|[^\"\\])*\"        { printf("%s\n", yytext); }

\'(\\.|[^\'\\])\'         { printf("%s\n", yytext); }

[\n \t]                   {}

\/\*([^*]|\*+[^/*])*\*+\/ { printf("%s\n", yytext); }

.                       { printf("NO SE NADA: %s\n", yytext); }

%%

main(int argc, char **argv) {


   if(argc > 1) 
      if(!(yyin = fopen(argv[1], "r"))){
         perror(argv[1]);
         return(-1);
      }
      
      
    yylex();
    fclose(yyin);
    
}




























   