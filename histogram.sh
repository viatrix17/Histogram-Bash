#!/bin/bash

declare -A words=([.]=0)

check(){
    local yes=0
    for potential_word in ${!words[@]}
    do
        if [[ $potential_word == $word ]]
        then
            yes=1
        fi
    done
    echo $yes
}

couting_words() {
    IFS=' '  read -a current_words <<< "$text"
    for word in ${current_words[@]}
    do
        output=$(check $word)
        if [[ $output == 1 ]]
        then
            words[$word]=$((words[$word]+1))
        else
            words[$word]=1
        fi
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
        couting_words $text
    else
        echo "Wrong format."
    fi
done

#displaying the histogram
for i in "${!words[@]}"
do
    if [[ $i != . ]]
    then
        echo $i ${words[$i]}
    fi
done