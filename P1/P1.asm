.include "m8535def.inc"
.def aux = R16
.def cont = R17

ser aux
out DDRA,aux
out DDRC,aux
out PORTB,aux

aqui: in aux,PINB
out PORTA,cont
out PORTC,aux


inc cont
loop: dec aux
nop
brne loop
rjmp aqui

  
