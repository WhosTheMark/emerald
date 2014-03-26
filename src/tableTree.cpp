#include <iostream>
#include <string>
#include <map>
#include <vector>
#include "symTable.cpp"

using namespace std;

class SymTableNode {

public:
   SymTable table;
   SymTableNode *parent;
   vector<SymTableNode*> children;

   SymTableNode(SymTableNode *p) : parent(p) {};
   SymTableNode() : parent(nullptr) {};

};


class TableTree {

public:

   SymTableNode *root;
   SymTableNode *currentScope;

   TableTree() : root(nullptr) , currentScope(nullptr) {};

   void enterScope() {

      if (root != nullptr) {

         SymTableNode *child = new SymTableNode(currentScope);
         currentScope->children.push_back(child);
         currentScope = child;

      } else {

         SymTableNode *newRoot = new SymTableNode();
         root = newRoot;
         currentScope = newRoot;

      }
   };

   void exitScope() {

      currentScope = currentScope->parent;
   };

   bool insert(Symbol *sym) {
    //TODO ver cuando no se puede redefinir las variables definidas por usuario

      if (!root->table.contains(sym)) {
        if (!currentScope->table.insert(sym)){
         pair<string,Symbol*> *reDef = this->lookup(sym->name);
         cout << "Variable " << sym->name << " at line: " << sym->line << ", column: ";
         cout << sym->column << " has already been defined at line: " << reDef->second->line;
         cout << " column: " << reDef->second->column << "\n";
        } else
           return true;
      }
      return false;

   };

   pair<string,Symbol*> *lookup(string symName) {

      SymTableNode *aux = currentScope;

      while (aux != nullptr) {

         pair<string,Symbol*> *sym = aux->table.lookup(symName);

         if (sym != nullptr)
            return sym;

         aux = aux->parent;
      }
      return nullptr;
   };


   void printTree() {

      printNode(0,root);

   };


private:

   void printNode(int tabs, SymTableNode *currentNode) {

      currentNode->table.print(tabs);
      vector<SymTableNode*>::iterator it = currentNode->children.begin();

      for ( ; it != currentNode->children.end() ; ++it)
         printNode(tabs+1,*it);
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
   Function funcInt("i", 1, 1, &basicInt, emptyVector, 1);
   Register reg("persona", 8, 9, 28);
   pair<string,Definition*> pairReg(reg.name,&reg);
   Declaration varPerson("Andrea", 6, 66, &pairReg, false);

   TableTree tree;
   tree.enterScope();

   tree.insert(&basicInt);
   tree.insert(&func);

   tree.enterScope();

   tree.insert(&variable);
   tree.insert(&array);

   tree.enterScope();

   tree.insert(&funcInt);
   tree.insert(&reg);

   //tree.exitScope();
   tree.insert(&varPerson);

   tree.printTree();

   pair<string,Symbol*> *sym = tree.lookup("i");

   sym->second->printSym();

   tree.exitScope();

   sym = tree.lookup("i");

   sym->second->printSym();


   return 0;



}*/