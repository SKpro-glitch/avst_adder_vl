import esdl;
import uvm;
import std.stdio;

class avst_agent: uvm_agent
{

  @UVM_BUILD {
    avst_sequencer sequencer;
    avst_driver    driver;
    avst_out_driver driver_out;

    avst_monitor   req_monitor;
    avst_monitor   rsp_monitor;

    avst_snooper   req_snooper;
    avst_snooper   rsp_snooper;

    avst_scoreboard   scoreboard;
  }
  
  mixin uvm_component_utils;
   
  this(string name, uvm_component parent = null) {
    super(name, parent);
  }

  override void connect_phase(uvm_phase phase) {
    driver.seq_item_port.connect(sequencer.seq_item_export);
    req_snooper.egress.connect(req_monitor.ingress);
    req_monitor.egress.connect(scoreboard.req_analysis);
    rsp_snooper.egress.connect(rsp_monitor.ingress);
    rsp_monitor.egress.connect(scoreboard.rsp_analysis);
  }

  override void end_of_elaboration_phase(uvm_phase phase) {
    rsp_snooper.set_read_latency(1);
  }
}
