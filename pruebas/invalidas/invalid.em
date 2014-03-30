
/* Invalid program to test invalid symbols,
   undeclared variables and redefined variables */

intmonchan int;

registeer register {

   intmonchan a, b;
}

floatzel plusTwo (floatzel f) {

   return f + 2.0
}

# ERROR: Redefined function

intmonchan plusTwo (intmonchan i) {

   return l + 2      # ERROR: undeclared variable
}

~ # ERROR: invalid symbol

voidporeon main() {

   intmonchan int := 3;
   unown register a;       # ERROR: declared as a register but used as unown type

   int := @int * 9 + 1;    # ERROR: invalid symbol

   for I from 1 to 10
      float := i + 19;     # ERROR: two undeclared variables

   println(float)          # ERROR: undeclared variable


}