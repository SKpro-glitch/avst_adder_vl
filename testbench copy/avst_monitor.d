import esdl;
import uvm;
import std.stdio;

class avst_monitor: uvm_monitor
{

  mixin uvm_component_utils;
  
  @UVM_BUILD {
    uvm_analysis_port!avst_phrase_seq egress;
    uvm_analysis_imp!(avst_monitor, write) ingress;
  }


  this(string name, uvm_component parent = null) {
    super(name, parent);
  }

  avst_phrase_seq seq;

  void write(avst_item item) {
    if (seq is null) {
      seq = avst_phrase_seq.type_id.create("avst_seq");
    }
    seq ~= item;
    if (seq.is_finalized()) {
      uvm_info("Monitor", "Got Seq " ~ seq.sprint(), UVM_DEBUG);
      egress.write(seq);
      seq = null;
    }
  }
  
}
