@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "K:\Microcontroladores\P5\labels.tmp" -fI -W+ie -C V2E -o "K:\Microcontroladores\P5\P5.hex" -d "K:\Microcontroladores\P5\P5.obj" -e "K:\Microcontroladores\P5\P5.eep" -m "K:\Microcontroladores\P5\P5.map" "K:\Microcontroladores\P5\P5.asm"
