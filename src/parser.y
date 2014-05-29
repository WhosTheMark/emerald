%skeleton "lalr1.cc"
%require "2.5"
%debug
%defines
%locations

%define parser_class_name "Parser"

%code requires{
   #include "symbol.cpp"
   class Driver;
   class Scanner;
   class TableTree;
   extern int errorCount;
}

%lex-param { Scanner &scanner }
%parse-param { Scanner &scanner }

%lex-param { Driver &driver }
%parse-param { Driver &driver }

%lex-param { TableTree &scopeTree }
%parse-param { TableTree &scopeTree }

%lex-param { TupleFactory &tupleFactory }
%parse-param { TupleFactory &tupleFactory }

%code{

   #include <iostream>
   #include <cstdlib>
   #include <fstream>
   #include <math.h>
   #include "driver.hpp"
   #include <vector>
   #include <string>

   static int yylex(yy::Parser::semantic_type *yylval, yy::Parser::location_type *yylloc,
   Scanner &scanner, Driver &driver, TableTree &scopeTree, TupleFactory &tupleFactory);
   typedef std::vector<std::pair<std::string*,yy::position>*> vecString;
   typedef std::vector<std::pair<std::string,Declaration*>*> vecFunc;
   vector<Declaration*> declList;
   Function *funcAux;
   map<string,Type*> fields;
   map<string,Declaration*> decls;
   Type_Error *typeError = new Type_Error();
   vector<Type*> typeList;
   ArrayFactory *arrayFactory = new ArrayFactory();
   int globalOffset = 0;
   int currentOffset = 0; 

}

%union{

   int intNum;
   float floatNum;
   std::string* ident;
   char* str;
   char chars;
   char* strOp;
   int token;
   std::string* ids;
   std::vector<Declaration*> *idsList;
   bool boolean;
   std::vector<std::pair<std::string,Declaration*>*> *vecFunction;
   std::pair<std::string,std::string> *complex;
   Declaration *declr;
   Function *funct;
   std::vector<std::pair<std::string,Type*>*> *vecFields;
   std::pair<int,int> *range;
   Type *typeCheck;
}

%type <idsList> IDLIST
%type <ids> tk_identifier TYPE tk_charType tk_floatType tk_intType tk_boolType tk_stringType
%type <ids> tk_structType tk_unionType tk_voidType
%type <complex> COMPLEXTYPE
%type <boolean> VAR
%type <vecFunction> ARGSDEF
%type <declr> ARG
%type <funct> FUNC
%type <vecFields> FIELD FIELDS
%type <range> ARRAYDECL
%type <intNum> tk_int
%type <typeCheck> EXPR CONST NUMBER BOOLEAN FUNCCALL SWITCHSTMT CASELIST CASE


