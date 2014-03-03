#include <iostream>
#include <string>
#include <vector>

using namespace std;

enum class BasicType { intmonchan, charizard, boolbasaur, floatzel, onix, voidporeon };

class Symbol {
   
public:
   string name;
   int size;
   int line;
   int column;
   
   Symbol(string n, int s, int l, int c);
   void printSym(int tabs);
   //virtual ~Symbol();
};

class SymbolFunc : public Symbol {
   
public:
   BasicType type;
   vector<Symbol> *arguments;
   int numArgs;
   // apuntador al body
   SymbolFunc(string n, int s, int l, int c, BasicType t, vector<Symbol> *a, int na);
   ostream& printSym(int tabs);   
   ~SymbolFunc();
};
/*
class SymRegisterDef : public Symbol {
 
public:
   //SymTable *type;
   SymRegisterDef(string n, int s, int l, int c);
   ostream& printSym(int tabs);
   
};

class SymRegisterDecl : public Symbol {
   
public:   
   Symbol *type;
   SymRegisterDecl(string n, int s, int l, int c, Symbol *t);    
   ostream& printSym(int tabs);
   
};

class SymbolBasic : public Symbol {
 
public:
   BasicType type;
   SymbolBasic(string n, int s, int l, int c, BasicType t);
   ostream& printSym(int tabs);
    
};

class SymbolArray : public Symbol {
   
public:
   Symbol *type;
   int lower;
   int upper;
   SymbolArray(string n, int s, int l, int c, Symbol *t, int low, int up);
   ostream& printSym(int tabs);
};*/
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   