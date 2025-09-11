library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Sign_Extend is
    Port (
        immediate_in : in  STD_LOGIC_VECTOR(15 downto 0);  -- 16-bit immediate input
        func         : in  STD_LOGIC_VECTOR(1 downto 0);   -- 2-bit control signal to specify extension type
        extended_out : out STD_LOGIC_VECTOR(31 downto 0)   -- 32-bit extended output
    );
end Sign_Extend;

architecture Behavioral of Sign_Extend is
begin
    process(immediate_in, func)
    begin
        case func is
            -- Load Upper Immediate: Pad least significant 16 bits with 0s
            when "00" => 
                extended_out <= immediate_in & X"0000";

            -- Set Less Immediate: Arithmetic sign extend (copy the sign bit i15)
            when "01" =>
                extended_out <= (immediate_in(15) & immediate_in(15) & immediate_in(15) & immediate_in(15) & immediate_in(15) &
                                 immediate_in(15) & immediate_in(15) & immediate_in(15) & immediate_in(15) & immediate_in(15) &
                                 immediate_in(15) & immediate_in(15) & immediate_in(15) & immediate_in(15) & immediate_in(15) & 
                                 immediate_in(15)) & immediate_in;

            -- Arithmetic: Arithmetic sign extend (copy the sign bit i15)
            when "10" => 
                extended_out <= (immediate_in(15) & immediate_in(15) & immediate_in(15) & immediate_in(15) & immediate_in(15) &
                                 immediate_in(15) & immediate_in(15) & immediate_in(15) & immediate_in(15) & immediate_in(15) &
                                 immediate_in(15) & immediate_in(15) & immediate_in(15) & immediate_in(15) & immediate_in(15) & 
                                 immediate_in(15)) & immediate_in;

            -- Logical: Pad high-order 16 bits with 0s
            when "11" => 
                extended_out <= X"0000" & immediate_in;

            -- Default case to handle unexpected `func` values
            when others =>
                extended_out <= (others => '0');
        end case;
    end process;
end Behavioral;
