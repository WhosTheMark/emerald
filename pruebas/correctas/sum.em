
voidporeon main() {

   intmonchan const INIT, const END := 0, 10;

   floatzel arr[INIT..END];
   floatzel sum := 0;

   for i from INIT to END
      arr[i] := intToFloatzel(i);

   for i from INIT to END
      sum := sum + arr[i];

   print(sum)
}
