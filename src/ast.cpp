#include <string>
#include <vector>
#include "tableTree.cpp"
#include "expressions.cpp"
#include "instructions.cpp"

using namespace std;


class DefNode { };

class ArgsDef {
   
public:
   
   string id;
   bool variable;
   
   ArgsDef(string i, bool v) : id(i), variable(v) {};
   
};

class FuncDef : public DefNode {
  
public:
   
   string name;
   string returnType;
   vector<ArgsDef*> args;
   Block *block;
   SymTableNode *table;   
   
   FuncDef(string n, string rt, vector<ArgsDef*> a, Block *b) :
           name(n) , returnType(rt) , args(a) , block(b) {};
};

class IdNode {

public:
   
   string name;
   bool constant;
   
   IdNode(string n, bool c) : name(n), constant(c) {};
      
};

class ArrayDeclare : public IdNode {
   
public:
   
   Expression *lower;
   Expression *upper;
   
   ArrayDeclare(string n, bool c, Expression *l, Expression *u) : 
               IdNode(n,c) , lower(l), upper(u) {};
   
};

class DeclareNode : public DefNode {
  
public:
   
   string type;
   vector<IdNode*> ids;
   vector<Expression*> inits;
   
   DeclareNode(string t, vector<IdNode*> id, vector<Expression*> init) :
               type(t), ids(id), inits(init) {};
                 
};

class RegisterDef : public DefNode {
  
public:
   
   string name;
   vector<DeclareNode*> fields;
   
   RegisterDef(string n, vector<DeclareNode*> f) : name(n) , fields(f) {};
   
};


class DefList {   
   
public:
   
   vector<DefNode*> list;
   
   DefList(vector<DefNode*> l) : list(l) {};

};

class AST {
   
public:
   
   DefList *root;
   TableTree table;
   
   AST(DefList *r) : root(r) {};
   
};
   
   
int main () {
   
   
 return 0;
 
}