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

   Basic(string n, int l, int c, int s) : size(s), Definition(n,l,c) {};

   void printSym(int tabs=0) {

      cout << "PRIMITIVE TYPE: " << name << "\n";
   };

};

class Function : public Definition {

public:
   Definition *returnType;
   vector<pair<string,Declaration*>*> arguments;
   int numArgs;
   //TODO body

   Function(string n, int l, int c, Definition *r,
           vector<pair<string,Declaration*>*> args,
           int numA): returnType(r), arguments(args), numArgs(numA),
           Definition(n,l,c) {};

   void printSym(int tabs=0) {

      cout << "FUNCTION NAME: " << name << " RETURN TYPE: " << returnType->name << "\n";
   };
};

class Register : public Definition {

public:
   int size;
   //TODO table

   Register(string n, int l, int c, int s): size(s), Definition(n,l,c) {};

   void printSym(int tabs=0) {
      //TODO imprimir la tabla del registro
      cout << "REGISTER NAME: " << name << "\n";
   };
};

class Declaration : public Symbol {

public:
   pair<string,Definition*> *type;
   bool constant;

   Declaration(string n, int l, int c, pair<string,Definition*> *p, bool con) :
      type(p), constant(con), Symbol(n,l,c) {};

   void printSym(int tabs=0) {

      cout << "VARIABLE NAME: " << name << " TYPE: " << type-> first << "\n" ;
   };

};

class ArrayDecl : public Declaration {

public:
   int lower;
   int upper;

   ArrayDecl(string n, int l, int c, pair<string,Definition*> *p, bool con, int low, int u) :
      lower(low), upper(u), Declaration(n,l,c,p,con) {};

   //NOTE Imprimir lower y upper?
   void printSym(int tabs=0) {

      cout << "ARRAY NAME: " << name << " TYPE: " << type-> first << "\n" ;
   };

};


int main () {

   Basic basicInt("int", -1,-1, 4);
   vector<pair<string,Declaration*>*> emptyVector;
   Function func("squirtle", 1, 1, &basicInt, emptyVector, 1);
   pair<string,Definition*> pairDef(basicInt.name,&basicInt);

   Declaration variable("i", 2, 3, &pairDef, false);
   ArrayDecl array("intArr", 5, 6, &pairDef, false, 0, 10);

   Register reg("persona", 8, 9, 28);
   pair<string,Definition*> pairReg(reg.name,&reg);
   Declaration varPerson("Andrea", 6, 66, &pairReg, false);


   basicInt.printSym();
   reg.printSym();

   func.printSym();
   variable.printSym();
   array.printSym();
   varPerson.printSym();

   Symbol *we = new ArrayDecl("whatever", 5, 6, &pairDef, false, 0, 10);
   we->printSym();
   delete(we);
   
   return 0;
}
