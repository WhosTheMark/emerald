#include <iostream>
#include <string>
#include <map>
#include "symbol.cpp"

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

      return false;
   };

   TableIt* lookup(string str) {

      TableIt it = table.find(str);
      if (table.end() != it)
         return new TableIt(it);

      return nullptr;
   };

   bool contains(Symbol *sym){

      return table.find(sym->name) != table.end();
   };

   void print(int tabs=0){

      for(TableIt it = table.begin(); it != table.end(); ++it)
         it->second->printSym();
   };
};

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
   
   return 0;
}