
	.include "m8535def.inc"
;Declaracion de macros
.macro ldb
	ldi r16,@1
	mov @0,r16
.endm

	.macro pulso
	sbi portb,0
	ldi aux,@0
loop1:
	rcall delay
	dec aux
	brne loop1
	cbi portb,0
	ldi aux,@1
loop2:
	rcall delay
	dec aux
	brne loop2
	rjmp INICIO
	.endm


.macro pulso2
	ldi aux,@0
loop1:
	sbi portb,0
	rcall delay
	cbi portb,0
	rcall delay
	dec aux
	brne loop1
	cbi portb,0
	ldi aux,@1
loop2:
	rcall delay
	dec aux
	brne loop2
	rjmp INICIO
	.endm


;Declaracion de registros
	.def col = R17
	.def dato = R18
	.def aux = r19
;De definen direcciones main y de interrupcion
	rjmp main
	.org $009
	rjmp shift			;Vector timer0

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
	out ddrb, dato
	//Declaramos D como entradas por los cambios de pulso
	ldi dato,0b00000000
	out ddrd, dato
	//PULLUPS
	ldi dato,0b11111111
	out portd, dato
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
	ldb r7, 0b00111111 ;0
	ldb r6, 0b01111101 ;G
	ldb r5, 0b01010000 ;r
	ldb r4, 0b01110111 ;A
	ldb r3, 0b01011110 ;d
	ldb r2, 0b00111111 ;0
	ldb r1, 0b01101101 ;s
	ldb r0, 0b01000000 ;-
	clr zh
;Inicio del Programa
INICIO:
	sbis pind,5
	rjmp cero
	sbis pind,6
	rjmp uno
	sbis pind,7
	rjmp dos
	rjmp INICIO
cero:
    		; hgfedcba	
	ldb r7, 0b00111111 ;0
	ldb r6, 0b01111101 ;G
	ldb r5, 0b01010000 ;r
	ldb r4, 0b01110111 ;A
	ldb r3, 0b01011110 ;d
	ldb r2, 0b00111111 ;0
	ldb r1, 0b01101101 ;s
	ldb r0, 0b01000000 ;-

	pulso 1,1
uno:
	ldb r7, 0b01100111 ;9
	ldb r6, 0b00111111 ;0
	ldb r5, 0b01111101 ;G
	ldb r4, 0b01010000 ;r
	ldb r3, 0b01110111 ;A
	ldb r2, 0b01011110 ;d
	ldb r1, 0b00111111 ;0
	ldb r0, 0b01101101 ;s
	pulso 20,20
dos:
	ldb r7, 0b00000110 ;1
	ldb r6, 0b01111111 ;8
	ldb r5, 0b00111111 ;0
	ldb r4, 0b01111101 ;G
	ldb r3, 0b01010000 ;r
	ldb r2, 0b01110111 ;A
	ldb r1, 0b01011110 ;d
	ldb r0, 0b00111111 ;0
	
	pulso2 20,20

;Interrupciones

delay:
; ============================= 
;    delay loop generator 
;     500 cycles:
; ----------------------------- 
; delaying 498 cycles:
    ldi  R20, $A6
WGLOOP0:
	dec  R20
    brne WGLOOP0
; ----------------------------- 
; delaying 2 cycles:
    nop
    nop
; ============================= 
	ret

shift:
	out porta,zh
	inc zl
	lsl col
	brne dosS; si z = 0
	ldi col,0b00000001
	clr zl
dosS:
	com col
	out portc,col
	com col
	ld dato,z
	out porta,dato
	reti
