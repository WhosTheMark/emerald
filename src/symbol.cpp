#ifndef SYMBOL_
#define SYMBOL_

#include <iostream>
#include <string>
#include <vector>

using namespace std;

class Declaration;

class Symbol {

public:
   string name;
   int line;
   int column;

   Symbol(string n, int l, int c) : name(n), line(l), column(c) {};
   virtual void printSym(int tabs=0) {};
   //virtual ~Symbol();
};

class Definition : public Symbol {

public:
   Definition(string n, int l, int c) : Symbol(n,l,c) {};

};

class Basic : public Definition {

public:
   int size;

   Basic(string n, int l, int c, int s) : Definition(n,l,c), size(s) {};

   void printSym(int tabs=0) {

      cout << "PRIMITIVE TYPE: " << name << "\n";
   };

};

class Function : public Definition {

public:
   Basic *returnType;
   vector<pair<string,Declaration*>*> arguments;
   int numArgs;
   //TODO body

   Function(string n, int l, int c, Basic *r, vector<pair<string,Declaration*>*> args) :
         Definition(n,l,c), returnType(r), arguments(args) {
              numArgs = arguments.size();
         };
           
   Function(string n, int l, int c, Basic *r) : 
            Definition(n,l,c), returnType(r), numArgs(0) {};

   void printSym(int tabs=0) {

      cout << "FUNCTION NAME: " << name << " RETURN TYPE: " << returnType->name << "\n";
   };
};

class Register : public Definition {

public:
   int size;
   //TODO table

   Register(string n, int l, int c, int s): Definition(n,l,c), size(s) {};

   void printSym(int tabs=0) {
      //TODO imprimir la tabla del registro
      cout << "REGISTER NAME: " << name << "\n";
   };
};

class Declaration : public Symbol {

public:
   pair<string,Symbol*> *type;
   bool constant;

   Declaration(string n, int l, int c, pair<string,Symbol*> *p, bool con) :
      Symbol(n,l,c), type(p), constant(con) {};

   void printSym(int tabs=0) {

      cout << "VARIABLE NAME: " << name << " TYPE: " << type-> first << "\n" ;
   };

};

class ArrayDecl : public Declaration {

public:
   int lower;
   int upper;

   ArrayDecl(string n, int l, int c, pair<string,Symbol*> *p, bool con, int low, int u) :
      Declaration(n,l,c,p,con), lower(low), upper(u) {};

   //NOTE Imprimir lower y upper?
   void printSym(int tabs=0) {

      cout << "ARRAY NAME: " << name << " TYPE: " << type-> first << "\n" ;
   };

};

/*
int main () {

   Basic *basicInt = new Basic("int", -1,-1, 4);
   vector<pair<string,Declaration*>*> emptyVector;
   Function *func = new Function("squirtle", 1, 1, basicInt, emptyVector, 1);
   pair<string,Definition*> *pairDef = new pair<string,Definition*>(basicInt->name,basicInt);

   Declaration *variable = new Declaration("i", 2, 3, pairDef, false);
   ArrayDecl *array = new ArrayDecl("intArr", 5, 6, pairDef, false, 0, 10);

   Register *reg = new Register("persona", 8, 9, 28);
   pair<string,Definition*> *pairReg = new pair<string,Definition*>(reg->name,reg);
   Declaration *varPerson = new Declaration("Andrea", 6, 66, pairReg, false);


   basicInt->printSym();
   reg->printSym();

   func->printSym();
   variable->printSym();
   array->printSym();
   varPerson->printSym();

   Symbol *we = new ArrayDecl("whatever", 5, 6, pairDef, false, 0, 10);
   we->printSym();
   delete(we);
   
   return 0;
}*/

#endif