add wave -position end clk
add wave -position end reset
add wave -position end address
add wave -position end d_in
add wave -position end data_write
add wave -position end d_out


# Initial reset and clock setup
force clk 0;
force reset 1;
force address "00010";
force d_in x"00000000";
force data_write 0;

run 100ns;   # Initial reset state

# Release reset and prepare for first write operation
force reset 0;
force clk 1;
force address "00011";
force d_in x"AAAAAAAA";
force data_write 1;

run 100ns;   # Perform write at address 00011

# Toggle clock for next operation
force clk 0;
run 50ns;
force clk 1;
run 50ns;

# Write another value at a different address
force address "00100";
force d_in x"55555555";
force data_write 1;

run 100ns;   # Perform write at address 00100

# Toggle clock for next operation
force clk 0;
run 50ns;
force clk 1;
run 50ns;

# Read from the address 00011, which should contain 0xAAAAAAAA
force address "00011";
force data_write 0;   # Ensure no write occurs during read

run 100ns;

# Toggle clock for next operation
force clk 0;
run 50ns;
force clk 1;
run 50ns;

# Read from the address 00100, which should contain 0x55555555
force address "00100";
force data_write 0;   # Ensure no write occurs during read

run 100ns;

# Additional write to check overwrite functionality
force address "00011";
force d_in x"12345678";
force data_write 1;

run 100ns;   # Overwrite at address 00011 with 0x12345678

# Toggle clock for next operation
force clk 0;
run 50ns;
force clk 1;
run 50ns;

# Read back the overwritten value at address 00011
force address "00011";
force data_write 0;

run 100ns;

# Final read from address 00100 to ensure it is unchanged
force address "00100";
run 100ns;

# End of test
force clk 0;
run 50ns;
