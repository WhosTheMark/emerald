#ifndef INST_
#define INST_

#include <string>
#include <vector>
#include "expressions.cpp"
#include "symTable.cpp"
#include "tableTree.cpp"

class Inst {
public:
   Inst() {};
   virtual void printInstruction(int tabs=0) {};
   void printTabs(int tabs) {

      for (int i=0; i < tabs ; ++i)
         cout << "    ";
   };
};

class Statement : public Inst {

public:
   Statement() {};
};

class Block : public Inst {

public:

   vector<Statement*> list;
   SymTableNode *table;

   Block(vector<Statement*> l) : list(l) {};

   void printInstruction(int tabs=0) {

      ++tabs;
      vector<Statement*>::reverse_iterator it = list.rbegin();

      cout << "BLOCK--------------------------------------\n";

      for (; it != list.rend(); ++it) {
         printTabs(tabs);
         (*it)->printInstruction(tabs);
      }

      printTabs(tabs-1);
      cout << "END----------------------------------------\n";


   };

};

class Branch {

public:

   virtual void printBranch(int tabs=0) {};
   /* Imprime los tabuladores necesarios. */
   void printTabs(int tabs) {

      for (int i=0; i < tabs ; ++i)
         cout << "    ";
   };
};

class IfBranch : public Branch {

public:

   Expression *condition;
   Inst *instruction;

   IfBranch(Expression *c, Inst *i) : condition(c) , instruction(i) { };

   void printBranch(int tabs=0) {

      ++tabs;
      cout << "IF BRANCH\n";
      printTabs(tabs);
      cout << "CONDITION: \n";
      printTabs(tabs+1);
      condition->printExpression(tabs+1);
      printTabs(tabs);
      cout << "INSTRUCTION:\n";
      printTabs(tabs+1);
      instruction->printInstruction(tabs+1);
      cout << "\n";
   };

};

class ElseBranch : public Branch{
public:
   Inst *instruction;

   ElseBranch(Inst *i) : instruction(i) {};

   void printBranch(int tabs=0) {

      ++tabs;
      cout << "ELSE BRANCH\n";
      printTabs(tabs);
      cout << "INSTRUCTION:\n";
      printTabs(tabs+1);
      instruction->printInstruction(tabs+1);
      cout << "\n";
   };

};

class IfStmt : public Statement {

public:

   vector<Branch*> branches;

   IfStmt(vector<Branch*> b) : branches(b) {};

   void printInstruction(int tabs=0) {

      ++tabs;
      cout << "IF STATEMENT\n";

      vector<Branch*>::reverse_iterator it = branches.rbegin();

      for (; it != branches.rend(); ++it) {
         printTabs(tabs);
         (*it)->printBranch(tabs);
      }
   };

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

   vector<LValue*> lvalues;   //ESTO NO ESTÁ FUNCIONANDO, NO IMPRIMIR.
   vector<Expression*> rvalues;

   Asignment(vector<LValue*> l, vector<Expression*> r) : lvalues(l) , rvalues(r) {};

   void printInstruction(int tabs=0) {

      ++tabs;
      cout << "ASIGNMENT\n";

      vector<Expression*>::iterator it = rvalues.begin();

      for (; it != rvalues.end(); ++it) {
         printTabs(tabs);
         cout << "RIGHT VALUE:\n";
         printTabs(tabs+1);
         (*it)->printExpression(tabs+1);
      }

   };

};

class WhileStmt : public Statement {

public:

   Expression *condition;
   Inst *instruction;

   WhileStmt(Expression *c, Inst *i) : condition(c) , instruction(i) {};

   void printInstruction(int tabs=0) {

      ++tabs;
      cout << "WHILE STATEMENT\n";
      printTabs(tabs);
      cout << "CONDITION:\n";
      printTabs(tabs+1);
      condition->printExpression(tabs+1);
      printTabs(tabs);
      cout << "INSTRUCTION:\n";
      printTabs(tabs+1);
      instruction->printInstruction(tabs+1);
      cout << "\n";

   };

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

