;
;	00 01 02 03 04 05 06 07 08
;	 B  C  D  E  H  L  A  I  R
;
;	10 11 12 13 14 15 16
;	BC DE HL AF IX IY SP
;
;	20 21 22 23 24 25 26 27
;	NZ  Z NC -- PO PE  P  M
;
;	 30   31   32   33   34  35   36
;	(BC) (DE) (HL) (SP) (C) (IX) (IY)
;
;	  40     41    42
;	(IX+d) (IY+d) (nn)
;
;	50
;	nn
;
OPCOD2:
	CALL	S.SKP2
	CP	','
	JP	NZ,ERR6
OPCOD3:	INC	IX

OPCODE:
	LD	HL,WORK2
	LD	B,40
	LD	A,' '
CODECL:	LD	(HL),A
	INC	HL
	DJNZ	CODECL
	DEC	IX
	CALL	S.SKIP
	JP	Z,CODE99
	LD	A,(IX+0)
	CP	'('
	JP	NZ,CODE10
	INC	IX
	CALL	CODE10
	LD	B,A
	LD	A,(IX+0)
	CP	')'
	JR	NZ,CODE50
	INC	IX

	LD	A,B
	CP	1
	JR	NZ,CD01
	LD	B,34H	;(c)
	JP	CODE90
CD01:	CP	10H
	JP	C,ERR6
	CP	16H
	JR	NZ,CD02
	LD	B,33H	;(sp)
	JP	CODE90
CD02:	CP	14H
	JR	NZ,CD03
	LD	B,35H	;(ix)
	JP	CODE90
CD03:	CP	15H
	JR	NZ,CD04
	LD	B,36H	;(iy)
	JP	CODE90
CD04:	CP	50H
	JR	NZ,CD05
	LD	B,42H	;(nn)
	JP	CODE90
CD05:	CP	13H
	JP	NC,ERR6

	ADD	A,20H	;(bc),(de),(hl)
	LD	B,A
	JP	CODE90

CODE50:	LD	A,B
	PUSH	AF
	CALL	GET.NO
	LD	A,(IX+0)
	CP	')'
	JP	NZ,CODE52
	INC	IX
	POP	AF
	CP	14H
	LD	B,40H	;(ix+d)
	JP	Z,CODE90
	CP	15H
	LD	B,41H	;(iy+d)
	JP	Z,CODE90
	JP	ERR6
CODE52:	POP	AF
	JP	ERR6

CODE10:	LD	(PNT),IX
	LD	DE,WORK2+1
	LD	B,40
	LD	A,(IX+0)
	CP	'9'+1
	JP	NC,CODE11
	CP	27H
	JR	Z,CD90
	CP	'$'
	JR	Z,CD90
	CP	'0'
	JR	C,CODE11
CD90:	CALL	GET.NO
	LD	B,50H
	JP	CODE90
CODE11:	LD	A,(IX+0)
	CP	'}'
	JR	Z,CODE12
	CP	'@'
	JP	NC,CDE110
	OR	A
	JR	Z,CODE12
	CP	09H
	JR	Z,CODE12
	CP	' '
	JR	Z,CODE12
	CP	';'
	JR	Z,CODE12
	CP	','
	JR	Z,CODE12
	CP	'+'
	JR	Z,CODE12
	CP	'-'
	JR	Z,CODE12
	CP	')'
	JR	Z,CODE12
CDE110:	CALL	UPPER
	LD	(DE),A
	INC	IX
	INC	DE
	DJNZ	CODE11
	JP	ERR6
CODE12:	LD	A,40
	SUB	B
	LD	(LEN),A

CODE02:	LD	A,(LEN)
	LD	C,A
	CP	1
	JP	NZ,CODE15

;	LD	B,0
;	LD	HL,C.DAT1
;CODE13:	LD	DE,WORK2+1
;	LD	A,(DE)
;	CP	(HL)
;	JP	Z,CODE90
;	INC	HL
;	INC	B
;	LD	A,B
;	CP	9
;	JP	NZ,CODE13

	LD	A,(WORK2+1)
	LD	HL,CODE90
	PUSH	HL

	LD	B,0
	CP	'B'
	RET	Z

	INC	B
	CP	'C'
	RET	Z

	INC	B
	CP	'D'
	RET	Z

	INC	B
	CP	'E'
	RET	Z

	INC	B
	CP	'H'
	RET	Z

	INC	B
	CP	'L'
	RET	Z

	INC	B
	CP	'A'
	RET	Z

	INC	B
	CP	'I'
	RET	Z

	INC	B
	CP	'R'
	RET	Z
	POP	HL

	LD	A,C
