#ifndef __TYPE_HPP__
#define __TYPE_HPP__

#include <iostream>
#include <map>

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
   int lower;
   int upper;
   Type *elemType;

   Array_Type(int l, int u, Type *e) : Type(), lower(l), upper(u), elemType(e) {};

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

#endif