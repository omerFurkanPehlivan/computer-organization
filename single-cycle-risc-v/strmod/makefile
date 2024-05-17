FILE = no_default_value

ifeq ($(FILE),no_default_value)
$(error FILE is not set)
endif

all:
	iverilog -o testbench/$(FILE)_tb.vvp -y . testbench/$(FILE)_tb.v && vvp testbench/$(FILE)_tb.vvp