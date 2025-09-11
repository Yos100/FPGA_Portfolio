library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity control_unit is
    port (
        --opcode    : in  std_logic_vector(5 downto 0); -- 6-bit opcode
        --func      : in  std_logic_vector(5 downto 0); -- 6-bit function code
        reg_write : out std_logic;  -- control signal
        reg_dst   : out std_logic;  -- control signal
        reg_in_src: out std_logic;  -- control signal
        alu_src   : out std_logic;  -- control signal
        add_sub   : out std_logic;  -- control signal
        data_write: out std_logic;  -- control signal
        logic_func: out std_logic_vector(1 downto 0); -- 2-bit control signal
        branch_type: out std_logic_vector(1 downto 0); -- 2-bit control signal
        pc_sel    : out std_logic_vector(1 downto 0) -- 2-bit control signal
    );
end control_unit;

architecture behavioral of control_unit is
    signal opcode : std_logic_vector(5 downto 0);
    signal func   : std_logic_vector(5 downto 0);
    signal instruction_internal         : std_logic_vector(31 downto 0) := (others => '0');
    signal pc_out_signal : std_logic_vector(31 downto 0) := (others => '0');
begin
    i_cache_inst: entity work.I_Cache
        port map (
            address => pc_out_signal(4 downto 0),
            data_out => instruction_internal
        );


    process(opcode, func)
    begin
        -- Default values (reset)
        reg_write <= '0';
        reg_dst   <= '0';
        reg_in_src<= '0';
        alu_src   <= '0';
        add_sub   <= '0';
        data_write<= '0';
        logic_func<= "00";
        branch_type<= "00";
        pc_sel    <= "00";
        
        -- Control Logic based on opcode and func
        case opcode is
            -- R-type instructions
            when "000000" =>  -- R-type instructions (e.g., add, sub, slt, jr)
                reg_write <= '1';
                reg_dst   <= '1';
                reg_in_src<= '0';
                alu_src   <= '0';
                add_sub   <= '0'; -- Default to Add
                data_write<= '0';
                logic_func<= "00"; -- Default to Add
                branch_type<= "00";
                pc_sel    <= "00"; -- No jump by default

                -- Now check the func field to differentiate between R-type operations and `jr`
                case func is
                    when "100000" => logic_func <= "00"; -- add
                    when "100010" => logic_func <= "01"; -- sub
                    when "101010" => logic_func <= "10"; -- slt
                    when "001000" => -- jr (special case for jump)
                        reg_write <= '0';
                        reg_dst   <= '0';
                        reg_in_src<= '0';
                        alu_src   <= '0';
                        add_sub   <= '0';
                        data_write<= '0';
                        logic_func<= "00";
                        branch_type<= "00";
                        pc_sel    <= "10"; -- Jump to address in `rs`
                    when others => logic_func <= "00"; -- default to add
                end case;

            -- I-type instructions (e.g., addi, andi, ori, lw, sw)
            when "001000" =>  -- addi
                reg_write <= '1';
                reg_dst   <= '0';
                reg_in_src<= '1'; -- ALU output
                alu_src   <= '1'; -- Sign extended immediate
                add_sub   <= '0'; -- Add
                data_write<= '0';
                logic_func<= "00"; -- ALU addition
                branch_type<= "00";
                pc_sel <= "00"; -- No jump

            when "001100" =>  -- andi
                reg_write <= '1';
                reg_dst   <= '0';
                reg_in_src<= '1'; -- ALU output
                alu_src   <= '1'; -- Sign extended immediate
                add_sub   <= '0'; -- Add
                data_write<= '0';
                logic_func<= "00"; -- ALU AND
                branch_type<= "00";
                pc_sel <= "00"; -- No jump

            when "100011" =>  -- lw
                reg_write <= '1';
                reg_dst   <= '0';
                reg_in_src<= '1'; -- Data memory output
                alu_src   <= '1'; -- Address calculation
                add_sub   <= '0'; -- Add
                data_write<= '0';
                logic_func<= "00"; -- ALU addition
                branch_type<= "00";
                pc_sel <= "00"; -- No jump

            when "101011" =>  -- sw
                reg_write <= '0'; -- No register write
                reg_dst   <= '0'; -- Not needed
                reg_in_src<= '0'; -- Not needed
                alu_src   <= '1'; -- Address calculation
                add_sub   <= '0'; -- Add
                data_write<= '1'; -- Write data to memory
                logic_func<= "00"; -- ALU addition
                branch_type<= "00";
                pc_sel <= "00"; -- No jump

            -- J-type instructions (e.g., j)
            when "000010" =>  -- j
                reg_write <= '0';
                reg_dst   <= '0';
                reg_in_src<= '0';
                alu_src   <= '0';
                add_sub   <= '0';
                data_write<= '0';
                logic_func<= "00";
                branch_type<= "00";
                pc_sel <= "01"; -- Jump to target address

            -- Branch instructions (beq, bne)
            when "000100" =>  -- beq
                reg_write <= '0';
                reg_dst   <= '0';
                reg_in_src<= '0';
                alu_src   <= '0';
                add_sub   <= '1'; -- Subtraction for comparison
                data_write<= '0';
                logic_func<= "00";
                branch_type<= "01"; -- Branch equal
                pc_sel <= "00"; -- Conditional branch

            when "000101" =>  -- bne
                reg_write <= '0';
                reg_dst   <= '0';
                reg_in_src<= '0';
                alu_src   <= '0';
                add_sub   <= '1'; -- Subtraction for comparison
                data_write<= '0';
                logic_func<= "00";
                branch_type<= "10"; -- Branch not equal
                pc_sel <= "00"; -- Conditional branch

            when others =>
                -- Default values in case of an unknown opcode
                reg_write <= '0';
                reg_dst   <= '0';
                reg_in_src<= '0';
                alu_src   <= '0';
                add_sub   <= '0';
                data_write<= '0';
                logic_func<= "00";
                branch_type<= "00";
                pc_sel <= "00";
        end case;
    end process;
    opcode <= instruction_internal(31 downto 26);  -- 6-bit opcode
    func   <= instruction_internal(5 downto 0);    -- 6-bit function code
end behavioral;
