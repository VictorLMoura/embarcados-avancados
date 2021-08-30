--
-- Rafael C.
-- ref:
--   - https://www.intel.com/content/www/us/en/programmable/quartushelp/13.0/mergedProjects/hdl/vhdl/vhdl_pro_state_machines.htm
--   - https://www.allaboutcircuits.com/technical-articles/implementing-a-finite-state-machine-in-vhdl/
--   - https://www.digikey.com/eewiki/pages/viewpage.action?pageId=4096117

library IEEE;
use IEEE.std_logic_1164.all;

entity stepmotor is
    port (
        -- Gloabals
        clk   : in  std_logic;

        -- controls
        en      : in std_logic;                     -- 1 on/ 0 of
        dir     : in std_logic;                     -- 1 clock wise
        vel     : in std_logic_vector(1 downto 0);  -- 00: low / 11: fast
        steps     : in std_logic_vector(1 downto 0);  -- 00: 1000 / 11: 8000

        -- I/Os
        phases  : out std_logic_vector(3 downto 0)
  );
end entity stepmotor;

architecture rtl of stepmotor is

   TYPE STATE_TYPE IS (s0, s1, s2, s3);
   SIGNAL state  : STATE_TYPE := s0;
   signal enable : std_logic  := '0';
   signal topCounter : integer range 0 to 50000000;
	signal current_steps : integer range 0 to 8000 := 0;
	signal max_steps : integer range 0 to 8000;

begin

	PROCESS(clk)
	BEGIN
	 if (rising_edge(clk)) then
		CASE state IS
		WHEN s0=>
			if (enable = '1') then
				current_steps <= current_steps + 1;
				if (dir = '1') then
					state <= s3;
				else
					state <= s1;
				end if;
		  end if;
		WHEN s1=>
		  if (enable = '1') then
				current_steps <= current_steps + 1;
				if (dir = '1') then
					state <= s0;
				else
					state <= s2;
				end if;
		  end if;
		WHEN s2=>
		  if (enable = '1') then
				current_steps <= current_steps + 1;
				if (dir = '1') then
					state <= s1;
				else
					state <= s3;
				end if;
		  end if;
		WHEN s3=>
		  if (enable = '1') then
				current_steps <= current_steps + 1;
				if (dir = '1') then
					state <= s2;
				else
					state <= s0;
				end if;
		  end if;
		when others=>
		  state <= s0;
		END CASE;
	 end if;
	end process;

	PROCESS (state)
   BEGIN
      CASE state IS
        WHEN s0 =>
          phases <= "0001";
        WHEN s1 =>
          phases <= "0010";
        WHEN s2 =>
          phases <= "0100";
        when s3 =>
          phases <= "1000";
        when others =>
          phases <= "0000";
      END CASE;
   END PROCESS;
	
	PROCESS (vel)
	BEGIN
		CASE vel IS
		  WHEN "11" =>
			 topCounter <= 100000;
		  WHEN "10" =>
			 topCounter <= 300000;
		  WHEN "01" =>
			 topCounter <= 400000;
		  WHEN "00" =>
			 topCounter <= 500000;
		  when others =>
			 topCounter <= 10000;
		END CASE;
	END PROCESS;
	
	PROCESS (steps)
	BEGIN
		CASE steps IS
		  WHEN "11" =>
			 current_steps <= 0;
			 max_steps <= 8000;
		  WHEN "10" =>
			 current_steps <= 0;
			 max_steps <= 4000;
		  WHEN "01" =>
			 current_steps <= 0;
			 max_steps <= 2000;
		  WHEN "00" =>
			 current_steps <= 0;
			 max_steps <= 1000;
		  when others =>
			 max_steps <= 1000;
		END CASE;
	END PROCESS;

	process(clk, en)
	 variable counter : integer range 0 to 50000000 := 0;
	begin
	 if (rising_edge(clk) and en = '1') then
		if (counter < topCounter or current_steps > max_steps/4) then
		  counter := counter + 1;
		  enable  <= '0';
		else
		  counter := 0;
		  enable  <= '1';
		end if;
	 end if;
	end process;

end rtl;
