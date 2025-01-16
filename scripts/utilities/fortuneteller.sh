#!/bin/bash

tellersstr="$(cowsay -l)"
tellersstr="${tellersstr#*:}"
tellers=()
for i in $tellersstr;
do
	tellers+=($i)
done
tellerscount="${#tellers[@]}"
randomtellerindex=$(($RANDOM%$tellerscount))
#echo "${tellers[$randomtellerindex]}"
randomteller="${tellers[$randomtellerindex]}"

fortune -s -a | cowsay -f $randomteller | lolcat
