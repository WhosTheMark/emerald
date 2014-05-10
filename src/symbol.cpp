#ifndef SYMBOL_
#define SYMBOL_

#include <iostream>
#include <string>
#include <vector>
#include "type.hpp"

using namespace std;

class Symbol {

public:
   string name;
   int line;
   int column;

   Symbol(string n, int l, int c) : name(n), line(l), column(c) {};
   virtual void printSym(int tabs=0) {};
   virtual ~Symbol() {};
};

/* Clase de declaracion de simbolos. */
class Declaration : public Symbol {

public:
   pair<string,Symbol*> *type; //Tipo de la variable declarada.
   bool constant;

   Declaration(string n, int l, int c, pair<string,Symbol*> *p, bool con) :
   Symbol(n,l,c), type(p), constant(con) {};

   bool operator==(Declaration d) {

      return (this->name == d.name && this->type->second == d.type->second);
   }

   bool operator!=(Declaration d) {

      return !(*this == d);
   }

   void printSym(int tabs=0) {

      cout << "VARIABLE NAME: " << name << " TYPE: ";

      if(type != nullptr)
         cout << type-> first;
      else
         cout << "Not Defined";

      cout << " LINE: " << line << " COLUMN: " << column << "\n" ;
   };

   virtual ~Declaration() { };
};

/* Clase de declaracion de arreglos.*/
class ArrayDecl : public Declaration {

public:
   int lower; //Limite inferior del arreglo.
   int upper; //Limite superior del arreglo.

   ArrayDecl(string n, int l, int c, pair<string,Symbol*> *p, bool con, int low, int u) :
   Declaration(n,l,c,p,con), lower(low), upper(u) {};

   //NOTE Imprimir lower y upper?
   void printSym(int tabs=0) {

      cout << "ARRAY NAME: " << name << " TYPE: ";

      if(type != nullptr)
         cout << type-> first;
      else
         cout << "Not Defined";

      cout << " LINE: " << line << " COLUMN: " << column << "\n" ;
   };

   ~ArrayDecl() {};
};

/* Clase de simbolos utilizada para la definicion de tipos primitivos y
 * definidos por el usuario y funciones.
 */
class Definition : public Symbol {

public:
   Definition(string n, int l, int c) : Symbol(n,l,c) {};
   virtual ~Definition() {};
};

/* Clase de tipos primitivos. */
class Basic : public Definition {

public:
   int size;

   Basic(string n, int l, int c, int s) : Definition(n,l,c), size(s) {};

   void printSym(int tabs=0) {

      cout << "PRIMITIVE TYPE: " << name << "\n" ;
   };

   ~Basic() {};
};

/* Clase de definicion de funciones. */
class Function : public Definition {

public:
   Function_Type *type;
   vector<pair<string,Declaration*>*> arguments; //Lista de los argumentos de la funcion.
   int numArgs; //Numero de argumentos de la funcion.
   bool fwdDecl = false; //Flag para determinar si es un forward declaration de una funcion.
   //TODO body

   Function(string n, int l, int c, Basic *r, vector<pair<string,Declaration*>*> args) :
         Definition(n,l,c), arguments(args) {

            type = new Function_Type(dynamic_cast<Type*>(r),nullptr);
            numArgs = arguments.size();
   };

   Function(string n, int l, int c, Basic *r) : Definition(n,l,c), numArgs(0) {



      type = new Function_Type(dynamic_cast<Type*>(r),nullptr);

   };

   void printSym(int tabs=0) {

      cout << "FUNCTION NAME: " << name << " RETURN TYPE: ";

      if (type->returnType != nullptr)
         cout << ""; //TODO type->returnType->name;
      else
         cout << "Not Defined";

      if (line >= 0 || column >= 0)
         cout << " LINE: " << line << " COLUMN: " << column;
      cout << "\n";
   };

   ~Function() {

      vector<pair<string,Declaration*>*>::iterator it = arguments.begin();
      for(; it != arguments.end(); ++it){
            delete(*it);
      }
   };
};

#endif