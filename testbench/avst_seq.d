import esdl;
import uvm;
import std.stdio;

class avst_seq: uvm_sequence!avst_item
{
  @UVM_DEFAULT {
    @rand uint seq_size;
  }

  mixin uvm_object_utils;


  this(string name="") {
    super(name);
    req = avst_item.type_id.create(name ~ ".req");
  }

  constraint!q{
    seq_size < 64;
    seq_size > 16;
  } seq_size_cst;

  // task
  override void body() {
      for (size_t i=0; i!=seq_size; ++i) {
	wait_for_grant();
	req.randomize();
	if (i == seq_size - 1) req.end = true;
	else req.end = false;
	avst_item cloned = cast(avst_item) req.clone;
	// uvm_info("avst_item", cloned.sprint, UVM_DEBUG);
	send_request(cloned);
      }
      // uvm_info("avst_item", "Finishing sequence", UVM_DEBUG);
    }

}
