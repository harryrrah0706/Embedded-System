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
    clkm : in std_ulogic;
    rstn : in std_ulogic
  );
end entity;

architecture structural of state_machine is
  
  type state_type is (IDLE,FETCH);
  
  signal current_state : state_type;
  signal next_state : state_type;
  
begin
  
  state_transition : process(htrans,dmao.ready)
  begin
    
    case current_state is
      
      when IDLE =>
        
        hready <= '1';
        if htrans = "10" then
          next_state <= FETCH;
        else
          next_state <= IDLE;
        end if;
       
      when FETCH =>
        
        hready <= '0';
        if dmao.ready = '1' then
          hready <= '1';
          next_state <= IDLE;
        else
          next_state <= FETCH;
        end if;
          
    end case;
    
  end process;
  
  state_register : process (clkm, rstn)	
  begin
    
	  if rising_edge(clkm) then
--	   if rstn = '1' then
--	     current_state <= IDLE;
--		 else
			 current_state <= next_state;
--		 end if;	
	  end if;
	  
	end process;
	
	state_conditions : process (current_state,htrans,dmao.ready)
	begin
	  
	  if current_state = IDLE then
--	    hready <= '1';
	    dmai.start <= '0';
	  end if;
	  
	  if current_state = IDLE and htrans = "10" then
	    dmai.start <= '1';
	    dmai.address <= haddr;
	    dmai.wdata <= hwdata;
	    dmai.write <= hwrite;
	    dmai.size <= hsize;
	  end if;
	  
	  if current_state = FETCH then
--	    hready <= '0';
	    dmai.start <= '0';
	  end if;
	  
--	  if current_state = FETCH and dmao.ready = '1' then
--	    hready <= '1';
--	  end if;
	  
	end process;
	
end structural;