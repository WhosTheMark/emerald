#include <iostream>
#include <vector>

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

class NodeChar : public NodeExpr {
public:
   char value;
   NodeChar(char v) : value(v) {};
};

class NodeStr : public NodeExpr {
public:
   string value;
   NodeStr(string v) : value(v) {};
};

class NodeBool : public NodeExpr {
public:
   bool value;
   NodeBool(bool v) : value(v) {};
};




class NodeIdentifier : public NodeExpr {
public:
   string name;
   NodeIdentifier(const string& n) : name(n) {};
};

class NodeBinaryOp : public NodeExpr {
public:
   
   string op;
   NodeExpr *lhs;
   NodeExpr *rhs;
   
   NodeBinaryOp(string o, NodeExpr *l, NodeExpr *r) : op(o), lhs(l), rhs(r) {};
};

class NodeUnaryOp : public NodeExpr {
public:
   
   string op;
   NodeExpr *arg;
   
   NodeUnaryOp(string o, NodeExpr *a) : op(o), arg(a) {};
};

class NodeFunctionCall : public NodeExpr {
public:
   
   string name;
   vector<NodeExpr*> argList;
   
   NodeFunctionCall(string n, vector<NodeExpr*> args) : name(n), argList(args) {};
};


   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   