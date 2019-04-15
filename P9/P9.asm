	.include "m8535def.inc"
;Declaracion de registros
	.def adl = r17
	.def adh = r16
	.def MINIMO = r18
	.def MAXIMO = r19
;De definen direcciones main y de interrupcion
	rjmp	main
	.org	$0E
	rjmp	conversion
main:
//Definiciones para la pila
    ldi r16,low(RAMEND)
	out spl,r16
	ldi r16,high(RAMEND)
	out sph,r16
//Se definen como salidas B,C y D
	ldi r16,0b11111111
	out ddrb,r16
	out ddrc,r16
	out ddrd,r16
//Y se define A como entrada

//Ponemos MAXIMO con 0 y MINIMO con 1
	ldi MINIMO,0b11111111
	ldi MAXIMO,0b00000000

//Se configura el ADC
	ldi r16,$ED 	;1110 1101
	out ADCSRA,r16
	ldi r16,$20
	out ADMUX,r16
	sei

//Inicio del Programa
inicio:
	out portb,adh
	out portc,MINIMO
	out portd,MAXIMO
    rjmp  inicio

conversion:
    IN adl,ADCL
	IN adh,ADCH
	;//Preguntamos si el dato ingresado es mas minimo que 111111
	CP adh,MINIMO //COMPARE = CP
	BRLO esmenor //Branch if Lower
	RJMP noesmenor
esmenor:
	IN MINIMO,ADCH //Mueve el registro
	rjmp sigue
noesmenor:
sigue:
	CP adh,MAXIMO
	BRSH esmayor //Branch if Same or Higher 
	RJMP noesmayor
esmayor:
	IN MAXIMO,ADCH //Mueve el registro
	RETI
noesmayor:
	RETI
