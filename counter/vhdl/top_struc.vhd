-------------------------------------------------------------------------------
--                                                                      
--                        Counter Project Base
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         top
--
-- FILENAME:       top_struc.vhd
-- 
-- ARCHITECTURE:   structural
-- 
-- ENGINEER:       Andreas Puhm
--
-- DATE:           2018-09-06
--
-- VERSION:        1.0
--
-------------------------------------------------------------------------------
--                                                                      
-- DESCRIPTION:    This describes the architecture of the top-level
--                 of the counter VHDL class example.
--
--
-------------------------------------------------------------------------------
--
-- REFERENCES:     (none)
--
-------------------------------------------------------------------------------
--                                                                      
-- PACKAGES:       std_logic_1164 (IEEE library)
--
-------------------------------------------------------------------------------
--                                                                      
-- CHANGES:
--                 1.0 - initial version
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
library work;
use work.basys3_util_pkg.all;
use work.counter_util_pkg.all;
use work.counter_comp_pkg.all;

architecture struc of top is
---------------------------------------------------------
  -- define signals for sub unit interconnect
  signal s_cntr_1     : std_logic_vector(3 downto 0);
  signal s_cntr_10    : std_logic_vector(3 downto 0);
  signal s_cntr_100   : std_logic_vector(3 downto 0);
  signal s_cntr_1000  : std_logic_vector(3 downto 0);
  signal s_cntr_hold  : std_logic;
  signal s_cntr_reset : std_logic;
  signal s_cntr_up    : std_logic;
  signal s_cntr_down  : std_logic;
  signal s_cntr_mode  : std_logic_vector(2 downto 0);
  signal s_cntr_speed : std_logic_vector(3 downto 0);
---------------------------------------------------------
  signal tmpsw_i       : std_logic_vector(15 downto 0) := (OTHERS => '0');
  signal tmpbtnu_i     : std_logic;
  signal tmpbtnd_i     : std_logic;
  signal tmpbtnl_i     : std_logic;
  signal tmpbtnr_i     : std_logic;
  
  signal sw_o       : std_logic_vector(15 downto 0);
  signal btnu_o     : std_logic;
  signal btnd_o     : std_logic;
  signal btnl_o     : std_logic;
  signal btnr_o     : std_logic;
  
  signal sw_db       : std_logic_vector(15 downto 0);
  signal btnu_db     : std_logic;
  signal btnd_db     : std_logic;
  signal btnl_db     : std_logic;
  signal btnr_db     : std_logic;
  
  signal counterPrescale : std_logic_vector(counter_size DOWNTO 0) := (OTHERS => '0'); --counter output
  
---------------------------------------------------------
begin
---------------------------------------------------------
  i_io_ctrl : component io_ctrl
    generic map(
      G_CNT_UP_BUTTON_ID      => G_CNT_UP_BUTTON_ID,
      G_CNT_DOWN_BUTTON_ID    => G_CNT_DOWN_BUTTON_ID,
      G_CNT_HOLD_BUTTON_ID    => G_CNT_HOLD_BUTTON_ID,
      G_CNT_RESET_BUTTON_ID   => G_CNT_RESET_BUTTON_ID,
      G_CNT_MODE_BIT_0_SW_ID  => G_CNT_MODE_BIT_0_SW_ID,
      G_CNT_MODE_BIT_1_SW_ID  => G_CNT_MODE_BIT_1_SW_ID,
      G_CNT_SPEED_BIT_0_SW_ID => G_CNT_SPEED_BIT_0_SW_ID,
      G_CNT_SPEED_BIT_1_SW_ID => G_CNT_SPEED_BIT_1_SW_ID,
      G_CNT_SPEED_DIV_SIM     => G_CNT_SPEED_DIV_SIM
      )
    port map (
      clk_i        => clk_i,
      reset_i      => reset_i,
      sw_i         => sw_i,
      btnu_i       => btnu_i,
      btnd_i       => btnd_i,
      btnl_i       => btnl_i,
      btnr_i       => btnr_i,
      ss_o         => ss_o,
      ss_anode_o   => ss_anode_o,
      cntr_1_i     => s_cntr_1,
      cntr_10_i    => s_cntr_10,
      cntr_100_i   => s_cntr_100,
      cntr_1000_i  => s_cntr_1000,
      cntr_hold_o  => s_cntr_hold,
      cntr_reset_o => s_cntr_reset,
      cntr_up_o    => s_cntr_up,
      cntr_down_o  => s_cntr_down,
      cntr_mode_o  => s_cntr_mode,
      cntr_speed_o => s_cntr_speed);
---------------------------------------------------------
  i_counter : component counter
    generic map(
      G_CNT_SPEED_DIV_SIM => G_CNT_SPEED_DIV_SIM
      )
    port map (
      clk_i        => clk_i,
      reset_i      => reset_i,
      cntr_1_o     => s_cntr_1,
      cntr_10_o    => s_cntr_10,
      cntr_100_o   => s_cntr_100,
      cntr_1000_o  => s_cntr_1000,
      cntr_hold_i  => s_cntr_hold,
      cntr_reset_i => s_cntr_reset,
      cntr_up_i    => s_cntr_up,
      cntr_down_i  => s_cntr_down,
      cntr_mode_i  => s_cntr_mode,
      cntr_speed_i => s_cntr_speed);
---------------------------------------------------------    
--First synchronizer
    p_ff1 : process (clk_i, reset_i)
	begin
		if reset_i = '1' then
            tmpsw_i <= (others => '0');
            tmpbtnu_i <= '0';
            tmpbtnd_i <= '0';
            tmpbtnl_i <= '0';
            tmpbtnr_i <= '0';
		elsif (clk_i'event and clk_i = 	'1') then
            tmpsw_i <= sw_i;
            tmpbtnu_i <= btnu_i;
            tmpbtnd_i <= btnd_i;
            tmpbtnl_i <= btnl_i;
            tmpbtnr_i <= btnr_i;
		end if;
	end process p_ff1;
    
---------------------------------------------------------    
--Second Synchronizer
    p_ff2 : process (clk_i, reset_i)
	begin
		if reset_i = '1' then
            sw_o <= (others => '0');
            btnu_o <= '0';
            btnd_o <= '0';
            btnl_o <= '0';
            btnr_o <= '0';
		elsif (clk_i'event and clk_i = 	'1') then
            sw_o <= tmpsw_i;
            btnu_o <= tmpbtnu_i;
            btnd_o <= tmpbtnd_i;
            btnl_o <= tmpbtnl_i;
            btnr_o <= tmpbtnr_i;
		end if;
	end process p_ff2;

--countersize = 2^8 = 256    
--DEBOUNCE
    p_db : process (clk_i, reset_i)
	begin
		if reset_i = '1' then
            counterPrescale <= (others => '0');
		elsif (clk_i'event and clk_i = 	'1') then
            if (counterPrescale(counter_size) = '0') then
                counterPrescale <= counterPrescale + 1;
            else
                sw_db <= sw_o;
                btnu_db <= btnu_o;
                btnd_db <= btnd_o;
                btnl_db <= btnl_o;
                btnr_db <= btnr_o;                
            end if;
		end if;
	end process p_db;
---------------------------------------------------------    
    
    




end struc;
