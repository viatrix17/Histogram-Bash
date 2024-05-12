#!/bin/bash

#files=()
declare -A words=(
    ["nice"]=1
    ["ok"]=2
)


#counting the words
for file in $@ #all parameters passed to the script
do
    echo $file
    if [[ $file == *.pdf ]] #spaces!!!!!
    then
        #convert from pdf
        #pdf_text=$(pdftotext $file) #czy ogolnie w calym systemie czy tylko w biezacym katalogu czy musi podac sciezke po prostu??
        echo "pdf"
    elif [[ $file  == *.ps ]] #convert from ps
    then
        echo "ps"
    elif [[ $file == *.txt ]]
    then
        cat $file | tr -cd "a-z " | tr -s ' '
        echo -e "\ntxt"
    else
        echo "Wrong format."
    fi
done

#displaying the histogram
for i in "${!words[@]}"
do
    echo $i ${words[$i]}
done