-- Load necessary libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;  -- This is required for std_logic, std_logic_vector, etc.
use IEEE.STD_LOGIC_ARITH.ALL;  -- Optional, for arithmetic operations on std_logic_vector
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- Optional, for unsigned arithmetic operations
use IEEE.STD_LOGIC_SIGNED.ALL;  -- Optional, for signed arithmetic operations

-- Top-level entity for instantiating 5 CPUs
entity five_cpu is
    port(
        reset : in std_logic;           -- Reset signal
        clk   : in std_logic            -- Clock signal
    );
end five_cpu;

architecture rtl of five_cpu is

    -- Declare the component for the CPU
    component cpu is
        port(
            reset    : in std_logic;                -- Reset signal
            clk      : in std_logic;                -- Clock signal
            rs_out   : out std_logic_vector(3 downto 0);  -- Output rs
            rt_out   : out std_logic_vector(3 downto 0);  -- Output rt
            pc_out   : out std_logic_vector(3 downto 0);  -- Output PC
            overflow : out std_logic;               -- Overflow flag
            zero     : out std_logic                -- Zero flag
        );
    end component;

    -- Declare signals for 5 CPUs' outputs
    signal rs_out0, rs_out1, rs_out2, rs_out3, rs_out4 : std_logic_vector(3 downto 0);
    signal rt_out0, rt_out1, rt_out2, rt_out3, rt_out4 : std_logic_vector(3 downto 0);
    signal pc_out0, pc_out1, pc_out2, pc_out3, pc_out4 : std_logic_vector(3 downto 0);
    signal overflow0, overflow1, overflow2, overflow3, overflow4 : std_logic;
    signal zero0, zero1, zero2, zero3, zero4 : std_logic;

    for cpu0, cpu1, cpu2, cpu3, cpu4 : cpu use entity WORK.cpu (rtl);
   
    attribute DONT_TOUCH : string;
    attribute DONT_TOUCH of cpu0 : label is "TRUE";
    attribute DONT_TOUCH of cpu1 : label is "TRUE";
    attribute DONT_TOUCH of cpu2 : label is "TRUE";
    attribute DONT_TOUCH of cpu3 : label is "TRUE";
    attribute DONT_TOUCH of cpu4 : label is "TRUE";


begin

    -- Instantiate the 5 CPUs
    cpu0: cpu port map(
        reset => reset, clk => clk, 
        rs_out => rs_out0, rt_out => rt_out0, pc_out => pc_out0, 
        overflow => overflow0, zero => zero0
    );

    cpu1: cpu port map(
        reset => reset, clk => clk, 
        rs_out => rs_out1, rt_out => rt_out1, pc_out => pc_out1, 
        overflow => overflow1, zero => zero1
    );

    cpu2: cpu port map(
        reset => reset, clk => clk, 
        rs_out => rs_out2, rt_out => rt_out2, pc_out => pc_out2, 
        overflow => overflow2, zero => zero2
    );

    cpu3: cpu port map(
        reset => reset, clk => clk, 
        rs_out => rs_out3, rt_out => rt_out3, pc_out => pc_out3, 
        overflow => overflow3, zero => zero3
    );

    cpu4: cpu port map(
        reset => reset, clk => clk, 
        rs_out => rs_out4, rt_out => rt_out4, pc_out => pc_out4, 
        overflow => overflow4, zero => zero4
    );

end rtl;


