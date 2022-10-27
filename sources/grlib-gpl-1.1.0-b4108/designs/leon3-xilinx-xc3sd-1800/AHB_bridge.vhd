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



entity AHB_bridge is
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
    hready : out std_ulogic
  );
end;



architecture structural of AHB_bridge is
  
-- Declare a component for state_machine
  component state_machine
    port(
      hwdata	 : in std_logic_vector(AHBDW-1 downto 0); 	-- write data bus
      hready	 : out std_ulogic;                         -- transfer done
      htrans	 : in std_logic_vector(1 downto 0); 	      -- transfer type
      haddr	  : in std_logic_vector(31 downto 0); 	      -- address bus (byte)
      hwrite	 : in std_ulogic;                         	-- read/write
      hsize	  : in std_logic_vector(2 downto 0);         -- transfer size
      dmai    : out ahb_dma_in_type;
      dmao    : in ahb_dma_out_type;
      clkm    : in std_ulogic;
      rstn    : in std_ulogic
    );
  end component;
    
-- Declare a component for ahbmst
  component ahbmst
    generic (
      hindex  : integer := 0;
      hirq    : integer := 0;
      venid   : integer := VENDOR_GAISLER;
      devid   : integer := 0;
      version : integer := 0;
      chprot  : integer := 3;
      incaddr : integer := 0
    ); 
    port (
      rst     : in  std_ulogic;
      clk     : in  std_ulogic;
      dmai    : in ahb_dma_in_type;
      dmao    : out ahb_dma_out_type;
      ahbi    : in  ahb_mst_in_type;
      ahbo    : out ahb_mst_out_type
    );
  end component;
      
-- Declare a component for data_swapper
  component data_swapper
    port(
      dmao    : in ahb_dma_out_type;
      hrdata  : out std_logic_vector(AHBDW-1 downto 0)
    );
  end component;

-- Create signals for the architecture
  signal dmai : ahb_dma_in_type;
  signal dmao : ahb_dma_out_type;

begin
  
-- Instantiate state_machine component and make the connections
  state_machine_1 : state_machine
    port map(hwdata,hready,htrans,haddr,hwrite,hsize,dmai,dmao,clkm,rstn);
      
-- Instantiate the ahbmst component and make the connections
  ahbmst_1 : ahbmst
    generic map(0,0,VENDOR_GAISLER,0,0,3,0)
    port map(rstn,clkm,dmai,dmao,ahbmi,ahbmo);
      
-- Instantiate the data_swapper component and make the connections
  data_swapper_1 : data_swapper
    port map(dmao,hrdata);
  
end structural;