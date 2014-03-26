%skeleton "lalr1.cc"
%require "2.7"
%debug
%defines
%locations

%define parser_class_name "Parser"

%code requires{
   #include "symbol.cpp"
   class Driver;
   class Scanner;
   class TableTree;
}

%lex-param { Scanner &scanner }
%parse-param { Scanner &scanner }

%lex-param { Driver &driver }
%parse-param { Driver &driver }

%lex-param { TableTree &scopeTree }
%parse-param { TableTree &scopeTree }

%code{

   #include <iostream>
   #include <cstdlib>
   #include <fstream>
   #include <math.h>
   #include "driver.hpp"
   #include <vector>
   #include <string>

   static int yylex(yy::Parser::semantic_type *yylval, yy::Parser::location_type *yylloc,
   Scanner &scanner, Driver &driver, TableTree &scopeTree);
   typedef std::vector<std::pair<std::string*,yy::position>*> vecString;
   typedef std::vector<std::pair<std::string,Declaration*>*> vecFunc;

   vector<Declaration*> declList;
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
   std::vector<std::pair<std::string*,yy::position>*> *idsList;
   bool boolean;
   std::vector<std::pair<std::string,Declaration*>*> *vecFunction;
   std::pair<std::string,std::string> *complex;
   Declaration *declr;
}

