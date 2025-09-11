add wave -position end opcode
add wave -position end func
add wave -position end reg_write
add wave -position end reg_dst
add wave -position end reg_in_src
add wave -position end alu_src
add wave -position end add_sub
add wave -position end data_write
add wave -position end logic_func
add wave -position end branch_type
add wave -position end pc_sel

force opcode "000000";
force func "100000";

run 50ns;

force opcode "000000";
force func "100010";

run 50ns;

force opcode "000000";
force func "101010";

run 50ns;

force opcode "000000";
force func "001000";

run 50ns;

force opcode "001000";
run 50ns;

force opcode "001100";
run 50ns;

force opcode "100011";
run 50ns;

force opcode "101011";
run 50ns;

force opcode "000010";
run 50ns;

force opcode "000100";
run 50ns;

force opcode "000101";
run 50ns;

force opcode "111111";
run 50ns;

run 200ns;
