#include <iostream>
#include <map>
#include <string>
#include "symbol.hpp"
#include "symTable.hpp"

using namespace std;

typedef std::pair<string, Symbol> symPair;

void SymTable::insert(Symbol sym) {
    
    table.insert(symPair(sym.name,sym));     
}

bool SymTable::contains(string str) {
   
      map<string,Symbol>::iterator it = table.find(str);
      
      return it != table.end() ;
}
   
Symbol SymTable::lookup(string str) {
   
      map<string,Symbol>::iterator it = table.find(str);
      
      if (it != table.end())
         return it->second;
      else 
         return nullptr;
   
}
   
void SymTable::printTable(int tabs) {

   map<string,Symbol>::iterator it;
   
   for (it = table.begin(); it != table.end(); ++it) {
      
      Symbol sym = it->second;
      
      
      
   }

}   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
}