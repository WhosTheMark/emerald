
#include <iostream>
#include <string>
#include <map>

#if ! defined(SYMBOL_)
#include "symbol.cpp"
#endif

using namespace std;

typedef map<string,Symbol*>::iterator TableIt;

class SymTable {

private:
   map<string,Symbol*> table;

public:
   SymTable() {};

   /* Agrega un simbolo a la tabla. */
   bool insert(Symbol *sym) {

      if(!contains(sym)){
         table.insert(pair<string,Symbol*>(sym->name,sym));
         return true;
      }
      return false;
   };

   /* Retorna el par del simbolo dado su nombre en la tabla. */
   pair<string,Symbol*> *lookup(string str) {

      TableIt it = table.find(str);
      if (table.end() != it)
         return new pair<string,Symbol*>(*it);

      return nullptr;
   };

   /* Retorna true si el simbolo se encuentra en la tabla. */
   bool contains(Symbol *sym){

      return table.find(sym->name) != table.end();
   };

   /* Imprime la tabla. */
   void print(int tabs=0){

      printTabs(tabs);
      cout << "----------------------------------------\n";

      for(TableIt it = table.begin(); it != table.end(); ++it) {

         printTabs(tabs);

         if (it->second != nullptr)
            it->second->printSym();
      }
   };

   /* Imprime los tabuladores necesarios. */
   void printTabs(int tabs) {

      for (int i=0; i < tabs ; ++i)
         cout << "    ";
   };

   ~SymTable() {

      map<string,Symbol*>::iterator it = table.begin();

      for(; it != table.end(); ++it){
         delete(it->second);
      }

      table.clear();
   }
};
