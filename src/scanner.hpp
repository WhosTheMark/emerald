#ifndef __SCANNER_HPP__
#define __SCANNER_HPP__ 1

#if ! defined(yyFlexLexerOnce)
#include <FlexLexer.h>
#endif

#undef YY_DECL
#define YY_DECL int Scanner::yylex()

#include "parser.tab.h"

class Scanner : public yyFlexLexer {
public:
   
   Scanner(std::istream *in) : yyFlexLexer(in), yylval(nullptr) {};
   
   int yylex(yy::Parser::semantic_type *lval) {
      
      yylval = lval;
      return yylex();
   }
   
private:
   
   int yylex();
   yy::Parser::semantic_type *yylval;
   
};

#endif 