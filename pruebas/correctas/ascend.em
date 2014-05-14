
boolbasaur ascendArray (intmonchan a[init..end]) {

   boolbasaur ascending := true;
   intmonchan i := init;

   while (ascending && i < end) {
      ascending := a[i] <= a[i+1];
      i := i + 1
   };
   return ascending
}

voidporeon main() {

   intmonchan const INIT, const END := 0, 10;
   intmonchan arr[0..10];
   boolbasaur ascend;

   for i from INIT to END
      arr[i] := i * 28 % 20;

   println(ascendArray(arr))
}