CODE15:
	CP	3
	JR	NC,CODE19

	LD	HL,C.DAT2
	LD	B,10H
CODE16:	LD	DE,WORK2+1
	LD	A,(DE)
	CP	(HL)
	INC	HL
	INC	DE
	JR	NZ,CODE18
	LD	A,(DE)
	CP	(HL)
	JR	Z,CODE20
CODE18:	INC	HL
	INC	B
	LD	A,B
	CP	1FH
	JP	NZ,CODE16
CODE19:
	LD	HL,0
	LD	(VAL1),HL
	LD	IX,(PNT)
	CALL	GET.NO
CODE1A:
	DEC	IX
	CALL	L.SKIP
	LD	B,50H
	JR	CODE90

CODE20:	LD	A,B
	CP	17H
	JP	C,CODE90
	ADD	A,9
	LD	B,A
;	JP	CODE90

CODE90:	LD	A,B
	OR	A
	RET
CODE99:	LD	A,0FFH
	SCF
	RET

;C.DAT1:	DEFM	'BCDEHLAIR'

C.DAT2:	DEFM	'BC'
	DEFM	'DE'
	DEFM	'HL'
	DEFM	'AF'
	DEFM	'IX'
	DEFM	'IY'
	DEFM	'SP'

C.DAT3:	DEFM	'NZ'
	DEFM	'Z '
	DEFM	'NC'
	DEFM	'C '
	DEFM	'PO'
	DEFM	'PE'
	DEFM	'P '
	DEFM	'M '

C.40:	LD	H,0
	LD	L,A
	LD	DE,TBL.40
	ADD	HL,DE
	LD	A,(HL)
	JP	SETD1

TBL.40:	DEFB	3FH,2FH,27H,0F3H,0FBH,0D9H,76H
	DEFB	00H,17H,07H, 1FH, 0FH, 37H

C.50:	PUSH	AF
	LD	A,0EDH
	CALL	SETDAT
	POP	AF
	LD	H,0
	LD	L,A
	LD	DE,TBL.50
	ADD	HL,DE
	LD	A,(HL)
	JP	SETD1

TBL.50:	DEFB	0A9H,0B9H,0A1H,0B1H,0AAH,0BAH,0A2H,0B2H
	DEFB	0A8H,0B8H,0A0H,0B0H, 44H,0BBH,0B3H,0ABH
	DEFB	0A3H, 4DH, 45H, 6FH, 67H
;
;
;
MAIN20:
	DEC	IX
	CALL	S.SKIP
	JP	NZ,ERR6

MAIN50:	LD	HL,(LIN.NO)
	INC	HL
	LD	(LIN.NO),HL
;	CALL	CRLF
	JP	MAIN01
;
;
;
PUTLIN:	LD	HL,L.DATA
LOOP2:	LD	A,(HL)
	OR	A
	RET	Z
	CP	1AH
	RET	Z
	INC	HL
	CALL	DOS02
	JP	LOOP2
;
;
;
SETDAT:	PUSH	HL
	LD	HL,(O.ADR2)
;	LD	(HL),A
	INC	HL
	LD	(O.ADR2),HL
	LD	HL,PASS
	BIT	0,(HL)
	CALL	Z,PUTCHR
	LD	HL,(O.ADR1)
	INC	HL
	LD	(O.ADR1),HL
	LD	HL,(O.BYTE)
	INC	HL
	LD	(O.BYTE),HL
	POP	HL
	RET
;
;
;
S.SKIP:	INC	IX
S.SKP2:	LD	A,(IX+0)
	CP	' '
	JP	Z,S.SKIP
	CP	09H
	JP	Z,S.SKIP
	OR	A
	RET	Z
	CP	';'
	RET
