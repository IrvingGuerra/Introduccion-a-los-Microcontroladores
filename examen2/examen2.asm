	.include "m8535def.inc"
;Declaracion de registros
	.def aux = R16
	.def cont = R17
	.def SegundaParte = R18
	.def ParteFinal = R19
;De definen direcciones main y de interrupcion
	rjmp main
	rjmp actionINT0 	;Vector Int0
	.org $008
	rjmp actionTMR1		;Vector timer1
	rjmp actionTMR0		;Vector timer0
main:
	//Definiciones para la pila
	ldi aux, low(RAMEND)
	out spl, aux
	ldi aux, high(RAMEND)
	out sph, aux
	//Ponemos A como salidas y C
	ldi aux,0b11111111
	out ddra, aux
	out ddrc, aux
	//Ponemos D Y B como entradas
	ldi aux,0b00000000
	out ddrb, aux
	out ddrd, aux
	//Pull-ups de D Y B
	ldi aux,0b11111111
	out portb, aux
	out portd, aux
	//Definicion de interrupcioones
	ldi aux,4 		;preescala 1024
	out TCCR0, aux
	ldi aux,253
	out TCNT0, aux

	ldi aux,4
	out TCCR1B, aux; preescala ck/256 para 5 Segs
	ldi aux, $B3
	out TCNT1H, aux	
	ldi aux, $B5
	out TCNT1L, aux

	//AQUI SOLO ACTIVO LAS INTERRUPCIONES RAPIDAS
	ldi aux, 0b00000001
	out TIMSK, aux; toie0	
	ldi aux, 0b00000010
	out mcucr, aux
	ldi aux, 0b01000000
	out gicr, aux
	sei
	clr zh
	clr cont
	clr SegundaParte
	clr ParteFinal



;Inicio del Programa
INICIO:
	out portc, cont
	rjmp INICIO





;Interrupciones





//INTERRUPCION BOTON
actionINT0:

//Parte final
	SBRS ParteFinal,0
	rjmp aFinalNO
	rjmp aFinalYES

aFinalNO:
//Primera parte
	SBRS SegundaParte,0
	rjmp aFirst
	rjmp aSecond
aFirst:
	clr cont
	sbi porta,0 //Prende LED rojo
	rcall activa5segs
	reti
aSecond:
	clr cont
	sbi porta,0 //Prende LED rojo
	rcall activa5segs
	reti
aFinalYES:
	reti
	





//INTERRUPCION 5 SEGS
actionTMR1:

//Parte Final

	SBRS ParteFinal,0
	rjmp bFinalNO
	rjmp bFinalYES

bFinalNO:
//Primera parte
	SBRS SegundaParte,0
	rjmp bFirst
	rjmp bSecond

bFirst:
	clr cont
	cbi porta,0	//Apagamos LED1
	rcall desactiva5segs
	reti

bSecond:
	clr cont
	sbi porta,1
	cbi porta,0
	rcall desactiva5segs
	reti

bFinalYES:
	clr cont
	cbi porta,1
	rcall desactiva5segs
	reti






//INTERRUPCION RAPIDA 
actionTMR0:

//Parte Final

	SBRS ParteFinal,0
	rjmp cFinalNO
	rjmp cFinalYES

cFinalNO:

//Primera Parte

	SBRS SegundaParte,0
	rjmp cFirst
	rjmp cSecond

cFirst:
	sbis porta,0 //Pregunta si led esta activado
	rjmp LED1down
	rjmp LED1up

LED1up:
	//Preguntaremos si ya se hicieron 3 pulsaciones para pasar a la segunda parte
	CPI cont,6
	brsh es3
	rjmp noes3

noes3:
	sbis pinb, 0
	rjmp ISpress
	rjmp ISunpress
ISpress:
	out portc, cont
	sbis portc,0
	inc cont
	reti
ISunpress:
	out portc, cont
	sbic portc,0
	inc cont
	reti

es3:
	inc SegundaParte
	rjmp actionTMR1
	reti

LED1down:
	reti


cSecond:
	sbis porta,0 //Pregunta si led esta activado
	rjmp bLED1down
	rjmp bLED1up

bLED1up:
	//Preguntaremos si ya se hicieron 3 pulsaciones para pasar a la segunda parte
	CPI cont,6
	brsh bes3
	rjmp bnoes3

bnoes3:
	sbis pinb, 0
	rjmp bISpress
	rjmp bISunpress
bISpress:
	out portc, cont
	sbis portc,0
	inc cont
	reti
bISunpress:
	out portc, cont
	sbic portc,0
	inc cont
	reti

bes3:
	inc ParteFinal
	rjmp actionTMR1
	reti

bLED1down:
	reti

	

cFinalYES:
	reti




;SUBRUTINAS

activa5segs:
	ldi aux,4
	out TCCR1B, aux
	ldi aux, $B3
	out TCNT1H, aux	
	ldi aux, $B5
	out TCNT1L, aux
	ldi aux, 0b00000101
	out TIMSK, aux
	ret

desactiva5segs:
	ldi aux, 0b00000001
	out TIMSK, aux
	reti
