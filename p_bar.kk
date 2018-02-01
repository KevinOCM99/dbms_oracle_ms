#!/bin/bash

c=$1
while [ $c -gt 0 ]; do 
    c=$((c-1))
	b=''
	REWRITE="\e[25D\e[1A\e[K"
	for ((i=0;$i<100;i+=1))
	  do
	   printf "Refreshing :[%-100s]%d%%\r" $b $i
	   sleep 0.0081
	   b=">"$b
	  done
done
echo -e "${REWRITE}Done."
echo
