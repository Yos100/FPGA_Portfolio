library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity regfile is
    port(
        din           : in std_logic_vector(31 downto 0);   -- 32-bit data input
        reset         : in std_logic;                       -- Asynchronous reset
        clk           : in std_logic;                       -- Clock input
        write         : in std_logic;                       -- Write enable
        read_a        : in std_logic_vector(4 downto 0);    -- Read address for port A
        read_b        : in std_logic_vector(4 downto 0);    -- Read address for port B
        write_address : in std_logic_vector(4 downto 0);    -- Write address
        out_a         : out std_logic_vector(31 downto 0);  -- Data output for port A
        out_b         : out std_logic_vector(31 downto 0)   -- Data output for port B
    );
end regfile;

architecture behavior of regfile is
    -- Declare the register file: 32 registers, each 32 bits wide
    type reg_array is array (0 to 31) of std_logic_vector(31 downto 0);
    signal registers : reg_array := (others => (others => '0'));  -- Initialize all to 0


begin




    --Asynchronous read process
    process(read_a, read_b)
    begin
        out_a <= registers (to_integer(unsigned(read_a)));
        out_b <= registers (to_integer(unsigned(read_b)));
    end process;
    -- Process for synchronous write and asynchronous reset
    process(clk, reset)
    begin
        -- Asynchronous reset
        if reset = '1' then
            registers <= (others => (others => '0'));  -- Clear all registers

        -- Synchronous write on rising edge of clock
        elsif rising_edge(clk) then
            if write = '1' then
                registers(to_integer(unsigned(write_address))) <= din;  -- Write data to selected register
            end if;
        end if;
    end process;
end behavior;
