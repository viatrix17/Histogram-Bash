#!/bin/bash

#files=()
declare -A words=(
    ["nice"]=1
    ["ok"]=2
)


#counting the words
#for file in 
#do
#count
#done

#displaying the histogram
for i in "${!words[@]}"
do
    echo $i ${words[$i]}
#display
done