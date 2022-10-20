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
      haddr : in std_logic_vector (31 downto 0);        -- AHB transaction address
      hsize : in std_logic_vector (2 downto 0);         -- AHB size: byte, half-word or word
      htrans : in std_logic_vector (1 downto 0);        -- AHB transfer: non-sequential only
      hwdata : in std_logic_vector (31 downto 0);       -- AHB write-data
      hwrite : in std_logic;                            -- AHB write control
      hrdata : out std_logic_vector (31 downto 0);      -- AHB read-data
      hready : out std_logic);                          -- AHB stall signal
  end component;
    
  component CORTEXM0DS
    port(
      HCLK : in std_logic;
      HRESETn : in std_logic;
      
      HADDR	: out std_logic_vector(31 downto 0); 	      -- address bus (byte)
      HBURST	: out std_logic_vector(2 downto 0);       	-- burst type
      HMASTLOCK	: out std_logic;                        -- locked access
      HPROT	: out std_logic_vector(3 downto 0);        	-- protection control
      HSIZE	: out std_logic_vector(2 downto 0);        	-- transfer size
      HTRANS	: out std_logic_vector(1 downto 0);       	-- transfer type
      HWDATA	: out std_logic_vector(31 downto 0); 	     -- write data bus
      HWRITE	: out std_logic;                          	-- read/write
      HRDATA	: in std_logic_vector(31 downto 0); 	      -- read data bus
      HREADY	: in std_logic;                            -- transfer done
      HRESP	: in std_logic; 	                           -- response type
      
      NMI : in std_logic;
      IRQ : in std_logic_vector(15 downto 0);
      TXEV : out std_logic;
      RXEV : in std_logic;
      LOCKUP : out std_logic;
      SYSRESETREQ : out std_logic;
      SLEEPING : out std_logic);
  end component;
  
  signal haddr : std_logic_vector (31 downto 0);
  signal hsize :  std_logic_vector (2 downto 0);
  signal htrans : std_logic_vector (1 downto 0); 
  signal hwdata : std_logic_vector (31 downto 0);
  signal hwrite : std_logic;
  signal hrdata : std_logic_vector (31 downto 0);
  signal hready : std_logic;
  
  
  signal hclk : std_logic;
  signal hresetn : std_logic;
  signal hburst	: std_logic_vector(2 downto 0); 
  signal hmastlock	: std_logic;                
  signal hprot	: std_logic_vector(3 downto 0);     
  signal hresp	: std_logic; 	    
  signal nmi : std_logic;
  signal irq : std_logic_vector(15 downto 0);
  signal txev : std_logic;
  signal rxev : std_logic;
  signal lockup : std_logic;
  signal sysresetreq : std_logic;
  signal sleeping : std_logic;
  
  
begin
  
  cortexm0 : CORTEXM0DS
    port map(hclk,hresetn,haddr,hburst,hmastlock,hprot,hsize,htrans,hwdata,hwrite,hrdata,hready,hresp,nmi,irq,txev,rxev,lockup,sysresetreq,sleeping);
  
  ahblite_bridge : AHB_bridge
    port map(clkm,rstn,ahbmi,ahbmo,haddr,hsize,htrans,hwdata,hwrite,hrdata,hready);
  
end structural;