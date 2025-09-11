Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

entity alu is
    port (
         x,y          : in std_logic_vector(31 downto 0); --Two input operands
         add_sub      : in std_logic;  -- 0 = add, 1 = sub
         logic_func   : in std_logic_vector(1 downto 0); -- 00 = AND, 01 = OR, 10 = XOR, 11 = NOR
         func         : in std_logic_vector(1 downto 0); -- 00 = LUI, 01 = SLT, 10 = Arithmetic, 11 = Logic
         output       : out std_logic_vector(31 downto 0); -- Output
         overflow     : out std_logic;                    -- overflow flag
         zero         : out std_logic                    -- Zero flag

     );
end alu;
architecture Behavioral of alu is
    signal adder_subtract_result : std_logic_vector(31 downto 0);
    signal logic_result          : std_logic_vector(31 downto 0);
    signal slt_result            : std_logic_vector(31 downto 0);
    signal carry_out             : std_logic;
begin
   -- Adder/Subtractor Logic 
   process(x, y, add_sub)
   begin
      if add_sub = '0' then
          adder_subtract_result <= x + y; --Addition
      else
          adder_subtract_result <= x - y; -- Subtraction
      end if;
   end process;

   -- Logic Unit
   process(x, y, logic_func)
   begin
       case logic_func is
           when "00" => logic_result <= x and y; --AND
           when "01" => logic_result <= x or y; -- OR
           when "10" => logic_result <= x xor y; --XOR
           when "11" => logic_result <= not (x or y); --NOR
           when others => logic_result <= (others => '0');
       end case;
   end process;

   --Set Less Than (SLT) Logic
   process (adder_subtract_result)
   begin
       if adder_subtract_result(31) = '1' then
           slt_result <= (others => '0');
           slt_result (0) <= '1'; -- Set to 1 if x < y
       else
           slt_result <= (others => '0');
       end if;
   end process;

   -- Multiplexer to select the output based on func
   process(func, y , adder_subtract_result, slt_result, logic_result)
   begin
       case func is
           when "00" => output(31 downto 0) <= y(31 downto 0); -- LUI                       
           when "01" => output <= slt_result; --Set Less Than
           when "10" => output <= adder_subtract_result; -- Arithmetic
           when "11" => output <= logic_result; -- Logical
           when others => output <= (others => '0');
       end case;
   end process;

   -- Overflow Detection
   --process(x, y, adder_subtract_result, add_sub)
       --variable pos_overflow : std_logic;
      -- variable neg_overflow : std_logic;
     --  variable sub_overflow : std_logic;
   --begin
       --if add_sub = '0' then
           --pos_overflow <= ((x(31) = '0') and (y(31) = '0') and (adder_subtract_result(31) = '1')); --positive overflow
           --neg_overflow <= (x(31) = '1' and y(31) = '1' and adder_subtract_result(31) = '0'); --Negative overflow
           --overflow <= pos_overflow or neg_overflow; --combine
       
      -- else
           --sub_overflow <= (x(31) /= y(31)) and (x(31) /= adder_subtract_result(31));
           --overflow <= sub_overflow;
       --end if;
   --end process;
     -- Overflow Detection
   process(x, y, adder_subtract_result, add_sub)
   begin
       if add_sub = '0' then  -- Addition
        -- Check for positive and negative overflow
            if (x(31) = '0' and y(31) = '0' and adder_subtract_result(31) = '1') or
               (x(31) = '1' and y(31) = '1' and adder_subtract_result(31) = '0') then
                overflow <= '1'; -- Overflow occurred
            else
                overflow <= '0'; -- No overflow
            end if;
       else  -- Subtraction
        -- Check for overflow in subtraction
             if (x(31) /= y(31)) then
                 overflow <= '1'; -- Overflow occurred
             else
                 overflow <= '0'; -- No overflow
             end if;
       end if;
   end process;


   -- Zero Flag
   process(adder_subtract_result, slt_result, logic_result)
   begin
       if adder_subtract_result = x"00000000000000000000000000000000" then
           zero <= '1';
       else
           zero <= '0';
       end if;
   end process;

end Behavioral;
