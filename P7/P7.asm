	.include "m8535def.inc"
;Declaracion de macros
.macro ldb
	ldi r16,@1
	mov @0,r16
.endm
;Declaracion de registros
	.def col = R17
	.def dato = R18
;De definen direcciones main y de interrupcion
	rjmp main
	rjmp dato1 ;Vector Int0
	rjmp dato2 ;Vector Int1
	.org $008
	rjmp desplazamiento ;Vector timer1
	rjmp shift			;Vector timer0
	.org $012
	rjmp stop ;Vector INT2

main:
	//Definiciones para la pila
	ldi dato, low(RAMEND)
	out spl, dato
	ldi dato, high(RAMEND)
	out sph, dato
	//Ponemos C Y A como salidas
	ldi dato,0b11111111
	out ddrc, dato
	out ddra, dato
	//Declaramos D como entradas por las interrupciones
	ldi dato,0b00000000
	out ddrd, dato
	out ddrb, dato
	//Definicion de interrupcioones
	ldi dato,1
	out TCCR0, dato; preescala ck
	ldi dato,2
	out TCCR1B, dato; preescala ck/8
	ldi dato, 0b00000101
	out TIMSK, dato; toie0
	ldi r18, 193; para contar 63 4ms
	ldi dato, 0b00001010
	out mcucr, dato
	ldi dato, 0b11100000
	out gicr, dato
	sei

	//Se carga el dato de una vez.
			; hgfedcba	
	ldb r7, 0b01111001 ;E
	ldb r6, 0b01101101 ;S
	ldb r5, 0b00111001 ;C
	ldb r4, 0b00111111 ;O
	ldb r3, 0b00110111 ;N
	ldb r2, 0b00110111 ;N 
	ldb r1, 0b01011011 ;2
	ldb r0, 0b01101101 ;5
	clr zh
;Inicio del Programa
INICIO:
	nop
	nop
	rjmp INICIO

;Interrupciones

shift:
	out porta,zh
	inc zl
	lsl col
	brne dos; si z = 0
	ldi col,0b00000001
	clr zl
dos:
	com col
	out portc,col
	com col
	ld dato,z
	out porta,dato
	reti

desplazamiento:
	mov r8,r7
	mov r7,r6
	mov r6,r5
	mov r5,r4
	mov r4,r3
	mov r3,r2
	mov r2,r1
	mov r1,r0
	mov r0,r8
	reti

stop:
	push dato
	push col
	in dato,timsk
	ldi col,$04
	eor dato,col
	out timsk,dato
	pop col
	pop dato
	reti


dato1:
			; hgfedcba	
	ldb r7, 0b01000000 ;-
	ldb r6, 0b00000110 ;I
	ldb r5, 0b01110011 ;P
	ldb r4, 0b00110111 ;N
	ldb r3, 0b01000000 ;-
	ldb r2, 0b00110111 ;N 
	ldb r1, 0b00110111 ;N
	ldb r0, 0b01110110 ;X
	reti

dato2:
			; hgfedcba	
	ldb r7, 0b01000000 ;-
	ldb r6, 0b00111110 ;U
	ldb r5, 0b01110011 ;P
	ldb r4, 0b00000110 ;I
	ldb r3, 0b00000110 ;I
	ldb r2, 0b01111000 ;T 
	ldb r1, 0b01110111 ;A
	ldb r0, 0b01000000 ;-
	reti


