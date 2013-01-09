library verilog;
use verilog.vl_types.all;
entity SDR_REV_A is
    port(
        CLOCK_50        : in     vl_logic;
        LED             : out    vl_logic_vector(7 downto 0);
        KEY             : in     vl_logic_vector(1 downto 0);
        SW              : in     vl_logic_vector(3 downto 0);
        EPCS_ASDO       : out    vl_logic;
        EPCS_DATA0      : in     vl_logic;
        EPCS_DCLK       : out    vl_logic;
        EPCS_NCSO       : out    vl_logic;
        GPIO_2          : inout  vl_logic_vector(12 downto 0);
        GPIO_2_IN       : in     vl_logic_vector(2 downto 0);
        A               : inout  vl_logic_vector(33 downto 0);
        A_IN            : in     vl_logic_vector(1 downto 0);
        B               : inout  vl_logic_vector(33 downto 0);
        B_IN            : in     vl_logic_vector(1 downto 0)
    );
end SDR_REV_A;
