import esdl;
import uvm;
import std.stdio;

class avst_out_driver: uvm_component
{

  mixin uvm_component_utils;
  
  AvstIntf avst_out;

  this(string name, uvm_component parent = null) {
    super(name, parent);
    uvm_config_db!AvstIntf.get(this, "", "avst_out", avst_out);
    assert (avst_out !is null);
  }


  override void run_phase(uvm_phase phase) {
    super.run_phase(phase);
    while (true) {
      uint delay;
      uint flag;
      delay = urandom(0, 10);
      flag = urandom(0, 10);
      if (flag == 0) {
	for (size_t i=0; i!=delay; ++i) {
	  avst_out.ready = false;
	  wait (avst_out.clock.negedge());
	}
      }
      else {
	avst_out.ready = true;
	wait (avst_out.clock.negedge());
      }
    }
  }

  // protected void trans_received(avst_item tr) {}
  // protected void trans_executed(avst_item tr) {}

}
