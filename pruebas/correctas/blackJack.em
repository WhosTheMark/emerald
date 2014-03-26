

# BlackJack

intmonchan blackJack(intmonchan a, intmonchan b) {

   intmonchan aValue := a;
   intmonchan bValue := b;

   if (aValue > 21)
      aValue := 0;

   if (bValue > 21)
      bValue := 0;

   if (aValue > bValue)
      return aValue
   else
      return bValue
}
 
voidporeon main() {

   intmonchan a;
   intmonchan b;
   intmonchan winner;

   println("Player 1: ");
   read(a);

   println("Player 2: ");
   read(b);

   winner := blackJack(a,b);
   
   println("And the winning hand is... ");
   println(winner)
   
}