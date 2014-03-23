#include <iostream>
#include <cstdlib>

#include "driver.hpp"


int main(const int argc, const char **argv) {

   if (argc != 2) 
      return (EXIT_FAILURE);

   Driver driver;

   driver.parse(argv[1]);
   
   return(EXIT_SUCCESS);
}

