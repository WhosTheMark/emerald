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

   if (!in_file.good())
      exit(EXIT_FAILURE);

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

}

/* Inicializacion del arbol de tablas con los tipos primitivos. */
void Driver::initializeTree(TableTree *scopeTree) {

   scopeTree->enterScope();

   Basic *basicInt = new Basic("intmonchan",-1,-1,INT_SIZE);
   Basic *basicChar = new Basic("charizard",-1,-1,CHAR_SIZE);
   Basic *basicFloat = new Basic("floatzel",-1,-1,FLOAT_SIZE);
   Basic *basicBool = new Basic("boolbasaur",-1,-1,BOOL_SIZE);
   Basic *basicStr = new Basic("onix",-1,-1,0);
   Basic *basicVoid = new Basic("voidporeon",-1,-1,0);

   scopeTree->insert(basicInt);
   scopeTree->insert(basicChar);
   scopeTree->insert(basicFloat);
   scopeTree->insert(basicBool);
   scopeTree->insert(basicStr);
   scopeTree->insert(basicVoid);

}