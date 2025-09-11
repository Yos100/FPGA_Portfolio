library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

-- Wrapper for board implementation
entity regfile_wrapper is
    port(
        din_in           : in std_logic_vector(3 downto 0);   -- 4-bit data input
        reset            : in std_logic;                     -- Asynchronous reset
        clk              : in std_logic;                     -- Clock input
        write            : in std_logic;                     -- Write enable
        read_a_in        : in std_logic_vector(1 downto 0);  -- 2-bit read address for port A
        read_b_in        : in std_logic_vector(1 downto 0);  -- 2-bit read address for port B
        write_address_in : in std_logic_vector(1 downto 0);  -- 2-bit write address
        out_a_out        : out std_logic_vector(3 downto 0); -- 4-bit data output for port A
        out_b_out        : out std_logic_vector(3 downto 0)  -- 4-bit data output for port B
    );
end regfile_wrapper;


architecture behavior of regfile_wrapper is 
  --signals to connect with instantiated regfile (32 bit)
    signal din_internal       : std_logic_vector(31 downto 0);
    signal out_a_internal     : std_logic_vector(31 downto 0);
    signal out_b_internal     : std_logic_vector(31 downto 0);
    signal read_a_internal    : std_logic_vector(4 downto 0);
    signal read_b_internal    : std_logic_vector(4 downto 0);
    signal write_address_internal : std_logic_vector(4 downto 0);

begin

    -- Instantiate the regfile entity
    u_regfile : entity work.regfile
        port map (
            din            => din_internal,         -- 32-bit input to regfile
            reset          => reset,                -- Reset signal
            clk            => clk,                  -- Clock signal
            write          => write,                -- Write enable signal
            read_a         => read_a_internal,      -- 5-bit read address for port A
            read_b         => read_b_internal,      -- 5-bit read address for port B
            write_address  => write_address_internal, -- 5-bit write address
            out_a          => out_a_internal,       -- 32-bit output for port A
            out_b          => out_b_internal        -- 32-bit output for port B
        );

    -- Map the 4-bit inputs to the lower 4 bits of the 32-bit signals
    din_internal(3 downto 0)   <= din_in;
    din_internal(31 downto 4)  <= (others => '0');  -- Zero-extend to 32 bits

    -- Map the 2-bit read and write addresses to the lower 2 bits of the 5-bit addresses
    read_a_internal(1 downto 0) <= read_a_in;
    read_a_internal(4 downto 2) <= (others => '0');  -- Zero-extend to 5 bits

    read_b_internal(1 downto 0) <= read_b_in;
    read_b_internal(4 downto 2) <= (others => '0');  -- Zero-extend to 5 bits

    write_address_internal(1 downto 0) <= write_address_in;
    write_address_internal(4 downto 2) <= (others => '0');  -- Zero-extend to 5 bits

    -- Extract the lower 4 bits of the outputs
    out_a_out <= out_a_internal(3 downto 0);
    out_b_out <= out_b_internal(3 downto 0);

end behavior;
