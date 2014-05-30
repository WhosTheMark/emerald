#include <string>
#include <vector>
#include "tableTree.cpp"
#include "expressions.cpp"
#include "instructions.cpp"
#include "symTable.cpp"

using namespace std;


class DefNode {

public:
   virtual void printDefNode(int tabs=0) {};
   void printTabs(int tabs) {

      for (int i=0; i < tabs ; ++i)
         cout << "    ";
   };
};

class FuncDef : public DefNode {

public:

   string name;
   Block *block;  //Esto puede ser nullptr si es un foward declaration!

   FuncDef(string n, Block *b) : name(n) , block(b) {};

   void printDefNode(int tabs=0) {

      if (block != nullptr) {

         cout << "FUNCTION: " << name << "\n";
         printTabs(tabs);
         block->printInstruction(tabs+1);

      } else
         cout << "FORWARD DECLARATION OF FUNCTION: " << name << "\n";

   };
};

class DeclareNode : public DefNode {

public:

   string type;
   vector<Expression*> inits;

   DeclareNode(string t, vector<Expression*> init) :
               type(t), inits(init) {};

   void printDefNode(int tabs=0) {

      cout << "DECLARATION: " << type << "\n";

      vector<Expression*>::iterator it = inits.begin();

      for (; it != inits.end(); ++it) {
         printTabs(tabs);
         (*it)->printExpression(tabs+1);
      }

   };
};

class RegisterDef : public DefNode {

public:

   string name;
   SymTableNode *fields;

   RegisterDef(string n) : name(n) {};

   void printDefNode(int tabs=0) {

      cout << "REGISTER: " << name << "\n";
      fields->table.print(tabs+1);
      printTabs(tabs+1);
      cout << "----------------------------------------\n";

   };
};

class UnionDef : public DefNode {

public:

   string name;
   SymTableNode *fields;

   UnionDef(string n) : name(n) {};

   void printDefNode(int tabs=0) {

      cout << "UNION: " << name << "\n";
      fields->table.print(tabs+1);
      printTabs(tabs+1);
      cout << "----------------------------------------\n";
   };

};

class AST {

public:

   vector<DefNode*> list;
   TableTree *table; //Solo de referencia, no imprimir
   SymTableNode *globalScope = nullptr;

   AST(vector<DefNode*> r, TableTree *t) : list(r), table(t) {};

   AST() {};

   void printAST(int tabs=0) {

      if (table != nullptr) {
         printTabs(tabs);
         cout << "GLOBAL SCOPE";
         globalScope->table.print(tabs+1);
         printTabs(tabs);
         cout << "----------------------------------------\n";
      }

      vector<DefNode*>::reverse_iterator it = list.rbegin();

      for (; it != list.rend(); ++it) {

         (*it)->printDefNode(tabs+1);
      }

   };

   void printTabs(int tabs) {

      for (int i=0; i < tabs ; ++i)
         cout << "    ";
   };

};
