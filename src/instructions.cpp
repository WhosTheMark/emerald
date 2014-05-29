#include <string>
#include <vector>
#include "expressions.cpp"
#include "symTable.cpp"

class Inst { };

class Statement : public Inst { };

class Block : public Inst {
  
public:
   
   vector<Statement*> list;
   SymTable *table;
   
   Block(vector<Statement*> l) : list(l) {};
   
};

class IfBranch {
   
public:
   
   Expression *condition;
   Inst *instruction;
   
   IfBranch(Expression *c, Inst *i) : condition(c) , instruction(i) {};
   
};

class IfStmt : public Statement {
  
public:
   
   vector<IfBranch*> branches;
   Inst *elseBranch;
   
   IfStmt(vector<IfBranch*> b, Inst *e) : branches(b) , elseBranch(e) {};
   
};

class LDecorator {
   
public:
   
  LDecorator *decoration;
  
  LDecorator(LDecorator *d) { decoration = d; };
};

class ArrayDecorator : public LDecorator {
  
public:
   
   Expression *inBrackets;
   
   ArrayDecorator(Expression *in, LDecorator *d) : LDecorator(d) , inBrackets(in) {};
   
};

class RegDecorator : public LDecorator {
   
public:
   
   string ident;
   
   RegDecorator(string i, LDecorator *d) : LDecorator(d) , ident(i) {};
   
};

class LValue {
   
public:
   
   string name;
   LDecorator *decoration;
   
   LValue(string n, LDecorator *d) : name(n) , decoration(d) {};
};

class Asignment : public Statement {
   
public:
   
   vector<LValue*> lvalues;
   vector<Expression*> rvalues;
   
   Asignment(vector<LValue*> l, vector<Expression*> r) : lvalues(l) , rvalues(r) {};   
   
};

class WhileStmt : public Statement {
  
public:
   
   Expression *condition;
   Inst *instruction;
   
   WhileStmt(Expression *c, Inst *i) : condition(c) , instruction(i) {};
   
};

class ForStmt : public Statement {
  
public:
   
   string id;
   Expression *from;
   Expression *to;
   Expression *step;
   Inst *instruction;
   
   ForStmt(string i, Expression *f, Expression *t, Expression *s, Inst *ins) :
           id(i) , from(f) , to(t) , step(s) , instruction(ins) {};
           
};

class Break : public Statement {
   
public:
   
   string *tag;
   
   Break(string *t) : tag(t) {};
   
};

class Continue : public Statement {
  
public:
   
   string *tag;
   
   Continue(string *t) : tag(t) {};
   
};

class Tag : public Statement {
  
public:
   
   string name;
   
   Tag(string n) : name(n) {};
   
   
};

class Return : public Statement { };

class CaseBranch {
  
public:
   
   Const *constant;
   Block *caseBlock;
   
   CaseBranch(Const *c, Block *cb) : constant(c) , caseBlock(cb) {};
   
};

class SwitchStmt : public Statement {
   
   Expression *caseExpr;
   vector<CaseBranch*> branches;
   Block *defaultBranch;
   
   SwitchStmt(Expression *c, vector<CaseBranch*> b, Block *d) : 
              caseExpr(c) , branches(b) , defaultBranch(d) {};
     
};