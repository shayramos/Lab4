transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Lab4/AudioPin {C:/Lab4/AudioPin/memoController.v}
vlog -vlog01compat -work work +incdir+C:/Lab4/AudioPin {C:/Lab4/AudioPin/codecInterface.v}
vlog -vlog01compat -work work +incdir+C:/Lab4/AudioPin {C:/Lab4/AudioPin/audioprocessor.v}
vlog -vlog01compat -work work +incdir+C:/Lab4/AudioPin {C:/Lab4/AudioPin/geradorsqwave.v}
vlog -vlog01compat -work work +incdir+C:/Lab4/AudioPin/db {C:/Lab4/AudioPin/db/clkdiv_altpll.v}
vcom -93 -work work {C:/Lab4/AudioPin/romMemory.vhd}
vcom -93 -work work {C:/Lab4/AudioPin/clkdiv.vhd}