;
;
;
L.SKIP:	INC	IX
	LD	A,(IX+0)
	OR	A
	RET	Z
	CP	09H
	RET	Z
	CP	' '
	RET	Z
	CP	';'
	RET	Z
	CP	')'
	RET	Z
	CP	','
	RET	Z
	JR	L.SKIP

;-------------------
GET.NO:
	LD	HL,0
	LD	(VAL1),HL
	CALL	GET.NO_ADD
	LD	(VAL1),HL
	OR	A
	RET

GET.NO_ADD:
	CALL	GET.NO_MULT
	LD	A,(IX+0)
	CP	'+'
	JR	NZ,GET.NO_SUB
	INC	IX
	PUSH	HL
	CALL	GET.NO_MULT
	POP	DE
	ADD	HL,DE
	JR	GET.NO_ADD+3
GET.NO_SUB:
	CP	'-'
	RET	NZ
	INC	IX
	PUSH	HL
	CALL	GET.NO_MULT
	POP	DE
	EX	DE,HL
	OR	A
	SBC	HL,DE
	JR	GET.NO_ADD+3
;
;
GET.NO_MULT:
	CALL	GET.NO_FACT
	LD	A,(IX+0)
	CP	'*'
	JR	NZ,GET.NO_DIV
	INC	IX
	PUSH	HL
	CALL	GET.NO_FACT
	POP	DE
	CALL	MULT_HLDE
	JR	GET.NO_MULT+3
GET.NO_DIV:
	CP	'/'
	RET	NZ
	INC	IX
	PUSH	HL
	CALL	GET.NO_FACT
	EX	DE,HL
	POP	HL
	CALL	DIV_HLDE
	JR	GET.NO_MULT+3


GET.NO_FACT:
	LD	A,(IX+0)
	CP	'+'
	JR	NZ,GET.NO_FACT1
	INC	IX
	JR	GET.NO_FACT2
GET.NO_FACT1:
	CP	'-'
	JR	NZ,GET.NO_FACT2
	INC	IX
	CALL	GET.NO_FACT2
	LD	A,H
	CPL
	LD	H,A
	LD	A,L
	CPL
	LD	L,A
	INC	HL
	RET

GET.NO_FACT2:
	LD	A,(IX+0)
	CP	'{'
	JR	NZ,GET.NO_FACT3
	INC	IX
	CALL	GET.NO_ADD
	LD	A,(IX+0)
	CP	'}'
	JP	NZ,ERR6
	INC	IX
	OR	A
	RET
GET.NO_FACT3:
;	CALL	GET.NO_FACT5
;	RET

GET.NO_FACT5:
	LD	A,(IX+0)
	CP	' '
	JR	NZ,GET.NO_FACT6
	INC	IX
	JR	GET.NO_FACT5

GET.NO_FACT6:

	LD	DE,WORK2+1
GN10:	LD	A,(IX+0)
	CP	27H	;'
	JP	Z,GETN60
	CP	'"'
	JP	Z,GETN60
	CP	'$'
	JP	Z,GETN70

	LD	B,40
GETN05:	LD	A,(IX+0)
	CP	';'
	JR	Z,GETN20
	OR	A
	JR	Z,GETN20
	CP	09H
	JR	Z,GETN20
	CP	' '
	JR	Z,GETN20
	CP	','
	JR	Z,GETN20
	CP	'+'
	JR	Z,GETN20
	CP	'-'
	JR	Z,GETN20
	CP	'*'
	JR	Z,GETN20
	CP	'/'
	JR	Z,GETN20
	CP	')'
	JR	Z,GETN20
	CP	'}'
	JR	Z,GETN20
GETN06:	CALL	UPPER
	LD	(DE),A
	INC	IX
	INC	DE
	DJNZ	GETN05
	JP	ERR6
GETN20:	LD	A,' '
	LD	(DE),A
	LD	A,40
	SUB	B
	LD	(WORK2),A
	LD	HL,WORK2+1
	LD	A,(HL)
	CP	'0'
	JP	C,GETN40
	CP	'9'+1
	JP	NC,GETN40
	XOR	A
	LD	(DE),A
	DEC	DE
	LD	A,(DE)
	CP	'H'
	LD	HL,0000H
	JR	NZ,GETN24
	XOR	A
	LD	(DE),A
	LD	DE,WORK2+1
