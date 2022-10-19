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
    clkm : in std_logic;
    rstn : in std_logic;
 -- AHB Master records --------------
    ahbmi : in ahb_mst_in_type;
    ahbmo : out ahb_mst_out_type);

end;



architecture structural of cm0_wrapper is
  
  component AHB_bridge
    port(
 -- Clock and Reset -----------------
      clkm : in std_logic;
      rstn : in std_logic;
 -- AHB Master records --------------
      ahbmi : in ahb_mst_in_type;
      ahbmo : out ahb_mst_out_type;
 -- ARM Cortex-M0 AHB-Lite signals -- 
      HADDR : in std_logic_vector (31 downto 0);        -- AHB transaction address
      HSIZE : in std_logic_vector (2 downto 0);         -- AHB size: byte, half-word or word
      HTRANS : in std_logic_vector (1 downto 0);        -- AHB transfer: non-sequential only
      HWDATA : in std_logic_vector (31 downto 0);       -- AHB write-data
      HWRITE : in std_logic;                            -- AHB write control
      HRDATA : out std_logic_vector (31 downto 0);      -- AHB read-data
      HREADY : out std_logic);                          -- AHB stall signal
  end component;
    
  component CORTEXM0DS
    port(
      haddr	: out std_logic_vector(31 downto 0); 	      -- address bus (byte)
      hburst	: out std_logic_vector(2 downto 0);       	-- burst type
      hmastlock	: out std_ulogic;                       -- locked access
      hprot	: out std_logic_vector(3 downto 0);        	-- protection control
      hsize	: out std_logic_vector(2 downto 0);        	-- transfer size
      htrans	: out std_logic_vector(1 downto 0);       	-- transfer type
      hwdata	: out std_logic_vector(AHBDW-1 downto 0); 	-- write data bus
      hwrite	: out std_ulogic;                         	-- read/write
      hrdata	: in std_logic_vector(AHBDW-1 downto 0); 	 -- read data bus
      hready	: in std_ulogic;                           -- transfer done
      hresp	: in std_logic_vector(1 downto 0); 	        -- response type
      nmi : in std_ulogic;
      irq : in std_logic_vector(15 downto 0);
      txev : out std_ulogic;
      rxev : in std_ulogic;
      lockup : out std_ulogic;
      sysresetreq : out std_ulogic;
      sleeping : out std_ulogic);
  end component;
  
begin
  
end structural;