%type <idsList> IDLIST
%type <ids> tk_identifier TYPE tk_charType tk_floatType tk_intType tk_boolType tk_stringType
%type <ids> tk_structType tk_unionType tk_voidType
%type <complex> COMPLEXTYPE
%type <boolean> VAR
%type <vecFunction> ARGSDEF
%type <declr> ARG


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
      : { scopeTree.enterScope(); } DEFLIST { scopeTree.exitScope(); }
      ;

   DEFLIST
      : DEFINITION
      | DEFINITION DEFLIST ;

   DEFINITION
      : FUNCDEF
      | REGISTER
      | UNION
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
      | '{' { scopeTree.enterScope(); } DECLARELIST STMTLIST '}' { scopeTree.exitScope(); } ;

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
      : tk_for tk_identifier tk_from EXPR tk_to EXPR tk_by EXPR { scopeTree.enterScope();
                                                                  yy::position pos = @2.begin;  //TODO poner el tipo adecuado de la variable
                                                                  Declaration* decl = new Declaration(*$2,pos.line, pos.column, nullptr, false);
                                                                  scopeTree.insert(decl);
                                                         } INST { scopeTree.exitScope(); }
      | tk_for tk_identifier tk_from EXPR tk_to EXPR { scopeTree.enterScope();
                                                       yy::position pos = @2.begin;  //TODO poner el tipo adecuado de la variable
                                                       Declaration* decl = new Declaration(*$2,pos.line, pos.column, nullptr, false);
                                                       scopeTree.insert(decl);
                                              } INST { scopeTree.exitScope(); };

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
      : TYPE IDLIST INITLIST tk_semicolon { vecString::reverse_iterator it = $2->rbegin();
                                             pair<string,Symbol*> *symType = scopeTree.lookup(*$1);

                                             if (symType == nullptr || dynamic_cast<Definition*>(symType->second) != 0)

                                                for(; it != $2->rend(); ++it) {
                                                   Declaration *decl = new Declaration(*((**it).first),(**it).second.line,
                                                                                       (**it).second.column,symType,false);
                                                   scopeTree.insert(decl);
                                                }
                                             else
                                                cout << "BOOM: Symbol" << symType->second << " is not a valid Definition\n";
                                          }

      | COMPLEXTYPE IDLIST INITLIST tk_semicolon { vecString::reverse_iterator it = $2->rbegin();
                                                   pair<string,Symbol*> *symType = scopeTree.lookup($1->second);

                                                   if (symType == nullptr ||
                                                      ((dynamic_cast<Register*>(symType->second) != 0) && ($1->first == "registeer")))

                                                      for(; it != $2->rend(); ++it) {
                                                         Declaration *decl = new Declaration(*((**it).first),(**it).second.line,
                                                                                             (**it).second.column,symType,false);
                                                         scopeTree.insert(decl);
                                                      }

                                                   else if ($1->first == "unown")
                                                      cout << "HAY QUE HACER UNOWNS!!!\n"; //TODO

                                                   else
                                                      cout << "BOOM\n";
                                                 }
      ;



   IDLIST
      : tk_identifier ARRAYDECL { vecString *idList = new vecString;
                                  pair<string*,yy::position> *idPos = new pair<string*,yy::position>($1,@1.begin);
                                  idList->push_back(idPos);
                                  $$ = idList; }
      | tk_identifier ARRAYDECL tk_comma IDLIST { pair<string*,yy::position> *idPos = new pair<string*,yy::position>($1,@1.begin);
                                                  $4->push_back(idPos);
                                                  $$ = $4; }
      | tk_const tk_identifier ARRAYDECL { vecString *idList = new vecString;
                                           pair<string*,yy::position> *idPos = new pair<string*,yy::position>($2,@2.begin);
                                           idList->push_back(idPos);
                                           $$ = idList; /*TODO FALTA CONST*/ }
      | tk_const tk_identifier ARRAYDECL tk_comma IDLIST { pair<string*,yy::position> *idPos = new pair<string*,yy::position>($2,@2.begin);
                                                           $5->push_back(idPos);
                                                           $$ = $5; };

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
      : tk_unionType tk_identifier { $$ = new pair<string,string>(*$1,*$2); }
      | tk_structType tk_identifier { $$ = new pair<string,string>(*$1,*$2); }
      ;

   VAR
      : /* vacio */ { $$ = false; }
      | tk_var { $$ = true; } ;

   REGISTER
      : tk_structType tk_identifier '{' DECLARELIST '}' { yy::position pos = @1.begin;
                                                          Register *reg = new Register(*$2,pos.line,pos.column,0);
                                                          scopeTree.insert(reg);
                                                          //NOTE que hacemos con los campos?
                                                        }
      ;

   UNION
      : tk_unionType tk_identifier '{' DECLARELIST '}' { yy::position pos = @1.begin;
                                                          Union *un = new Union(*$2,pos.line,pos.column,0);
                                                          scopeTree.insert(un);
                                                          //NOTE que hacemos con los campos?
                                                        }
      ;

   FUNCDEF
      : TYPE tk_identifier '(' ')' { yy::position pos = @1.begin;
                                     Basic *symType = (Basic*) scopeTree.lookup(*$1)->second;
                                     Function *func = new Function(*$2,pos.line,pos.column,symType);
                                     scopeTree.insert(func);
                                   }

                                   BLOCK {  }

      | tk_voidType tk_identifier '(' ')' { Basic *symType = (Basic*) scopeTree.lookup(*$1)->second;
                                            yy::position pos = @1.begin;
                                            Function *func = new Function(*$2,pos.line,pos.column,symType);
                                            scopeTree.insert(func);
                                          }

                                          BLOCK {  }

      | TYPE tk_identifier '(' ARGSDEF ')' { Basic *symType = (Basic*) scopeTree.lookup(*$1)->second;
                                                   vecFunc *args = new vecFunc;
                                                   vecFunc::reverse_iterator it = $4->rbegin();

                                                   for(; it != $4->rend(); ++it)
                                                      args->push_back(*it);

                                                  yy::position pos = @1.begin;
                                                  Function *func = new Function(*$2,pos.line,pos.column,symType,*args);
                                                  scopeTree.insert(func);
                                                  scopeTree.enterScope();

                                                  for(it = $4->rbegin(); it != $4->rend(); ++it)
                                                         scopeTree.insert((*it)->second);
                                                  vector<Declaration*>::reverse_iterator declIt = declList.rbegin();
                                                  for(;declIt != declList.rend(); ++declIt)
                                                     scopeTree.insert(*declIt);

                                                  declList.empty();
                                           }

                                           BLOCK { scopeTree.exitScope(); }

      | tk_voidType tk_identifier '(' ARGSDEF ')' { Basic *symType = (Basic*) scopeTree.lookup(*$1)->second;
                                                    vecFunc *args = new vecFunc;
                                                    vecFunc::reverse_iterator it = $4->rbegin();

                                                    for(; it != $4->rend(); ++it)
                                                      args->push_back(*it);

                                                    yy::position pos = @1.begin;
                                                    Function *func = new Function(*$2,pos.line,pos.column,symType,*args);
                                                    scopeTree.insert(func);
                                                    scopeTree.enterScope();

                                                    for(it = $4->rbegin(); it != $4->rend(); ++it)
                                                         scopeTree.insert((*it)->second);

                                                    vector<Declaration*>::reverse_iterator declIt = declList.rbegin();
                                                    for(;declIt != declList.rend(); ++declIt)
                                                         scopeTree.insert(*declIt);

                                                    declList.empty();

                                                  }

                                                  BLOCK { scopeTree.exitScope(); }
      ;

   ARGSDEF
      :  VAR TYPE ARG { vecFunc *args = new vecFunc;
                       pair<string,Symbol*> *symType = scopeTree.lookup(*$2);
                       $3->constant = !$1;
                       $3->type = symType;
                       pair<string,Declaration*> *arg = new pair<string,Declaration*>($3->name,$3);
                       args->push_back(arg);
                       $$ = args;
                     }

      | VAR TYPE ARG tk_comma ARGSDEF { pair<string,Symbol*> *symType = scopeTree.lookup(*$2);
                                        $3->constant = !$1;
                                        $3->type = symType;
                                        pair<string,Declaration*> *arg = new pair<string,Declaration*>($3->name,$3);
                                        $5->push_back(arg);
                                        $$ = $5;
                                      }

      | VAR COMPLEXTYPE ARG { vecFunc *args = new vecFunc;
                              pair<string,Symbol*> *symType = scopeTree.lookup($2->second);
                              $3->constant = !$1;
                              $3->type = symType;
                              pair<string,Declaration*> *arg = new pair<string,Declaration*>($3->name,$3);
                              args->push_back(arg);
                              $$ = args;
                            }

      | VAR COMPLEXTYPE ARG tk_comma ARGSDEF { pair<string,Symbol*> *symType = scopeTree.lookup($2->second);
                                               $3->constant = !$1;
                                               $3->type = symType;
                                               pair<string,Declaration*> *arg = new pair<string,Declaration*>($3->name,$3);
                                               $5->push_back(arg);
                                               $$ = $5;
                                             }
      ;

   ARG
      : tk_identifier { yy::position pos = @1.begin;
                        $$ = new Declaration(*$1,pos.line,pos.column,nullptr,false);
                      }
      | '[' tk_identifier tk_range tk_identifier ']' tk_identifier { pair<string,Symbol*> *symType = scopeTree.lookup("intmonchan");
                                                                     yy::position lowerPos = @2.begin;
                                                                     Declaration *lower = new Declaration(*$2,lowerPos.line,lowerPos.column,symType,false);
                                                                     yy::position upperPos = @4.begin;
                                                                     Declaration *upper = new Declaration(*$4,upperPos.line,upperPos.column,symType,false);
                                                                     declList.push_back(lower);
                                                                     declList.push_back(upper);
                                                                     yy::position pos = @6.begin;
                                                                     $$ = new ArrayDecl(*$6,pos.line,pos.column,nullptr,false,-1,-1);
                                                                   }
      ;

%%

void yy::Parser::error(const yy::Parser::location_type &l, const std::string &err_msg) {
   std::cerr << "Error: " << l << "\n";
}

#include "scanner.hpp"
static int yylex(yy::Parser::semantic_type *yylval, yy::Parser::location_type *yylloc,
                 Scanner &scanner, Driver &driver, TableTree &scopeTree) {
   return scanner.yylex(yylval,yylloc);
}