GETN21:	LD	A,(DE)
	OR	A
	JP	Z,GETN55
	CP	'A'
	JR	C,GETN22
	SUB	7
GETN22:	SUB	'0'
	ADD	HL,HL
	JP	C,ERR7
	ADD	HL,HL
	JP	C,ERR7
	ADD	HL,HL
	JP	C,ERR7
	ADD	HL,HL
	JP	C,ERR7
	LD	B,0
	LD	C,A
	ADD	HL,BC
	JP	C,ERR7
	INC	DE
	JR	GETN21

GETN24:	CP	'B'
	JR	NZ,GETN28
	XOR	A
	LD	(DE),A
	LD	DE,WORK2+1
	LD	HL,0000H
GETN25:	LD	A,(DE)
	OR	A
	JR	Z,GETN55
	SUB	'0'
	CP	2
	JP	NC,ERR7	;Number error
	ADD	HL,HL
	JP	C,ERR7
	LD	B,0
	LD	C,A
	ADD	HL,BC
	JP	C,ERR7
	INC	DE
	JR	GETN25

GETN28:	LD	DE,WORK2+1
	LD	HL,0000H
GETN29:	LD	A,(DE)
	OR	A
	JR	Z,GETN55
	CP	'9'+1
	JP	NC,ERR7	;Number error
	SUB	'0'
	ADD	HL,HL
	JP	C,ERR7
	LD	B,H
	LD	C,L
	ADD	HL,HL
	JP	C,ERR7
	ADD	HL,HL
	JP	C,ERR7
	ADD	HL,BC
	JP	C,ERR7
	LD	B,0
	LD	C,A
	ADD	HL,BC
	JP	C,ERR7
	INC	DE
	JR	GETN29

GETN40:	LD	HL,WORK2
	LD	(PNT2),HL
	LD	HL,(VAL1)
	PUSH	HL
	CALL	SRCHL
	JP	NC,GET45
	LD	A,(PASS)
	DEC	A
	JP	NZ,ERR9
GET45:	LD	DE,(VAL1)
	POP	HL
	LD	(VAL1),HL
	EX	DE,HL
	JR	GETN50

GETN55:

GETN50:	
	OR	A
	RET

GETN60:	LD	C,A	;' or "
	INC	IX
	LD	HL,0
	LD	A,(IX+0)
	CP	C
	JP	Z,ERR7
;	CP	20H
;	JP	C,ERR7
	CP	7FH
	JP	Z,ERR7
	LD	H,A
	INC	IX
	LD	A,(IX+0)
	CP	C
	JR	Z,GETN66
	LD	L,A
	INC	IX
	LD	A,(IX+0)
	CP	C
	JP	NZ,ERR6
GETN65:	INC	IX
	JR	GETN50

GETN66:	LD	L,H
	LD	H,0
	JR	GETN65

GETN70:	INC	IX
	LD	HL,(O.ADR1)
	JR	GETN50

;--------------------

SET.LBL:
	LD	(LBL.PNT.NEXT),DE

	LD	A,(PASS)
	DEC	A
	JP	NZ,SET.LBL50

	LD	A,(WORK1)
	DEC	A
	LD	A,(WORK1+1)
	JR	Z,GET.LBL05
	LD	C,A
	LD	A,(WORK1+2)
	XOR	C
GET.LBL05:
	LD	B,0
	LD	C,A
	SLA	C
	RL	B
	LD	HL,LBL.PNT.TOP
	ADD	HL,BC
	LD	A,(HL)
	INC	HL
	LD	H,(HL)
	OR	H
	JR	NZ,SET.LBL10

	LD	HL,LBL.PNT.TOP
	ADD	HL,BC
	LD	(HL),E
	INC	HL
	LD	(HL),D
	JR	SET.LBL20

SET.LBL10:
	LD	HL,LBL.PNT
	ADD	HL,BC
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	INC	DE
	PUSH	HL
	LD	HL,(LBL.PNT.NEXT)
	LD	A,L
	LD	(DE),A
	INC	DE
	LD	A,H
	LD	(DE),A
	POP	HL

SET.LBL20:

	LD	HL,LBL.PNT
	ADD	HL,BC
	LD	DE,(LBL.PNT.NEXT)
	LD	(HL),E
	INC	HL
	LD	(HL),D

