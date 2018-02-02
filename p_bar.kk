#!/bin/bash

c=$1
b=''
echo
for ((i=0;$i<=100;i+=1))
  do
   if [ $i -eq 100 ]
   then
   printf "Done       :[%-100s]%d%%\r" $b $i
   else
   printf "Refreshing :[%-100s]%d%%\r" $b $i
   fi
   for ((j=0;$j<$c;j+=1))
     do
        sleep 0.0081
     done
   b=">"$b
  done
echo

