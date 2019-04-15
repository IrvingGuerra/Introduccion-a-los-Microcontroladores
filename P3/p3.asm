	.include "m8535def.inc"

;Declaracion de registros
	.def datoA = R17
	.def datoB = R18

	ser datoA
	ser datoB

	out ddra,datoA
	out ddrc,datoB
	out portb,datoB
	
	ldi r20,$3f
	ldi r21,6
	ldi r22,$5b
	ldi r23,$4f
	ldi r24,$66
	ldi r25,$6d
	ldi r26,$7d
	ldi r27,$27
	ldi r28,$7f
	ldi r29,$6f
	ldi r19,$80

INICIO:
	ldi zl,20
	in datoA, pinb
	in datoB, pinb
	swap datoB
	andi datoA,$0f
	andi datoB,$0f

	cpi datoA,10
	brsh ESMAYORA
	add zl,datoA
	ld datoA,z
	out porta,datoA
	rjmp SIGUEB
ESMAYORA:
	dec zl
	ld datoA,z
	out porta,datoA
SIGUEB:
	ldi zl,20
	cpi datoB,10
	brsh ESMAYORB
	add zl,datoB
	ld datoB,z
	out portc,datoB
	rjmp INICIO
ESMAYORB:
	ldi zl,19
	ld datoB,z
	out portc,datoB
	rjmp INICIO
