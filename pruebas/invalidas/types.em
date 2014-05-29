
voidporeon main() {

   intmonchan i;
   boolbasaur b;
   floatzel f := 2.0;

   i := 8 * f;       # ERROR: operator '*' arguments must have the same type.
   
   for a from 1 to 10.0 by 2.0 {    # ERROR: the range and step of the for statement must match.
   
      if (b > 10) {                 # ERROR: if condition must be a boolbasaur type
         f := intToFloatzel(10.0);  # ERROR: arguments do not match the parameters of the function intToFloatzel
         println(f)   
         
      } elsif (3 + 4.0 / a)       # ERROR: elsif condition must be a boolbasaur type
         f := 10.0
   }
}