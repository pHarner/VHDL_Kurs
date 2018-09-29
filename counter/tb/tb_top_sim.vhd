-------------------------------------------------------------------------------
-- Title      : Testbench for design "top"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : top_tb.vhd
-- Author     :   <puhm@PUHM-THINK>
-- Company    : 
-- Created    : 2018-09-06
-- Last update: 2018-09-14
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-09-06  1.0      puhm	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.basys3_util_pkg.all;
use work.counter_util_pkg.all;

-------------------------------------------------------------------------------

entity tb_top is

end entity tb_top;

-------------------------------------------------------------------------------

architecture sim of tb_top is

  -- component ports
  signal s_clk_i      : std_logic := '0';
  signal s_reset_i    : std_logic := '1';
  signal s_sw_i       : std_logic_vector(15 downto 0) := (others => '0');
  signal s_btnu_i     : std_logic := '0';
  signal s_btnd_i     : std_logic := '0';
  signal s_btnl_i     : std_logic := '0';
  signal s_btnr_i     : std_logic := '0';
  signal s_ss_o       : std_logic_vector(7 downto 0);
  signal s_ss_anode_o : std_logic_vector(3 downto 0);


  component top is
    generic (
      G_CNT_UP_BUTTON_ID      : integer range 0 to 3;
      G_CNT_DOWN_BUTTON_ID    : integer range 0 to 3;
      G_CNT_HOLD_BUTTON_ID    : integer range 0 to 3;
      G_CNT_RESET_BUTTON_ID   : integer range 0 to 3;
      G_CNT_MODE_BIT_0_SW_ID  : integer range 0 to 15;
      G_CNT_MODE_BIT_1_SW_ID  : integer range 0 to 15;
      G_CNT_SPEED_BIT_0_SW_ID : integer range 0 to 15;
      G_CNT_SPEED_BIT_1_SW_ID : integer range 0 to 15;
      G_CNT_SPEED_DIV_SIM     : integer := 1);
    port (
      clk_i      : in  std_logic;
      reset_i    : in  std_logic;
      sw_i       : in  std_logic_vector(15 downto 0);
      btnu_i     : in  std_logic;
      btnd_i     : in  std_logic;
      btnl_i     : in  std_logic;
      btnr_i     : in  std_logic;
      ss_o       : out std_logic_vector(7 downto 0);
      ss_anode_o : out std_logic_vector(3 downto 0));
  end component top;

begin  -- architecture sim

  -- component instantiation
  DUT: component top
    generic map (
      G_CNT_UP_BUTTON_ID      => C_BASYS3_BUTTON_UP,
      G_CNT_DOWN_BUTTON_ID    => C_BASYS3_BUTTON_DOWN,
      G_CNT_HOLD_BUTTON_ID    => C_BASYS3_BUTTON_LEFT,
      G_CNT_RESET_BUTTON_ID   => C_BASYS3_BUTTON_RIGHT,
      G_CNT_MODE_BIT_0_SW_ID  => 14,
      G_CNT_MODE_BIT_1_SW_ID  => 15,
      G_CNT_SPEED_BIT_0_SW_ID => 0,
      G_CNT_SPEED_BIT_1_SW_ID => 1,
      G_CNT_SPEED_DIV_SIM     => 1000)
    port map (
      clk_i       => s_clk_i,
      reset_i     => s_reset_i,
      sw_i        => s_sw_i,
      btnu_i      => s_btnu_i,
      btnd_i      => s_btnd_i,
      btnl_i      => s_btnl_i,
      btnr_i      => s_btnr_i,
      ss_o        => s_ss_o,
      ss_anode_o => s_ss_anode_o);

  -- clock generation
  s_clk_i <= not s_clk_i after 5 ns; -- 100MHz

  s_reset_i <= '0' after 101 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
    -- count up @ 1000 Hz (1 MHz in simulation) @ octal
    s_sw_i(1 downto 0) <= STD_LOGIC_VECTOR(TO_UNSIGNED(C_CNT_SPEED_1000HZ,2));
    s_sw_i(15 downto 14) <= STD_LOGIC_VECTOR(TO_UNSIGNED(C_CNT_MODE_OCTAL,2));
    
    wait until s_reset_i <= '0';
    wait until s_clk_i = '1';

    wait for 1 ms;
    -- count up @ 100 Hz (100 kHz in simulation)
    s_sw_i(1 downto 0) <= STD_LOGIC_VECTOR(TO_UNSIGNED(C_CNT_SPEED_100HZ,2));
    wait for 1 us;
    -- count up @ 100 Hz (100 kHz in simulation) @ decimal
    s_sw_i(15 downto 14) <= STD_LOGIC_VECTOR(TO_UNSIGNED(C_CNT_MODE_DECIMAL,2));
    wait for 2 ms;
    s_btnl_i <= '1'; -- hold on
    wait for 200 us;
    s_btnl_i <= '0'; -- hold off
    wait for 2 ms;
    s_btnr_i <= '1'; -- sync reset on
    wait for 10 us;
    s_btnr_i <= '0'; -- sync reset off
    wait for 1 ms;
    s_btnu_i <= '1'; -- count up @ 1000 Hz (1 MHz in simulation) @ hex
    s_sw_i(1 downto 0) <= STD_LOGIC_VECTOR(TO_UNSIGNED(C_CNT_SPEED_1000HZ,2));
    s_sw_i(15 downto 14) <= STD_LOGIC_VECTOR(TO_UNSIGNED(C_CNT_MODE_HEX,2));
    wait for 1 ms;
    s_btnu_i <= '0';
    s_btnd_i <= '1'; -- count down @ 1000 Hz (1 MHz in simulation) @ hex
    wait for 2 ms;
    s_btnu_i <= '1';
    s_btnd_i <= '0'; -- count up @ 1000 Hz (1 MHz in simulation) @ hex
    wait for 2 ms;

    assert false report "SIMULATION END" severity failure;
  end process WaveGen_Proc;

  

end architecture sim;
