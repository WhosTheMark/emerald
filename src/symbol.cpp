#include <iostream>
#include <string>
#include <vector>

using namespace std;

enum class BasicType : int { 
   intmonchan, 
   charizard, 
   boolbasaur, 
   floatzel, 
   onix, 
   voidporeon 
};

string BasicTypeStr[] = {
   "intmonchan",
   "charizard",
   "boolbasaur",
   "floatzel",
   "onix",
   "voidporeon"
};
   
class Symbol {
   
public:
   string name;
   int size;
   int line;
   int column;
   
   Symbol(string n, int s, int l, int c) : name(n), size(s), line(l), column(c) {};
   
   void printSym(int tabs = 0) {};
   //virtual ~Symbol();
   
};

class SymbolFunc : public Symbol {
   
public:
   BasicType type;
   vector<Symbol> *arguments;
   int numArgs;
   // apuntador al body
   
   SymbolFunc(string n, int s, int l, int c, BasicType t, vector<Symbol> *a, int na) :
      type(t), arguments(a), numArgs(na), Symbol(n,s,l,c) {};

   void printSym(int tabs = 0) {
         
      int typeInt = static_cast<int>(type);
      
      cout << "FUNCTION NAME: " << name << " RETURN TYPE: " << BasicTypeStr[typeInt] << "\n" ;              
   
      
   };
   
   ~SymbolFunc() {
      delete(arguments);
   }
      
};

class SymRegisterDef : public Symbol {
 
public:
   //SymTable *type;
   SymRegisterDef(string n, int s, int l, int c) : Symbol(n,s,l,c) {};

   void printSym(int tabs = 0) {
         
      cout << "TYPE NAME: " << name << " FIELDS: " << "\n" ; //FALTA TYPE y RECURSIVE              
   }
   
};

class SymRegisterDecl : public Symbol {
   
public:   
   Symbol *type;
   
   SymRegisterDecl(string n, int s, int l, int c, Symbol *t) : type(t), 
      Symbol(n,s,l,c) {};
      
   void printSym(int tabs = 0) {
    
      cout << "VARIABLE NAME: " << name << " TYPE: " << type->name << "\n"; 
   }
   
};

class SymbolBasic : public Symbol {
 
public:
   BasicType type;
   
   SymbolBasic(string n, int s, int l, int c, BasicType t) : type(t),
      Symbol(n,s,l,c) {};

   void printSym(int tabs = 0) {
    
      int typeInt = static_cast<int>(type);     
      cout << "VARIABLE NAME: " << name << " TYPE: " << BasicTypeStr[typeInt] << "\n"; 
   }
   
};

class SymbolArray : public Symbol {
   
public:
   Symbol *type;
   int lower;
   int upper;
   
   SymbolArray(string n, int s, int l, int c, Symbol *t, int low, int up) :
      type(t), lower(low), upper(up), Symbol(n,s,l,c) {};

   void printSym(int tabs = 0) {
    
      cout << "ARRAY NAME: " << name << " TYPE: " << type->name << "\n"; 
   }
};
   
int main () {

   SymbolFunc func("func",1,1,1,BasicType::intmonchan,nullptr,0);
   SymbolBasic basic("basic",1,1,1,BasicType::onix);
   SymbolArray arr("arr",1,1,1,&basic,0,10);
   SymRegisterDecl reg("reg",1,1,1,&basic);
   SymRegisterDef reg2("reg2",1,1,1);
   
   func.printSym();
   basic.printSym();
   arr.printSym();
   reg.printSym();
   reg2.printSym();
   
   return 0;
}   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   