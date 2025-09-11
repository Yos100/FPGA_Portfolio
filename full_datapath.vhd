library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.all;

entity datapath is
    port (
        clk, reset         : in std_logic;
        -- Control signals
        add_sub            : in std_logic;
        logic_func         : in std_logic_vector(1 downto 0);
        alu_func           : in std_logic_vector(1 downto 0);
        reg_write_enable   : in std_logic;
        mem_write_enable   : in std_logic;
        pc_sel             : in std_logic_vector(1 downto 0);
        branch_type        : in std_logic_vector(1 downto 0);
        sign_ext_ctrl      : in std_logic_vector(1 downto 0);
        reg_dst            : in std_logic;
        
        -- Outputs
        rs_out        : out std_logic_vector(31 downto 0);
        rt_out        : out std_logic_vector(31 downto 0);
        pc_out        : out std_logic_vector(31 downto 0);
        alu_zero_flag : out std_logic;
        alu_overflow_flag : out std_logic;
        instruction   : out std_logic_vector(31 downto 0);
        d_cache_out   : out std_logic_vector(31 downto 0)
    );
end datapath;

architecture Behavioral of datapath is
    -- Internal signals
    signal pc_out_signal, next_pc       : std_logic_vector(31 downto 0) := (others => '0');
    signal alu_out                      : std_logic_vector(31 downto 0) := (others => '0');
    signal rs_data, rt_data             : std_logic_vector(31 downto 0) := (others => '0');
    signal sign_ext_out                 : std_logic_vector(31 downto 0) := (others => '0');
    signal d_cache_data_in              : std_logic_vector(31 downto 0) := (others => '0');
    signal d_cache_data_out             : std_logic_vector(31 downto 0) := (others => '0');
    signal instruction_internal         : std_logic_vector(31 downto 0) := (others => '0');

begin
    -- Program Counter (PC) Register
    pc_reg: process(clk, reset)
    begin
        if reset = '1' then
            pc_out_signal <= (others => '0');
        elsif rising_edge(clk) then
            pc_out_signal <= next_pc;
        end if;
    end process;

    -- Drive pc_out from the internal signal
    pc_out <= pc_out_signal;

    -- Instruction Cache
    i_cache_inst: entity work.I_Cache
        port map (
            address => pc_out_signal(4 downto 0),
            data_out => instruction_internal
        );

    -- Connect instruction to output
    instruction <= instruction_internal;


    -- Register File
    regfile_inst: entity work.regfile
        port map (
            din => d_cache_data_in,
            reset => reset,
            clk => clk,
            write => reg_write_enable,
            read_a => instruction_internal(25 downto 21),
            read_b => instruction_internal(20 downto 16),
            write_address => instruction_internal(15 downto 11),
            out_a => rs_data,
            out_b => rt_data
        );
   

    -- Connect register outputs to datapath outputs
    rs_out <= instruction_internal;
    rt_out <= instruction_internal;
    


    -- Sign Extension Unit
    sign_ext_inst: entity work.sign_extend
        port map (
            immediate_in => instruction_internal(15 downto 0),
            func => sign_ext_ctrl,
            extended_out => sign_ext_out
        );

    -- ALU
    alu_inst: entity work.alu
        port map (
            x => rs_data,
            y => sign_ext_out,
            add_sub => add_sub,
            logic_func => logic_func,
            func => alu_func,
            output => alu_out,
            overflow => alu_overflow_flag,
            zero => alu_zero_flag
        );
   
    -- Data Cache
    d_cache_inst: entity work.Data_cache
        port map (
            clk => clk,
            reset => reset,
            address => alu_out(4 downto 0),
            d_in => rt_data,
            d_out => d_cache_data_out,
            data_write => mem_write_enable
        );

    -- Assign data cache output to datapath output
    d_cache_out <= d_cache_data_out;

    -- Next Address Unit
    next_addr_inst: entity work.next_address_entity
        port map (
            rt => rt_data,
            rs => rs_data,
            pc => pc_out_signal,
            target_address => instruction_internal(25 downto 0),
            branch_type => branch_type,
            pc_sel => pc_sel,
            next_pc => next_pc
        );

end Behavioral;

