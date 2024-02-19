target=ram

RTL= ../../rtl/bram.v

$(target): $(target).gtk

$(target).gtk: sim.vcd

sim.vcd: sim.out
	vvp $<

sim.out: sim.v $(RTL)
	iverilog -o $@ -D VCD_OUTPUT=sim $^

.PHONY: gui

gui:
	gtkwave sim.vcd
