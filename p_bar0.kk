#!/bin/sh

b=''
for ((i=0;$i<=100;i+=1))
do
        printf "Refreshing :[%-100s]%d%%\r" $b $i
        sleep 0.005
        b=">"$b
done
echo
