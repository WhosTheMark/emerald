
# This is a random program

/* And 
   this 
   is   
   multi-line
   comment
*/

intmonchan globalInt;
floatzel   globalFloat;
boolbasaur globalBool;
charizard  globalChar;


registeer aRegister {
   
   intmonchan field1;
   floatzel   field2;
}

/*
unown aUnion {

   intmonchan field1;
   floatzel   field2;
   boolbasaur field3;
}
*/

floatzel aFunction (floatzel parameter) {

   floatzel result;

   result := parameter * 2 + 1;
   result := result ^ 2 / 4;

   return result
}

voidporeon main() {

   intmonchan int := 0;
   registeer aRegister reg;
   floatzel float := 0.0;
   intmonchan num;

   print("Enter a number: ");
   read(int);
   println();

   if (int >= 9) {
      
      intmonchan num;

      print("Enter a number between 1 and 4: ");
      read(num);
      println();
            
      switch num {

         case 1 -> { for i from 0 to 30 by 3
                        println(int + 1);
                        
                        println("WIIII++")
                   }

         case 2 -> { charizard c;
                     intmonchan array[0..5];
                     
                     array[1] := 1;

                     c := 'a';
                     
                     for i from 0 to 5 {
                        array[i] := num * i;
                        println(array[i])
                     }
      
                   }

         case 3 -> { while (num <= int)                         
                        num := num + 1;

                     float := intToFloatzel(num);
                     float := aFunction(float);
                     println(float)
                   }

         case 4 -> { reg.field1 := num }
         default -> { println("Wrong number") }
      }  
 
   } elsif int <= 4  {

      boolbasaur unused;
      onix randomStr := "I am random";

      unused := 2;
      tag: aTag;

      for i from -100 to 4 {

         if (int = i) 
            BOOM
         else
            println(i)
      };
      
      
      if 1 = 2 {
         boolbasaur BOO;
         println("hello")
      } elsif 1 < 2 
         println("BOO")
      else
         println();

      println(randomStr)
   }
}
