#!/bin/bash

declare -A words=()

# check(){

# }

couting_words() {
    echo "text: $text"
    IFS=' '  read -a current_words <<< "$text"
    for word in ${current_words[@]}
    do
        
        echo $word
    done
}

#help flag
if [[ $1 == -h ]]
then
    echo "help" #do dodania
    shift   #shifting the arguments by one to right
fi
#counting the words
for file in $@ #all files arguments passed to the script
do
    echo "file $file"
    if [[ $file == *.pdf ]] #spaces!!!!!
    then
        #convert from pdf
        #text=$(pdftotext $file)
        #couting_words $text
        echo "pdf"
    elif [[ $file  == *.ps ]] #convert from ps
    then
        # text=$(pstotext $file)
        # couting_words $text
        echo "ps"
    elif [[ $file == *.txt ]]
    then
        text=$(cat $file | tr -cd "a-z " | tr -s ' ')
        echo $text
        couting_words $text
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