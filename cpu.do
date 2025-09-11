
# Add specific signals you want to observe from the datapath and control unit
add wave -position end sim:/cpu/u_control_unit/*
add wave -position end sim:/cpu/u_datapath/*
add wave -position end sim:/cpu/rs_out
add wave -position end sim:/cpu/rt_out
add wave -position end sim:/cpu/pc_out
add wave -position end sim:/cpu/overflow
add wave -position end sim:/cpu/zero
add wave -position end sim:/cpu/alu_zero_flag
add wave -position end sim:/cpu/alu_overflow_flag
add wave -position end sim:/cpu/instruction_internal
add wave -position end sim:/cpu/d_cache_out
add wave reset
add wave clk

force reset 1
force clk 0
run 2

force reset 0
run 2
force clk 1
 run 2
force clk 0
run 2

force clk 1 
 run 2
force clk 0
run 2

force clk 1 
 run 2
force clk 0
run 2

force clk 1 
 run 2
force clk 0
run 2

force clk 1 
 run 2
force clk 0
run 2

force clk 1 
 run 2
force clk 0
run 2

force clk 1 
 run 2
force clk 0
run 2

force clk 1 
 run 2
force clk 0
run 2

force clk 1 
 run 2
force clk 0
run 2

force clk 1 
 run 2
force clk 0
run 2



force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2


force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2


force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

force clk 1
 run 2
force clk 0
run 2

# Run the simulation
run -all

# Optionally, if you want to simulate for a specific time:
# run 1000 ns

# End the simulation
quit
