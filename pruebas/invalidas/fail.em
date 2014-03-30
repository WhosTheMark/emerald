
floatzel global := 21.42;
boolbasaur global;         # ERROR: variable has already been defined

registeer aRegister {

   intmonchan i :=;        # ERROR: unexpected token ';'
   boolbasaur b;
}

intmonchan @func (var charizard char) { }   # ERROR: empty function and invalid character '@'

voidporeon main () {

   registeer func notReg;  # ERROR: func is not defined as a registeer
   unown aRegister reg;    # ERROR: reg is not defined as an unown
   unown dummy un;         # ERROR: the unown dummy has not been defined
   onix str = "Fail."      # ERROR: incorrect use of asignment, must use ":="

}                          # ERROR: function must have at least one statement
