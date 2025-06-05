import esdl;
import uvm;
import std.stdio;

class avst_driver: uvm_driver!(avst_item)
{

  mixin uvm_component_utils;
  
  AvstIntf avst_in;

  this(string name, uvm_component parent = null) {
    super(name, parent);
    uvm_config_db!AvstIntf.get(this, "", "avst_in", avst_in);
    assert (avst_in !is null);
  }


  override void run_phase(uvm_phase phase) {
    super.run_phase(phase);
    while (true) {
      // uvm_info("AVL TRANSACTION", req.sprint(), UVM_DEBUG);
      seq_item_port.try_next_item(req);

      if (req !is null) {

	for (int i = 0; i != req.delay; ++i) {
	  wait (avst_in.clock.negedge());

	  avst_in.end = false;
	  avst_in.valid = false;
	}
	
	while (avst_in.ready == 0 || avst_in.reset == 1) {
	  wait (avst_in.clock.negedge());

	  avst_in.end = false;
	  avst_in.valid = false;
	}
	  

	wait (avst_in.clock.negedge());

	avst_in.data = req.data;
	avst_in.end = req.end;
	avst_in.valid = true;

	// req_analysis.write(req);
	seq_item_port.item_done();
      }
      else {
	wait (avst_in.clock.negedge());

	avst_in.end = false;
	avst_in.valid = false;
      }
    }
  }

  // protected void trans_received(avst_item tr) {}
  // protected void trans_executed(avst_item tr) {}

}
