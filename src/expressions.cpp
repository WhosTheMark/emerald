#ifndef EXPR_
#define EXPR_

#include <vector>
#include <string>
#include "type.cpp"

class Expression { 
public:
   Type *type;
};

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

class BooleanNode : public Const {
   
public:

   bool value;

   BooleanNode(bool v) : value(v) {};   
   
}; 

class CharacterNode : public Const {
   
public:
   
   char value;   
  
   CharacterNode(char v) : value(v) {};
};

class Identifier : public Expression {
   
public:
   
   string name;
   
   Identifier(string n) : name(n) {};
   
};

class StringNode: public Expression{
   
public:
   string content;
   StringNode(string c) :content(c) {};
   
   
};

class ArrayExpr : public Expression {
  
public:
   
   Expression *outBracket;
   Expression *inBracket;
   
   ArrayExpr(Expression *out, Expression *in) : outBracket(out) , inBracket(in) {};
   
};

class DotExpression : public Expression {
   
public:
   
    Expression *left;
    string id;
    
    DotExpression(Expression *l, string i) : left(l), id(i) {};
    
};

#endif