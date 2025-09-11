add wave -position end address
add wave -position end data_out

force address "00000";

run 100ns

force address "00001";

run 100ns

force address "00010";

run 100ns

force address "00011";

run 100ns

force address "00100";

run 100ns

# End simulation
run 1000ns
