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
  signal counterPrescaleLed : std_logic_vector(counter_size DOWNTO 0) := (OTHERS => '0'); --counter output
  
---------------------------------------------------------
begin
---------------------------------------------------------
  
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
                counterPrescale <= (others => '0');              
            end if;
		end if;
	end process p_db;
---------------------------------------------------------    
    
--Write button press to sub unit
    p_setsubunit : process (clk_i, reset_i)
	begin
		if reset_i = '1' then
            s_cntr_hold <= '1';
            s_cntr_reset <= '1';
            s_cntr_up <= '0';
            s_cntr_down <= '0';
            s_cntr_mode <= (others => '0');
            s_cntr_speed <= (others => '0');
		elsif (clk_i'event and clk_i = 	'1') then
            s_cntr_hold <= sw_db(0);
            s_cntr_reset <= sw_db(1);
            if btnu_db /= btnd_db then
                s_cntr_up <= btnu_db;
                s_cntr_down <= btnd_db;
            end if;
            if (sw_db(15) = '0' and sw_db(14) = '0') then
                s_cntr_mode(0) <= '1';
                s_cntr_mode(1) <= '0';
                s_cntr_mode(2) <= '0';
            elsif (sw_db(15) = '1' and sw_db(14) = '0') then
                s_cntr_mode(0) <= '0';
                s_cntr_mode(1) <= '1';
                s_cntr_mode(2) <= '0';
            elsif (sw_db(15) = '1' and sw_db(14) = '1') then
                s_cntr_mode(0) <= '0';
                s_cntr_mode(1) <= '0';
                s_cntr_mode(2) <= '1';
            end if;
            if (sw_db(13) = '0' and sw_db(12) = '0') then
                s_cntr_speed(0) <= '1';
                s_cntr_speed(1) <= '0';
                s_cntr_speed(2) <= '0';
                s_cntr_speed(3) <= '0';
            elsif (sw_db(13) = '1' and sw_db(12) = '0') then
                s_cntr_speed(0) <= '0';
                s_cntr_speed(1) <= '1';
                s_cntr_speed(2) <= '0';
                s_cntr_speed(3) <= '0';
            elsif (sw_db(13) = '0' and sw_db(12) = '1') then
                s_cntr_speed(0) <= '0';
                s_cntr_speed(1) <= '0';
                s_cntr_speed(2) <= '1';
                s_cntr_speed(3) <= '0';
            elsif (sw_db(13) = '1' and sw_db(12) = '1') then
                s_cntr_speed(0) <= '0';
                s_cntr_speed(1) <= '0';
                s_cntr_speed(2) <= '0';
                s_cntr_speed(3) <= '1';               
            end if;
        end if;
	end process p_setsubunit;    

--7segment
    p_segment : process (clk_i, reset_i)
	begin
		if reset_i = '1' then
            counterPrescaleLed <= (others => '0');
            ss_anode_o <= (others => '1');
		elsif (clk_i'event and clk_i = 	'1') then
            if (counterPrescaleLed(counter_size) = '0') then
                counterPrescaleLed <= counterPrescaleLed + 1;
            else
                ss_anode_o(0) <= '0';
                ss_anode_o(1) <= '1';
                ss_anode_o(2) <= '1';
                ss_anode_o(3) <= '1';
                case s_cntr_1 is
                    when "0001" => ss_o <= "01100001";
                    when "0010" => ss_o <= "11011011";
                    when "0011" => ss_o <= "11110011";
                    when "0100" => ss_o <= "01100111"; --4
                    when "0101" => ss_o <= "10110111"; --5
                    when "0110" => ss_o <= "10111111"; --6
                    when "0111" => ss_o <= "11100001"; --7
                    when "1000" => ss_o <= "11111111"; --8
                    when "1001" => ss_o <= "11110111"; --9
                    when "1010" => ss_o <= "11101111"; --a
                    when "1011" => ss_o <= "00111111"; --b
                    when "1100" => ss_o <= "10011101"; --c
                    when "1101" => ss_o <= "01111011"; --d
                    when "1110" => ss_o <= "10011111"; --e
                    when "1111" => ss_o <= "10001111"; --f
                    when others => ss_o <= "11111101";
                    
                end case;
                
                ss_anode_o(0) <= '1';
                ss_anode_o(1) <= '0';
                ss_anode_o(2) <= '1';
                ss_anode_o(3) <= '1';
                case s_cntr_10 is
                    when "0001" => ss_o <= "01100001";
                    when "0010" => ss_o <= "11011011";
                    when "0011" => ss_o <= "11110011";
                    when "0100" => ss_o <= "01100111"; --4
                    when "0101" => ss_o <= "10110111"; --5
                    when "0110" => ss_o <= "10111111"; --6
                    when "0111" => ss_o <= "11100001"; --7
                    when "1000" => ss_o <= "11111111"; --8
                    when "1001" => ss_o <= "11110111"; --9
                    when "1010" => ss_o <= "11101111"; --a
                    when "1011" => ss_o <= "00111111"; --b
                    when "1100" => ss_o <= "10011101"; --c
                    when "1101" => ss_o <= "01111011"; --d
                    when "1110" => ss_o <= "10011111"; --e
                    when "1111" => ss_o <= "10001111"; --f
                    when others => ss_o <= "11111101";
                    
                end case;
                
                ss_anode_o(0) <= '1';
                ss_anode_o(1) <= '1';
                ss_anode_o(2) <= '0';
                ss_anode_o(3) <= '1';
                case s_cntr_100 is
                    when "0001" => ss_o <= "01100001";
                    when "0010" => ss_o <= "11011011";
                    when "0011" => ss_o <= "11110011";
                    when "0100" => ss_o <= "01100111"; --4
                    when "0101" => ss_o <= "10110111"; --5
                    when "0110" => ss_o <= "10111111"; --6
                    when "0111" => ss_o <= "11100001"; --7
                    when "1000" => ss_o <= "11111111"; --8
                    when "1001" => ss_o <= "11110111"; --9
                    when "1010" => ss_o <= "11101111"; --a
                    when "1011" => ss_o <= "00111111"; --b
                    when "1100" => ss_o <= "10011101"; --c
                    when "1101" => ss_o <= "01111011"; --d
                    when "1110" => ss_o <= "10011111"; --e
                    when "1111" => ss_o <= "10001111"; --f
                    when others => ss_o <= "11111101";
                    
                end case;
                
                ss_anode_o(0) <= '1';
                ss_anode_o(1) <= '1';
                ss_anode_o(2) <= '1';
                ss_anode_o(3) <= '0';
                case s_cntr_1000 is
                    when "0001" => ss_o <= "01100001";
                    when "0010" => ss_o <= "11011011";
                    when "0011" => ss_o <= "11110011";
                    when "0100" => ss_o <= "01100111"; --4
                    when "0101" => ss_o <= "10110111"; --5
                    when "0110" => ss_o <= "10111111"; --6
                    when "0111" => ss_o <= "11100001"; --7
                    when "1000" => ss_o <= "11111111"; --8
                    when "1001" => ss_o <= "11110111"; --9
                    when "1010" => ss_o <= "11101111"; --a
                    when "1011" => ss_o <= "00111111"; --b
                    when "1100" => ss_o <= "10011101"; --c
                    when "1101" => ss_o <= "01111011"; --d
                    when "1110" => ss_o <= "10011111"; --e
                    when "1111" => ss_o <= "10001111"; --f
                    when others => ss_o <= "11111101";
                    
                end case;
            end if;
		end if;
	end process p_segment;


end struc;
