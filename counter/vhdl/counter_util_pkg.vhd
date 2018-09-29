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
-- DESCRIPTION:    This describes the utility package
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
use IEEE.numeric_std.all;

package counter_util_pkg is

  constant C_10KHZ_CNT_MAX : integer := 10000;

  constant C_SYNC_STAGES : integer := 2;

  constant C_CNT_MODE_OCTAL       : integer                      := 0;
  constant C_CNT_MODE_OCTAL_VEC   : std_logic_vector(2 downto 0) := (C_CNT_MODE_OCTAL   => '1', others => '0');
  constant C_CNT_MODE_OCTAL_MAX   : integer                      := 7;
  constant C_CNT_MODE_DECIMAL     : integer                      := 1;
  constant C_CNT_MODE_DECIMAL_VEC : std_logic_vector(2 downto 0) := (C_CNT_MODE_DECIMAL => '1', others => '0');
  constant C_CNT_MODE_DECIMAL_MAX : integer                      := 9;
  constant C_CNT_MODE_HEX         : integer                      := 2;
  constant C_CNT_MODE_HEX_VEC     : std_logic_vector(2 downto 0) := (C_CNT_MODE_HEX     => '1', others => '0');
  constant C_CNT_MODE_HEX_MAX     : integer                      := 15;

  constant C_CNT_MODE_TOTAL_MAX : integer := C_CNT_MODE_HEX_MAX;

  constant C_CNT_SPEED_1HZ        : integer                      := 0;
  constant C_CNT_SPEED_1HZ_VEC    : std_logic_vector(3 downto 0) := (C_CNT_SPEED_1HZ    => '1', others => '0');
  constant C_CNT_1HZ_CNT_MAX      : integer                      := 100000000;
  constant C_CNT_SPEED_10HZ       : integer                      := 1;
  constant C_CNT_SPEED_10HZ_VEC   : std_logic_vector(3 downto 0) := (C_CNT_SPEED_10HZ   => '1', others => '0');
  constant C_CNT_10HZ_CNT_MAX     : integer                      := 10000000;
  constant C_CNT_SPEED_100HZ      : integer                      := 2;
  constant C_CNT_SPEED_100HZ_VEC  : std_logic_vector(3 downto 0) := (C_CNT_SPEED_100HZ  => '1', others => '0');
  constant C_CNT_100HZ_CNT_MAX    : integer                      := 1000000;
  constant C_CNT_SPEED_1000HZ     : integer                      := 3;
  constant C_CNT_SPEED_1000HZ_VEC : std_logic_vector(3 downto 0) := (C_CNT_SPEED_1000HZ => '1', others => '0');
  constant C_CNT_1000HZ_CNT_MAX   : integer                      := 100000;
  -----------------------------------------------------
  
  -----------------------------------------------------
  -- count up when enabled (count_en_i)
  -- increment higher digit at overflow (count_max_i)
  -- set to 0 at overflow
  -- wrap around if all digits overflow
  -- total 4 digits
  procedure proc_count_up (
    count_en_i   : in  std_logic;
    count_max_i  : in  integer;
    count_1_i    : in  std_logic_vector(3 downto 0);
    count_10_i   : in  std_logic_vector(3 downto 0);
    count_100_i  : in  std_logic_vector(3 downto 0);
    count_1000_i : in  std_logic_vector(3 downto 0);
    count_1_o    : out std_logic_vector(3 downto 0);
    count_10_o   : out std_logic_vector(3 downto 0);
    count_100_o  : out std_logic_vector(3 downto 0);
    count_1000_o : out std_logic_vector(3 downto 0)
    );
  -----------------------------------------------------
  
  -----------------------------------------------------
  -- count down when enabled (count_en_i)
  -- decrement higher digit at underflow
  -- set to count_max_i at underflow
  -- wrap around if all digits underflow
  -- total 4 digits
  procedure proc_count_down (
    count_en_i   : in  std_logic;
    count_max_i  : in  integer;
    count_1_i    : in  std_logic_vector(3 downto 0);
    count_10_i   : in  std_logic_vector(3 downto 0);
    count_100_i  : in  std_logic_vector(3 downto 0);
    count_1000_i : in  std_logic_vector(3 downto 0);
    count_1_o    : out std_logic_vector(3 downto 0);
    count_10_o   : out std_logic_vector(3 downto 0);
    count_100_o  : out std_logic_vector(3 downto 0);
    count_1000_o : out std_logic_vector(3 downto 0)
    );
  -----------------------------------------------------

end package counter_util_pkg;

