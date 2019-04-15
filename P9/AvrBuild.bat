@ECHO OFF
"C:\Program Files (x86)\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "G:\Microcontroladores\P9\labels.tmp" -fI -W+ie -C V2E -o "G:\Microcontroladores\P9\P9.hex" -d "G:\Microcontroladores\P9\P9.obj" -e "G:\Microcontroladores\P9\P9.eep" -m "G:\Microcontroladores\P9\P9.map" "G:\Microcontroladores\P9\P9.asm"
