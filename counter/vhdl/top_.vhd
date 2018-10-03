-------------------------------------------------------------------------------
--                                                                      
--                        Counter Project Base
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         top
--
-- FILENAME:       top_.vhd
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
-- DESCRIPTION:    This describes the entity of the top-level
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
library work;
use work.basys3_util_pkg.all;

entity top is
  generic (
    G_CNT_UP_BUTTON_ID      : integer range 0 to 3 := C_BASYS3_BUTTON_UP;
    G_CNT_DOWN_BUTTON_ID    : integer range 0 to 3 := C_BASYS3_BUTTON_DOWN;
    G_CNT_HOLD_BUTTON_ID    : integer range 0 to 3 := C_BASYS3_BUTTON_LEFT;
    G_CNT_RESET_BUTTON_ID   : integer range 0 to 3 := C_BASYS3_BUTTON_RIGHT;
    G_CNT_MODE_BIT_0_SW_ID  : integer range 0 to 15 := 14;
    G_CNT_MODE_BIT_1_SW_ID  : integer range 0 to 15 := 15;
    G_CNT_SPEED_BIT_0_SW_ID : integer range 0 to 15 := 0;
    G_CNT_SPEED_BIT_1_SW_ID : integer range 0 to 15 := 1;
    G_CNT_SPEED_DIV_SIM     : integer := 1;
    counter_size  :  INTEGER := 13
    );
  port (clk_i      : in  std_logic;
        reset_i    : in  std_logic;
        sw_i       : in  std_logic_vector(15 downto 0);
        btnu_i     : in  std_logic;
        btnd_i     : in  std_logic;
        btnl_i     : in  std_logic;
        btnr_i     : in  std_logic;
        ss_o       : out std_logic_vector(7 downto 0);
        ss_anode_o : out std_logic_vector(3 downto 0)
        );
end top;
