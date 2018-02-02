#!/bin/bash

c=$1
b=''
REWRITE="\e[25D\e[1A\e[K"
for ((i=0;$i<=100;i+=1))
  do
   printf "Refreshing :[%-100s]%d%%\r" $b $i
   for ((j=0;$j<$c;j+=1)) 
     do
	sleep 0.0081
     done
   b=">"$b
  done
echo -e "${REWRITE}Done."
echo

