	.include "m8535def.inc"
;Declaracion de macros
.macro ldb
	ldi r16,@1
	mov @0,r16
.endm
;Declaracion de registros
	.def col = R17
	.def dato = R18 //(Tambien lo usaremos como Auxiliar)
;De definen direcciones main y de interrupcion
	//Definiciones para la pila
	ldi dato, low(RAMEND)
	out spl, dato
	ldi dato, high(RAMEND)
	out sph, dato
	//Ponemos C Y B como salidas
	ldi dato,0b11111111
	out ddrc, dato
	out ddra, dato
	//Declaramos D como entradas por las interrupciones
	ldi dato,0b00000000
	out ddrd, dato
	//Activamos pull-ups
	ldi dato,0b11111111
	out portb, dato
	sei
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
	clr zl
	ldi col,1
dos:
	com col
	out portc,col
	com col
	ld dato,z+
	out porta,dato
	rcall delay
	out porta,zh
	lsl col
	brcc dos
	rjmp INICIO
;Subrutinas

delay:	

; ============================= 
;    delay loop generator 
;     2000 cycles:
; ----------------------------- 
; delaying 1998 cycles:
          ldi  R20, $03
WGLOOP0:  ldi  R21, $DD
WGLOOP1:  dec  R21
          brne WGLOOP1
          dec  R20
          brne WGLOOP0
; ----------------------------- 
; delaying 2 cycles:
          nop
          nop
; ============================= 

	ret
