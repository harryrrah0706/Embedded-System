library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
library gaisler;
use gaisler.misc.all;
library UNISIM;
use UNISIM.VComponents.all;



entity cm0_wrapper is
  port(
 -- Clock and Reset -----------------
    clkm   : in std_logic;
    rstn   : in std_logic;
 -- AHB Master records --------------
    ahbmi   : in ahb_mst_in_type;
    ahbmo   : out ahb_mst_out_type;
 -- LED signal ----------------------
    cm0_led : out std_ulogic);
end;



architecture structural of cm0_wrapper is
  
-- Declare a component for the bridge
  component AHB_bridge
    port(
 -- Clock and Reset -----------------
      clkm   : in std_ulogic;
      rstn   : in std_ulogic;
 -- AHB Master records --------------
      ahbmi  : in ahb_mst_in_type;
      ahbmo  : out ahb_mst_out_type;
 -- ARM Cortex-M0 AHB-Lite signals -- 
      haddr  : in std_logic_vector (31 downto 0);
      hsize  : in std_logic_vector (2 downto 0);
      htrans : in std_logic_vector (1 downto 0);
      hwdata : in std_logic_vector (31 downto 0);
      hwrite : in std_ulogic;
      hrdata : out std_logic_vector (31 downto 0);
      hready : out std_ulogic);
  end component;

-- Declare a component for CortexM0
  component CORTEXM0DS
    port(
      hclk        : in std_ulogic;
      hresetn     : in std_ulogic;
      haddr	      : out std_logic_vector(31 downto 0);
      hburst	     : out std_logic_vector(2 downto 0);
      hmastlock	  : out std_ulogic;
      hprot	      : out std_logic_vector(3 downto 0);
      hsize	      : out std_logic_vector(2 downto 0);
      htrans	     : out std_logic_vector(1 downto 0);
      hwdata	     : out std_logic_vector(31 downto 0);
      hwrite	     : out std_ulogic;
      hrdata	     : in std_logic_vector(31 downto 0);
      hready	     : in std_ulogic;
      hresp	      : in std_ulogic;
      nmi         : in std_ulogic;
      irq         : in std_logic_vector(15 downto 0);
      txev        : out std_ulogic;
      rxev        : in std_ulogic;
      lockup      : out std_ulogic;
      sysresetreq : out std_ulogic;
      sleeping    : out std_ulogic);
  end component;
  
  signal haddr  : std_logic_vector (31 downto 0);
  signal hsize  : std_logic_vector (2 downto 0);
  signal htrans : std_logic_vector (1 downto 0); 
  signal hwdata : std_logic_vector (31 downto 0);
  signal hwrite : std_ulogic;
  signal hrdata : std_logic_vector (31 downto 0);
  signal hready : std_ulogic;
  
begin

-- Instantiate the CortexM0 component and make the connections
  cortexm0 : CORTEXM0DS
    port map(clkm,rstn,haddr,open,open,open,hsize,htrans,hwdata,hwrite,hrdata,hready,
      '0','0',"0000000000000000",open,'0',open,open,open);

-- Instantiate the bridge component and make the connections
  ahblite_bridge : AHB_bridge
    port map(clkm,rstn,ahbmi,ahbmo,haddr,hsize,htrans,hwdata,hwrite,hrdata,hready);

-- Set a cm0_led connected to testbench to blink when group number 13 is detected
  detection : process (clkm)
  begin
    if falling_edge(clkm) then
      if hrdata(31 downto 0) = "00001101000011010000110100001101" then
        cm0_led <= '1';
      else
        cm0_led <= '0';
      end if;
    end if;
  end process;
  
end structural;