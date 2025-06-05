import esdl;
import uvm;
import std.stdio;

class AvstIntf: VlInterface
{
  Port!(Signal!(ubvec!1)) clock;
  Port!(Signal!(ubvec!1)) reset;
  
  VlPort!8 data;
  VlPort!1 end;
  VlPort!1 valid;
  VlPort!1 ready;
}