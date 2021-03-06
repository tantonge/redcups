LIBRARY IEEE;
LIBRARY ALTERA_MF;
LIBRARY LPM;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ALTERA_MF.ALTERA_MF_COMPONENTS.ALL;
USE LPM.LPM_COMPONENTS.ALL;

--initializes the input/outputs of the state machine
ENTITY SRAM IS
	PORT(
		IO_WRITE    	: IN    STD_LOGIC;
		IO_CYCLE		: IN    STD_LOGIC;
		SRAM_ADHI_EN   	: IN    STD_LOGIC;
		SRAM_ADLOW_EN   : IN    STD_LOGIC;
		SRAM_WRITE	    : IN    STD_LOGIC;
		SRAM_READ   	: IN    STD_LOGIC;
		CLOCK			: IN    STD_LOGIC;          
		IO_DATA  		: INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		SRAM_ADDR  		: OUT   STD_LOGIC_VECTOR(17 DOWNTO 0);
		SRAM_OE_N 		: OUT   STD_LOGIC;
		SRAM_DQ			: INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		SRAM_WE_N		: OUT   STD_LOGIC;
		SRAM_UB_N		: OUT   STD_LOGIC;
		SRAM_LB_N		: OUT   STD_LOGIC;
		SRAM_CE_N		: OUT   STD_LOGIC
	);
END SRAM;

ARCHITECTURE a OF SRAM IS

--defines the states of the I/O device
TYPE STATE_TYPE IS (
		IDLE,
		WRITE_EN, 
		DATA_SEND, 
		WRITE_DISABLE1,
		WRITE_DISABLE2,
		READ_DATA1, 
		READ_DATA2, 
		READ_DATA3,
		READ_DATA4,
		SEND
	);
--made a signal called state we can can referece this instead of STATE_TYPE
SIGNAL STATE: STATE_TYPE;
SIGNAL TRI_READ : STD_LOGIC;
SIGNAL TRI_WRITE: STD_LOGIC;
SIGNAL TRI_SEND: STD_LOGIC;
attribute keep : string;
attribute keep of IO_DATA : signal is "true";


BEGIN

-- Use LPM function to drive I/O bus
	WRITE_BUS: LPM_BUSTRI
	GENERIC MAP (
		lpm_width => 16
	)
	PORT MAP (
		data     => IO_DATA,
		enabledt => TRI_WRITE,
		tridata  => SRAM_DQ
	);
	
-- Use LPM function to drive I/O bus
	READ_STORE_BUS: LPM_BUSTRI
	GENERIC MAP (
		lpm_width => 16
	)
	PORT MAP (
		data     => SRAM_DQ,
		enabledt => TRI_READ,
		tridata  => IO_DATA
	);
	



--these three all go to ground, so here they are zero
SRAM_UB_N <= '0';
SRAM_LB_N <= '0';
SRAM_CE_N <= '0';

PROCESS (IO_WRITE, SRAM_ADHI_EN)
BEGIN
	IF (IO_WRITE = '1') AND (SRAM_ADHI_EN = '1') THEN
		SRAM_ADDR(17 DOWNTO 16) <= IO_DATA(1 DOWNTO 0);
	END IF;
END PROCESS;

PROCESS (IO_WRITE, SRAM_ADLOW_EN)	
BEGIN	
	IF (IO_WRITE = '1') AND (SRAM_ADLOW_EN = '1') THEN
		SRAM_ADDR(15 DOWNTO 0) <= IO_DATA;
	END IF;
END PROCESS;

PROCESS (IO_WRITE, CLOCK, SRAM_WRITE, SRAM_READ)
BEGIN
	IF (IO_WRITE = '0') AND (IO_CYCLE = '0') THEN          
		STATE <= IDLE;
	ELSIF (RISING_EDGE(CLOCK)) THEN
		TRI_READ <= '1';
		CASE STATE IS
			--IDLE
			WHEN IDLE =>
				SRAM_WE_N <= '1';
				SRAM_OE_N <= '1';
				TRI_WRITE <= '0';
				TRI_READ <= '0';
				TRI_SEND <= '0';
				IF (SRAM_WRITE = '1') THEN
					STATE <= WRITE_EN;
				--ELSIF (SRAM_READ = '1') AND (IO_WRITE = '0') THEN
					--STATE <= SEND;
				ELSIF (SRAM_READ = '1') THEN
					STATE <= READ_DATA1;
				END IF;
			--Write
			WHEN WRITE_EN => 
				SRAM_WE_N <= '0';
				STATE <= DATA_SEND;
			WHEN DATA_SEND =>
				TRI_WRITE <= '1';
				STATE <= WRITE_DISABLE1;
			WHEN WRITE_DISABLE1 =>
				STATE <= WRITE_DISABLE2;
			WHEN WRITE_DISABLE2 =>
				SRAM_WE_N <= '1';
				STATE <= IDLE;
			--Read
			WHEN READ_DATA1 =>
				SRAM_OE_N <= '0';
				STATE <= READ_DATA2;
			WHEN READ_DATA2 =>
				STATE <= READ_DATA3;
			WHEN READ_DATA3 =>
				TRI_READ <= '1';
				STATE <= READ_DATA4;
			WHEN READ_DATA4 =>
				SRAM_OE_N <= '1';
			--Send
			--WHEN SEND =>
				--TRI_SEND <= '1';
			WHEN OTHERS =>
				STATE <= IDLE;
		END CASE;
	END IF;
END PROCESS;
	

END a;