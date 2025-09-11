library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;

-- CPU entity definition
entity cpu is
    port (
        reset    : in std_logic;  -- Asynchronous reset input
        clk      : in std_logic;  -- Clock input
        rs_out   : out std_logic_vector(3 downto 0);  -- rs output from register file
        rt_out   : out std_logic_vector(3 downto 0);  -- rt output from register file
        pc_out   : out std_logic_vector(3 downto 0);  -- Program counter output
        overflow : out std_logic;  -- Overflow flag
        zero     : out std_logic   -- Zero flag
    );
end cpu;

architecture behavioral of cpu is



    -- Signals for connecting datapath and control unit
    signal opcode        : std_logic_vector(5 downto 0);  -- 6-bit opcode from instruction
    signal func          : std_logic_vector(5 downto 0);  -- 6-bit function field from instruction
    signal reg_write     : std_logic;
    signal reg_dst       : std_logic;
    signal reg_in_src    : std_logic;
    signal alu_src       : std_logic;
    signal add_sub       : std_logic;
    signal data_write    : std_logic;
    signal logic_func    : std_logic_vector(1 downto 0);
    signal branch_type   : std_logic_vector(1 downto 0);
    signal pc_sel        : std_logic_vector(1 downto 0);
    signal sign_ext_ctrl : std_logic_vector(1 downto 0);
    signal alu_func      : std_logic_vector(1 downto 0);

    -- Internal signals for outputs from datapath
    signal rs_data_internal       : std_logic_vector(31 downto 0);  -- Correct internal signal for rs data
    signal rt_data_internal       : std_logic_vector(31 downto 0);  -- Correct internal signal for rt data
    signal pc_out_internal : std_logic_vector(31 downto 0);
    signal alu_zero_flag : std_logic;
    signal alu_overflow_flag : std_logic;
    signal instruction_internal : std_logic_vector(31 downto 0);
    signal d_cache_out   : std_logic_vector(31 downto 0);
   

    -- Components (Control Unit and Datapath)
    component control_unit is
        port (
            reg_write     : out std_logic;
            reg_dst       : out std_logic;
            reg_in_src    : out std_logic;
            alu_src       : out std_logic;
            add_sub       : out std_logic;
            data_write    : out std_logic;
            logic_func    : out std_logic_vector(1 downto 0);
            branch_type   : out std_logic_vector(1 downto 0);
            pc_sel        : out std_logic_vector(1 downto 0)
        );
    end component;
    
    component datapath is
        port (
            clk           : in std_logic;
            reset         : in std_logic;
            reg_write_enable : in std_logic;
            mem_write_enable : in std_logic;
            add_sub       : in std_logic;
            logic_func    : in std_logic_vector(1 downto 0);
            alu_func      : in std_logic_vector(1 downto 0);
            reg_dst       : in std_logic;
            sign_ext_ctrl : in std_logic_vector(1 downto 0);
            pc_sel        : in std_logic_vector(1 downto 0);
            branch_type   : in std_logic_vector(1 downto 0);
            rs_out        : out std_logic_vector(31 downto 0);  -- rs data output
            rt_out        : out std_logic_vector(31 downto 0);  -- rt data output
            pc_out        : out std_logic_vector(31 downto 0);
            alu_zero_flag : out std_logic;
            alu_overflow_flag : out std_logic;
            instruction   : out std_logic_vector(31 downto 0);
            d_cache_out   : out std_logic_vector(31 downto 0)
        );
    end component;

begin

    -- Instantiate the control unit
    u_control_unit: control_unit
        port map (
            reg_write     => reg_write,
            reg_dst       => reg_dst,
            reg_in_src    => reg_in_src,
            alu_src       => alu_src,
            add_sub       => add_sub,
            data_write    => data_write,
            logic_func    => logic_func,
            branch_type   => branch_type,
            pc_sel        => pc_sel
        );

    -- Instantiate the datapath
    u_datapath: datapath
        port map (
            clk           => clk,
            reset         => reset,
            reg_write_enable => reg_write,
            mem_write_enable => data_write,
            add_sub       => add_sub,
            logic_func    => logic_func,
            alu_func      => alu_func,
            reg_dst       => reg_dst,
            sign_ext_ctrl => sign_ext_ctrl,
            pc_sel        => pc_sel,
            branch_type   => branch_type,
            rs_out        => rs_data_internal,  -- Connect rs_out to rs_data signal
            rt_out        => rt_data_internal,  -- Connect rt_out to rt_data signal
            pc_out        => pc_out_internal,
            alu_zero_flag => alu_zero_flag,
            alu_overflow_flag => alu_overflow_flag,
            instruction   => instruction_internal,
            d_cache_out   => d_cache_out
        );

    -- Connecting outputs from datapath to the top-level CPU
    rs_out <= rs_data_internal(24 downto 21);  -- Extract the lower 4 bits of the rs data
    --process (rs_data_internal(3 downto 0), instruction_internal (3 downto 0))
    --begin
     --rt_data_internal <= rs_data_internal + instruction_internal;  -- Extract the lower 4 bits of the rt data
    --end process;
    --rt_out <= rt_data_internal(3 downto 0)
    --pc_out <= pc_out_internal(3 downto 0);  -- Extract the lower 4 bits of the pc out
    --overflow <= alu_overflow_flag;
    --zero <= alu_zero_flag;
  -- Connecting outputs from datapath to the top-level CPU
    --rs_out <= rs_data_internal(3 downto 0);  -- Extract the lower 4 bits of the rs data

    -- Use numeric_std for arithmetic operations


    rt_out <= rt_data_internal(3 downto 0);  -- Extract the lower 4 bits of the rt data
    pc_out <= pc_out_internal(3 downto 0);  -- Extract the lower 4 bits of the pc out
    overflow <= alu_overflow_flag;
    zero <= alu_zero_flag;

end behavioral;

