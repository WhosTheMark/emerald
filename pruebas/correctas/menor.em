
registeer persona {

   intmonchan cedula;
   onix nombre[1..20];
   intmonchan edad;

}

/* Esto es un ******** comentario ****
   de varias // lineas muy feo. */

/*
boolbasaur menorEdad (registeer persona p1,registeer persona p2) {

   return p1.edad < p2.edad
}
*/

voidporeon main() {

   registeer persona p1;
   registeer persona p2;
   boolbasaur menor;
   intmonchan a;

   a:= 0;

   p1.cedula := 12345;
   p1.nombre := "Andrea";
   p1.edad := 24;

   p2.cedula := 54321;
   p2.nombre := "Marcos";
   p2.edad := 21;

   if (menorEdad(p1,p2))
      print("Mentira.")

   else
      print("Como sabes?")

}