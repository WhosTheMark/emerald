#include <iostream>
#include <string>
#include <map>
#include <vector>
#include "symTable.cpp"

using namespace std;

extern int errorCount;

class SymTableNode {

public:

   SymTable table;
   SymTableNode *parent;
   vector<SymTableNode*> children;

   SymTableNode(SymTableNode *p) : parent(p) {};
   SymTableNode() : parent(nullptr) {};

   ~SymTableNode(){

      vector<SymTableNode*>::iterator it = children.begin();
      for(; it != children.end(); ++it)
         delete(*it);

      children.clear();
   }
};

class TableTree {

public:

   SymTableNode *root;
   SymTableNode *currentScope;

   TableTree() : root(nullptr) , currentScope(nullptr) {};

   /* Abre un alcance nuevo. */
   void enterScope() {

      if (root != nullptr) {

         SymTableNode *child = new SymTableNode(currentScope);
         currentScope->children.push_back(child);
         currentScope = child;

      /* Si no existe la raiz, crea el primer alcance. */
      } else {

         SymTableNode *newRoot = new SymTableNode();
         root = newRoot;
         currentScope = newRoot;
      }
   };

   /* Cierra el alcance actual. */
   void exitScope() {

      currentScope = currentScope->parent;
   };

   /* Inserta un simbolo al alcance actual. */
   bool insert(Symbol *sym) {

      /* Si el simbolo no esta en la raiz, se intenta de agregar.*/
      if (!root->table.contains(sym)) {

         vector<SymTableNode*>::iterator it = root->children.begin();

         /* Si el simbolo es una funcion o tipo definido por el usuario
          * o esta en el alcance actual entonces no se agrega.*/
         if ((it != root->children.end() && root->children.front()->table.contains(sym)
            && dynamic_cast<Declaration*>((root->children.front()->table.lookup(sym->name))->second) == 0)
            || !currentScope->table.insert(sym)) {

            ++errorCount;
            pair<string,Symbol*> *reDef = this->lookup(sym->name);
            cout << "The variable '" << sym->name << "' at line: " << sym->line << ", column: ";
            cout << sym->column << " has already been defined at line: " << reDef->second->line;
            cout << ", column: " << reDef->second->column << ".\n";

         } else
            return true;
      }
      return false;
   };

   /* Busca el simbolo dado su nombre en el arbol de tablas.*/
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

   /* Imprime el arbol de tablas. */
   void printTree() {

      printNode(0,root);
      cout << "\n";
   };

   ~TableTree() {
      delete(root);
   }

private:

   /* Imprime un nodo del arbol de tablas. */
   void printNode(int tabs, SymTableNode *currentNode) {

      currentNode->table.print(tabs);
      vector<SymTableNode*>::iterator it = currentNode->children.begin();

      for ( ; it != currentNode->children.end() ; ++it)
         printNode(tabs+1,*it);
   };
};