SET.LBL50:
	LD	HL,WORK1
	LDI
	LD	A,(PASS)
	DEC	A
	JR	Z,SET.LBL60
	INC	DE
	INC	DE
	JR	SET.LBL70
SET.LBL60:
	XOR	A
	LD	(DE),A
	INC	DE
	LD	(DE),A
	INC	DE
SET.LBL70:
	LD	A,(WORK1)
	LD	B,0
	LD	C,A
	INC	BC
	INC	BC
	LDIR
	RET
;
;
;
SRCHL:	PUSH	HL
	PUSH	DE
	PUSH	BC
	LD	DE,(PNT2)
	LD	A,(DE)
	INC	DE
	DEC	A
	LD	A,(DE)
	JR	Z,SRCHL.05
	LD	C,A
	INC	DE
	LD	A,(DE)
	DEC	DE
	XOR	C
SRCHL.05:
	LD	B,0
	LD	C,A
	LD	HL,LBL.PNT.TOP
	ADD	HL,BC
	ADD	HL,BC
	LD	A,(HL)
	INC	HL
	LD	H,(HL)
	LD	L,A
	OR	H
	JP	Z,SRCHL4
SRCHL1:
	LD	DE,(PNT2)
	LD	A,(DE)
	CP	(HL)
	PUSH	HL
	PUSH	AF
	INC	DE
	INC	HL
	LD	C,(HL)
	INC	HL
	LD	B,(HL)
	INC	HL
	LD	(LBL.PNT.NEXT),BC
	POP	AF
	JR	NZ,SRCHL3
	LD	B,A
SRCHL2:	LD	A,(HL)
	EX	DE,HL
	CP	(HL)
	EX	DE,HL
	JP	NZ,SRCHL3
	INC	HL
	INC	DE
	DJNZ	SRCHL2

	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	LD	(VAL1),DE
	POP	HL
	LD	(PNT2),HL
	POP	BC
	POP	DE
	POP	HL
	OR	A	;CY=0 .. found
	RET
SRCHL3:
	POP	HL

	LD	HL,(LBL.PNT.NEXT)
	LD	A,H
	OR	L
	JR	Z,SRCHL4
	JP	SRCHL1
SRCHL4:	
	POP	BC
	POP	DE
	POP	HL
	SCF		;CY=1 .. not found
	RET

;------------------------

GETLIN:	LD	HL,L.DATA
	LD	B,0	;tab-flg
	LD	C,0	;count
GETL02:	PUSH	HL
	PUSH	BC
	CALL	GETCHR
	POP	BC
	POP	HL
	JP	C,GETL25
;	CP	09H
;	JP	NZ,GETL10
	JR	GETL10		;**

	BIT	0,B
	JR	NZ,GETL10
	LD	A,' '
GETL10:	LD	(HL),A
	INC	C
	JP	Z,ERRD	;too long line
	CP	27H+1
	JR	C,GETL13
GETL12:	INC	HL
	JP	GETL02
GETL13:
;	CP	'"'
;	JR	Z,GETL15
;	CP	27H
;	JR	Z,GETL15
	CP	0DH
	JR	Z,GETL20
	CP	1AH
	JP	Z,GETL30
	JR	GETL12
GETL15:	BIT	0,B
	JR	NZ,GETL16
	LD	(QUOTATION),A
	DEC	B
	LD	(HL),A
	INC	HL
	JR	GETL02
GETL16:	LD	B,A
	LD	A,(QUOTATION)
	CP	B
	JR	Z,GETL17
	LD	A,B
	LD	(HL),A
	INC	HL
	LD	B,0FFH
	JR	GETL02
GETL17:	LD	B,00H
	LD	(HL),A
	INC	HL
	JP	GETL02
GETL20:	LD	(HL),00H
	CALL	GETCHR
	RET
GETL25:	LD	(HL),1AH
GETL30:	INC	HL
	LD	(HL),00H
	RET

;------------------------

GETCHR:	LD	HL,(S.LEFT)
	LD	A,H
	OR	L
	JR	Z,GETC10
	DEC	HL
	LD	(S.LEFT),HL
	LD	HL,(S.PNT)
	LD	A,(HL)
	INC	HL
	LD	(S.PNT),HL
	OR	A
	RET
