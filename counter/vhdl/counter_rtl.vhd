-------------------------------------------------------------------------------
--                                                                      
--                        Counter Project Base
--  
-------------------------------------------------------------------------------
--                                                                      
-- ENTITY:         counter
--
-- FILENAME:       counter_rtl.vhd
-- 
-- ARCHITECTURE:   RTL
-- 
-- ENGINEER:       Andreas Puhm
--
-- DATE:           2018-09-06
--
-- VERSION:        1.0
--
-------------------------------------------------------------------------------
--                                                                      
-- DESCRIPTION:    This describes the architecture of the counter sub unit
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
library work;
use work.counter_util_pkg.all;

architecture rtl of counter is
  -- for timing
  signal s_counter_period_max : integer range 1 to C_CNT_1HZ_CNT_MAX/G_CNT_SPEED_DIV_SIM;
  signal s_counter_period_cnt : integer range 1 to C_CNT_1HZ_CNT_MAX/G_CNT_SPEED_DIV_SIM;
  signal s_counter_en         : std_logic;

  -- for coutner mode
  signal s_counter_max : integer range 0 to C_CNT_MODE_HEX_MAX;

  -- for counter value to io_ctrl
  signal s_counter_1_val    : std_logic_vector(3 downto 0);
  signal s_counter_10_val   : std_logic_vector(3 downto 0);
  signal s_counter_100_val  : std_logic_vector(3 downto 0);
  signal s_counter_1000_val : std_logic_vector(3 downto 0);
  
