#!/bin/bash  
./dasm $1 -o$1.bin -f3

pkill stella
stella -grabmouse 0 $1.bin 




