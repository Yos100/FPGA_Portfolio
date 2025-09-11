# Datapath Test Script
add wave -position end clk
add wave -position end reset
add wave -position end add_sub
add wave -position end logic_func
add wave -position end alu_func
add wave -position end reg_write_enable
add wave -position end mem_write_enable
add wave -position end pc_sel
add wave -position end branch_type
add wave -position end sign_ext_ctrl
add wave -position end reg_dst
add wave -position end rs_out
add wave -position end rt_out
add wave -position end pc_out
add wave -position end alu_zero_flag
add wave -position end alu_overflow_flag
add wave -position end instruction
add wave -position end d_cache_out

# Set initial clock, reset, and control signal states
force clk 0;
force reset 1;
force add_sub 0;
force logic_func "00";
force alu_func "00";
force reg_write_enable 0;
force mem_write_enable 0;
force pc_sel "00";
force branch_type "00";
force sign_ext_ctrl "00";
force reg_dst 0;

run 100ns;  # Initial reset state

# Release reset to start operation
force reset 0;

# Test Program Counter Increment (PC) without branching
force clk 1;
run 50ns;
force clk 0;
run 50ns;
force clk 1;
run 50ns;
force clk 0;
run 50ns;

# Test Register File Write (write a value into a register)
force reg_write_enable 1;
force logic_func "01";  # Sample control value for ALU operation
force alu_func "01";    # Sample control value for ALU operation
force pc_sel "01";      # Select signal for branching or PC update
#force instruction x"00430820";  # Example MIPS instruction: add r1, r2, r3

# Simulate rising clock edge to perform register write
force clk 1;
run 50ns;
force clk 0;
run 50ns;

# Disable write and set another instruction to simulate reading from a register
force reg_write_enable 0;
#force instruction x"00430822";  # Example MIPS instruction: sub r1, r2, r3

# Simulate clock cycles to test register file reads
force clk 1;
run 50ns;
force clk 0;
run 50ns;
force clk 1;
run 50ns;
force clk 0;
run 50ns;

# Test ALU with add operation, setting add_sub to perform addition
force add_sub 0;    # Set for addition
force alu_func "10";  # Another control function for testing
#force instruction x"8C220004";  # Example load instruction
run 50ns;

# Toggle clk to check ALU operation
force clk 1;
run 50ns;
force clk 0;
run 50ns;

# Test Data Cache Write (store operation)
force mem_write_enable 1;
#force instruction x"AC220004";  # Example store instruction
force clk 1;
run 50ns;
force clk 0;
run 50ns;

# Disable memory write after store operation
force mem_write_enable 0;
force clk 1;
run 50ns;
force clk 0;
run 50ns;

# Test Sign Extension Unit and Branch Operation
force sign_ext_ctrl "10";  # Control signal for sign extension
force branch_type "01";    # Sample branch type
force pc_sel "10";         # Control signal for next address selection
#force instruction x"10220003";  # Example branch instruction

# Toggle clk to check branching behavior
force clk 1;
run
