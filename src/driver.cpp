#include <fstream>
#include <cassert>
#include "driver.hpp"

extern int errorCount;
const int INT_SIZE = 32;
const int CHAR_SIZE = 8;
const int FLOAT_SIZE = 32;
const int BOOL_SIZE = 1;

Driver::~Driver() {
   delete(scanner);
   delete(parser);
}

void Driver::parse(const char *file) {

   assert(file != nullptr);
   std::ifstream in_file(file);

   if (!in_file.good()){
      cout << "The file does not exists.\n";
      exit(EXIT_FAILURE);
   }

   delete(scanner);
   scanner = nullptr;

   scanner = new Scanner(&in_file);
   assert(scanner != nullptr);

   delete(parser);
   parser = nullptr;
   scopeTree = new TableTree;
   initializeTree(scopeTree);
   parser = new yy::Parser(*scanner,*this,*scopeTree);

   assert(parser != nullptr);

   const int ACCEPT(0);

   if(parser->parse() == ACCEPT && errorCount == 0)
      scopeTree->printTree();
   else
      cout << errorCount << " error(s) found.\n";

   delete(scopeTree);

}

/* Inicializacion del arbol de tablas con los tipos primitivos. */
void Driver::initializeTree(TableTree *scopeTree) {

   scopeTree->enterScope();

   // Tipos basicos.

   Basic *basicInt = new Basic("intmonchan",-1,-1,INT_SIZE);
   Basic *basicChar = new Basic("charizard",-1,-1,CHAR_SIZE);
   Basic *basicFloat = new Basic("floatzel",-1,-1,FLOAT_SIZE);
   Basic *basicBool = new Basic("boolbasaur",-1,-1,BOOL_SIZE);
   Basic *basicStr = new Basic("onix",-1,-1,0);
   Basic *basicVoid = new Basic("voidporeon",-1,-1,0);

   // Funciones predefinidas

   vector<pair<string,Declaration*>*> args;
   pair<string,Declaration*> *argument;
   Declaration *n;

   Function *read = new Function("read",-1,-1,basicVoid);
   Function *print = new Function("print",-1,-1,basicVoid);
   Function *println = new Function("println",-1,-1,basicVoid);

   pair<string,Symbol*> *sym = new pair<string,Symbol*>("intmonchan",basicInt);
   n = new Declaration("int",-1,-1,sym,false);
   argument = new pair<string,Declaration*>("int",n);
   args.push_back(argument);

   Function *intToChar = new Function("intToCharizard",-1,-1,basicChar,args);

   args.clear();
   argument = new pair<string,Declaration*>(*argument);
   args.push_back(argument);

   Function *intToFloat = new Function("intToFloatzel",-1,-1,basicFloat,args);

   args.clear();

   sym = new pair<string,Symbol*>("charizard",basicChar);
   n = new Declaration("char",-1,-1,sym,false);
   argument = new pair<string,Declaration*>("char",n);
   args.push_back(argument);

   Function *charToInt = new Function("charToIntmonchan",-1,-1,basicInt,args);

   args.clear();

   sym = new pair<string,Symbol*>("floatzel",basicFloat);
   n = new Declaration("float",-1,-1,sym,false);
   argument = new pair<string,Declaration*>("float",n);
   args.push_back(argument);

   Function *floatToInt = new Function("floatToIntmonchan",-1,-1,basicInt,args);

   args.clear();


   scopeTree->insert(basicInt);
   scopeTree->insert(basicChar);
   scopeTree->insert(basicFloat);
   scopeTree->insert(basicBool);
   scopeTree->insert(basicStr);
   scopeTree->insert(basicVoid);

   scopeTree->insert(read);
   scopeTree->insert(print);
   scopeTree->insert(println);
   scopeTree->insert(intToChar);
   scopeTree->insert(intToFloat);
   scopeTree->insert(charToInt);
   scopeTree->insert(floatToInt);
}