%token tk_boolType tk_intType  tk_charType  tk_floatType
%token tk_stringType  tk_structType  tk_unionType  tk_voidType
%token tk_if  tk_else tk_elsif tk_for  tk_from  tk_to  tk_by  tk_while
%token tk_break  tk_continue  tk_switch  tk_colon tk_tag tk_arrow
%token tk_case  tk_default  tk_return  tk_const  tk_var  tk_true  tk_false
%token tk_lessThan  tk_lessEq  tk_moreThan  tk_moreEq tk_mod
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
      : { scopeTree.enterScope(); } DEFLIST { scopeTree.exitScope(); }
      ;

   DEFLIST
      : DEFINITION
      | DEFINITION DEFLIST
      ;

   DEFINITION
      : FUNCDEF
      | REGISTER
      | UNION
      | DECLARATION
      ;

   EXPR
      : EXPR '+' EXPR               {  Symbol *symInt = (scopeTree.lookup("intmonchan"))->second;
                                       Symbol *symFloat = (scopeTree.lookup("floatzel"))->second;
                                       Basic *b1 = dynamic_cast<Basic*>($1);
                                       if (($1 == $3 && (b1 == symInt || b1 == symFloat)) || ($1 == typeError && $3 == typeError))
                                          $$ = $1;
                                       else {

                                          Basic *b2 = dynamic_cast<Basic*>($3);

                                          if ($1 != typeError && (b1 != symInt && b1 != symFloat)) {
                                             ++errorCount;
                                             cout << "Type error using operator '+' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The left expression is ";
                                             cout << "not intmonchan or floatzel type.\n";
                                          }

                                          if ($3 != typeError && (b2 != symInt && b2 != symFloat)) {
                                             ++errorCount;
                                             cout << "Type error using operator '+' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The right expression is ";
                                             cout << "not intmonchan or floatzel type.\n";
                                          }

                                          if ($1 != $3 && $1 != typeError && $3 != typeError) {
                                             ++errorCount;
                                             cout << "Type Error using operator '+' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The types of the ";
                                             cout << "expressions do not match.\n";
                                          }

                                          $$ = typeError;
                                       }

                                    }

      | EXPR '-' EXPR               {  Symbol *symInt = (scopeTree.lookup("intmonchan"))->second;
                                       Symbol *symFloat = (scopeTree.lookup("floatzel"))->second;
                                       Basic *b1 = dynamic_cast<Basic*>($1);
                                       if (($1 == $3 && (b1 == symInt || b1 == symFloat)) || ($1 == typeError && $3 == typeError))
                                          $$ = $1;
                                       else {

                                          Basic *b2 = dynamic_cast<Basic*>($3);

                                          if ($1 != typeError && (b1 != symInt && b1 != symFloat)) {
                                             ++errorCount;
                                             cout << "Type error using operator '-' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The left expression is ";
                                             cout << "not intmonchan or floatzel type.\n";
                                          }

                                          if ($3 != typeError && (b2 != symInt && b2 != symFloat)) {
                                             ++errorCount;
                                             cout << "Type error using operator '-' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The right expression is ";
                                             cout << "not intmonchan or floatzel type.\n";
                                          }

                                          if ($1 != $3 && $1 != typeError && $3 != typeError) {
                                             ++errorCount;
                                             cout << "Type Error using operator '-' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The types of the ";
                                             cout << "expressions do not match.\n";
                                          }

                                          $$ = typeError;
                                       }

                                    }
      | EXPR '*' EXPR               {  Symbol *symInt = (scopeTree.lookup("intmonchan"))->second;
                                       Symbol *symFloat = (scopeTree.lookup("floatzel"))->second;
                                       Basic *b1 = dynamic_cast<Basic*>($1);
                                       if (($1 == $3 && (b1 == symInt || b1 == symFloat)) || ($1 == typeError && $3 == typeError))
                                          $$ = $1;
                                       else {

                                          Basic *b2 = dynamic_cast<Basic*>($3);

                                          if ($1 != typeError && (b1 != symInt && b1 != symFloat)) {
                                             ++errorCount;
                                             cout << "Type error using operator '*' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The left expression is ";
                                             cout << "not intmonchan or floatzel type.\n";
                                          }

                                          if ($3 != typeError && (b2 != symInt && b2 != symFloat)) {
                                             ++errorCount;
                                             cout << "Type error using operator '*' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The right expression is ";
                                             cout << "not intmonchan or floatzel type.\n";
                                          }

                                          if ($1 != $3 && $1 != typeError && $3 != typeError) {
                                             ++errorCount;
                                             cout << "Type Error using operator '*' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The types of the ";
                                             cout << "expressions do not match.\n";
                                          }

                                          $$ = typeError;
                                       }

                                    }
      | EXPR '/' EXPR               {  Symbol *symInt = (scopeTree.lookup("intmonchan"))->second;
                                       Symbol *symFloat = (scopeTree.lookup("floatzel"))->second;
                                       Basic *b1 = dynamic_cast<Basic*>($1);
                                       if (($1 == $3 && (b1 == symInt || b1 == symFloat)) || ($1 == typeError && $3 == typeError))
                                          $$ = $1;
                                       else {

                                          Basic *b2 = dynamic_cast<Basic*>($3);

                                          if ($1 != typeError && (b1 != symInt && b1 != symFloat)) {
                                             ++errorCount;
                                             cout << "Type error using operator '/' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The left expression is ";
                                             cout << "not intmonchan or floatzel type.\n";
                                          }

                                          if ($3 != typeError && (b2 != symInt && b2 != symFloat)) {
                                             ++errorCount;
                                             cout << "Type error using operator '/' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The right expression is ";
                                             cout << "not intmonchan or floatzel type.\n";
                                          }

                                          if ($1 != $3 && $1 != typeError && $3 != typeError) {
                                             ++errorCount;
                                             cout << "Type Error using operator '/' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The types of the ";
                                             cout << "expressions do not match.\n";
                                          }

                                          $$ = typeError;
                                       }

                                    }
      | EXPR '^' EXPR               {  Symbol *symInt = (scopeTree.lookup("intmonchan"))->second;
                                       Symbol *symFloat = (scopeTree.lookup("floatzel"))->second;
                                       Basic *b1 = dynamic_cast<Basic*>($1);
                                       Basic *b2 = dynamic_cast<Basic*>($3);
                                       if (((b1 == symInt || b1 == symFloat) && b2 == symInt) || ($1 == typeError && $3 == typeError))
                                          $$ = $1;
                                       else {

                                          if ($1 != typeError && (b1 != symInt && b1 != symFloat)) {
                                             ++errorCount;
                                             cout << "Type error using operator '^' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The left expression is ";
                                             cout << "not intmonchan or floatzel type.\n";
                                          }

                                          if ($3 != typeError && b2 != symInt) {
                                             ++errorCount;
                                             cout << "Type error using operator '^' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The right expression is ";
                                             cout << "not intmonchan type.\n";
                                          }

                                          $$ = typeError;
                                       }

                                    }
      | EXPR '=' EXPR               {  Symbol *sym = (scopeTree.lookup("voidporeon"))->second;
                                       if ($1 == $3 && $1 != typeError && sym != (dynamic_cast<Basic*>($1)))
                                          $$ = (Boolean*)((scopeTree.lookup("boolbasaur"))->second);

                                       else if ($1 != typeError && $3 != typeError) {
                                          ++errorCount;
                                          cout << "Type Error using operator '=' at line: " << @2.begin.line;
                                          cout << ", column: " << @2.begin.column << ". The types of the ";
                                          cout << "expressions do not match.\n";
                                          $$ = typeError;
                                       } else
                                          $$ = typeError;

                                    }
      | EXPR '=''=' EXPR            {  ++errorCount;
                                       cout << "Error: Perhaps you meant \"=\" instead of \"==\" at line: ";
                                       cout << @2.begin.line << ", column: " << @2.begin.column << ".\n";
                                       $$ = typeError;
                                    }
      | EXPR '[' EXPR ']'           {  Array_Type *array = dynamic_cast<Array_Type*>($1);
                                       Symbol *symInt = (scopeTree.lookup("intmonchan"))->second;
                                       Basic *b = dynamic_cast<Basic*>($3);
                                       if (array != 0 && b == symInt){
                                          $$ = array->elemType;
                                       } else {

                                          if ($1 != typeError && array == 0) {
                                             ++errorCount;
                                             cout << "Type error using operator '[]' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The left expression is ";
                                             cout << "not array type.\n";
                                          }

                                          if ($3 != typeError && b != symInt) {
                                             ++errorCount;
                                             cout << "Type error using operator '[]' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The expression inside '[]' ";
                                             cout << "is not intmonchan type.\n";

                                          }
                                          $$ = typeError;
                                       }
                                    }
      | EXPR tk_mod EXPR            {  Symbol *symInt = (scopeTree.lookup("intmonchan"))->second;
                                       Basic *b1 = dynamic_cast<Basic*>($1);
                                       if (($1 == $3 && b1 == symInt) || ($1 == typeError && $3 == typeError))
                                          $$ = $1;
                                       else {

                                          Basic *b2 = dynamic_cast<Basic*>($3);

                                          if ($1 != typeError && b1 != symInt) {
                                             ++errorCount;
                                             cout << "Type error using operator '%' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The left expression is ";
                                             cout << "not intmonchan type.\n";
                                          }

                                          if ($3 != typeError && b2 != symInt) {
                                             ++errorCount;
                                             cout << "Type error using operator '%' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The right expression is ";
                                             cout << "not intmonchan or floatzel type.\n";
                                          }

                                          $$ = typeError;
                                       }

                                    }
      | EXPR tk_and EXPR            {  Symbol *sym = (scopeTree.lookup("boolbasaur"))->second;
                                       bool isBoolType1 = sym == (dynamic_cast<Basic*>($1));
                                       bool isBoolType2 = sym == (dynamic_cast<Basic*>($3));
                                       if ((isBoolType1 && isBoolType2) || ($1 == typeError && $3 == typeError))
                                          $$ = $1;
                                       else {

                                          if ($1 != typeError && !isBoolType1) {
                                             ++errorCount;
                                             cout << "Type error using operator '&&' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The left expression is ";
                                             cout << "not boolbasaur type.\n";
                                          }

                                          if ($3 != typeError && !isBoolType2) {
                                             ++errorCount;
                                             cout << "Type error using operator '&&' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The right expression is ";
                                             cout << "not boolbasaur type.\n";
                                          }

                                          $$ = typeError;
                                       }
                                    }
      | EXPR tk_or EXPR             {  Symbol *sym = (scopeTree.lookup("boolbasaur"))->second;
                                       bool isBoolType1 = sym == (dynamic_cast<Basic*>($1));
                                       bool isBoolType2 = sym == (dynamic_cast<Basic*>($3));
                                       if ((isBoolType1 && isBoolType2) || ($1 == typeError && $3 == typeError))
                                          $$ = $1;
                                       else {

                                          if ($1 != typeError && !isBoolType1) {
                                             ++errorCount;
                                             cout << "Type error using operator '||' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The left expression is ";
                                             cout << "not boolbasaur type.\n";
                                          }

                                          if ($3 != typeError && !isBoolType2) {
                                             ++errorCount;
                                             cout << "Type error using operator '||' at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ". The right expression is ";
                                             cout << "not boolbasaur type.\n";
                                          }

                                          $$ = typeError;
                                       }
                                    }
      | EXPR tk_lessEq EXPR         {  Symbol *sym = (scopeTree.lookup("voidporeon"))->second;
                                       if ($1 == $3 && $1 != typeError && sym != (dynamic_cast<Basic*>($1)))
                                          $$ = (Boolean*)((scopeTree.lookup("boolbasaur"))->second);

                                       else if ($1 != typeError && $3 != typeError) {
                                          ++errorCount;
                                          cout << "Type Error using operator '<=' at line: " << @2.begin.line;
                                          cout << ", column: " << @2.begin.column << ". The types of the ";
                                          cout << "expressions do not match.\n";
                                          $$ = typeError;
                                       } else
                                          $$ = typeError;
                                    }
      | EXPR tk_moreEq EXPR         {  Symbol *sym = (scopeTree.lookup("voidporeon"))->second;
                                       if ($1 == $3 && $1 != typeError && sym != (dynamic_cast<Basic*>($1)))
                                          $$ = (Boolean*)((scopeTree.lookup("boolbasaur"))->second);

                                       else if ($1 != typeError && $3 != typeError) {
                                          ++errorCount;
                                          cout << "Type Error using operator '>=' at line: " << @2.begin.line;
                                          cout << ", column: " << @2.begin.column << ". The types of the ";
                                          cout << "expressions do not match.\n";
                                          $$ = typeError;
                                       } else
                                          $$ = typeError;
                                    }
      | EXPR tk_lessThan EXPR       {  Symbol *sym = (scopeTree.lookup("voidporeon"))->second;
                                       if ($1 == $3 && $1 != typeError && sym != (dynamic_cast<Basic*>($1)))
                                          $$ = (Boolean*)((scopeTree.lookup("boolbasaur"))->second);

                                       else if ($1 != typeError && $3 != typeError) {
                                          ++errorCount;
                                          cout << "Type Error using operator '<' at line: " << @2.begin.line;
                                          cout << ", column: " << @2.begin.column << ". The types of the ";
                                          cout << "expressions do not match.\n";
                                          $$ = typeError;
                                       } else
                                          $$ = typeError;
                                    }
      | EXPR tk_moreThan EXPR       {  Symbol *sym = (scopeTree.lookup("voidporeon"))->second;
                                       if ($1 == $3 && $1 != typeError && sym != (dynamic_cast<Basic*>($1)))
                                          $$ = (Boolean*)((scopeTree.lookup("boolbasaur"))->second);

                                       else if ($1 != typeError && $3 != typeError) {
                                          ++errorCount;
                                          cout << "Type Error using operator '>' at line: " << @2.begin.line;
                                          cout << ", column: " << @2.begin.column << ". The types of the ";
                                          cout << "expressions do not match.\n";
                                          $$ = typeError;
                                       } else
                                          $$ = typeError;
                                    }
      | EXPR tk_notEqual EXPR       {  Symbol *sym = (scopeTree.lookup("voidporeon"))->second;
                                       if ($1 == $3 && $1 != typeError && sym != (dynamic_cast<Basic*>($1)))
                                          $$ = (Boolean*)((scopeTree.lookup("boolbasaur"))->second);

                                       else if ($1 != typeError && $3 != typeError) {
                                          ++errorCount;
                                          cout << "Type Error using operator '!=' at line: " << @2.begin.line;
                                          cout << ", column: " << @2.begin.column << ". The types of the ";
                                          cout << "expressions do not match.\n";
                                          $$ = typeError;
                                       } else
                                          $$ = typeError;
                                    }
      | EXPR tk_dot tk_identifier   {  Register_Type *reg = dynamic_cast<Register_Type*>($1);
                                       Union_Type *un = dynamic_cast<Union_Type*>($1);

                                       if (reg != 0) {

                                          map<string,Type*>::iterator it = reg->fields.find(*$3);

                                          if (reg->fields.end() != it)
                                             $$ = it->second;
                                          else {
                                             ++errorCount;
                                             cout << "Error at line: " << @3.begin.line << ", column: ";
                                             cout << @3.begin.column << ". '" << *$3 << "' is not a field of registeer '";
                                             cout << reg->name << "'.\n";
                                             $$ = typeError;
                                          }
                                       } else if (un != 0) {

                                          map<string,Type*>::iterator it = un->fields.find(*$3);

                                          if (un->fields.end() != it)
                                             $$ = it->second;
                                          else {
                                             ++errorCount;
                                             cout << "Error at line: " << @3.begin.line << ", column: ";
                                             cout << @3.begin.column << ". '" << *$3 << "' is not a field of unown '";
                                             cout << reg->name << "'.\n";
                                             $$ = typeError;
                                          }
                                       } else {
                                          ++errorCount;
                                          cout << "Error using operator '.' at line: " << @2.begin.line << ", column: ";
                                          cout << @3.begin.column << ". The left expression is not a registeer type ";
                                          cout << "or unown type.\n";
                                          $$ = typeError;
                                       }

                                       delete($3); /*NOTE puede que esto se use despues*/
                                    }
      | '!' EXPR                    {  if (((scopeTree.lookup("boolbasaur"))->second == (dynamic_cast<Basic*>($2))) || ($2 == typeError))
                                          $$ = $2;
                                       else {
                                          ++errorCount;
                                          cout << "Type error using operator '!' at line: " << @1.begin.line;
                                          cout << ", column: " << @1.begin.column << ". The expression is ";
                                          cout << "not boolbasaur type.\n";
                                          $$ = typeError;
                                       }
                                    }
      | '-' EXPR %prec UMINUS       {  if (scopeTree.lookup("intmonchan")->second == (dynamic_cast<Basic*>($2)) ||
                                           scopeTree.lookup("floatzel")->second == (dynamic_cast<Basic*>($2)) ||
                                           ($2 == typeError))
                                           $$ = $2;
                                       else {
                                          ++errorCount;
                                          cout << "Type error using operator unary '-' at line: " << @1.begin.line;
                                          cout << ", column: " << @1.begin.column << ". The expression is ";
                                          cout << "not intmonchan or floatzel type.\n";
                                          $$ = typeError;
                                       }
                                    }
      | '(' EXPR ')'                {  $$ = $2; }
      | '(' error ')'               {  ++errorCount;
                                       cout << "Error in expression at line: " << @2.begin.line;
                                       cout << ", column: " << @2.begin.column << ".\n";
                                       $$ = typeError;
                                    }
      | '(' ')'                     {  ++errorCount;
                                       cout << "Error at line: " << @1.begin.line;
                                       cout << ", column: " << @1.begin.column;
                                       cout << ": parenthesis must contain an expression.\n";
                                       $$ = typeError;
                                    }
      | CONST
      | FUNCCALL
      | tk_identifier               {  pair<string,Symbol*> *id = scopeTree.lookup(*$1);

                                       if (id == nullptr) {
                                          ++errorCount;
                                          yy::position pos = @1.begin;
                                          cout << "The variable '" << *$1 << "' at line: " << pos.line;
                                          cout << ", column: " << pos.column << " has not been declared.\n";
                                          $$ = typeError;
                                       } else {


                                          Declaration *decl = dynamic_cast<Declaration*>(id->second);

                                          /* NOTE Las varibles de los for todavia no tienen tipos */

                                          Type *t = decl->getType();

                                          if (t == nullptr)
                                             t = typeError;

                                          $$ = t;
                                          delete(id);
                                       }

                                       delete($1); //NOTE puede que esto se use despues
                                    }
      | tk_string                   {  $$ = (String*)(scopeTree.lookup("onix")->second); }
      ;

   CONST
      : NUMBER
      | BOOLEAN
      | tk_char   {  $$ = (Character*)(scopeTree.lookup("charizard")->second); }
      ;

   NUMBER
      : tk_int    {  $$ = (Integer*)(scopeTree.lookup("intmonchan")->second); }
      | tk_float  {  $$ = (Float*)(scopeTree.lookup("floatzel")->second); }
      ;

   BOOLEAN
      : tk_true   {  $$ = (Boolean*)(scopeTree.lookup("boolbasaur")->second); }
      | tk_false  {  $$ = (Boolean*)(scopeTree.lookup("boolbasaur")->second); }
      ;

   ARGS
      : /* empty */  {  pair<string,Symbol*> *sym = scopeTree.lookup("voidporeon");
                        Type *type = dynamic_cast<Type*>(sym->second);
                        typeList.push_back(type);
                     }
      | ARGSLIST
      ;
   ARGSLIST
      : EXPR                     {  typeList.push_back($1); }
      | ARGSLIST tk_comma EXPR   {  typeList.push_back($3); }
      ;

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
      : '{' STMTLIST
      | '{'                         {  scopeTree.enterScope(); }
         DECLARELIST STMTLIST       {  scopeTree.exitScope();
                                    }
      | '{' '}'                     {  ++errorCount;
                                       cout << "Error at line: " << @1.begin.line;
                                       cout << ", column: " << @1.begin.column;
                                       cout << ": a block must have at least one statement.\n";
                                    }
      ;

   STMTLIST
      : STMT '}'
      | STMT tk_semicolon STMTLIST
      | error tk_semicolon STMTLIST {  ++errorCount;
                                       cout << "Invalid statement at line: " << @1.begin.line;
                                       cout << ", column: " << @1.begin.column << ".\n";
                                       yyerrok;
                                    }
      | error '}'                   {  ++errorCount;
                                       cout << "Invalid statement at line: " << @1.begin.line;
                                       cout << ", column: " << @1.begin.column << ".\n";
                                       yyerrok;
                                    }
     ;

   ASIGNMENT
      : ASIGNLIST tk_asignment ARGSLIST   {  typeList.clear(); }
      | ASIGNLIST '=' ARGSLIST            {  typeList.clear();
                                             ++errorCount;
                                             cout << "Error: Perhaps you meant \":=\" instead of \"=\" at line: ";
                                             cout << @2.begin.line << ", column: " << @2.begin.column << ".\n";
                                          }
      ;

   ASIGNLIST
      : tk_identifier ARRDOT                    {  pair<string,Symbol*> *id = scopeTree.lookup(*$1);
                                                   if (id == nullptr) {
                                                     ++errorCount;
                                                     yy::position pos = @1.begin;
                                                     cout << "The variable " << *$1 << " at line: " << pos.line;
                                                     cout << ", column: " << pos.column << " has not been declared.\n";
                                                   } else
                                                      delete(id);

                                                   delete($1); //NOTE puede que esto se use despues.
                                                }
      | tk_identifier ARRDOT tk_comma ASIGNLIST {  pair<string,Symbol*> *id = scopeTree.lookup(*$1);
                                                   if (id == nullptr){
                                                      ++errorCount;
                                                      yy::position pos = @1.begin;
                                                      cout << "The variable " << *$1 << " at line: " << pos.line;
                                                      cout << ", column: " << pos.column << " has not been declared.\n";
                                                   } else
                                                      delete(id);

                                                   delete($1); //NOTE puede que esto se use despues.
                                                }
      ;

   ARRDOT
      : /* empty */
      | '[' EXPR ']' ARRDOT
      | tk_dot tk_identifier ARRDOT { delete($2); /*NOTE puede que esto se use despues.*/ }

      | '[' error ']'               {  ++errorCount;
                                       cout << "Invalid expression in array asignment at line: ";
                                       cout << @2.begin.line << ", column: " << @2.begin.column;
                                       cout << ".\n";
                                       yyerrok;
                                    }

      ;

   IFSTMT
      : tk_if EXPR INST %prec IFPREC   {  if (dynamic_cast<Boolean*>($2) == 0) {
                                             ++errorCount;
                                             cout << "Error at line: " << @2.begin.line << ", column: ";
                                             cout << @2.begin.column << ". If condition is not a ";
                                             cout << "boolbasaur type.\n";
                                          }
                                       }
      | tk_if EXPR INST IFLIST         {  if (dynamic_cast<Boolean*>($2) == 0) {
                                             ++errorCount;
                                             cout << "Error at line: " << @2.begin.line << ", column: ";
                                             cout << @2.begin.column << ". If condition is not a ";
                                             cout << "boolbasaur type.\n";
                                          }
                                       }
      | tk_if error INST %prec IFPREC  {  ++errorCount;
                                          cout << "Invalid expression in if condition at line: ";
                                          cout << @2.begin.line << ", column: " << @2.begin.column;
                                          cout << ".\n";
                                          yyerrok;
                                       }
      | tk_if error INST IFLIST        {  ++errorCount;
                                          cout << "Invalid expression in if condition at line: ";
                                          cout << @2.begin.line << ", column: " << @2.begin.column;
                                          cout << ".\n";
                                          yyerrok;
                                       }
      ;

   IFLIST
      : tk_else INST
      | tk_elsif IFHELPER
      | tk_elsif IFHELPER IFLIST
      ;

   IFHELPER
      : EXPR INST    {  if (dynamic_cast<Boolean*>($1) == 0) {
                           ++errorCount;
                           cout << "Error at line: " << @1.begin.line << ", column: ";
                           cout << @1.begin.column << ". Elsif condition is not a ";
                           cout << "boolbasaur type.\n";
                        }
                     }
      | error INST   {  ++errorCount;
                        cout << "Invalid expression in elsif condition at line: ";
                        cout << @1.begin.line << ", column: " << @1.begin.column;
                        cout << ".\n";
                        yyerrok;
                     }
      ;

   WHILESTMT
      : tk_while EXPR INST    {  if (dynamic_cast<Boolean*>($2) == 0) {
                                    ++errorCount;
                                    cout << "Error at line: " << @2.begin.line << ", column: ";
                                    cout << @2.begin.column << ". While condition is not a ";
                                    cout << "boolbasaur type.\n";
                                 }
                              }
      | tk_while error INST   {  ++errorCount;
                                 cout << "Invalid expression in while condition at line: ";
                                 cout << @2.begin.line << ", column: " << @2.begin.column;
                                 cout << ".\n";
                                 yyerrok;
                              }
      ;

   FORSTMT
      : tk_for tk_identifier tk_from EXPR tk_to EXPR tk_by EXPR   {  /* Se abre un nuevo alcance para la variable de la
                                                                      * instruccion for y la agrega a la tabla. */
                                                                     scopeTree.enterScope();
                                                                     yy::position pos = @2.begin;  //TODO poner el tipo adecuado de la variable
                                                                     Declaration* decl = new Declaration(*$2,pos.line, pos.column, nullptr, false);
                                                                     Integer *basicInt = dynamic_cast<Integer*>($4);
                                                                     Float *basicFloat = dynamic_cast<Float*>($4);
                                                                     Character *basicChar = dynamic_cast<Character*>($4);

                                                                     if ($4 == $6 && $6 == $8 && $4 != typeError) {

                                                                        pair<string,Symbol*> *sym = nullptr;

                                                                        if (basicInt != 0)
                                                                           sym = scopeTree.lookup(basicInt->name);
                                                                        else if (basicFloat != 0)
                                                                           sym = scopeTree.lookup(basicFloat->name);
                                                                        else if (basicChar != 0)
                                                                           sym = scopeTree.lookup(basicChar->name);
                                                                        else {

                                                                           ++errorCount;
                                                                           cout << "Error at line: " << @4.begin.line << ", column: " << @4.begin.column;
                                                                           cout << ". Expressions in for statement must be intmonchan, floatzel or charizard.\n";

                                                                        }


                                                                        decl->setType(sym);
                                                                        currentOffset = decl->setOffset(currentOffset);

                                                                     } else if ($4 != $6 && $6 == $8 && $6 != typeError) {

                                                                        ++errorCount;
                                                                        cout << "Error at line: " << @4.begin.line << ", column: " << @4.begin.column;
                                                                        cout << ". Lower bound expression type does not match with upper bound and step";
                                                                        cout << " expression types.\n";

                                                                     } else if ($6 != $4 && $4 == $8 && $4 != typeError) {

                                                                        ++errorCount;
                                                                        cout << "Error at line: " << @6.begin.line << ", column: " << @6.begin.column;
                                                                        cout << ". Upper bound expression type does not match with lower bound and step";
                                                                        cout << " expression types.\n";

                                                                     } else if ($8 != $6 && $6 == $4 && $6 != typeError) {
                                                                        ++errorCount;
                                                                        cout << "Error at line: " << @8.begin.line << ", column: " << @8.begin.column;
                                                                        cout << ". Step expression type does not match with lower bound and upper bound";
                                                                        cout << " expression types.\n";

                                                                     }

                                                                     scopeTree.insert(decl);
                                                                     delete($2);
                                                                  }
                                                            INST  {  scopeTree.exitScope(); }

      | tk_for tk_identifier tk_from EXPR tk_to EXPR              {  /* Se abre un nuevo alcance para la variable de la
                                                                      * instruccion for y la agrega a la tabla. */
                                                                     scopeTree.enterScope();
                                                                     yy::position pos = @2.begin;  //TODO poner el tipo adecuado de la variable
                                                                     Declaration* decl = new Declaration(*$2,pos.line, pos.column, nullptr, false);

                                                                     Integer *basicInt = dynamic_cast<Integer*>($4);
                                                                     Float *basicFloat = dynamic_cast<Float*>($4);
                                                                     Character *basicChar = dynamic_cast<Character*>($4);

                                                                     if ($4 == $6 && $4 != typeError) {

                                                                        pair<string,Symbol*> *sym = nullptr;

                                                                        if (basicInt != 0)
                                                                           sym = scopeTree.lookup(basicInt->name);
                                                                        else if (basicFloat != 0)
                                                                           sym = scopeTree.lookup(basicFloat->name);
                                                                        else if (basicChar != 0)
                                                                           sym = scopeTree.lookup(basicChar->name);
                                                                        else {

                                                                           ++errorCount;
                                                                           cout << "Error at line: " << @4.begin.line << ", column: " << @4.begin.column;
                                                                           cout << ". Expressions in for statement must be intmonchan, floatzel or charizard.\n";

                                                                        }


                                                                        decl->setType(sym);
                                                                        currentOffset = decl->setOffset(currentOffset);

                                                                     } else if ($4 != $6 && $6 != typeError) {

                                                                        ++errorCount;
                                                                        cout << "Error at line: " << @4.begin.line << ", column: " << @4.begin.column;
                                                                        cout << ". Lower bound expression type does not match with upper bound";
                                                                        cout << " expression type.\n";

                                                                     }


                                                                     scopeTree.insert(decl);
                                                                     delete($2);
                                                                  }
                                                            INST  {  scopeTree.exitScope();
                                                                  }
      | tk_for error INST                                         {  ++errorCount;
                                                                     cout << "Error in for statement at line: ";
                                                                     cout << @2.begin.line << ", column: " << @2.begin.column;
                                                                     cout << ".\n";
                                                                     yyerrok;
                                                                  }
      ;

   FUNCCALL
      : tk_identifier '(' ARGS ')'     {  pair<string,Symbol*> *sym = scopeTree.lookup(*$1);

                                          if (sym == nullptr) {
                                             ++errorCount;
                                             yy::position pos = @1.begin;
                                             cout << "The function '" << *$1 << "' at line: " << pos.line;
                                             cout << ", column: " << pos.column << " has not been declared.\n";
                                             $$ = typeError;
                                          } else {


                                             Function *func = dynamic_cast<Function*>(sym->second);

                                             if (func != 0) {

                                                if (dynamic_cast<Ditto*>(func->type->arguments) != 0) {


                                                   if (dynamic_cast<Basic*>(typeList[0]) != 0 && typeList.size() == 1)
                                                      $$ = func->getType();
                                                   else {
                                                      ++errorCount;
                                                      cout << "Error at line: " << @3.begin.line << ", column: " << @3.begin.column;
                                                      cout << ". Arguments of the function '" << *$1 << "' must be one of the basic types.\n";
                                                      $$ = typeError;
                                                   }

                                               } else {

                                                   vector<Type*>::reverse_iterator it = typeList.rbegin();
                                                   Type *type = *it;
                                                   ++it;

                                                   for(; it != typeList.rend(); ++it){
                                                      Type *type2 = *it;
                                                      type = tupleFactory.buildTuple(type2,type);
                                                   }

                                                   //VER SI CUADRAN
                                                   if (type == func->type->arguments){
                                                      $$ = func->getType();

                                                   } else {
                                                      ++errorCount;
                                                      cout << "Error at line: "<< @3.begin.line << ", column: " << @3.begin.column;
                                                      cout << ". Arguments of the function '" << *$1 << "' do not match.\n";
                                                      $$ = typeError;
                                                   }
                                              }

                                             } else{
                                                ++errorCount;
                                                cout << "Error at line: " << @1.begin.line << ", column: " << @1.begin.column;
                                                cout << ". '" << *$1 << "' is not a function.\n";
                                                $$ = typeError;


                                             }
                                          }

                                          typeList.clear();
                                          delete($1); /*NOTE puede que esto se use despues.*/ }
      ;

   BREAK
      : tk_break
      | tk_break tk_identifier         { delete($2); /*NOTE puede que esto se use despues.*/ }
      ;

   CONTINUE
      : tk_continue
      | tk_continue tk_identifier      { delete($2); /*NOTE puede que esto se use despues.*/ }
      ;

   LABEL
      : tk_tag tk_colon tk_identifier  { delete($3); /*NOTE puede que esto se use despues.*/ }
      ;

   RETURN
      : tk_return
      | tk_return EXPR
      ;

   SWITCHSTMT
      : tk_switch EXPR '{' CASE '}'    {  if ($2 != $4 && $2 != typeError && $4 != typeError) {
                                             ++errorCount;
                                             cout << "Error at line: " << @2.begin.line << ", column: ";
                                             cout << @2.begin.column << ". Switch condition does not match ";
                                             cout << "with switch guards.\n";
                                          }
                                       }
      ;

   CASE
      : tk_case CONST tk_arrow BLOCK            {  $$ = $2; }
      | tk_case CONST tk_arrow BLOCK CASELIST   {  if ($2 == $5 || $5 == typeError)
                                                      $$ = $5;
                                                   else if ($5 == nullptr)
                                                      $$ = $2;
                                                   else {
                                                      ++errorCount;
                                                      cout << "Error at line: " << @2.begin.line << ", column: ";
                                                      cout << @2.begin.column << ". Switch guards' types do not match.\n";
                                                      $$ = typeError;
                                                   }
                                                }
      ;

   CASELIST
      : tk_default tk_arrow BLOCK               {  $$ = nullptr; }
      | tk_case CONST tk_arrow BLOCK            {  $$ = $2; }
      | tk_case CONST tk_arrow BLOCK CASELIST   {  if ($2 == $5 || $5 == typeError)
                                                      $$ = $5;
                                                   else if ($5 == nullptr)
                                                      $$ = $2;
                                                   else {
                                                      ++errorCount;
                                                      cout << "Error at line: " << @2.begin.line << ", column: ";
                                                      cout << @2.begin.column << ". Switch guards' types do not match.\n";
                                                      $$ = typeError;
                                                   }
                                                }
      ;

   DECLARATION
      : TYPE IDLIST INITLIST tk_semicolon          {  /* Toma una lista de identificadores y los inserta a tabla de simbolos con su tipo. */
                                                      vector<Declaration*>::reverse_iterator it = $2->rbegin();
                                                      pair<string,Symbol*> *symType = scopeTree.lookup(*$1);

                                                      //Por si acaso el usuario usa variable declarada como tipo
                                                      if (symType == nullptr || dynamic_cast<Definition*>(symType->second) != 0)

                                                      for(; it != $2->rend(); ++it) {
                                                         Declaration *decl = *it;
                                                         decl->setType(symType);
                                                         
                                                         currentOffset = decl->setOffset(currentOffset);

                                                         scopeTree.insert(decl);
                                                      }

                                                      delete($2);
                                                      delete($1);
                                                   }
      | COMPLEXTYPE IDLIST INITLIST tk_semicolon   {  /* Toma una lista de identificadores y los inserta a tabla de simbolos con su tipo. */
                                                      vector<Declaration*>::reverse_iterator it = $2->rbegin();
                                                      pair<string,Symbol*> *symType = scopeTree.lookup($1->second);

                                                      for(; it != $2->rend(); ++it) {
                                                         Declaration *decl = *it;
                                                         decl->setType(symType);
                                                         currentOffset = decl->setOffset(currentOffset);
                                                         scopeTree.insert(decl);
                                                      }

                                                      delete($2);
                                                      delete($1);

                                                   }
      | TYPE error tk_semicolon                    {  ++errorCount;
                                                      cout << "Error in declaration at line: " << @2.begin.line;
                                                      cout << ", column: " << @2.begin.column << ".\n";
                                                      yyerrok;
                                                      delete($1);
                                                   }
      | COMPLEXTYPE error tk_semicolon             {  ++errorCount;
                                                      cout << "Error in declaration at line: " << @2.begin.line;
                                                      cout << ", column: " << @2.begin.column << ".\n";
                                                      yyerrok;
                                                      delete($1);
                                                   }
      ;

   IDLIST
      : tk_identifier ARRAYDECL                          {  /* Se crea una nueva lista de strings para los identificadores
                                                             * y se agrega el identificador actual.*/
                                                            vector<Declaration*> *idList = new vector<Declaration*>;
                                                            Declaration *newDecl;

                                                            if ($2 == nullptr)
                                                               newDecl = new Declaration(*$1,@1.begin.line,@1.begin.column,nullptr,false);
                                                            else {
                                                               newDecl = new ArrayDecl(*$1,@1.begin.line,@1.begin.column,nullptr,false,$2->first,$2->second,arrayFactory);
                                                               delete($2);
                                                            }

                                                            idList->push_back(newDecl);
                                                            $$ = idList;
                                                         }
      | tk_identifier ARRAYDECL tk_comma IDLIST          {  /* Se agrega el identificador actual a la lista ya creada.*/
                                                            Declaration *newDecl;

                                                            if ($2 == nullptr)
                                                               newDecl = new Declaration(*$1,@1.begin.line,@1.begin.column,nullptr,false);
                                                            else {
                                                               newDecl = new ArrayDecl(*$1,@1.begin.line,@1.begin.column,nullptr,false,$2->first,$2->second,arrayFactory);
                                                               delete($2);
                                                            }

                                                            $4->push_back(newDecl);
                                                            $$ = $4;
                                                         }
      | tk_const tk_identifier ARRAYDECL                 {  /* Se crea una nueva lista de strings para los identificadores
                                                             * y se agrega el identificador actual.*/
                                                            vector<Declaration*> *idList = new vector<Declaration*>;
                                                            Declaration *newDecl;

                                                            if ($3 == nullptr)
                                                               newDecl = new Declaration(*$2,@2.begin.line,@2.begin.column,nullptr,true);
                                                            else {
                                                               newDecl = new ArrayDecl(*$2,@2.begin.line,@2.begin.column,nullptr,true,$3->first,$3->second,arrayFactory);
                                                               delete($3);
                                                            }

                                                            idList->push_back(newDecl);
                                                            $$ = idList;
                                                         }
      | tk_const tk_identifier ARRAYDECL tk_comma IDLIST {  /* Se agrega el identificador actual a la lista ya creada.*/

                                                            Declaration *newDecl;

                                                            if ($3 == nullptr)
                                                               newDecl = new Declaration(*$2,@2.begin.line,@2.begin.column,nullptr,true);
                                                            else {
                                                               newDecl = new ArrayDecl(*$2,@2.begin.line,@2.begin.column,nullptr,true,$3->first,$3->second,arrayFactory);
                                                               delete($3);
                                                            }

                                                            $5->push_back(newDecl);
                                                            $$ = $5;
                                                         }
      | error tk_comma IDLIST                            {  ++errorCount;
                                                            cout << "Error in declaration at line: " << @1.begin.line;
                                                            cout << ", column: " << @1.begin.column << ".\n";
                                                            yyerrok;
                                                            $$ = $3;
                                                         }
      ;

   ARRAYDECL
      : /* empty */                    {  $$ = nullptr; }
      | '[' tk_int tk_range tk_int ']' {  $$ = new pair<int,int>($2,$4); }
      | '[' error ']'                  {  ++errorCount;
                                          cout << "Invalid expression in array declaration at line: ";
                                          cout << @2.begin.line << ", column: " << @2.begin.column;
                                          cout << ".\n";
                                          yyerrok;
                                       }
      ;


   DECLARELIST
      : DECLARATION
      | DECLARELIST DECLARATION;

   INITLIST
      : /* empty */
      | tk_asignment ARGSLIST { typeList.clear(); }
      | '=' ARGSLIST          {  typeList.clear();
                                 ++errorCount;
                                 cout << "Error: Perhaps you meant \":=\" instead of \"=\" at line: ";
                                 cout << @2.begin.line << ", column: " << @2.begin.column << ".\n";
                              }
      ;

   TYPE
      : tk_intType
      | tk_floatType
      | tk_boolType
      | tk_charType
      | tk_stringType
      ;

   COMPLEXTYPE
      : tk_unionType tk_identifier  {  pair<string,Symbol*> *symType = scopeTree.lookup(*$2);

                                       if (symType == nullptr) {
                                          ++errorCount;
                                          cout << "Error at line: " << @1.begin.line << ", column: " << @1.begin.column;
                                          cout << ": The unown '" << *$2 << "' has not been defined.\n";

                                       } else if (dynamic_cast<Union_Type*>(symType->second) == 0){
                                          ++errorCount;
                                          cout << "Error at line: " << @1.begin.line << ", column: " << @1.begin.column;
                                          cout << ": you declared an unown but '" << *$2 << "' is not defined as an unown.\n";
                                       }
                                       $$ = new pair<string,string>(*$1,*$2);
                                       delete($1);
                                       delete($2);
                                    }
      | tk_structType tk_identifier {  pair<string,Symbol*> *symType = scopeTree.lookup(*$2);

                                       if (symType == nullptr) {
                                          ++errorCount;
                                          cout << "Error at line: " << @1.begin.line << ", column: " << @1.begin.column;
                                          cout << ": The registeer '" << *$2 << "' has not been defined.\n";

                                       } else if (dynamic_cast<Register_Type*>(symType->second) == 0){
                                          ++errorCount;
                                          cout << "Error at line: " << @1.begin.line << ", column: " << @1.begin.column;
                                          cout << ": you declared a registeer but '" << *$2 << "' is not defined as a registeer.\n";
                                       }
                                       $$ = new pair<string,string>(*$1,*$2);
                                       delete($1);
                                       delete($2);
                                    }
      ;

   VAR
      : /* empty */  {  $$ = false; }
      | tk_var       {  $$ = true;  }
      ;

   FIELDS
      : FIELD
      | FIELDS FIELD
      ;


   FIELD
      : TYPE IDLIST tk_semicolon          {  /* Toma una lista de identificadores y los inserta a tabla de simbolos con su tipo. */
                                             vector<Declaration*>::reverse_iterator it = $2->rbegin();
                                             pair<string,Symbol*> *symType = scopeTree.lookup(*$1);

                                             //Por si acaso el usuario usa variable declarada como tipo
                                             if (symType == nullptr || dynamic_cast<Definition*>(symType->second) != 0)

                                                for(; it != $2->rend(); ++it) {
                                                   Declaration *decl = *it;
                                                   decl->setType(symType);
                                                   scopeTree.insert(decl);
                                                   fields.insert(pair<string,Type*>(decl->name,decl->getType()));
                                                   decls.insert(pair<string,Declaration*>(decl->name,decl));
                                                }

                                             delete($2);
                                             delete($1);
                                          }
      | COMPLEXTYPE IDLIST tk_semicolon   {  /* Toma una lista de identificadores y los inserta a tabla de simbolos con su tipo. */
                                             vector<Declaration*>::reverse_iterator it = $2->rbegin();
                                             pair<string,Symbol*> *symType = scopeTree.lookup($1->second);

                                             for(; it != $2->rend(); ++it) {
                                                Declaration *decl = *it;
                                                decl->setType(symType);
                                                scopeTree.insert(decl);
                                                fields.insert(pair<string,Type*>(decl->name,decl->getType()));
                                                decls.insert(pair<string,Declaration*>(decl->name,decl));
                                             }

                                             delete($2);
                                             delete($1);

                                          }
      | TYPE error tk_semicolon           {  ++errorCount;
                                             cout << "Error in declaration at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ".\n";
                                             yyerrok;
                                             delete($1);
                                          }
      | COMPLEXTYPE error tk_semicolon    {  ++errorCount;
                                             cout << "Error in declaration at line: " << @2.begin.line;
                                             cout << ", column: " << @2.begin.column << ".\n";
                                             yyerrok;
                                             delete($1);
                                          }
      ;


   REGISTER
      : tk_structType tk_identifier '{'   {  scopeTree.enterScope(); }

                             FIELDS '}'   {  scopeTree.exitScope();
                                             yy::position pos = @1.begin;
                                             Register_Type *reg = new Register_Type(*$2,pos.line,pos.column,0,fields,decls);
                                             scopeTree.insert(reg);
                                             fields.clear();
                                             decls.clear();
                                             delete($2);
                                             delete($1);
                                          }
      ;

   UNION
      : tk_unionType tk_identifier '{'    {  scopeTree.enterScope(); }

                            FIELDS '}'    {  scopeTree.exitScope();
                                             yy::position pos = @1.begin;
                                             Union_Type *un = new Union_Type(*$2,pos.line,pos.column,0,fields,decls);
                                             scopeTree.insert(un);
                                             fields.clear();
                                             decls.clear();
                                             delete($2);
                                             delete($1);
                                          }
      ;


   FUNCDEF
      : TYPE FUNC          {  pair<string,Symbol*> *type = scopeTree.lookup(*$1);
                              Type *symType = dynamic_cast<Type*>(type->second);
                              $2->setType(symType);
                              funcAux = $2;
                              delete(type);
                              delete($1);
                           }

                  FUNCBODY

      | tk_voidType FUNC   {  pair<string,Symbol*> *type = scopeTree.lookup(*$1);
                              Type *symType = dynamic_cast<Type*>(type->second);
                              $2->setType(symType);
                              funcAux = $2;
                              delete(type);
                              delete($1);
                           }
                  FUNCBODY
      ;

   FUNCBODY
      : tk_semicolon {  funcAux->fwdDecl = true;
                        pair<string,Symbol*> *func = scopeTree.lookup(funcAux->name);
                        if (func != nullptr) {
                           ++errorCount;
                           cout << "Error at line: " << funcAux->line << ", column: " << funcAux->column;
                           cout << ". This name has already been used at line: " << func->second->line;
                           cout << ", column: " << func->second->column << ".\n";
                           delete(func);
                        } else
                           scopeTree.insert(funcAux);
                        funcAux = nullptr;
                        declList.clear();
                     }

      | /* empty */  {  pair<string,Symbol*> *funcPair = scopeTree.lookup(funcAux->name);
                        Function *func = nullptr;

                        if (funcPair != nullptr)
                           func = dynamic_cast<Function*>(funcPair->second);


                        vector<pair<string,Declaration*>*>::iterator args2 = funcAux->arguments.begin();

                        if (func != nullptr && func != 0 && func->fwdDecl) {

                           if (func->type->returnType != funcAux->type->returnType) {
                              ++errorCount;
                              cout << "Error at line: " << funcAux->line << ", column: " << funcAux->column;
                              cout << ". The return type of the function '" << funcAux->name << "' does not match ";
                              cout << "with its forward declaration at line: "<< func->line;
                              cout << ", column: " << func->column << ".\n";

                           }

                           if (func->arguments.size() == funcAux->arguments.size()) {

                              vector<pair<string,Declaration*>*>::iterator args1 = func->arguments.begin();

                              int argPos = 1;

                              for (; args1 != func->arguments.end(); ++args1) {

                                 if (*((*args1)->second) != *((*args2)->second)) {

                                    ++errorCount;
                                    cout << "Error at line: " << funcAux->line << ", column: " << funcAux->column;
                                    cout << ". The parameter #" << argPos << " of the function '" << funcAux->name;
                                    cout << "' does not match with its forward declaration at line: "<< func->line;
                                    cout << ", column: " << func->column << ".\n";


                                 }
                                 ++argPos;
                                 ++args2;
                              }
                              func->fwdDecl = false;

                           } else {
                              ++errorCount;
                              cout << "Error at line: " << funcAux->line << ", column: " << funcAux->column;
                              cout << ". The number of parameters of the function '" << funcAux->name << "' do not match ";
                              cout << "with number of parameters of its forward declaration at line: "<< func->line;
                              cout << ", column: " << func->column << ".\n";

                           }

                           delete(funcPair);

                        } else
                           scopeTree.insert(funcAux);

                        if (funcAux->arguments.size() != 0) {

                           /* Abre un nuevo alcance y se agregan los argumentos a la tabla de simbolos. */
                           scopeTree.enterScope();
                           
                           int argsOffset = 0;  
                           
                           //NOTE !!!!!!!!!!!!!!!!!!!!!!!! NOTE
                           for(args2 = funcAux->arguments.begin(); args2 != funcAux->arguments.end(); ++args2){
                              Declaration* decl = (*args2)->second;
                              scopeTree.insert(decl);
                              argsOffset = decl->setOffset(argsOffset);
                              decl->offset = - decl->offset;
                              
                           }

                           /* Si hay arreglos en los argumentos entonces se agregan
                            * las variables asociadas a sus delimitadores. */

                           vector<Declaration*>::reverse_iterator declIt = declList.rbegin();
                           for(;declIt != declList.rend(); ++declIt){
                              scopeTree.insert(*declIt);
                              argsOffset = (*declIt)->setOffset(argsOffset);
                              (*declIt)->offset = - (*declIt)->offset;
                              
                           }
                           declList.clear(); //Vacia la lista.

                           //Respaldo del offset global
                           globalOffset = currentOffset;
                           currentOffset = 0;
                        }
                     }

               BLOCK {  if (funcAux->arguments.size() != 0)
                           scopeTree.exitScope();
                        funcAux = nullptr;
                        currentOffset = globalOffset;
                     }
      ;

   FUNC
      : tk_identifier '(' ')'          {  yy::position pos = @1.begin;
                                          pair<string,Symbol*> *sym = scopeTree.lookup("voidporeon");
                                          Type *type = dynamic_cast<Type*>(sym->second);
                                          Function *func = new Function(*$1,pos.line,pos.column,nullptr,type);
                                          $$ = func;
                                          delete($1);
                                       }


     | tk_identifier '(' ARGSDEF ')'   {  yy::position pos = @1.begin;
                                          vecFunc args;
                                          vecFunc::reverse_iterator it = $3->rbegin();
                                          vecFunc::iterator it2 = $3->begin();
 
                                          
                                          
                                          Type *type = dynamic_cast<Type*>((*it2)->second->getType());
                                          ++it2;

                                          /* Invierte la lista de argumentos para agregarla a la declaracion. */
                                          for(; it != $3->rend(); ++it)
                                             args.push_back(*it);

                                             
                                          for(; it2 != $3->end(); ++it2) {
                                          
                                             Type *type2 = dynamic_cast<Type*>((*it2)->second->getType());
                                             type = tupleFactory.buildTuple(type2,type);

                                          }

                                          Function *func = new Function(*$1,pos.line,pos.column,nullptr,args,type);
                                          $$ = func;

                                          delete($1);
                                       }
      ;

   ARGSDEF
      :  VAR TYPE ARG                        {  /* Se crea una nueva lista para los argumentos de las funciones y
                                                 * se agrega el argumento actual. */
                                                vecFunc *args = new vecFunc;
                                                pair<string,Symbol*> *symType = scopeTree.lookup(*$2);
                                                $3->constant = !$1;
                                                $3->setType(symType);

                                                pair<string,Declaration*> *arg = new pair<string,Declaration*>($3->name,$3);
                                                args->push_back(arg);
                                                delete($2);
                                                $$ = args;
                                             }
      | VAR TYPE ARG tk_comma ARGSDEF        {  /* Se agrega el argumento actual a la lista de argumentos de la funcion. */
                                                pair<string,Symbol*> *symType = scopeTree.lookup(*$2);
                                                $3->constant = !$1;
                                                $3->setType(symType);

                                                pair<string,Declaration*> *arg = new pair<string,Declaration*>($3->name,$3);
                                                $5->push_back(arg);
                                                delete($2);
                                                $$ = $5;
                                             }
      | VAR COMPLEXTYPE ARG                  {  /* Se crea una nueva lista para los argumentos de las funciones y
                                                 * se agrega el argumento actual. */
                                                vecFunc *args = new vecFunc;
                                                pair<string,Symbol*> *symType = scopeTree.lookup($2->second);
                                                $3->constant = !$1;
                                                $3->setType(symType);

                                                pair<string,Declaration*> *arg = new pair<string,Declaration*>($3->name,$3);
                                                args->push_back(arg);
                                                delete($2);
                                                $$ = args;
                                             }
      | VAR COMPLEXTYPE ARG tk_comma ARGSDEF {  /* Se agrega el argumento actual a la lista de argumentos de la funcion. */
                                                pair<string,Symbol*> *symType = scopeTree.lookup($2->second);
                                                $3->constant = !$1;
                                                $3->setType(symType);

                                                pair<string,Declaration*> *arg = new pair<string,Declaration*>($3->name,$3);
                                                $5->push_back(arg);
                                                delete($2);
                                                $$ = $5;
                                             }
      |  VAR TYPE ARG tk_comma               {  /* Dummy para el manejo de errores cuando hay una coma extra. */
                                                vecFunc *args = new vecFunc;
                                                pair<string,Symbol*> *symType = scopeTree.lookup(*$2);
                                                $3->constant = !$1;
                                                $3->type = symType;
                                                pair<string,Declaration*> *arg = new pair<string,Declaration*>($3->name,$3);
                                                args->push_back(arg);
                                                delete($2);
                                                $$ = args;

                                                ++errorCount;
                                                cout << "Error: Extra comma at line: " << @4.begin.line;
                                                cout << ", column: " << @4.begin.column << ".\n";
                                             }
      ;

   ARG
      : tk_identifier                                                {  yy::position pos = @1.begin;
                                                                        $$ = new Declaration(*$1,pos.line,pos.column,nullptr,false);
                                                                        delete($1);
                                                                     }
      | tk_identifier '[' tk_identifier tk_range tk_identifier ']'   {  pair<string,Symbol*> *symType = scopeTree.lookup("intmonchan");
                                                                        yy::position lowerPos = @3.begin;
                                                                        Declaration *lower = new Declaration(*$3,lowerPos.line,lowerPos.column,symType,false);
                                                                        yy::position upperPos = @5.begin;
                                                                        Declaration *upper = new Declaration(*$5,upperPos.line,upperPos.column,symType,false);

                                                                        /* Se agregan los delimitadores del arreglo a una lista global para
                                                                         * luego ser agregados al alcance correspondiente. */
                                                                        declList.push_back(lower);
                                                                        declList.push_back(upper);

                                                                        yy::position pos = @1.begin;
                                                                        $$ = new ArrayDecl(*$1,pos.line,pos.column,nullptr,false,-1,-1,arrayFactory);
                                                                        delete($1);
                                                                        delete($3);
                                                                        delete($5);
                                                                     }
      ;

%%

void yy::Parser::error(const yy::Parser::location_type &l, const std::string &err_msg) {
   ++errorCount;
   std::cerr << "Unexpected token at line: " << l.begin.line << ", column: " << l.begin.column << "\n";
}

#include "scanner.hpp"
static int yylex(yy::Parser::semantic_type *yylval, yy::Parser::location_type *yylloc,
                 Scanner &scanner, Driver &driver, TableTree &scopeTree, TupleFactory &tupleFactory) {
   return scanner.yylex(yylval,yylloc);
}
