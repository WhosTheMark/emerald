#include <iostream>

using namespace std;

class Node {
   
public:
   virtual ~Node() {}
};

class NodeExpr : public Node {};

class NodeInt : public NodeExpr {
public:
   int value;
   NodeInt(int v) : value(v) {};
};

class NodeFloat : public NodeExpr {
public:
   float value;
   NodeFloat(float v) : value(v) {};
};

class NodeIdentifier : public NodeExpr {
public:
   string name;
   NodeIdentifier(const string& n) : name(n) {};
};

class NodeBinaryOp : public NodeExpr {
public:
   
   NodeExpr *lhs;
   NodeExpr *rhs;