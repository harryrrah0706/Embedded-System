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
      clkm : in std_ulogic;
      rstn : in std_ulogic;
 -- AHB Master records --------------
      ahbmi : in ahb_mst_in_type;
      ahbmo : out ahb_mst_out_type;
 -- ARM Cortex-M0 AHB-Lite signals -- 
      haddr : in std_logic_vector (31 downto 0);        -- AHB transaction address
      hsize : in std_logic_vector (2 downto 0);         -- AHB size: byte, half-word or word
      htrans : in std_logic_vector (1 downto 0);        -- AHB transfer: non-sequential only
      hwdata : in std_logic_vector (31 downto 0);       -- AHB write-data
      hwrite : in std_ulogic;                            -- AHB write control
      hrdata : out std_logic_vector (31 downto 0);      -- AHB read-data
      hready : out std_ulogic);                          -- AHB stall signal
  end component;
    
  component CORTEXM0DS
    port(
      hclk : in std_ulogic;
      hresetn : in std_ulogic;
      
      haddr	: out std_logic_vector(31 downto 0); 	      -- address bus (byte)
      hburst	: out std_logic_vector(2 downto 0);       	-- burst type
      hmastlock	: out std_ulogic;                        -- locked access
      hprot	: out std_logic_vector(3 downto 0);        	-- protection control
      hsize	: out std_logic_vector(2 downto 0);        	-- transfer size
      htrans	: out std_logic_vector(1 downto 0);       	-- transfer type
      hwdata	: out std_logic_vector(31 downto 0); 	     -- write data bus
      hwrite	: out std_ulogic;                          	-- read/write
      hrdata	: in std_logic_vector(31 downto 0); 	      -- read data bus
      hready	: in std_ulogic;                            -- transfer done
      hresp	: in std_ulogic; 	                           -- response type
      nmi : in std_ulogic;
      irq : in std_logic_vector(15 downto 0);
      txev : out std_ulogic;
      rxev : in std_ulogic;
      lockup : out std_ulogic;
      sysresetreq : out std_ulogic;
      sleeping : out std_ulogic);
  end component;
  
  signal haddr : std_logic_vector (31 downto 0);
  signal hsize : std_logic_vector (2 downto 0);
  signal htrans : std_logic_vector (1 downto 0); 
  signal hwdata : std_logic_vector (31 downto 0);
  signal hwrite : std_ulogic;
  signal hrdata : std_logic_vector (31 downto 0);
  signal hready : std_ulogic;
  signal hclk : std_ulogic;
  signal hresetn : std_ulogic;
  
  signal hburst	: std_logic_vector(2 downto 0); 
  signal hmastlock	: std_ulogic;                
  signal hprot	: std_logic_vector(3 downto 0);     
  signal hresp	: std_ulogic; 	    
  signal nmi : std_ulogic;
  signal irq : std_logic_vector(15 downto 0);
  signal txev : std_ulogic;
  signal rxev : std_ulogic;
  signal lockup : std_ulogic;
  signal sysresetreq : std_ulogic;
  signal sleeping : std_ulogic;
  
begin

  cortexm0 : CORTEXM0DS
    port map(
      clkm,
      rstn,
      haddr,
      hburst,
      open,
      hprot,
      hsize,
      htrans,
      hwdata,
      hwrite,
      hrdata,
      hready,
      '0',
      '0',
      "0000000000000000",
      open,
      '0',
      open,
      open,
      open);
  
  ahblite_bridge : AHB_bridge
    port map(
      clkm,
      rstn,
      ahbmi,
      ahbmo,
      haddr,
      hsize,
      htrans,
      hwdata,
      hwrite,
      hrdata,
      hready);
  
  ahbmo.hburst <= hburst;
  ahbmo.hprot <= hprot;
  
  
end structural;