GETC10:	LD	A,(FL.END)
	OR	A
	JR	NZ,GETC20
GETC12:	LD	DE,USRDMA
	LD	(S.PNT),DE
	LD	C,1AH
	CALL	0005H
	LD	DE,(FCB)
	LD	HL,R.BUF
	LD	C,27H
	CALL	0005H
	LD	(S.LEFT),HL
	LD	(FL.END),A
	JP	GETCHR
GETC20:	CALL	FCBDEC
	RET	C
	JR	GETC12
;
;
;
PUTCHR:	LD	C,A
	LD	HL,(W.LEFT)
	LD	A,H
	OR	L
	JR	Z,PUTC10
	DEC	HL
	LD	(W.LEFT),HL
	LD	HL,(W.PNT)
	LD	(HL),C
	INC	HL
	LD	(W.PNT),HL
	RET
PUTC10:	LD	DE,USRDMA+R.BUF
	LD	(W.PNT),DE
	CALL	DOS1A
	LD	DE,FILE2
	LD	HL,W.BUF
	LD	(W.LEFT),HL
	CALL	DOS26
	JP	Z,PUTCHR+1
	JP	ERR3	;write err
;
;
;
FCBDEC:	LD	A,(LOAD.F)
	SUB	1
	RET	C
	LD	(LOAD.F),A
	LD	HL,(FCB)
	LD	DE,0025H+2
	OR	A
	SBC	HL,DE
	LD	(FCB),HL
	LD	DE,25H
	ADD	HL,DE
	LD	A,(HL)
	INC	HL
	LD	H,(HL)
	LD	L,A
	LD	(LIN.NO),HL
	LD	HL,0
	LD	(S.LEFT),HL
	XOR	A
	LD	(FL.END),A
	OR	A
	RET
;
;
;
PUTH2:	LD	A,H
	CALL	PUTH1
	LD	A,L
	CALL	PUTH1
	RET
;
;
;
PUTH1:	PUSH	AF
	RRCA
	RRCA
	RRCA
	RRCA
	CALL	PUTHX
	POP	AF
PUTHX:	AND	0FH
	CP	10
	JR	C,PUTHX1
	ADD	A,7
PUTHX1:	ADD	A,'0'
	CALL	DOS02
	RET
;
;
;
CRLF:	LD	A,0DH
	CALL	DOS02
	LD	A,0AH
	CALL	DOS02
	RET
;
;
;
PUTDC:	PUSH	IX
	LD	IX,WORKDC
	LD	BC,10000
	CALL	PUTDC5
	LD	BC,1000
	CALL	PUTDC5
	LD	BC,100
	CALL	PUTDC5
	LD	BC,10
	CALL	PUTDC5
	LD	A,L
	ADD	A,'0'
	LD	(IX+0),A
	LD	A,'$'
	LD	(WORKDC+5),A
	LD	DE,WORKDC
	LD	B,4
PUTDC1:	LD	A,(DE)
	CP	'0'
	JR	NZ,PUTDC2
	INC	DE
	DJNZ	PUTDC1
PUTDC2:	CALL	DOS09
	POP	IX
	RET

PUTDC5:	LD	E,-1
	OR	A
PUTDC6:	INC	E
	SBC	HL,BC
	JR	NC,PUTDC6
	ADD	HL,BC
	LD	A,E
	ADD	A,'0'
	LD	(IX+0),A
	INC	IX
	RET
;
;
;
UPPER:	CP	'a'
	RET	C
	CP	'z'+1
	RET	NC
	SUB	20H
	RET

;---------------------

MULT_HLDE:
	LD	B,D
	LD	C,E
	EX	DE,HL
	LD	HL,0000H
MULT_HLDE1:
	LD	A,B
	OR	C
	RET	Z
	SRL	B
	RR	C
	JR	NC,MULT_HLDE5
	ADD	HL,DE
MULT_HLDE5:
	SLA	E
	RL	D
	JR	MULT_HLDE1
;
;
;
DIV_HLDE:
	LD	B,D
	LD	C,E
	EX	DE,HL
	LD	HL,0000H
	LD	A,16
