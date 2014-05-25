#ifndef __TYPE__
#define __TYPE__

#include "type.hpp"
#include "symbol.cpp"

using namespace std;

class Tuple;

typedef map<Type*,map<Type*,Tuple*>>::iterator tuplesMapsIt;
typedef map<Type*,Tuple*>::iterator tuplesIt;

const int INT_SIZE = 32;
const int CHAR_SIZE = 8;
const int FLOAT_SIZE = 32;
const int BOOL_SIZE = 1;


class Integer : public Type, public Basic {

public:
   Integer(): Type(), Basic("intmonchan",-1,-1,INT_SIZE) {};
   //~Integer() {};
};

class Boolean : public Type, public Basic {

public:
   Boolean(): Type(), Basic("boolbasaur",-1,-1,BOOL_SIZE) {};
   //~Boolean() {};
};

class Character : public Type, public Basic {

public:
   Character(): Type(), Basic("charizard",-1,-1,CHAR_SIZE) {};
   //~Character() {};
};

class Float : public Type, public Basic {

public:
   Float(): Type(), Basic("floatzel",-1,-1,FLOAT_SIZE) {};
   //~Float() {};
};

class String : public Type, public Basic {

public:
   String(): Type(), Basic("onix",-1,-1,0) {};
   //~String() {};
};

class Void : public Type, public Basic {

public:
   Void(): Type(), Basic("voidporeon",-1,-1,0) {};
   //~Void() {};
};

class Type_Error : public Type {

public:
   Type_Error() : Type() {};
   //~Type_Error() {};
};

class Tuple : public Type {

public:
   Type *first;
   Type *second;

   Tuple(Type *f, Type *s) : Type(), first(f), second(s) {};
   //~Tuple() {};
};

class Register_Type : public Type, public Definition {

public:
   int size;
   map<string,Type*> fields;
   Register_Type(string n, int l, int c, int s, map<string,Type*> f) :
      Type(), Definition(n, l, c), size(s), fields(f) {};

   void printSym(int tabs=0) {
      //TODO imprimir la tabla del registro

      cout << "REGISTER NAME: " << name << " LINE: " << line << " COLUMN: " << column << "\n";
   };

   //~Register_Type() {};
};

class Union_Type : public Type, public Definition {

public:
   int size;
   map<string,Type*> fields;
   Union_Type(string n, int l, int c, int s, map<string,Type*> f) :
      Type(), Definition(n,l,c), size(s), fields(f) {};

   void printSym(int tabs=0) {
      //TODO imprimir la tabla del union

      cout << "UNION NAME: " << name << " LINE: " << line << " COLUMN: " << column << "\n";
   };

   //~Union_Type() {};
};


class TupleFactory {

   map<Type*,map<Type*,Tuple*>> tuples;

public:
   TupleFactory() {};

   Tuple *buildTuple(Type *type1, Type *type2) {

      tuplesMapsIt it = tuples.find(type1);

      if (it != tuples.end()) {

         tuplesIt it2 = it->second.find(type2);

         if (it2 != it->second.end())
            return it2->second;

         Tuple *newTuple = new Tuple(type1,type2);

         it->second.insert(pair<Type*,Tuple*>(type2,newTuple));

         return newTuple;
      }

      map<Type*,Tuple*> newMap;

      Tuple *newTuple = new Tuple(type1,type2);

      newMap.insert(pair<Type*,Tuple*>(type2,newTuple));

      tuples.insert(pair<Type*,map<Type*,Tuple*>>(type1,newMap));

      return newTuple;

   }

};



#endif
