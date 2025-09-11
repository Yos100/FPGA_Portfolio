library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity next_address_entity is
  port(
    rt : in std_logic_vector(31 downto 0);  -- rt register input
    rs : in std_logic_vector(31 downto 0);  -- rs register input
    pc : in std_logic_vector(31 downto 0);  -- current PC value
    target_address : in std_logic_vector(25 downto 0); -- Jump target address
    branch_type : in std_logic_vector(1 downto 0); -- branch type input
    pc_sel : in std_logic_vector(1 downto 0); --PC select input
    next_pc : out std_logic_vector(31 downto 0) --next PC output
   );
end next_address_entity;

architecture Behavioral of next_address_entity is
  signal branch_target_address : std_logic_vector(15 downto 0);
  signal branch_offset : std_logic_vector(31 downto 0);
  signal jump_address : std_logic_vector(31 downto 0);
  signal incremented_pc : std_logic_vector(31 downto 0);
  signal branch_taken : std_logic;
begin
  -- Increment current PC
  incremented_pc <= pc + "00000000000000000000000000000001";

  -- Prepare jump address by padding target address
  jump_address <= "000000" & target_address;
  branch_target_address <= target_address(15 downto 0);
  process(branch_target_address) 
  begin
  --sign extend the branch offset
    if branch_target_address(15) = '1' then
       branch_offset <= "1111111111111111" & branch_target_address(15 downto 0);
    else 
       branch_offset <= "0000000000000000" & branch_target_address(15 downto 0);
    end if;
  end process;
  --Branch condition checker 
  process(rs, rt, branch_type)
  begin
    case branch_type is
      when "01" => --beq
       if rs = rt then
           branch_taken <= '1';
       else
         branch_taken <= '0';
       end if;
      when "10" => --bne
       if rs /= rt then
           branch_taken <= '1';
       else
           branch_taken <= '0';
       end if;
      when "11" => --bltz
       if signed (rs)<0 then
           branch_taken <= '1';
       else
           branch_taken <= '0';
       end if;
      when others =>
       branch_taken <= '0'; -- no branch
    end case;
  end process;
  
  --Multiplexer to select the next pc based on pc_sel
  process(pc_sel, incremented_pc, jump_address, branch_offset, branch_taken)
  begin
    case pc_sel is
      when "00" => --No jump
       if branch_taken = '1' then
           next_pc <= incremented_pc + branch_offset;
       else
           next_pc <= incremented_pc;
       end if; 
      when "01" => --jump
        next_pc <= jump_address;
      when "10" => --jump register(using rs)
        next_pc <= rs;
      when others =>
        next_pc <=(others => '0');-- Default case
    end case;       
  end process;
end Behavioral;
