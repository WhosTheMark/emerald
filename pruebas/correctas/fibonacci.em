
intmonchan fibonacci (intmonchan N) {

   if (N = 0 || N = 1)
      return 1
   else
      return fibonacci(N-1) + fibonacci(N-2)
}

voidporeon main() {

   intmonchan fib;
   read(fib);
   print(fibonacci(fib))
}