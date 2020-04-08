			 LOADI 0
			 OUT SRAM_ADHI

Test1:       LOAD  A
             OUT SRAM_ADLOW
             LOADI 1
             OUT SRAM_WRITE
         

Test2:       LOAD  B
             OUT SRAM_ADLOW
             LOADI 2
             OUT SRAM_WRITE
          

Test3:       LOAD  C
             OUT SRAM_ADLOW
             LOADI 3
             OUT SRAM_WRITE
             
             LOAD  A
             OUT SRAM_ADLOW
             OUT SRAM_READ
             IN  SRAM_READ
             
             LOAD  B
             OUT SRAM_ADLOW
             OUT SRAM_READ
             IN  SRAM_READ
             
             LOAD  C
             OUT SRAM_ADLOW
             OUT SRAM_READ
             IN  SRAM_READ
          
	
A: DW &H02
B: DW &H12
C: DW &H23
SRAM_READ:  EQU &H10
SRAM_WRITE: EQU &H11
SRAM_ADLOW: EQU &H12
SRAM_ADHI:  EQU &H13