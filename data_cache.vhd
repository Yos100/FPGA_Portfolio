library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity Data_Cache is
    Port (
        clk         : in  STD_LOGIC;                      -- Clock signal
        reset       : in  STD_LOGIC;                      -- Asynchronous reset signal
        address     : in  STD_LOGIC_VECTOR(4 downto 0);   -- 5-bit address input (from low-order bits of ALU output)
        d_in        : in  STD_LOGIC_VECTOR(31 downto 0);  -- 32-bit data input (from rt register of register file)
        data_write  : in  STD_LOGIC;                      -- Write enable signal
        d_out       : out STD_LOGIC_VECTOR(31 downto 0)   -- 32-bit data output
    );
end Data_Cache;

architecture Behavioral of Data_Cache is
    -- Define a 32x32-bit RAM for the data cache
    type memory_array is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
    signal data_mem : memory_array := (others => (others => '0'));  -- Initialize to 0
begin
    -- Process for synchronous write and asynchronous reset
    process(clk, reset)
    begin
        if reset = '1' then
            -- Clear the memory on reset
            data_mem <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if data_write = '1' then
                -- Write data to the cache on the rising clock edge if data_write is enabled
                data_mem(to_integer(unsigned(address))) <= d_in;
            end if;
        end if;
    end process;

    -- Output the data from the cache asynchronously
    d_out <= data_mem(to_integer(unsigned(address)));
end Behavioral;
