#!/bin/bash  
./dasm $1 -o$1.bin -f3
stella -grabmouse 0 $1.bin 




