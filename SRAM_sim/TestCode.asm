			 LOADI 0
			 OUT SRAM_ADHI

Test1:       LOAD  A
             OUT SRAM_ADLOW
             LOAD D
             OUT SRAM_WRITE
         

Test2:       LOAD  B
             OUT SRAM_ADLOW
             LOAD E
             OUT SRAM_WRITE
          

Test3:       LOAD  C
             OUT SRAM_ADLOW
             LOAD F
             OUT SRAM_WRITE
             
             LOAD  A
             OUT SRAM_ADLOW
             IN  SRAM_READ
             
             LOAD  B
             OUT SRAM_ADLOW
             IN  SRAM_READ
             
             LOAD  C
             OUT SRAM_ADLOW
             IN  SRAM_READ
          
	
A:  DW &H5
B:  DW &HA
C:  DW &HE

D:  DW &H13
E:  DW &H48
F:  DW &H8

SRAM_READ:  EQU &H10
SRAM_WRITE: EQU &H11
SRAM_ADLOW: EQU &H12
SRAM_ADHI:  EQU &H13