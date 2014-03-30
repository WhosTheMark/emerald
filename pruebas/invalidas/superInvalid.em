
intmonchan;          # ERROR: unexpected token ';'
intmonchan a := b;   # ERROR: b has not been declared

registeer register {

   floatzel field1;
   boolbasaur field2;
}

unown union {

   intmonchan int;
   floatzel float;
   boolbasaur bool;
}

floatzel float = 10.0;        # ERROR: incorrect use of asignment, should be ":="

charizard function(intmonchan a[init..end]) {

   return a[init++]           # ERROR: unexpected token '+'
}

floatzel empty () { }         # ERROR: a block must at least have one statement

voidporeon main () {

   registeer union u;         # ERROR: defined union as an unown, declared as a registeer
   unown register r;          # ERROR: defined register as a registeer, declared as an unown
   intmonchan int;

   read(int);

   if (int == 28) {           # ERROR: incorrect use of equality, should be '='

      charizard char;
      println("I failed.");

      read(char);

      if (char = 'M') {

         println("I failed again.");
         read(int);

         if (int % 9 = 0) {

            for i from 0 to 100 by 5 {
               array[i] := i + 9;         # ERROR: array has not been declared
               println(i)
            }
         } elsif () {                     # ERROR: parenthesis must contain an expression
         }                                # ERROR: a block must at least have one statement
      } else {
      }                                   # ERROR: a block must at least have one statement
   }
}

