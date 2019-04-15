	.include"m8535def.inc"

;DECLARACION DE REGISTROS Y VARIABLES
	.def dato = R16 
	.def aux = R17 ;Aux Sera la pila de datos

	clr aux
	out sph,aux

	ldi aux,$69
	out spl,aux

	;Se le meten los numeros a la pila

			 ;hgfedcba -- ANODO COMUN (Se prende con 0)
	ldi aux,0b00010000 ;9
	push aux
	ldi aux,0b00000000 ;8
	push aux  
	ldi aux,0b01111000 ;7
	push aux 
	ldi aux,0b00000010 ;6
	push aux
	ldi aux,0b00010010 ;5
	push aux
	ldi aux,0b10011001 ;4
	push aux
	ldi aux,0b00110000 ;3
	push aux
	ldi aux,0b00100100 ;2
	push aux
	ldi aux,0b11111001 ;1
	push aux
	ldi aux,0b01000000 ;0
	push aux

	ldi aux,low(RAMEND)
	out spl,aux

	ldi aux,high(RAMEND)
	out sph,aux

	ser aux
	;ACTIVA A Y C COMO SALIDAS. LEDS Y DISPLAY
	out DDRA,aux  
	out DDRC,aux  
	
	;ACTIVA PULLOPS DE PINES DE ENTRADA
	out PORTB,aux  

;INICIO DEL PROGRAMA
uno:
	clr dato		;Limpiamos dato inicial en 0
dos:
	out portc, dato	;Mostramos en Leds
	rcall deco		;Decodificamos
	out porta, aux	;Mostramos en Display ya decodificado
	rcall delay		;Esperamos
	in aux, pinb	;Preguntamos si sera Ascendente/Descendente
	andi aux,$80	
	brmi tres		;Prenta si fue 0/1
	inc dato		;Si fue 1, incrementa
	cpi dato,10
	brne dos
	rjmp uno
tres:				;Si fue 0, decrementa
	dec dato
	brmi cuatro
	rjmp dos
cuatro:
	ldi dato,9
	rjmp dos

;SUBRUTINAS

;Subrutina que decodifica lo que tiene dato.
deco:
	ldi zl,$60	
	add zl,dato
	ld aux,z
	ret
delay:
; ============================= 
;    delay loop generator 
;     250000 cycles:
; ----------------------------- 
; delaying 249999 cycles:
          ldi  R20, $A7
WGLOOP0:  ldi  R21, $02
WGLOOP1:  ldi  R22, $F8
WGLOOP2:  dec  R22
          brne WGLOOP2
          dec  R21
          brne WGLOOP1
          dec  R20
          brne WGLOOP0
; ----------------------------- 
; delaying 1 cycle:
          nop
; ============================= 
ret
