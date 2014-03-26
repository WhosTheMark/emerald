

intmonchan length (intmonchan[init..end] arr) {

   intmonchan acc := 0;

   for i from init to end
      acc := acc + 1;

   return acc
}


boolbasaur palindrome (intmonchan[init..end] arr) {

   intmonchan len := length(arr);

   for i from init to end {

      if (arr[i] != arr[len-i])
         return false
   }

   return true
}


voidporeon main() {

   intmonchan arr[0..3];
   boolbasaur isPalindrome;

   arr[0], arr[1], arr[2], arr[3] := 1, 2, 2, 1;

   isPalindrome := palindrome(arr)

}