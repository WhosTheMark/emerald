
# This is a random program.

/* And ********
   ******* this
   is *********
   * multi-line
   comment ****
*/

intmonchan globalInt;
floatzel   globalFloat;
boolbasaur globalBool;
charizard  globalChar;

registeer aRegister {

   intmonchan field1;
   floatzel   field2;
   boolbasaur field3[1..2];
}

unown aUnion {

   intmonchan field1;
   floatzel   field2;
   boolbasaur field3;
}

floatzel aFunction (floatzel parameter) {

   floatzel result;

   result := parameter * 2.0 + 1.0;
   result := result ^ 2 / 4.0;

   return result
}

intmonchan aRecursiveFunc (intmonchan int, intmonchan acc) {

   if (int = 0)
      return acc
   else
      return aRecursiveFunc(int-1,acc*int)
}

intmonchan regFunction (var registeer aRegister reg) {

   return reg.field1*3
}

voidporeon main() {

   intmonchan int := 0;
   unown aUnion un;
   registeer aRegister reg;
   floatzel float := 0.0;
   intmonchan num;

   reg.field3[1], reg.field3[2] := true, false;

   print("This is a multi-line string. \\n
          Enter a number: ");

   read(int);
   println();

   if (int >= 9) {

      intmonchan num;

      print("Enter a number between 1 and 4: ");
      read(num);
      println();

      switch num {

         case 1 -> { for i from 0 to 30 by 3
                        println(int + 1)
                   }

         case 2 -> { charizard c;
                     intmonchan array[0..5];

                     array[1] := 1;

                     c := 'a';

                     for i from -5 to 5 {
                        array[i] := num * i;
                        println(1)
                     }
                   }

         case 3 -> { while (num <= int^2)
                        num := num + 1;

                     float := intToFloatzel(num);
                     float := aFunction(float);
                     println(float)
                   }

         case 4 -> { reg.field1 := num }
         default -> { println("Wrong number") }
      };

      if (int % 4 + 1 = num && 42 / num = 3)
         println("You are special.")

      else

         if (float != 0.0) {
            onix str := "You are semi-special";
            println(str);

            if (!reg.field3[2] || float < 1000.0) {
               floatzel whoopsie := float / 10.0;

               for i from whoopsie to 200 by 3
                  println("Fun fun fun!")
            }
         }

         elsif (float / 19.0 > intToFloatzel(int))
            num := floatToIntmonchan(float+28.0)


   } elsif int <= 4  {

      boolbasaur bool1, const bool2 := true, false;
      onix randomStr := "I am random";

      tag: aTag;
      for i from -100 to 4 {

         if (int = i)
            BOOM
         else
            println(i)
      };
      println(randomStr)

   } else
      println("Whoopsie!");

   println("
            End
            of
            program
            ")
}
