ASM1
===

Z80 Self Assembler for MSX-DOS

usage:
````
	ASM1 <source file> [<output file>] [option]

	option:
		/B .. output bsave/bload file to .OBJ file
		/L .. output label values listing to .LBL file
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
