
registeer play {

   onix movie;
   intmonchan times := 1;
}

boolbasaur rewind(intmonchan b, charizard arr[init..end]);

# ERROR: Return type does not match with forward declaration.
intmonchan rewind(intmonchan b, charizard arr[init..end]) {
   return 0
}

# ERROR: The function rewind has already been defined.
boolbasaur rewind(intmonchan b, charizard arr[i..e]) {
   return true
}

voidporeon fastRewind(intmonchan i, boolbasaur b, charizard c);

# ERROR: The parameters do not match with the ones in the forward declaration.
voidporeon fastRewind(intmonchan j, charizard c, boolbasaur b) {

   println("<<<<<<<<<<<< Rewind <<<<<<<<<<<<")
}

voidporeon pause();

# ERROR: The number of parameters does not match with its forward declaration.
voidporeon pause(registeer play p) {

   p.times := 0
}

voidporeon main() {

   intmonchan i;
   registeer play p;

   p.movie, p.times := "The Hitchhiker's Guide to the Universe.", 42;

   pause()

}

