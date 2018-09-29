-------------------------------------------------------------------------------
--                                                                      
--                        Counter Project Base
--  
-------------------------------------------------------------------------------
--                                                                      
-- PACKAGE:        counter_util_pkg
--
-- FILENAME:       counter_util_pkg.vhd
-- 
-- ARCHITECTURE:   
-- 
-- ENGINEER:       Andreas Puhm
--
-- DATE:           2018-09-06
--
-- VERSION:        1.0
--
-------------------------------------------------------------------------------
--                                                                      
-- DESCRIPTION:    This describes the component package
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

package counter_comp_pkg is
  
  component counter is
    generic (
      G_CNT_SPEED_DIV_SIM     : integer := 1
      );
    port (
      clk_i        : in  std_logic;
      reset_i      : in  std_logic;
      cntr_1_o     : out std_logic_vector(3 downto 0);
      cntr_10_o    : out std_logic_vector(3 downto 0);
      cntr_100_o   : out std_logic_vector(3 downto 0);
      cntr_1000_o  : out std_logic_vector(3 downto 0);
      cntr_hold_i  : in  std_logic;
      cntr_reset_i : in  std_logic;
      cntr_up_i    : in  std_logic;
      cntr_down_i  : in  std_logic;
      cntr_mode_i  : in  std_logic_vector(2 downto 0);
      cntr_speed_i : in  std_logic_vector(3 downto 0));
  end component counter;

  component io_ctrl is
    generic (
      G_CNT_UP_BUTTON_ID      : integer range 0 to 3;
      G_CNT_DOWN_BUTTON_ID    : integer range 0 to 3;
      G_CNT_HOLD_BUTTON_ID    : integer range 0 to 3;
      G_CNT_RESET_BUTTON_ID   : integer range 0 to 3;
      G_CNT_MODE_BIT_0_SW_ID  : integer range 0 to 15;
      G_CNT_MODE_BIT_1_SW_ID  : integer range 0 to 15;
      G_CNT_SPEED_BIT_0_SW_ID : integer range 0 to 15;
      G_CNT_SPEED_BIT_1_SW_ID : integer range 0 to 15;
      G_CNT_SPEED_DIV_SIM     : integer := 1
      );
    port (
      clk_i        : in  std_logic;
      reset_i      : in  std_logic;
      sw_i         : in  std_logic_vector(15 downto 0);
      btnu_i       : in  std_logic;
      btnd_i       : in  std_logic;
      btnl_i       : in  std_logic;
      btnr_i       : in  std_logic;
      ss_o         : out std_logic_vector(7 downto 0);
      ss_anode_o   : out std_logic_vector(3 downto 0);
      cntr_1_i     : in  std_logic_vector(3 downto 0);
      cntr_10_i    : in  std_logic_vector(3 downto 0);
      cntr_100_i   : in  std_logic_vector(3 downto 0);
      cntr_1000_i  : in  std_logic_vector(3 downto 0);
      cntr_hold_o  : out std_logic;
      cntr_reset_o : out std_logic;
      cntr_up_o    : out std_logic;
      cntr_down_o  : out std_logic;
      cntr_mode_o  : out std_logic_vector(2 downto 0);
      cntr_speed_o : out std_logic_vector(3 downto 0));
  end component io_ctrl;

end package counter_comp_pkg;
