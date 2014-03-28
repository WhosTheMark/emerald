
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


   bool insert(Symbol *sym) {

      if(!contains(sym)){
         table.insert(pair<string,Symbol*>(sym->name,sym));
         return true;
      }
      //TODO error de declarar la variable mas de una vez
      return false;
   };

   pair<string,Symbol*> *lookup(string str) {

      TableIt it = table.find(str);
      if (table.end() != it)
         return new pair<string,Symbol*>(*it);

      return nullptr;
   };

   bool contains(Symbol *sym){

      return table.find(sym->name) != table.end();
   };

   void print(int tabs=0){
      
      printTabs(tabs);
      cout << "----------------------------------------\n";
      
      for(TableIt it = table.begin(); it != table.end(); ++it) {
       
         printTabs(tabs);
         it->second->printSym();
      }
   };
   
   void printTabs(int tabs) {
    
      for (int i=0; i < tabs ; ++i) 
         cout << "    ";      
   };
};
/*
int main () {

   Basic basicInt("int", -1,-1, 4);
   vector<pair<string,Declaration*>*> emptyVector;
   Function func("squirtle", 1, 1, &basicInt, emptyVector, 1);
   pair<string,Definition*> pairDef(basicInt.name,&basicInt);

   Declaration variable("i", 2, 3, &pairDef, false);
   ArrayDecl array("intArr", 5, 6, &pairDef, false, 0, 10);

   Register reg("persona", 8, 9, 28);
   pair<string,Definition*> pairReg(reg.name,&reg);
   Declaration varPerson("Andrea", 6, 66, &pairReg, false);

   SymTable table;
   
   table.insert(&basicInt);
   table.insert(&func);
   table.insert(&variable);
   table.insert(&array);
   table.insert(&reg);
   table.insert(&varPerson);
   
   table.print();
  
   pair<string,Symbol*> *sym = table.lookup("int");

   if (sym != nullptr)
      sym->second->printSym();
   
   
   return 0;
}*/