package body counter_util_pkg is

  -----------------------------------------------------
  procedure proc_count_up (
    count_en_i   : in  std_logic;
    count_max_i  : in  integer;
    count_1_i    : in  std_logic_vector(3 downto 0);
    count_10_i   : in  std_logic_vector(3 downto 0);
    count_100_i  : in  std_logic_vector(3 downto 0);
    count_1000_i : in  std_logic_vector(3 downto 0);
    count_1_o    : out std_logic_vector(3 downto 0);
    count_10_o   : out std_logic_vector(3 downto 0);
    count_100_o  : out std_logic_vector(3 downto 0);
    count_1000_o : out std_logic_vector(3 downto 0)
    ) is
    variable v_count_1    : integer range 0 to C_CNT_MODE_TOTAL_MAX;
    variable v_count_10   : integer range 0 to C_CNT_MODE_TOTAL_MAX;
    variable v_count_100  : integer range 0 to C_CNT_MODE_TOTAL_MAX;
    variable v_count_1000 : integer range 0 to C_CNT_MODE_TOTAL_MAX;
  begin
    v_count_1    := TO_INTEGER(UNSIGNED(count_1_i));
    v_count_10   := TO_INTEGER(UNSIGNED(count_10_i));
    v_count_100  := TO_INTEGER(UNSIGNED(count_100_i));
    v_count_1000 := TO_INTEGER(UNSIGNED(count_1000_i));

    if count_en_i = '1' then
      if v_count_1 = count_max_i then
        v_count_1 := 0;
        if v_count_10 = count_max_i then
          v_count_10 := 0;
          if v_count_100 = count_max_i then
            v_count_100 := 0;
            if v_count_1000 = count_max_i then
              v_count_1000 := 0;
            else
              v_count_1000 := v_count_1000 + 1;
            end if;  -- v_count_1000
          else
            v_count_100 := v_count_100 + 1;
          end if;  -- v_count_100
        else
          v_count_10 := v_count_10 + 1;
        end if;  -- v_count_10
      else
        v_count_1 := v_count_1 + 1;
      end if;  -- v_count_1
    end if;  -- count_en_i

    count_1_o    := STD_LOGIC_VECTOR(TO_UNSIGNED(v_count_1, 4));
    count_10_o   := STD_LOGIC_VECTOR(TO_UNSIGNED(v_count_10, 4));
    count_100_o  := STD_LOGIC_VECTOR(TO_UNSIGNED(v_count_100, 4));
    count_1000_o := STD_LOGIC_VECTOR(TO_UNSIGNED(v_count_1000, 4));
  end proc_count_up;
  -----------------------------------------------------

  -----------------------------------------------------
  procedure proc_count_down (
    count_en_i   : in  std_logic;
    count_max_i  : in  integer;
    count_1_i    : in  std_logic_vector(3 downto 0);
    count_10_i   : in  std_logic_vector(3 downto 0);
    count_100_i  : in  std_logic_vector(3 downto 0);
    count_1000_i : in  std_logic_vector(3 downto 0);
    count_1_o    : out std_logic_vector(3 downto 0);
    count_10_o   : out std_logic_vector(3 downto 0);
    count_100_o  : out std_logic_vector(3 downto 0);
    count_1000_o : out std_logic_vector(3 downto 0)
    ) is
    variable v_count_1    : integer range 0 to C_CNT_MODE_TOTAL_MAX;
    variable v_count_10   : integer range 0 to C_CNT_MODE_TOTAL_MAX;
    variable v_count_100  : integer range 0 to C_CNT_MODE_TOTAL_MAX;
    variable v_count_1000 : integer range 0 to C_CNT_MODE_TOTAL_MAX;
  begin
    v_count_1    := TO_INTEGER(UNSIGNED(count_1_i));
    v_count_10   := TO_INTEGER(UNSIGNED(count_10_i));
    v_count_100  := TO_INTEGER(UNSIGNED(count_100_i));
    v_count_1000 := TO_INTEGER(UNSIGNED(count_1000_i));

    if count_en_i = '1' then
      if v_count_1 = 0 then
        v_count_1 := count_max_i;
        if v_count_10 = 0 then
          v_count_10 := count_max_i;
          if v_count_100 = 0 then
            v_count_100 := count_max_i;
            if v_count_1000 = 0 then
              v_count_1000 := count_max_i;
            else
              v_count_1000 := v_count_1000 - 1;
            end if;  -- v_count_1000
          else
            v_count_100 := v_count_100 - 1;
          end if;  -- v_count_100
        else
          v_count_10 := v_count_10 - 1;
        end if;  -- v_count_10
      else
        v_count_1 := v_count_1 - 1;
      end if;  -- v_count_1
    end if;  -- count_en_i

    count_1_o    := STD_LOGIC_VECTOR(TO_UNSIGNED(v_count_1, 4));
    count_10_o   := STD_LOGIC_VECTOR(TO_UNSIGNED(v_count_10, 4));
    count_100_o  := STD_LOGIC_VECTOR(TO_UNSIGNED(v_count_100, 4));
    count_1000_o := STD_LOGIC_VECTOR(TO_UNSIGNED(v_count_1000, 4));
  end proc_count_down;
  -----------------------------------------------------

end package body counter_util_pkg;
