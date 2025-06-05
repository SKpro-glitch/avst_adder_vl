module avst_item;

import esdl;
import uvm;
import std.stdio;

class avst_item: uvm_sequence_item
{
  mixin uvm_object_utils;

  @UVM_DEFAULT {
    @rand ubyte data;
    @rand ubyte delay;
    ubvec!1 end;
  }
   
  this(string name = "avst_item") {
    super(name);
  }

  constraint! q{
    delay dist [0 := 99, 1:9 :/ 1];
  } cst_delay;

  constraint! q{
    data >= 0x30;
    data <= 0x7a;
  } cst_ascii;

}
