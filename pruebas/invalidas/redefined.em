
/* Invalid program to test redefinition errors */

charizard redefined := 'a';
onix redefined := "redefined";      # ERROR: Redefined global variable

# ERROR: Has already been declared

intmonchan redefined () {

   return 28
}

voidporeon main() {

   intmonchan a := 1;
   floatzel a;                      # ERROR: Redefined variable

   a := a + 1;

   for i from 1 to 10 {

      floatzel a, b := 1.0, 0.0;
      boolbasaur b := true;         # ERROR: Redefined variable

      b := intToFloatzel(a) * i;
      println(b)
   }
}