@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "K:\Microcontroladores\P7\labels.tmp" -fI -W+ie -C V2E -o "K:\Microcontroladores\P7\P7.hex" -d "K:\Microcontroladores\P7\P7.obj" -e "K:\Microcontroladores\P7\P7.eep" -m "K:\Microcontroladores\P7\P7.map" "K:\Microcontroladores\P7\P7.asm"
