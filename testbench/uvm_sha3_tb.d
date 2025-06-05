import esdl;
import uvm;
import std.stdio;

class uvm_sha3_tb: uvm_tb
{
  Top top;
  override void initial() {
    uvm_config_db!(AvstIntf).set(null, "uvm_test_top.env.agent.driver", "avst_in", top.avstIn);
    uvm_config_db!(AvstIntf).set(null, "uvm_test_top.env.agent.driver_out", "avst_out", top.avstOut);
    uvm_config_db!(AvstIntf).set(null, "uvm_test_top.env.agent.req_snooper", "avst", top.avstIn);
    uvm_config_db!(AvstIntf).set(null, "uvm_test_top.env.agent.rsp_snooper", "avst", top.avstOut);
  }
}
