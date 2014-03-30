
voidporeon main() {

   intmonchan a;

   println("Which do you prefer? (enter the corresponding number)");

   println("1. Cat 2. Dog 3. Both 4. I hate animals.");

   read(a);

   switch a {

      case 1 -> { println("Cats are the best!") }
      case 2 -> { println("Dogs are adorable!") }
      case 3 -> { println("YAY!!!") }
      case 4 -> {
                  println("That is just sad. :(");
                  println("Here's an infinite loop.");

                  while (true)
                     println("Why would you hate them?")

                }
   }
}
