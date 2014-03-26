
/* Invalid program to test invalid symbols, 
   undeclared variables and redefined variables */

intmonchan int;

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
   
   int := @int * 9 + 1;     # ERROR: invalid symbol
   
   for I from 1 to 10
      float := i + 19;      # ERROR: undeclared variables
      
   println(float)           # ERROR: undeclared variable


}