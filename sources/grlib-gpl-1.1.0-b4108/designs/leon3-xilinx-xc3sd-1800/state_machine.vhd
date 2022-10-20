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

entity state_machine is
  port(
    hwdata	: in std_logic_vector(AHBDW-1 downto 0); 	-- write data bus
    hready	: out std_ulogic;                         -- transfer done
    htrans	: in std_logic_vector(1 downto 0); 	      -- transfer type
    haddr	: in std_logic_vector(31 downto 0); 	      -- address bus (byte)
    hwrite	: in std_ulogic;                         	-- read/write
    hsize	: in std_logic_vector(2 downto 0);         -- transfer size
    dmai : out ahb_dma_in_type;
    dmao : in ahb_dma_out_type;
    clkm : in std_logic;
    rstn : in std_logic
  );
end entity;

architecture structural of state_machine is
  
begin
  
end structural;