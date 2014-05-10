#ifndef __DRIVER_HPP__
#define __DRIVER_HPP__ 1

#include <string>
#include "scanner.hpp"
#include "parser.tab.h"
#include "tableTree.cpp"
#include "type.cpp"

class Driver {
public:
   Driver() : parser(nullptr), scanner(nullptr), scopeTree(nullptr), tupleFactory(nullptr) {};
   virtual ~Driver();

   void parse(const char *file);
   void initializeTree(TableTree *scopeTree);

private:

   yy::Parser *parser;
   Scanner *scanner;
   TableTree *scopeTree;
   TupleFactory *tupleFactory;
};

#endif