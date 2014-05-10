#ifndef __TYPE_HPP__
#define __TYPE_HPP__

#include <iostream>
#include <map>

class Type {

public:
   Type() {};

};

class Integer;
class Boolean;
class Character;
class Float;
class String;
class Void;
class Type_Error;
class Tuple;
class Register_Type;
class Union_Type;
class Array_Type;
class Function_Type : public Type {

public:
   Type *returnType;
   Tuple *arguments;

   Function_Type(Type *r, Tuple *a) : Type(), returnType(r), arguments(a) {};

};

class TupleFactory;

#endif