   void printInstruction(int tabs=0) {

      ++tabs;
      cout << "FOR STATEMENT\n";
      printTabs(tabs);
      cout << "ID: " << id << "\n";
      printTabs(tabs);
      cout << "LOWER BOUND:\n";
      printTabs(tabs+1);
      from->printExpression(tabs+1);
      printTabs(tabs);
      cout << "UPPER BOUND:\n";
      printTabs(tabs+1);
      to->printExpression(tabs+1);

      if (step != nullptr) {
         printTabs(tabs);
         cout << "STEP:\n";
         printTabs(tabs+1);
         step->printExpression(tabs+1);
      }

      printTabs(tabs);
      cout << "INSTRUCTION:\n";
      printTabs(tabs+1);
      instruction->printInstruction(tabs+1);
      cout << "\n";

   };

};

class Break : public Statement {

public:

   string *tag;

   Break(string *t) : tag(t) {};

   void printInstruction(int tabs=0) {

      cout << "BREAK\n";

      if (tag != nullptr) {

         printTabs(tabs+1);
         cout << "TAG: " << *tag << "\n";
      }


   };
};

class Continue : public Statement {

public:

   string *tag;

   Continue(string *t) : tag(t) {};

   void printInstruction(int tabs=0) {

      cout << "CONTINUE\n";

      if (tag != nullptr) {

         printTabs(tabs+1);
         cout << "TAG: " << *tag << "\n";
      }
   };
};

class Tag : public Statement {

public:

   string name;

   Tag(string n) : name(n) {};

   void printInstruction(int tabs=0) {

      cout << "TAG: " << name << "\n";

   };
};

class Return : public Statement {

public:
   Expression *expr;

   Return(Expression *e) : expr(e) {};

   void printInstruction(int tabs=0) {

      ++tabs;
      cout << "RETURN\n";
      printTabs(tabs);
      expr->printExpression(tabs);
      cout << "\n";

   };
};

class CaseBranch {

public:

   Const *constant;
   Block *caseBlock;

   CaseBranch(Const *c, Block *cb) : constant(c) , caseBlock(cb) {};

   /* Imprime los tabuladores necesarios. */
   void printTabs(int tabs) {

      for (int i=0; i < tabs ; ++i)
         cout << "    ";
   };

   void printCase(int tabs=0) {

      cout << "CASE BRANCH\n";

      ++tabs;
      printTabs(tabs);

      if (constant != nullptr) {

         cout << "CASE VALUE:\n";
         printTabs(tabs+1);
         constant->printExpression(tabs+1);

      } else
         cout << "DEFAULT BRANCH\n";

      printTabs(tabs);
      caseBlock->printInstruction(tabs);

   };


};

class DefaultBranch : public CaseBranch {

public:

   DefaultBranch(Block *cb) : CaseBranch(nullptr,cb) {}; //Aquí la constante está en null porque es default
};

class SwitchStmt : public Statement {

public:
   Expression *caseExpr;
   vector<CaseBranch*> branches;

   SwitchStmt(Expression *c, vector<CaseBranch*> b) :
              caseExpr(c) , branches(b) {};

   void printInstruction(int tabs=0) {

      ++tabs;
      cout << "SWITCH STATEMENT\n";
      printTabs(tabs);
      cout << "SWITCH EXPRESSION:\n";
      printTabs(tabs+1);
      caseExpr->printExpression(tabs+1);
      printTabs(tabs);
      cout << "SWITCH CASES:\n";

      vector<CaseBranch*>::reverse_iterator it = branches.rbegin();

      for (; it != branches.rend(); ++it) {
         printTabs(tabs+1);
         (*it)->printCase(tabs+1);
      }
   };

};

class FuncCall : public Expression, public Statement {

public:

   string name;
   vector<Expression*> args;

   FuncCall(string n) : name(n) {};

   void printInstruction(int tabs=0) {

      ++tabs;
      cout << "FUNCTION CALL STATEMENT\n";
      Inst::printTabs(tabs);
      cout << "FUNCTION NAME: " << name << "\n";

      vector<Expression*>::iterator it = args.begin();

      for (; it != args.end(); ++it) {
         Inst::printTabs(tabs);
         (*it)->printExpression(tabs);
      }
   };

   void printExpression(int tabs=0) {

      ++tabs;
      cout << "FUNCTION CALL EXPRESSION\n";
      Expression::printTabs(tabs);
      cout << "FUNCTION NAME: " << name << "\n";

      vector<Expression*>::iterator it = args.begin();

      for (; it != args.end(); ++it) {
         Expression::printTabs(tabs);
         (*it)->printExpression(tabs);
      }
   };

};

#endif