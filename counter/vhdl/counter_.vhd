-------------------------------------------------------------------------------
--                                                                      
--                        Counter Project Base
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         counter
--
-- FILENAME:       counter_.vhd
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
-- DESCRIPTION:    This describes the entity of the counter sub unit
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

entity counter is
  generic (
    G_CNT_SPEED_DIV_SIM     : integer := 1
    );
  port (
    -- to/from top level
    clk_i        : in  std_logic;
    reset_i      : in  std_logic;
    -- to/from io_ctrl sub unit
    cntr_1_o     : out std_logic_vector(3 downto 0);
    cntr_10_o    : out std_logic_vector(3 downto 0);
    cntr_100_o   : out std_logic_vector(3 downto 0);
    cntr_1000_o  : out std_logic_vector(3 downto 0);
    cntr_hold_i  : in  std_logic;
    cntr_reset_i : in  std_logic;
    cntr_up_i    : in  std_logic;
    cntr_down_i  : in  std_logic;
    cntr_mode_i  : in  std_logic_vector(2 downto 0);
    cntr_speed_i : in  std_logic_vector(3 downto 0)
    );
end counter;
