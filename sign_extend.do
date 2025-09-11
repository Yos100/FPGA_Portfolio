add wave -position end immediate_in
add wave -position end func
add wave -position end extended_out

force immediate_in "1000111111111100";
force func 00;

run 100ns

force immediate_in "1000111111111100";
force func 01;

run 100ns

force immediate_in "1000111111111100";
force func 10;

run 100ns

force immediate_in "1000111111111100";
force func 11;

run 100ns

force immediate_in "0000111111111100";
force func 01;

run 100ns


force immediate_in "0000111111111100";
force func 01;

run 100ns


