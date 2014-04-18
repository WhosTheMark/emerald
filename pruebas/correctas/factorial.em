
# Iterative factorial

intmonchan factorial (intmonchan n) {

   intmonchan acc:= 1;

   for i from 1 to n
      acc:= acc * i
}

# Recursive factorial

intmonchan factRec1 (intmonchan n) {

   if (n = 0)
      return 1
   else
      return factRec1(n-1) * n
}

intmonchan factHelper(intmonchan n, intmonchan acc);

# Factorial with tail recursion

intmonchan factRec2 (intmonchan n) {

   return factHelper(n,1)
}

intmonchan factHelper(intmonchan n, intmonchan acc) {

   if (n = 0)
      return acc
   else
      return factHelper(n-1,n*acc)
}

voidporeon main() {

   intmonchan n;
   intmonchan f;

   print("Enter a number to calculate its factorial: ");
   read(n);

   f := factorial(n);
   println(f);

   f := factRec1(n);
   println(f);

   f := factRec2(n);
   println(f)

}