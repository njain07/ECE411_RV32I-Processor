from subprocess import PIPE, Popen
import parse
from os import getcwd

pipe_all = {"stdin" : PIPE}#, "stdout" : PIPE, "stderr" : PIPE}
quartus_tcl = "/software/altera/13.1/quartus/common/tcl/internal/nativelink/qnativesim.tcl"
#parser = parse.compile("{: >.d}{:s}+{:d}{write_data: >8.S}{write: >1.S}{write_address: >8.S}{:s}{{{REGS}}}{}") #riscv
parser = parse.compile("{: >.d}{:s}+{:d}{write_data: >4.S}{write: >1.S}{write_address: >4.S}{:s}{{{REGS}}}{}") #lc3


def init_sim(mp, path):
	quartus_map = Popen(["quartus_map", mp, "-c", mp], **pipe_all)
	quartus_map.wait()
	quartus_sh = Popen(["quartus_sh", "-t", quartus_tcl, "--no_gui", "--rtl_sim", mp, mp], **pipe_all)
	vsim_init = Popen(["/software/altera/13.1/modelsim_ase/bin/vsim", "-c"], **pipe_all)
	quartus_sh.wait()
	dolines = open(path + "/simulation/modelsim/" + mp + "_run_msim_rtl_verilog.do", 'r').readlines()
	initdo = "".join(dolines[:-2])
	vsim_init.communicate(initdo)
	vsim_init.wait()
	return dolines[-7] #-6 for quartus 15

def sim(vsim_command):
	vsim_sim = Popen(["/software/altera/13.1/modelsim_ase/bin/vsim", "-c"], **pipe_all)
	command = 'vlib rtl_work; vmap work rtl_work; ' + vsim_command + '; radix hex; add list -notrigger write_data; add list write; add list -notrigger write_address; add list registers; when {halt == "1"} {write list out.lst; exit} ; run -all'
	vsim_sim.communicate(command)
	vsim_sim.wait()
	with open("out.lst", 'r') as out:
		sim_out = [tuple(val for key,val in sorted(parsed.named.items())) for parsed in (parser.parse(line) for line in out) if parsed]
	return sim_out

#obviously
dolines = init_sim("mp0", getcwd())
#you must have memory.lst in the current working directory
sim_trace = sim(dolines)
print sim_trace

#after init_sim has been done once, you can sim as many times as you want
#you just need to invoke load_memory.sh or copy a new memory.lst from somewhere
#with the code you want to simulate next

#you'll need to init_sim again if you change your SystemVerilog code

