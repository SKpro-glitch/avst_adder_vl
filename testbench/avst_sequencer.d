import esdl;
import uvm;
import std.stdio;

class avst_sequencer: uvm_sequencer!avst_item
{
  mixin uvm_component_utils;

  this(string name, uvm_component parent=null) {
    super(name, parent);
  }
}
