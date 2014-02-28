#include <fstream>
#include <cassert>
#include "driver.hpp"

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
   parser = new yy::Parser(*scanner,*this);
   
   assert(parser != nullptr);
   
   const int ACCEPT(0);
   
   if(parser->parse() != ACCEPT)
      std::cerr << "Parse Failed\n";
   
}

