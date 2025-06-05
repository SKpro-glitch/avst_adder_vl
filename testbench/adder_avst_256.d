module adder_avst_256;

import esdl;
import uvm;
import avst_seq;

class avst_seq_256: avst_seq
{
  mixin uvm_object_utils;

  this(string name="") {
    super(name);
  }

  @constraint_override
  constraint!q{
    seq_size == 256;
  } seq_size_cst;
}
