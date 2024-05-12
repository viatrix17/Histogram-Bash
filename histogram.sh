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

counting_words() {
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

flags=0

#searching for flags
for argument in $@
do
    echo $argument
    if [[ $argument == -h ]]
    then
        help="-h\t\t\tShow this message\n-csv 'name.csv'\t\tSave the output to the CSV file.\n"
        echo -e $help #do dodania
        flags=$((flags+1))
    elif [[ $argument == -c ]]
    then
        #zapisz do csv
        flags=$($flags+2)
    elif [[ $argument == -t ]]
    then
        #zapisz to txt
        flags=$($flags+2)
    fi
done

if [[ $flags == 1 ]]
then
    shift
elif [[ $flags > 1 ]]
then
    shift $((flags-1))
fi



#counting the words
for file in $@ #all files arguments passed to the script    !!!!UWAGA: jeszcze dodac czytanie po prostu z wejscia czyli jak nie ma zadnych plikow podanych!!!!!
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
        text=$(cat $file | tr -cd "a-z " | tr -s ' ') #dodac zmienanie duzych liter na male
        counting_words $text
    else
        echo "Wrong format of file $file."
    fi
done
#UWAGA!!!! dodac zeby bledy tam przekierowywalo do kosza

#displaying the histogram
for i in "${!words[@]}"
do
    if [[ $i != . ]]
    then
        echo $i ${words[$i]}
    fi
done