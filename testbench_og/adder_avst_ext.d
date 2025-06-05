import uvm;
import esdl;
import adder_avst;

class avst_ext_item: avst_item
{
  mixin uvm_object_utils;

  this(string name = "avst_ext_item") {
    super(name);
  }

  @constraint_override
  constraint! q{
    delay dist [0 := 50, 1:9 :/ 50];
  } cst_delay;
  
}
