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
randomteller="${tellers[$randomtellerindex]}"

if [[ "$1" == "--no-lol" ]]; then
  fortune -s -a | cowsay -f $randomteller
else
  fortune -s -a | cowsay -f $randomteller | lolcat
fi
