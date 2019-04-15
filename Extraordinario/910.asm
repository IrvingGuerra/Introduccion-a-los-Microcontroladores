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
	rjmp	muestra  	;Ocurre cuando se presiona el push para mostrar los datos
	.org	$0E
	rjmp	conversion ;Ocurre cuando se detecta un cambio en el ADC
main:
//Definiciones para la pila
    ldi r16,low(RAMEND)
	out spl,r16
	ldi r16,high(RAMEND)
	out sph,r16
//Se definen puerto C como salidas (DISPLAY)
	ldi r16,0b11111111
	out ddrc,r16
//Se definen puerto D como entradas (PUSH para mostrar ultimos 5 datos)
	ldi r16,0b00000000
	out ddrd,r16
//Se definen puerto D como entradas (PUSH para mostrar ultimos 5 datos) PULLUPS
	ldi r16,0b11111111
	out portd,r16
//Se configura el ADC (donde entra el pin del teclado analogico)
	ldi r16,$ED 	;1110 1101
	out ADCSRA,r16
	ldi r16,$20
	out ADMUX,r16
	sei
//Definicion de interrupcioones (UNICAMENTE INT 0)
	ldi dato , 0b11000000
	out GICR, dato
	ldi dato,  0b00001010
	out MCUCR, dato
	sei
	clr cont
	clr firstTIME
//Pondremos predeterminadamente 0 en los ultimos 5 registros
	ldb r4, 0b01000000 ;0
	ldb r3, 0b01000000 ;0
	ldb r2, 0b01000000 ;0
	ldb r1, 0b01000000 ;0
	ldb r0, 0b01000000 ;0
//Inicio del Programa
inicio:
	nop
	out	portc,r0
	nop
    rjmp inicio

conversion:
;Nuestra FORMULA -> (Vin*255)/5Volts /*Ignorando los otros dos bits
/*
	0 = 134
	1 = 141
	2 = 150
	3 = 159
	4 = 170
	5 = 182
	6 = 196
	7 = 212
	8 = 231
	9 = 255 (logicamente)
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
	CPI adh,255
	BREQ es9 	//Branch if Equal
	RJMP noes9
es9:
	mov r7,r0
	ldb r0,0b00000001 //Carga el 9
	inc cont
	reti
noes9:	
	CPI adh,231
	BREQ es8
	RJMP noes8
es8:
	mov r7,r0
	ldb r0,0b00000010 	//Carga el 8
	inc cont
	reti
noes8:
	CPI adh,212
	BREQ es7
	RJMP noes7
es7:
	mov r7,r0
	ldb r0,0b00000100   //Carga el 7
	inc cont
	reti
noes7:
	CPI adh,196
	BREQ es6
	RJMP noes6
es6:
	mov r7,r0
	ldb r0,0b00001000 //6
	inc cont
	reti
noes6:
	CPI adh,182
	BREQ es5
	RJMP noes5
es5:
	mov r7,r0
	ldb r0,0b00010000 //5
	inc cont
	reti
noes5:
	CPI adh,170
	BREQ es4
	RJMP noes4
es4:
	mov r7,r0
	ldb r0,0b00100000 //4
	inc cont
	reti
noes4:
	CPI adh,159
	BREQ es3
	RJMP noes3
es3:
	mov r7,r0
	ldb r0,0b01000000 //3
	inc cont
	reti
noes3:
	CPI adh,150
	BREQ es2
	RJMP noes2
es2:
	mov r7,r0
	ldb r0,0b10000000 //2
	inc cont
	reti
noes2:
	CPI adh,141
	BREQ es1
	RJMP noes1
es1:
	mov r7,r0
	ldb r0,0b11000000 //1
	inc cont
	reti
noes1:
	CPI adh,134
	BREQ esn0
	RJMP noesn0
esn0:
	mov r7,r0
	ldb r0,0b11111111 //0
	inc cont
	reti
noesn0:
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
	mov r5,r4
	mov r4,r3
	mov r3,r2
	mov r2,r1
	mov r1,r7
	reti
esPrimera:
	inc firstTIME
	reti



muestra:
	//Mientras se insertaban los datos, se iban recorriendo a la izquierda
	//Entonces cuando suceda este push, recorremos los datos a la derecha
	//en intervalos de 1 segundo.
	out	portc,r0
	rcall delay		;Esperamos
	mov r0,r1
	mov r1,r2
	mov r2,r3
	mov r3,r4
	mov r4,r5
	out	portc,r0
	rcall delay		;Esperamos
	mov r0,r1
	mov r1,r2
	mov r2,r3
	mov r3,r4
	mov r4,r5
	out	portc,r0
	rcall delay		;Esperamos
	mov r0,r1
	mov r1,r2
	mov r2,r3
	mov r3,r4
	mov r4,r5
	out	portc,r0
	rcall delay		;Esperamos
	mov r0,r1
	mov r1,r2
	mov r2,r3
	mov r3,r4
	mov r4,r5
	out	portc,r0
	rcall delay		;Esperamos
	mov r0,r1
	mov r1,r2
	mov r2,r3
	mov r3,r4
	mov r4,r5
	reti


delay:
//Delay 1 SEG
; ============================= 
;    delay loop generator 
;     1000000 cycles:
; ----------------------------- 
; delaying 999999 cycles:
          ldi  R23, $09
WGLOOP0:  ldi  R24, $BC
WGLOOP1:  ldi  R25, $C4
WGLOOP2:  dec  R25
          brne WGLOOP2
          dec  R24
          brne WGLOOP1
          dec  R23
          brne WGLOOP0
; ----------------------------- 
; delaying 1 cycle:
          nop
; ============================= 
ret
