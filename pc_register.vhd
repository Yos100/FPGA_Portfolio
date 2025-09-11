library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PC_Register is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;         -- Asynchronous reset
        next_addr   : in  STD_LOGIC_VECTOR(31 downto 0); -- Input from next-address unit
        pc_out      : out STD_LOGIC_VECTOR(31 downto 0); -- Full 32-bit PC output
        cache_addr  : out STD_LOGIC_VECTOR(4 downto 0)   -- Low-order 5 bits for cache
    );
end PC_Register;

architecture Behavioral of PC_Register is
    signal pc_reg : STD_LOGIC_VECTOR(31 downto 0) := (others => '0'); -- Internal PC register
begin

    -- Process to handle PC register updates and asynchronous reset
    process(clk, reset)
    begin
        if reset = '1' then
            pc_reg <= (others => '0');     -- Reset PC register to 0 asynchronously
        elsif rising_edge(clk) then
            pc_reg <= next_addr;           -- Load the next address on each clock edge
        end if;
    end process;

    -- Outputs
    pc_out <= pc_reg;                      -- Full 32-bit output
    cache_addr <= pc_reg(4 downto 0);      -- Low-order 5 bits for cache addressing

end Behavioral;
