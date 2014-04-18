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
   Function *funcAux;
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
   Function *funct;
}

%type <idsList> IDLIST
%type <ids> tk_identifier TYPE tk_charType tk_floatType tk_intType tk_boolType tk_stringType
%type <ids> tk_structType tk_unionType tk_voidType
%type <complex> COMPLEXTYPE
%type <boolean> VAR
%type <vecFunction> ARGSDEF
%type <declr> ARG
%type <funct> FUNC


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
      : EXPR '+' EXPR
      | EXPR '-' EXPR
      | EXPR '*' EXPR
      | EXPR '/' EXPR
      | EXPR '^' EXPR
      | EXPR '=' EXPR
      | EXPR '=''=' EXPR            {  ++errorCount;
                                       cout << "Error: Perhaps you meant \"=\" instead of \"==\" at line: ";
                                       cout << @2.begin.line << ", column: " << @2.begin.column << ".\n";
                                    }
      | EXPR '[' EXPR ']'
      | EXPR tk_mod EXPR
      | EXPR tk_and EXPR
      | EXPR tk_or EXPR
      | EXPR tk_lessEq EXPR
      | EXPR tk_moreEq EXPR
      | EXPR tk_lessThan EXPR
      | EXPR tk_moreThan EXPR
      | EXPR tk_notEqual EXPR
      | EXPR tk_dot tk_identifier   { delete($3); /*NOTE puede que esto se use despues*/ }
      | '!' EXPR
      | '-' EXPR %prec UMINUS
      | '(' EXPR ')'
      | '(' error ')'               {  ++errorCount;
                                       cout << "Error in expression at line: " << @2.begin.line;
                                       cout << ", column: " << @2.begin.column << ".\n";
                                    }
      | '(' ')'                     {  ++errorCount;
                                       cout << "Error at line: " << @1.begin.line;
                                       cout << ", column: " << @1.begin.column;
                                       cout << ": parenthesis must contain an expression.\n";
                                    }
      | CONST
      | FUNCCALL
      | tk_identifier               {  pair<string,Symbol*> *id = scopeTree.lookup(*$1);

                                       if (id == nullptr) {
                                          ++errorCount;
                                          yy::position pos = @1.begin;
                                          cout << "The variable '" << *$1 << "' at line: " << pos.line;
                                          cout << ", column: " << pos.column << " has not been declared.\n";
                                       } else
                                          delete(id);

                                        delete($1); //NOTE puede que esto se use despues
                                    }
      | tk_string
      ;

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
      : /* empty */
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
      : ASIGNLIST tk_asignment ARGSLIST
      | ASIGNLIST '=' ARGSLIST       {  ++errorCount;
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
      : tk_if EXPR INST %prec IFPREC
      | tk_if EXPR INST IFLIST
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
      : EXPR INST
      | error INST   {  ++errorCount;
                        cout << "Invalid expression in elsif condition at line: ";
                        cout << @1.begin.line << ", column: " << @1.begin.column;
                        cout << ".\n";
                        yyerrok;
                     }
      ;

   WHILESTMT
      : tk_while EXPR INST
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
                                                                     scopeTree.insert(decl);
                                                                     delete($2);
                                                                  }
                                                            INST  {  scopeTree.exitScope(); }

      | tk_for tk_identifier tk_from EXPR tk_to EXPR              {  /* Se abre un nuevo alcance para la variable de la
                                                                      * instruccion for y la agrega a la tabla. */
                                                                     scopeTree.enterScope();
                                                                     yy::position pos = @2.begin;  //TODO poner el tipo adecuado de la variable
                                                                     Declaration* decl = new Declaration(*$2,pos.line, pos.column, nullptr, false);
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
                                          }

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
      : tk_switch EXPR '{' CASE '}'
      ;

   CASE
      : tk_case CONST tk_arrow BLOCK
      | tk_case CONST tk_arrow BLOCK CASELIST
      ;

   CASELIST
      : tk_default tk_arrow BLOCK
      | tk_case CONST tk_arrow BLOCK
      | tk_case CONST tk_arrow BLOCK CASELIST
      ;

   DECLARATION
      : TYPE IDLIST INITLIST tk_semicolon          {  /* Toma una lista de identificadores y los inserta a tabla de simbolos con su tipo. */
                                                      vecString::reverse_iterator it = $2->rbegin();
                                                      pair<string,Symbol*> *symType = scopeTree.lookup(*$1);

                                                      if (symType == nullptr || dynamic_cast<Definition*>(symType->second) != 0)

                                                         for(; it != $2->rend(); ++it) {
                                                            Declaration *decl = new Declaration(*((**it).first),(**it).second.line,
                                                                                                (**it).second.column,symType,false);
                                                            scopeTree.insert(decl);
                                                            delete((*it)->first);
                                                            delete(*it);
                                                         }
                                                      delete($2);
                                                      delete($1);
                                                   }
      | COMPLEXTYPE IDLIST INITLIST tk_semicolon   {  /* Toma una lista de identificadores y los inserta a tabla de simbolos con su tipo. */
                                                      vecString::reverse_iterator it = $2->rbegin();
                                                      pair<string,Symbol*> *symType = scopeTree.lookup($1->second);

                                                      for (; it != $2->rend(); ++it) {
                                                         Declaration *decl = new Declaration(*((**it).first),(**it).second.line,
                                                                                             (**it).second.column,symType,false);
                                                         scopeTree.insert(decl);
                                                         delete((*it)->first);
                                                         delete(*it);
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
                                                            vecString *idList = new vecString;
                                                            pair<string*,yy::position> *idPos = new pair<string*,yy::position>($1,@1.begin);
                                                            idList->push_back(idPos);
                                                            $$ = idList;
                                                         }
      | tk_identifier ARRAYDECL tk_comma IDLIST          {  /* Se agrega el identificador actual a la lista ya creada.*/
                                                            pair<string*,yy::position> *idPos = new pair<string*,yy::position>($1,@1.begin);
                                                            $4->push_back(idPos);
                                                            $$ = $4;
                                                         }
      | tk_const tk_identifier ARRAYDECL                 {  /* Se crea una nueva lista de strings para los identificadores
                                                             * y se agrega el identificador actual.*/
                                                            vecString *idList = new vecString;
                                                            pair<string*,yy::position> *idPos = new pair<string*,yy::position>($2,@2.begin);
                                                            idList->push_back(idPos);
                                                            $$ = idList;
                                                            /*TODO Falta poner si es una constante*/
                                                         }
      | tk_const tk_identifier ARRAYDECL tk_comma IDLIST {  /* Se agrega el identificador actual a la lista ya creada.*/
                                                            pair<string*,yy::position> *idPos = new pair<string*,yy::position>($2,@2.begin);
                                                            $5->push_back(idPos);
                                                            $$ = $5;
                                                            /*TODO Falta poner si es una constante*/
                                                         }
      | error tk_comma IDLIST                            {  ++errorCount;
                                                            cout << "Error in declaration at line: " << @1.begin.line;
                                                            cout << ", column: " << @1.begin.column << ".\n";
                                                            yyerrok;
                                                            $$ = $3;
                                                         }
      ;

   ARRAYDECL
      : /* empty */
      | '[' EXPR tk_range EXPR ']'
      | '[' error ']'   {  ++errorCount;
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
      | tk_asignment ARGSLIST
      | '=' ARGSLIST          {  ++errorCount;
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

                                       } else if (dynamic_cast<Union*>(symType->second) == 0){
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

                                       } else if (dynamic_cast<Register*>(symType->second) == 0){
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

   REGISTER
      : tk_structType tk_identifier '{'   {  scopeTree.enterScope(); }

                        DECLARELIST '}'   {  scopeTree.exitScope();
                                             yy::position pos = @1.begin;
                                             Register *reg = new Register(*$2,pos.line,pos.column,0);
                                             scopeTree.insert(reg);
                                             delete($2);
                                             delete($1);
                                          }
      ;

   UNION
      : tk_unionType tk_identifier '{'    {  scopeTree.enterScope(); }
                       DECLARELIST '}'    {  scopeTree.exitScope();
                                             yy::position pos = @1.begin;
                                             Union *un = new Union(*$2,pos.line,pos.column,0);
                                             scopeTree.insert(un);
                                             delete($2);
                                             delete($1);
                                          }
      ;


   FUNCDEF
      : TYPE FUNC          {  pair<string,Symbol*> *type = scopeTree.lookup(*$1);
                              Basic *symType = (Basic*) type->second;
                              $2->returnType = symType;
                              funcAux = $2;
                              delete(type);
                              delete($1);
                           }

                  FUNCBODY

      | tk_voidType FUNC   {  pair<string,Symbol*> *type = scopeTree.lookup(*$1);
                              Basic *symType = (Basic*) type->second;
                              $2->returnType = symType;
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

      |              {  pair<string,Symbol*> *funcPair = scopeTree.lookup(funcAux->name);
                        Function *func = nullptr;

                        if (funcPair != nullptr)
                           func = dynamic_cast<Function*>(funcPair->second);


                        vector<pair<string,Declaration*>*>::iterator args2 = funcAux->arguments.begin();

                        if (func != nullptr && func != 0 && func->fwdDecl) {

                           if (func->returnType != funcAux->returnType) {
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

                           for(args2 = funcAux->arguments.begin(); args2 != funcAux->arguments.end(); ++args2)
                              scopeTree.insert((*args2)->second);

                           /* Si hay arreglos en los argumentos entonces se agregan
                            * las variables asociadas a sus delimitadores. */

                           vector<Declaration*>::reverse_iterator declIt = declList.rbegin();
                           for(;declIt != declList.rend(); ++declIt)
                              scopeTree.insert(*declIt);

                           declList.clear(); //Vacia la lista.

                           //NOTE agregar el body
                        }
                     }

               BLOCK {  if (funcAux->arguments.size() != 0)
                           scopeTree.exitScope();
                        funcAux = nullptr;
                     }
      ;

   FUNC
      : tk_identifier '(' ')'          {  yy::position pos = @1.begin;
                                          Function *func = new Function(*$1,pos.line,pos.column,nullptr);
                                          $$ = func;
                                          delete($1);
                                       }


     | tk_identifier '(' ARGSDEF ')'   {  yy::position pos = @1.begin;
                                          vecFunc args;
                                          vecFunc::reverse_iterator it = $3->rbegin();

                                          /* Invierte la lista de argumentos para agregarla a la declaracion. */
                                          for(; it != $3->rend(); ++it)
                                             args.push_back(*it);

                                          Function *func = new Function(*$1,pos.line,pos.column,nullptr,args);
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
                                                $3->type = symType;
                                                pair<string,Declaration*> *arg = new pair<string,Declaration*>($3->name,$3);
                                                args->push_back(arg);
                                                delete($2);
                                                $$ = args;
                                             }
      | VAR TYPE ARG tk_comma ARGSDEF        {  /* Se agrega el argumento actual a la lista de argumentos de la funcion. */
                                                pair<string,Symbol*> *symType = scopeTree.lookup(*$2);
                                                $3->constant = !$1;
                                                $3->type = symType;
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
                                                $3->type = symType;
                                                pair<string,Declaration*> *arg = new pair<string,Declaration*>($3->name,$3);
                                                args->push_back(arg);
                                                delete($2);
                                                $$ = args;
                                             }
      | VAR COMPLEXTYPE ARG tk_comma ARGSDEF {  /* Se agrega el argumento actual a la lista de argumentos de la funcion. */
                                                pair<string,Symbol*> *symType = scopeTree.lookup($2->second);
                                                $3->constant = !$1;
                                                $3->type = symType;
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
                                                                        $$ = new ArrayDecl(*$1,pos.line,pos.column,nullptr,false,-1,-1);
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
                 Scanner &scanner, Driver &driver, TableTree &scopeTree) {
   return scanner.yylex(yylval,yylloc);
}
