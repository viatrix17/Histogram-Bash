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
        check_result=$(check $word)
        if [[ $check_result == 1 ]]
        then
            words[$word]=$((words[$word]+1))
        else
            words[$word]=1
        fi
    done
}

flags=0
output=0

#searching for flags
for(( i=1 ; i<=$#; i++))
do
    if [[ ${!i} == -h ]]
    then
        help="-h\t\t\tShow this message\n-t name.csv\t\tSave the output to the text file.\n-c name.csv\t\tSave the output to the CSV file.\n"
        echo -e $help 
        flags=$(($flags+1))
    elif [[ ${!i} == -c ]]
    then
        j=$((i+1))
        if [[ ${!j} == *.csv ]]
        then
            result_file=${!j}
            flags=$(($flags+1))
            output=3
        else
            output=4
        fi
        flags=$(($flags+1))
    elif [[ ${!i} == -t ]]
    then
        j=$((i+1))
        if [[ ${!j} == *.txt ]]
        then
            result_file=${!j}
            flags=$(($flags+1))
            output=1
        else
            output=2
        fi
        flags=$(($flags+1))
    fi
done

if [[ $flags == 1 ]]
then
    shift
elif [[ $flags > 1 ]]
then
    shift $((flags))
fi


#counting the words
for file in $@ #all files arguments passed to the script    !!!!UWAGA: jeszcze dodac czytanie po prostu z wejscia czyli jak nie ma zadnych plikow podanych!!!!!
do
    if [[ -f $file ]]
    then
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
            text=$(cat $file | tr -cd "a-z " | tr -s ' ' | tr A-Z a-z) #dodac zmienanie duzych liter na male
            counting_words $text
        else
            echo "Wrong format of file '$file'."
        fi
    else
        echo "File '$file' not found."
    fi
done

#displaying the histogram
if [[ -f $result_file ]]
then
    echo -e "Word\t\tCount" > $result_file
fi

for i in "${!words[@]}"
do
    if [[ $i != . ]]
    then
        if [[ $output == 1 ]]   #to custom txt file
        then
            echo -e "$i\t\t${words[$i]}"  >> $result_file
        elif [[ $output == 2 ]]  #to generated txt file
        then
            echo -e "$i\t\t${words[$i]}"  >> histogram_results.txt
        elif [[ $output == 3 ]]     #to custom csv file
        then
            echo -e "$i\t\t${words[$i]}"  >> $result_file
        elif [[ $output == 4 ]]     #to generated csv file
        then
            echo -e "$i\t${words[$i]}"  >> histogram_results.csv
        else    #to console
            echo -e "$i\t\t${words[$i]}" 
        fi
    fi
done