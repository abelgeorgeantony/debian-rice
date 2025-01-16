#!/bin/bash

brightstr=$(brightnessctl --machine-readable)
oldIFS=$IFS
IFS=','
read -a array <<< "$brightstr"
IFS=$oldIFS
echo "${array[0]} ${array[1]} ${array[2]} ${array[3]} ${array[4]}"