DIV_HLDE1:
	SLA	E
	RL	D
	ADC	HL,HL
	SBC	HL,BC
	JR	C,DIV_HLDE2
	INC	E
	JR	DIV_HLDE3
DIV_HLDE2:
	ADD	HL,BC
DIV_HLDE3:
	DEC	A
	JR	NZ,DIV_HLDE1
	EX	DE,HL
	RET
;
;
;
DOS02:	PUSH	IX
	PUSH	IY
	PUSH	HL
	PUSH	DE
	PUSH	BC
	PUSH	AF
	LD	C,02H
	LD	E,A
	CALL	0005H
	POP	AF
	POP	BC
	POP	DE
	POP	HL
	POP	IY
	POP	IX
	RET

DOS09:	PUSH	IX
	PUSH	IY
	PUSH	HL
	PUSH	DE
	PUSH	BC
	PUSH	AF
	LD	C,09H
	CALL	0005H
	POP	AF
	POP	BC
	POP	DE
	POP	HL
	POP	IY
	POP	IX
	RET

DOS0F:	PUSH	IX
	PUSH	IY
	PUSH	HL
	PUSH	DE
	PUSH	BC
	LD	C,0FH
	CALL	0005H
	POP	BC
	POP	DE
	POP	HL
	POP	IY
	POP	IX
	OR	A
	RET

DOS10:	PUSH	IX
	PUSH	IY
	PUSH	HL
	PUSH	DE
	PUSH	BC
	LD	C,10H
	CALL	0005H
	POP	BC
	POP	DE
	POP	HL
	POP	IY
	POP	IX
	OR	A
	RET

DOS11:	PUSH	IX
	PUSH	IY
	PUSH	HL
	PUSH	DE
	PUSH	BC
	LD	C,11H
	CALL	0005H
	POP	BC
	POP	DE
	POP	HL
	POP	IY
	POP	IX
	OR	A
	RET

DOS13:	PUSH	IX
	PUSH	IY
	PUSH	HL
	PUSH	DE
	PUSH	BC
	LD	C,13H
	CALL	0005H
	POP	BC
	POP	DE
	POP	HL
	POP	IY
	POP	IX
	OR	A
	RET

DOS16:	PUSH	IX
	PUSH	IY
	PUSH	HL
	PUSH	DE
	PUSH	BC
	LD	C,16H
	CALL	0005H
	POP	BC
	POP	DE
	POP	HL
	POP	IY
	POP	IX
	OR	A
	RET

DOS1A:	PUSH	IX
	PUSH	IY
	PUSH	HL
	PUSH	DE
	PUSH	BC
	PUSH	AF
	LD	C,1AH
	CALL	0005H
	POP	AF
	POP	BC
	POP	DE
	POP	HL
	POP	IY
	POP	IX
	RET

DOS26:	PUSH	IX
	PUSH	IY
	PUSH	HL
	PUSH	DE
	PUSH	BC
	LD	C,26H
	CALL	0005H
	POP	BC
	POP	DE
	POP	HL
	POP	IY
	POP	IX
	OR	A
	RET

DOS27:	PUSH	IX
	PUSH	IY
	PUSH	DE
	PUSH	BC
	LD	C,27H
	CALL	0005H
	POP	BC
	POP	DE
	POP	IY
	POP	IX
	OR	A
	RET



HELP:
	LD	DE,MES_HELP
	LD	C,09H
	CALL	0005H
	JP	0000H

ERR0:	LD	DE,EMES0
	JP	ERR_STOP

ERR1:	LD	DE,EMES1
	JP	ERR_STOP

ERR2:	LD	DE,EMES2
	JP	ERR_STOP

ERR3:	LD	DE,EMES3
	JP	ERR_STOP

ERR4:	LD	DE,EMES4
	JP	ERR_CONT

ERR5:	LD	DE,EMES5
	JP	ERR_CONT

ERR6:	LD	DE,EMES6
	JP	ERR_CONT

ERR7:	LD	DE,EMES7
	JP	ERR_CONT

ERR8:	LD	DE,EMES8
	JP	ERR_STOP

ERR9:	LD	DE,EMES9
	JP	ERR_CONT

ERRA:	LD	DE,EMESA
	JP	ERR_CONT

ERRB:	LD	DE,EMESB
	JP	ERR_CONT

