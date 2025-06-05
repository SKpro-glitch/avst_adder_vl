import esdl;
import uvm;
import std.stdio;

class Top: Entity
{
  import Vadder_avst_euvm;
  import esdl.intf.verilator.verilated;

  VerilatedVcdD _trace;

  Signal!(ubvec!1) reset;
  Signal!(ubvec!1) clock;

  DVadder_avst dut;

  AvstIntf avstIn;
  AvstIntf avstOut;
  
  void opentrace(string vcdname) {
    if (_trace is null) {
      _trace = new VerilatedVcdD();
      dut.trace(_trace, 99);
      _trace.open(vcdname);
    }
  }

  void closetrace() {
    if (_trace !is null) {
      _trace.close();
      _trace = null;
    }
  }

  override void doConnect() {
    import std.stdio;

    //
    avstIn.clock(clock);
    avstIn.reset(reset);

    avstIn.data(dut.data_in);
    avstIn.end(dut.end_in);
    avstIn.valid(dut.valid_in);
    avstIn.ready(dut.ready_in);

    // 
    avstOut.clock(clock);
    avstOut.reset(reset);

    avstOut.data(dut.data_out);
    avstOut.end(dut.end_out);
    avstOut.valid(dut.valid_out);
    avstOut.ready(dut.ready_out);
  }

  override void doBuild() {
    dut = new DVadder_avst();
    traceEverOn(true);
    opentrace("avst_adder.vcd");
  }
  
  Task!stimulateClock stimulateClockTask;
  Task!stimulateReset stimulateResetTask;
  Task!stimulateReadyOut stimulateReadyOutTask;

  void stimulateReadyOut() {
    dut.reset = true;
  }
  
  void stimulateClock() {
    import std.stdio;
    clock = false;
    for (size_t i=0; i!=1000000; ++i)
      {
	
      // writeln("clock is: ", clock);
      clock = false;
      dut.clk = false;
      wait (2.nsec);
      dut.eval();
      if (_trace !is null)
	_trace.dump(getSimTime().getVal());
      wait (8.nsec);
      clock = true;
      dut.clk = true;
      wait (2.nsec);
      dut.eval();
      if (_trace !is null) {
	_trace.dump(getSimTime().getVal());
	_trace.flush();
      }
      wait (8.nsec);
    }
  }

  void stimulateReset() {
    reset = true;
    dut.reset = true;
    wait (100.nsec);
    reset = false;
    dut.reset = false;
  }
  
}
