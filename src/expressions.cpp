#include <vector>
#include <string>

class Expression { };

class BinExpr : public Expression {
  
public:
   
   string op;
   Expression *left;
   Expression *right;
   
   BinExpr(string o, Expression *l, Expression *r) : op(o) , left(l) , right(r) {};
   
};

class UnaryExpr : public Expression {

public:
   
   string op;
   Expression *operand;
   
   UnaryExpr(string o, Expression *opr) : op(o) , operand(opr) {};
   
};

class Const : public Expression { };

class FloatConst : public Const {
   
public:
   
   float value;
   
   FloatConst(float v) : value(v) {};
      
};

class IntConst : public Const {
   
public:
   
   int value;
   
   IntConst(int v) : value(v) {};
   
};

class Boolean : public Const {
   
public:

   bool value;

   Boolean(bool v) : value(v) {};   
   
}; 

class Character : public Const {
   
public:
   
   char value;   
  
   Character(char v) : value(v) {};
};

class Identifier : public Expression {
   
public:
   
   string name;
   
   Identifier(string n) : name(n) {};
   
};

class FuncCall : public Expression {
  
public:
   
   string name;
   vector<Expression*> args;
   
   FuncCall(string n, vector<Expression*> a) : name(n) , args(a) {};
   
};

class ArrayExpr : public Expression {
  
public:
   
   Expression *outBracket;
   Expression *inBracket;
   
   ArrayExpr(Expression *out, Expression *in) : outBracket(out) , inBracket(in) {};
   
};