begin

  ----------------------------------------------------------------
  ----------------------------------------------------------------
  -- Provide timing
  ----------------------------------------------------------------
  ----------------------------------------------------------------

  -- purpose: select current max period for selected count speed
  -- type   : combinational
  -- inputs : cntr_speed_i
  -- outputs: 
  p_counter_period_select : process (cntr_speed_i) is
  begin  -- process p_counter_period_select
    if cntr_speed_i = C_CNT_SPEED_1HZ_VEC then
      s_counter_period_max <= C_CNT_1HZ_CNT_MAX/G_CNT_SPEED_DIV_SIM;
    elsif cntr_speed_i = C_CNT_SPEED_10HZ_VEC then
      s_counter_period_max <= C_CNT_10HZ_CNT_MAX/G_CNT_SPEED_DIV_SIM;
    elsif cntr_speed_i = C_CNT_SPEED_100HZ_VEC then
      s_counter_period_max <= C_CNT_100HZ_CNT_MAX/G_CNT_SPEED_DIV_SIM;
    elsif cntr_speed_i = C_CNT_SPEED_1000HZ_VEC then
      s_counter_period_max <= C_CNT_1000HZ_CNT_MAX/G_CNT_SPEED_DIV_SIM;
    else
      assert cntr_speed_i = "UUUU" report "Erroneous cntr_speed_i input!" severity failure;
      s_counter_period_max <= 1;
    end if;
  end process p_counter_period_select;

  -- purpose: generate counter enable
  -- type   : sequential
  -- inputs : clk_i, reset_i
  -- outputs: 
  p_counter_en : process (clk_i, reset_i) is
  begin  -- process p_counter_en
    if reset_i = '1' then                   -- asynchronous reset (active high)
      s_counter_en         <= '0';
      s_counter_period_cnt <= 1;
    elsif clk_i'event and clk_i = '1' then  -- rising clock edge
      s_counter_en <= '0';

      if cntr_reset_i = '1' then
        -- synchronous reset
        s_counter_period_cnt <= 1;
      elsif cntr_hold_i = '0' then
        -- advance period cnt only if counter is not in hold mode
        if s_counter_period_cnt = s_counter_period_max then
          s_counter_en <= '1';
          s_counter_period_cnt <= 1;
        elsif s_counter_period_cnt > s_counter_period_max then
          assert false report "Counter was not reset when the speed was changed!" severity warning;
        else
          s_counter_period_cnt <= s_counter_period_cnt + 1;
        end if;
      end if;
    end if;
  end process p_counter_en;

  ----------------------------------------------------------------
  ----------------------------------------------------------------
  -- Select counter mode
  ----------------------------------------------------------------
  ----------------------------------------------------------------

  -- purpose: select max value for selected counter mode
  -- type   : combinational
  -- inputs : cntr_mode_i
  -- outputs: 
  p_counter_select_max : process (cntr_mode_i) is
  begin  -- process p_counter_select_max
    if cntr_mode_i = C_CNT_MODE_OCTAL_VEC then
      s_counter_max <= C_CNT_MODE_OCTAL_MAX;
    elsif cntr_mode_i = C_CNT_MODE_DECIMAL_VEC then
      s_counter_max <= C_CNT_MODE_DECIMAL_MAX;
    elsif cntr_mode_i = C_CNT_MODE_HEX_VEC then
      s_counter_max <= C_CNT_MODE_HEX_MAX;
    else
      assert cntr_mode_i = "UUU" report "Erroneous cntr_mode_i input!" severity failure;
      s_counter_max <= 5;
    end if;
  end process p_counter_select_max;

  ----------------------------------------------------------------
  ----------------------------------------------------------------
  -- Count
  ----------------------------------------------------------------
  ----------------------------------------------------------------

  -- purpose: count
  -- type   : sequential
  -- inputs : clk_i, reset_i
  -- outputs: 
  p_count : process (clk_i, reset_i) is
    variable v_counter_1    : std_logic_vector(3 downto 0);
    variable v_counter_10   : std_logic_vector(3 downto 0);
    variable v_counter_100  : std_logic_vector(3 downto 0);
    variable v_counter_1000 : std_logic_vector(3 downto 0);
  begin  -- process p_count
    if reset_i = '1' then               -- asynchronous reset (active high)
      v_counter_1    := (others => '0');
      v_counter_10   := (others => '0');
      v_counter_100  := (others => '0');
      v_counter_1000 := (others => '0');
      s_counter_1_val <= (others => '0');
      s_counter_10_val <= (others => '0');
      s_counter_100_val <= (others => '0');
      s_counter_1000_val <= (others => '0');
    elsif Rising_edge(clk_i) then       -- rising clock edge
      if cntr_reset_i = '1' then
        v_counter_1    := (others => '0');
        v_counter_10   := (others => '0');
        v_counter_100  := (others => '0');
        v_counter_1000 := (others => '0');
      elsif cntr_hold_i = '0' then
        if cntr_up_i = '1' and cntr_down_i = '0' then
          -- count up
          proc_count_up(s_counter_en,
                        s_counter_max,
                        s_counter_1_val,
                        s_counter_10_val,
                        s_counter_100_val,
                        s_counter_1000_val,
                        v_counter_1,
                        v_counter_10,
                        v_counter_100,
                        v_counter_1000
                        );
        elsif cntr_up_i = '0' and cntr_down_i = '1' then
          -- count down
          proc_count_down(s_counter_en,
                          s_counter_max,
                          s_counter_1_val,
                          s_counter_10_val,
                          s_counter_100_val,
                          s_counter_1000_val,
                          v_counter_1,
                          v_counter_10,
                          v_counter_100,
                          v_counter_1000
                          );
        else
          -- error
          assert false report "Erreneous cntr_up_i + cntr_down_i inputs!" severity failure;
        end if; -- cntr_up_i + cntr_down_i
      end if; -- cntr_reset_i + cntr_hold_i
      s_counter_1_val <= v_counter_1;
      s_counter_10_val <= v_counter_10;
      s_counter_100_val <= v_counter_100;
      s_counter_1000_val <= v_counter_1000;
    end if;
  end process p_count;

  cntr_1_o <= s_counter_1_val;
  cntr_10_o <= s_counter_10_val;
  cntr_100_o <= s_counter_100_val;
  cntr_1000_o <= s_counter_1000_val;
  
end rtl;
