ASM1
===

Z80 Self Assembler for MSX-DOS

usage:
````
	ASM1 <source file> [<output file>] [option]

	option:
		/B .. create bsave/bload file (.OBJ)
		/L .. output label values listing (.LBL)
````

example:
````
A>TYPE HELLO.ASM

	ORG	100H

	LD	C,09H
	LD	DE,HELLO
	CALL	0005H
	RET

HELLO:	DB	"Hello, World!",0DH,0AH,'$'

A>ASM1 HELLO.ASM
4:19:44:0
==== Z-80A Self Assembler ====
       Programed by djnz80a
Pass...1
Pass...2
end address = 0118
label(s)    = 1
4:19:45:0

A>HELLO
Hello!, World!

A>
````

Z80 Instructions:
````
ADC
ADD
AND
BIT
CALL
CCF
CP
CPD
CPDR
CPI
CPIR
CPL
DEC
DJNZ
DAA
DI
EI
EX
EXX
HALT
IM
IN
INC
IM
IND
INDR
INI
INIR
JP
JR
LD
LDD
LDDR
LDI
LDIR
NEG
NOP
OR
OTDR
OTIR
OUT
OUTD
OUTI
POP
PUSH
RES
RET
RETI
RETN
RL
RLA
RLC
RLCA
RLD
RR
RRA
RRC
RRCA
RRD
RST
SBC
SUB
SCF
SET
SLA
SRA
SRL
XOR
````

Pseudo-Instructions:
````
 ORG	set orign address
 ADRS	change address temporaliry
 END	end of program
 
 DEFB	define byte
 DEFW	define word
 DEFM	define message
 DEFS	define space

 DB	same as DEFB
 DW	same as DEFW
 DWR	DW reverse endian
 DM	same as DEFM
 DS	same as DEFS
 
 #INCLUDE	include file
````
