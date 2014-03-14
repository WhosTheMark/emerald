
intmonchan factorial (intmonchan n) {

   intmonchan acc:= 1;

   for i from 1 to n   
      acc:= acc * i     
   
}

voidporeon main() {

   intmonchan n;   
   intmonchan f; 
   
   read(n);
   
   f := factorial(n);   
   print(f)

}