#ifndef EXPR_
#define EXPR_

#include <vector>
#include <string>
#include "type.cpp"

class Expression {
public:
   Type *type;
   virtual void printExpression(int tabs=0) {};

   /* Imprime los tabuladores necesarios. */
   void printTabs(int tabs) {

      for (int i=0; i < tabs ; ++i)
         cout << "    ";
   };

};

class BinExpr : public Expression {

public:

   string op;
   Expression *left;
   Expression *right;

   BinExpr(string o, Expression *l, Expression *r) : op(o) , left(l) , right(r) {};

   void printExpression(int tabs=0) {

      ++tabs;
      cout << "BINARY EXPRESSION\n";
      printTabs(tabs);
      cout << "OPERATOR: " << op << "\n";
      printTabs(tabs);
      cout << "LEFT EXPRESSION:\n";
      printTabs(tabs+1);
      left->printExpression(tabs+1);
      printTabs(tabs);
      cout << "RIGHT EXPRESSION:\n";
      printTabs(tabs+1);
      right->printExpression(tabs+1);
      cout << "\n";
   };

};

class UnaryExpr : public Expression {

public:

   string op;
   Expression *operand;

   UnaryExpr(string o, Expression *opr) : op(o) , operand(opr) {};

   void printExpression(int tabs=0) {

      ++tabs;
      cout << "UNARY EXPRESSION\n";
      printTabs(tabs);
      cout << "OPERATOR: " << op << "\n";
      printTabs(tabs);
      cout << "OPERAND:\n";
      printTabs(tabs+1);
      operand->printExpression(tabs+1);
      cout << "\n";
   };

};

class Const : public Expression { };

class FloatConst : public Const {

public:

   float value;

   FloatConst(float v) : value(v) {};

   void printExpression(int tabs=0) {

      cout << "FLOATZEL VALUE: " << value << "\n";
   };

};

class IntConst : public Const {

public:

   int value;

   IntConst(int v) : value(v) {};

   void printExpression(int tabs=0) {

      cout << "INTMONCHAN VALUE: " << value << "\n";
   };

};

class BooleanNode : public Const {

public:

   bool value;

   BooleanNode(bool v) : value(v) {};

   void printExpression(int tabs=0) {

      cout << "BOOLBASAUR VALUE: " << value << "\n";
   };

};

class CharacterNode : public Const {

public:

   char value;

   CharacterNode(char v) : value(v) {};

   void printExpression(int tabs=0) {

      cout << "CHARIZARD VALUE: " << value << "\n";
   };
};

class Identifier : public Expression {

public:

   string name;

   Identifier(string n) : name(n) {};

   void printExpression(int tabs=0) {

      cout << "IDENTIFIER NAME: " << name << "\n";
   };

};

class StringNode: public Expression{

public:
   string content;
   StringNode(string c) :content(c) {};

   void printExpression(int tabs=0) {

      cout << "STRING CONTENT: " << content << "\n";
   };

};

class ArrayExpr : public Expression {

public:

   Expression *outBracket;
   Expression *inBracket;

   ArrayExpr(Expression *out, Expression *in) : outBracket(out) , inBracket(in) {};

   void printExpression(int tabs=0) {

      ++tabs;
      cout << "ARRAY EXPRESSION\n";
      printTabs(tabs);
      cout << "OUTBRACKET:\n";
      printTabs(tabs);
      outBracket->printExpression(tabs);
      printTabs(tabs);
      cout << "INBRACKET:\n";
      printTabs(tabs);
      inBracket->printExpression(tabs);
      cout << "\n";
   };

};

class DotExpression : public Expression {

public:

    Expression *left;
    string id;

    DotExpression(Expression *l, string i) : left(l), id(i) {};

    void printExpression(int tabs=0) {

       ++tabs;
       cout << "DOT EXPRESSION\n";
       printTabs(tabs);
       cout << "LEFT EXPRESSION:\n";
       printTabs(tabs+1);
       left->printExpression(tabs+1);
       printTabs(tabs);
       cout << "ID: " << id << "\n";
    };

};

#endif