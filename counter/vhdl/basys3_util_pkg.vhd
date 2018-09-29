-------------------------------------------------------------------------------
--                                                                      
--                        Counter Project Base
--  
-------------------------------------------------------------------------------
--                                                                      
-- PACKAGE:        basys3_util_pkg
--
-- FILENAME:       basys3_util_pkg.vhd
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
-- DESCRIPTION:    This describes the utility package
--                 of the basys3 board.
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

package basys3_util_pkg is

  constant C_BASYS3_BUTTON_UP    : integer := 0;
  constant C_BASYS3_BUTTON_DOWN  : integer := 1;
  constant C_BASYS3_BUTTON_LEFT  : integer := 2;
  constant C_BASYS3_BUTTON_RIGHT : integer := 3;

end package basys3_util_pkg;

package body basys3_util_pkg is

end package body basys3_util_pkg;
