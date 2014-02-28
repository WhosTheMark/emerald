#ifndef __DRIVER_HPP__
#define __DRIVER_HPP__ 1

#include <string>
#include "scanner.hpp"
#include "parser.tab.h"

class Driver {
public:
   Driver() : parser(nullptr), scanner(nullptr) {};
   virtual ~Driver();
   
   void parse(const char *file);
   
private:
   
   yy::Parser *parser;
   Scanner *scanner;
};

#endif