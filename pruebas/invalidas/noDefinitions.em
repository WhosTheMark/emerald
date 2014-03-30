
/* A valid program must at least have a global variable
 * or a function, register or union definition.
 */

{
   intmonchan a := 4;
   intmonchan b := a;

   if true
      b := b*3;
   else
      a := a + b * 8;
}