ERRC:	LD	DE,EMESC
	JP	ERR_STOP

ERRD:	LD	DE,EMESD
	JP	ERR_STOP
;
;
;
ERR_STOP:
	CALL	ERRSUB
	LD	A,(FLAG_FILE2)
	OR	A
	JR	Z,ERR_STOP.10

	LD	DE,FILE2
	CALL	DOS10

ERR_STOP.10:
	JP	0000H

ERR_CONT:
	CALL	ERRSUB
	LD	SP,(STACK)
	JP	MAIN50
;
;
;
ERRSUB:
	PUSH	DE
	LD	HL,(FCB)
	INC	HL
	LD	B,8
	LD	A,'['
	CALL	DOS02
ERRSUB1:
	LD	A,(HL)
	INC	HL
	CALL	DOS02
	DJNZ	ERRSUB1
	LD	A,'.'
	CALL	DOS02
	LD	B,3
ERRSUB2:
	LD	A,(HL)
	INC	HL
	CALL	DOS02
	DJNZ	ERRSUB2
	LD	A,']'
	CALL	DOS02

	LD	A,' '
	CALL	DOS02

	LD	HL,(LIN.NO)
	CALL	PUTDC
	LD	A,':'
	CALL	DOS02
	POP	DE
	CALL	DOS09
	LD	A,' '
	CALL	DOS02
	CALL	PUTLIN
	CALL	CRLF
	RET

EMES0:	DEFM	'Read file open error$'
EMES1:	DEFM	'Read file read error$'
EMES2:	DEFM	'Write file make error$'
EMES3:	DEFM	'Write file write error$'
EMES4:	DEFM	'Label error$'
EMES5:	DEFM	'Multiply Defined label$'
EMES6:	DEFM	'Format error$'
EMES7:	DEFM	'Number error$'
EMES8:	DEFM	'Label table full$'
EMES9:	DEFM	'Undefined label$'
EMESA:	DEFM	'Reference error$'
EMESB:	DEFM	'Operand error$'
EMESC:	DEFM	'Include error$'
EMESD:	DEFM	'Too long line$'

MES1:	DEFM	'==== Z-80A Self Assembler ===='
	DEFB	0DH,0AH
	DEFM	'       Programed by djnz80a'
	DEFB	0DH,0AH,'$'
MES2:	DEFM	'Pass...$'

MES_HELP:
	DB	0DH,0AH
	DB	'ASM1 <source> [<output>] [options]',0DH,0AH
	DB	'options:',0DH,0AH
	DB	' /B .. create bsave/bload file(.OBJ)',0DH,0AH
	DB	' /l .. output label values (.LBL)',0DH,0AH
	DB	'$'

;-----
WORK:

PASS:	DEFS	1

LIN.NO:	DEFS	2
LBL.NO:	DEFS	2
LBL.NX:	DEFS	2
ERR.NO:	DEFS	2

ORG.ADR:DEFS	2
O.ADR1:	DEFS	2
O.ADR2:	DEFS	2
O.BYTE:	DEFS	2

FLG.1:	DEFS	1
FLG.2:	DEFS	1
FLG.3:	DEFS	1

S.LEFT:	DEFS	2
S.PNT:	DEFS	2
FL.END:	DEFS	1

W.LEFT:	DEFS	2
W.PNT:	DEFS	2

PNT:	DEFS	2
PNT2:	DEFS	2

VAL1:	DEFS	2
VAL2:	DEFS	2

F.TYPE:	DEFS	1

L.DATA:	DEFS	260
TABFLG:	DEFS	1

;SGN:	DEFS	1
LEN:	DEFS	1
WORK1:	DEFS	80
WORK2:	DEFS	80
WORKDC:	DEFS	6

FLAG_FILE2:DB	00H

LOAD.F:	DEFS	2	;including file no.
FCB:	DEFS	2	;pointer to fcb
FILE2:	DEFS	25H	;write file
FILE1:	DEFS	27H	;read file
	DEFS	270H	;for 16 files

STACK:	DS	2

QUOTATION:
	DS	1

LBL.PNT.NEXT:
	DS	2

LBL.PNT.TOP:
	DS	100H*2

LBL.PNT:
	DS	100H*2

USRDMA:

	END
