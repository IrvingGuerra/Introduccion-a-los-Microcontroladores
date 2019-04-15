@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "K:\Microcontroladores\P4\P4\labels.tmp" -fI -W+ie -C V2E -o "K:\Microcontroladores\P4\P4\P4.hex" -d "K:\Microcontroladores\P4\P4\P4.obj" -e "K:\Microcontroladores\P4\P4\P4.eep" -m "K:\Microcontroladores\P4\P4\P4.map" "K:\Microcontroladores\P4\P4\P4.asm"
