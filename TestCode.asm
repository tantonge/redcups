Test1:       LOAD  A
             OUT SRAM_ADLOW
             OUT SRAM_ADHI
             OUT read
             OUT write 

Test2:       LOAD  B
             OUT SRAM_ADLOW
             OUT SRAM_ADHI
             OUT read
             OUT write 

Test3:       LOAD  C
             OUT SRAM_ADLOW
             OUT SRAM_ADHI
             OUT read
             OUT write 
	
A: EQU &H01
B: EQU &H12
C: EQU &H23
SRAM_READ:  EQU &H110
SRAM_WRITE: EQU &H111
SRAM_ADLOW: EQU &H12
SRAM_ADHI:  EQU &H13