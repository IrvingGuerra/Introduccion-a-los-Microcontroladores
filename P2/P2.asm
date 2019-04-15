;ddr definen e/s internas  port definen fisicamente	
	
	.include "m8535def.inc"
	ldi r16,0b00001111
	out ddra,r16		
	ldi r18,0b11110000
	out porta,r18

;;DEFINIENDO EL VALOR DE ENTRADA
	ldi r19,0b00000000
	out ddrb,r19
	ldi r20,0b11111111
	out portb,r20
;;------------------------------
;;DEFINIR PUERTOS DE SALIDA, NEGATIVO Y POSITVO
	ldi r21,0b11111111
	out ddrc,r21
	out ddrd,r21
;;------------------------------


;;MAIN
again:
;;RECIBE Y ENTREGA COMPLEMENTO
	in r17,pina
	swap r17
	com r17
	ori r17,0b11110000
	out porta,r17
;;----------------------------
;;RECIBE DATO
	in r23,pinb
	tst r23
	brmi negativo
	out portc,r23
	clr r25
	out portd,r25
	rjmp again
negativo:
	out portd,r23
	clr r24
	out portc,r24
	rjmp again
