Main:        LOADI  0      
	     STORE  SRAM_addr_high
	     LOAD   A
             STORE  SRAM_addr_high
	
start:       LOAD SRAM_addr_low
             OUT SRAM_ADLOW
             LOAD SRAM_addr_high
             OUT SRAM_ADHI

loadAddr:    OUT &123

readWrite:   OUT read
             OUT write    
	     STORE  SRAM_addr_low
 	     STORE  SRAM_addr_high
	
	
A: EQU &H01
B: EQU &H02
C: EQU &H03
SRAM_READ:  EQU &H110
SRAM_WRITE: EQU &H111
SRAM_ADLOW: EQU &H12
SRAM_ADHI:  EQU &H13