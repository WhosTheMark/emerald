#include <iostream>
#include <cstdlib>
#include "driver.hpp"


int main(const int argc, const char **argv) {

   if (argc != 2) {
      cout << "There is no file to parse.\n";
      cout << "Syntax: ./emerald <file>\n";
      return (EXIT_FAILURE);
   }
   
   Driver driver;

   driver.parse(argv[1]);

   return(EXIT_SUCCESS);
}

