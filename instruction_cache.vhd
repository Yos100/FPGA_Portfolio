library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity I_Cache is
    Port (
        address      : in  STD_LOGIC_VECTOR(4 downto 0);  -- 5-bit address input
        data_out  : out STD_LOGIC_VECTOR(31 downto 0)  -- 32-bit instruction output
    );
end I_Cache;

architecture Behavioral of I_Cache is
begin
    process(address)
    begin
        case address is
            -- Store the machine code for each instruction
 
	 when "00000" => data_out <= "00100000000000110000000000000000"; -- addi r3, r0, 0
	 when "00001" => data_out <= "00100000000000010000000000000000"; -- addi r1, r1, 0
	 when "00010" => data_out <= "00100000000000100000000000000101"; -- addi r2, r0, 5
         when "00011" => data_out <= "00000000001000100000100000100000"; -- add r1, r1, r2
       	 when "00100" => data_out <= "00100000010000101111111111111111"; -- addi r2, r2, -1
	 when "00101" => data_out <= "00010000010000110000000000000001"; -- beq r2, r3 (+1) THERE
	 when "00110" => data_out <= "00001000000000000000000000000011"; -- jump 3 (LOOP)
         when "00111" => data_out <= "10101100000000010000000000000000"; -- sw r1, 0(r0)  
	 when "01000" => data_out <= "10001100000001000000000000000000"; -- lw r4, 0(r0)
	 when "01001" => data_out <= "00110000100001000000000000001010"; -- andi r4, r4, 0x000A
	 when "01010" => data_out <= "00110100100001000000000000000001"; -- ori r5, r4, 0x0001
	 when "01011" => data_out <= "00111000100001000000000000001011"; -- xori r6, r4, 0xB
	 when "01100" => data_out <= "00111000100001000000000000000000"; -- slti r7, r4, 0x0
	 when others  => data_out <= "00000000000000000000000000000000"; -- dont care                -- No operation / NOP
        end case;
    end process;
end Behavioral;


--      "00000"   "00100000000000110000000000000000"; -- addi r3, r0, 0
--      "00001"   "00100000000000010000000000000000"; -- addi r1, r0, 0
--      "00010"   "00100000000000100000000000000101"; -- addi r2,r0,5
--LOOP: "00011"  "00000000001000100000100000100000"; -- add r1,r1,r2
  --    "00100"  "00100000010000101111111111111111"; -- addi r2, r2, -1
    --  "00101"  "00010000010000110000000000000001"; -- beq r2,r3 (+1) THERE
      --"00110"  "00001000000000000000000000000011"; -- jump 3  (LOOP)
--THERE:"00111"  "10101100000000010000000000000000"; -- sw r1, 0(r0)  
  --    "01000"  "10001100000001000000000000000000"; -- lw r4, 0(r0)
   --   "01001"  "00110000100001000000000000001010"; -- andi r4,r4, 0x000A
     -- "01010"  "00110100100001000000000000000001"; -- ori r4,r4, 0x0001
     -- "01011"  "00111000100001000000000000001011"; -- xori r4,r4, 0xB
     --"01100"   "00111000100001000000000000000000"; -- xori r4,r4, 0x0000
      --others   "00000000000000000000000000000000"; -- dont care
