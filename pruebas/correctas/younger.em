
registeer person {

   intmonchan id;
   onix name;
   intmonchan age;
}

boolbasaur isYounger (registeer person p1,registeer person p2) {

   return p1.age < p2.age
}

voidporeon main() {

   registeer person p1;
   registeer person p2;
   boolbasaur younger;

   p1.id := 12345;
   p1.name := "Andrea";
   p1.age := 24;

   p2.id := 54321;
   p2.name := "Marcos";
   p2.age := 21;

   if (isYounger(p1,p2))
      println("Lies.")
   else
      println("How do you know?")
}