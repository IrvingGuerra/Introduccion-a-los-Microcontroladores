	.include "m8535def.inc"
;Declaracion de macros
.macro ldb
	ldi r16,@1
	mov @0,r16
.endm
;Declaracion de registros
	.def adl = r17
	.def adh = r18
	.def col = r19
	.def dato = r20
	.def cont = r21
	.def firstTIME = r22
;De definen direcciones main y de interrupcion
	rjmp	main
	.org	$009
	rjmp	shift
	.org	$0E
	rjmp	conversion
main:
//Definiciones para la pila
    ldi r16,low(RAMEND)
	out spl,r16
	ldi r16,high(RAMEND)
	out sph,r16
//Se definen como salidas C y D (SHIFT Y DATO)
	ldi r16,0b11111111
	out ddrc,r16
	out ddrd,r16

//Se configura el ADC
	ldi r16,$ED 	;1110 1101
	out ADCSRA,r16
	ldi r16,$20
	out ADMUX,r16
	sei
//Definicion de interrupcioones
	ldi r16,1
	out TCCR0, r16 ;preescala ck
	ldi r16, 0b00000001
	out TIMSK, r16 ;toie0
	ldi r16, 193 ;para contar 63 4ms
	out mcucr, r16
	ldi r16, 0b00000000
	out gicr, r16
	sei
	clr cont
	clr firstTIME
//CARGAMOS DATO
	ldb r3, 0b01000000 ;-
	ldb r2, 0b01000000 ;N 
	ldb r1, 0b01000000 ;N
	ldb r0, 0b01000000 ;X
//Inicio del Programa
inicio:
	nop
	nop
    rjmp  inicio

conversion:
;Nuestra FORMULA -> (Vin*255)/5Volts /*Ignorando los otros dos bits
	;Numero 1 = 4.10 Volts
	;Que en decimal es: 209.1
	;Entonces, haciendo todas las conversiones...
/*
	1 = 209.1
	2 = 157.59
	3 = 123.42
	4 = 194.82
	5 = 149.43
	6 = 118.32
	7 = 179.01
	8 = 140.25
	9 = 112.71
	0 = 134.64
	* = 170.34
	# = 109.14
	A = 102.51
	B = 99.45
	C = 95.37
	D = 93.33
*/
//Haremos un push, que se encargue de dar el barrel
    in adl,ADCL
	in adh,ADCH	
//Despues de todas las decodificaciones
	CPI adh,10
	BRSH isPressed  //Branch if Same or Higher 
	RJMP isUnPressed
isPressed:
	CPI cont,0
	BREQ zero
	reti
zero:
	CPI adh,209.1
	BREQ es1 	//Branch if Equal
	RJMP noes1
es1:
	mov r7,r0
	ldb r0,0b00000110
	inc cont
	reti
noes1:	
	CPI adh,157.59
	BREQ es2
	RJMP noes2
es2:
	mov r7,r0
	ldb r0,0b01011011 
	inc cont
	reti
noes2:
	CPI adh,123.42
	BREQ es3
	RJMP noes3
es3:
	mov r7,r0
	ldb r0,0b1001111 
	inc cont
	reti
noes3:
	CPI adh,194.82
	BREQ es4
	RJMP noes4
es4:
	mov r7,r0
	ldb r0,0b01100110
	inc cont
	reti
noes4:
	CPI adh,149.43
	BREQ es5
	RJMP noes5
es5:
	mov r7,r0
	ldb r0,0b11101101
	inc cont
	reti
noes5:
	CPI adh,118.32
	BREQ es6
	RJMP noes6
es6:
	mov r7,r0
	ldb r0,0b11111101
	inc cont
	reti
noes6:
	CPI adh,179.01
	BREQ es7
	RJMP noes7
es7:
	mov r7,r0
	ldb r0,0b10000111
	inc cont
	reti
noes7:
	CPI adh,140.25
	BREQ es8
	RJMP noes8
es8:
	mov r7,r0
	ldb r0,0b11111111
	inc cont
	reti
noes8:
	CPI adh,112.71
	BREQ es9
	RJMP noes9
es9:
	mov r7,r0
	ldb r0,0b11101111
	inc cont
	reti
noes9:
	CPI adh,134.64
	BREQ esn0
	RJMP noesn0
esn0:
	mov r7,r0
	ldb r0,0b10111111
	inc cont
	reti
noesn0:
	CPI adh,170.34
	BREQ esas
	RJMP noesas
esas:
	mov r7,r0
	ldb r0,0b01000000
	inc cont
	reti
noesas:
	CPI adh,107.61
	BREQ esagato
	RJMP noesgato
esagato:
	mov r7,r0
	ldb r0,0b01000110
	inc cont
	reti
noesgato:
	CPI adh,105.95
	BREQ esA
	RJMP noesA
esA:
	mov r7,r0
	ldb r0,0b11110111
	inc cont
	reti
noesA:
	CPI adh,103.02
	BREQ esB
	RJMP noesB
esB:
	mov r7,r0
	ldb r0,0b11111100
	inc cont
	reti
noesB:		
	CPI adh,97.92
	BREQ esC
	RJMP noesC
esC:
	mov r7,r0
	ldb r0,0b11011000
	inc cont
	reti
noesC:	
	CPI adh,95.88
	BREQ esD
	RJMP noesD
esD:
	mov r7,r0
	ldb r0,0b11011110
	inc cont
	reti
noesD:	
	reti
isUnPressed:
	CPI cont,1
	BREQ one
	reti
one:
	clr cont
	CPI firstTIME,0
	BREQ esPrimera
	RJMP noEsPrimera
noEsPrimera:
	mov r3,r2
	mov r2,r1
	mov r1,r7
	reti
esPrimera:
	inc firstTIME
	reti
















shift:
	out portd,zh
	inc zl
	lsl col
	brne dos
	ldi col,0b00000001
	clr zl
dos:
	com col
	out portc,col
	com col
	ld dato,z
	out portd,dato
	reti
