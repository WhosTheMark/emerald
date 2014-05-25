#include <fstream>
#include <cassert>
#include "driver.hpp"

extern int errorCount;


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

   tupleFactory = new TupleFactory();
   parser = new yy::Parser(*scanner,*this,*scopeTree,*tupleFactory);

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

   Integer *basicInt = new Integer();
   Character *basicChar = new Character();
   Float *basicFloat = new Float();
   Boolean *basicBool = new Boolean();
   String *basicStr = new String();
   Void *basicVoid = new Void();

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

   Function *intToChar = new Function("intToCharizard",-1,-1,basicChar,args,basicInt);

   args.clear();
   argument = new pair<string,Declaration*>(*argument);
   args.push_back(argument);

   Function *intToFloat = new Function("intToFloatzel",-1,-1,basicFloat,args,basicInt);

   args.clear();

   sym = new pair<string,Symbol*>("charizard",basicChar);
   n = new Declaration("char",-1,-1,sym,false);
   argument = new pair<string,Declaration*>("char",n);
   args.push_back(argument);

   Function *charToInt = new Function("charToIntmonchan",-1,-1,basicInt,args,basicChar);

   args.clear();

   sym = new pair<string,Symbol*>("floatzel",basicFloat);
   n = new Declaration("float",-1,-1,sym,false);
   argument = new pair<string,Declaration*>("float",n);
   args.push_back(argument);

   Function *floatToInt = new Function("floatToIntmonchan",-1,-1,basicInt,args,basicFloat);

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