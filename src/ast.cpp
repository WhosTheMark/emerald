#include <string>
#include <vector>
#include "tableTree.cpp"
#include "expressions.cpp"
#include "instructions.cpp"

using namespace std;


class DefNode { };

class FuncDef : public DefNode {
  
public:
   
   string name;
   Block *block;  //Esto puede ser nullptr si es un foward declaration!
   
   FuncDef(string n, Block *b) : name(n) , block(b) {};
};

class DeclareNode : public DefNode {
  
public:
   
   string type;
   vector<Expression*> inits;
   
   DeclareNode(string t, vector<Expression*> init) :
               type(t), inits(init) {};
                 
};

class RegisterDef : public DefNode {
  
public:
   
   string name;
   SymTableNode *fields;
   
   RegisterDef(string n) : name(n) {};
   
};

class UnionDef : public DefNode {
  
public:
   
   string name;
   SymTableNode *fields;
   
   UnionDef(string n) : name(n) {};
   
};

class AST {
   
public:
   
   vector<DefNode*> list;
   TableTree *table; //Solo de referencia, no imprimir
   SymTableNode *globalScope;
   
   AST(vector<DefNode*> r, TableTree *t) : list(r), table(t) {};
   
};
