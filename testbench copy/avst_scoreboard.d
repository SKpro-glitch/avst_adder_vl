import esdl;
import uvm;
import std.stdio;

class avst_scoreboard: uvm_scoreboard
{
  this(string name, uvm_component parent = null) {
    super(name, parent);
  }

  mixin uvm_component_utils;

  uvm_phase phase_run;

  uint matched;

  avst_phrase_seq[] req_queue;
  avst_phrase_seq[] rsp_queue;

  @UVM_BUILD {
    uvm_analysis_imp!(avst_scoreboard, write_req) req_analysis;
    uvm_analysis_imp!(avst_scoreboard, write_rsp) rsp_analysis;
  }

  override void run_phase(uvm_phase phase) {
    phase_run = phase;
    auto imp = phase.get_imp();
    assert(imp !is null);
    uvm_wait_for_ever();
  }

  void write_req(avst_phrase_seq seq) {
      uvm_info("Monitor", "Got req item", UVM_DEBUG);
      req_queue ~= seq;
      assert(phase_run !is null);
      phase_run.raise_objection(this);
      // writeln("Received request: ", matched + 1);
  }

  void write_rsp(avst_phrase_seq seq) {
      uvm_info("Monitor", "Got rsp item", UVM_DEBUG);
      // seq.print();
      rsp_queue ~= seq;
      assert(phase_run !is null);
      check_matched();
      phase_run.drop_objection(this);
  }

  void check_matched() {
    auto expected = req_queue[matched].transform();
    // writeln("Ecpected: ", expected[0..64]);
    if (expected == rsp_queue[matched].phrase) {
      uvm_info("MATCHED",
	       format("Scoreboard received expected response #%d", matched),
	       UVM_LOW);
      uvm_info("REQUEST", format("%s", req_queue[$-1].phrase), UVM_LOW);
      uvm_info("RESPONSE", format("%s", rsp_queue[$-1].phrase), UVM_LOW);
    }
    else {
      uvm_error("MISMATCHED", "Scoreboard received unmatched response");
      writeln(expected, " != ", rsp_queue[matched].phrase);
    }
    matched += 1;
  }

}
