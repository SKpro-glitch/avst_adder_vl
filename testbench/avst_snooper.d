import esdl;
import uvm;
import std.stdio;

class avst_snooper: uvm_monitor
{
  mixin uvm_component_utils;

  AvstIntf avst;

  int _ready_latency = 0;

  void set_read_latency(int latency) {
    assert (latency == 0 || latency == 1);
    _ready_latency = latency;
  }

  bool prev_ready;

  this (string name, uvm_component parent = null) {
    super(name,parent);
    uvm_config_db!AvstIntf.get(this, "", "avst", avst);
    assert (avst !is null);
  }

  @UVM_BUILD {
    uvm_analysis_port!avst_item egress;
  }
  
  override void run_phase(uvm_phase phase) {
    super.run_phase(phase);

    while (true) {
      wait (avst.clock.posedge());
      if (_ready_latency == 0) prev_ready = avst.ready;
      if (avst.reset == 1 ||
	  prev_ready == 0 || avst.valid == 0) {
	if (_ready_latency == 1) prev_ready = avst.ready;
	continue;
      }
      else {
	avst_item item = avst_item.type_id.create(get_full_name() ~ ".avst_item");
	item.data = avst.data;
	item.end = cast(bool) avst.end;
	egress.write(item);
	uvm_info("AVL Monitored Req", item.sprint(), UVM_DEBUG);
	// writeln("valid input");
      }
      if (_ready_latency == 1) prev_ready = avst.ready;
    }
  }

}