#ifndef __TYPE_HPP__
#define __TYPE_HPP__

#include <iostream>
#include <map>


using namespace std;



class Type {

public:
   Type() {};
   //~Type() {};
   virtual void hola(){

   };

};

class Integer;
class Boolean;
class Character;
class Float;
class String;
class Void;
class Ditto;
class Type_Error;
class Tuple;
class Register_Type;
class Union_Type;

class Array_Type : public Type {

public:
   Type *elemType;

   Array_Type(Type *e) : Type(), elemType(e) {}; 

  // ~Array_Type() {};


};

class Function_Type : public Type {

public:
   Type *returnType;
   Type *arguments;

   Function_Type(Type *r, Type *a) : Type(), returnType(r), arguments(a) {};

   //~Function_Type() {};
};

class TupleFactory;

typedef map<Type*,Array_Type*>::iterator arraysMapIt;

class ArrayFactory{

   map<Type*,Array_Type*> arrays;

public:

   ArrayFactory(){};

   Array_Type *buildArray(Type *t){

      arraysMapIt it = arrays.find(t);

      if (it != arrays.end()){
         return it->second;

      } else {

         Array_Type *newArray = new Array_Type(t);
         arrays.insert(pair<Type*,Array_Type*>(t,newArray));
         return newArray;
      }

   }

};
#endif