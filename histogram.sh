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
output=-1

#searching for flags
for(( i=1 ; i<=$#; i++))
do
    if [[ ${!i} == -h ]]
    then
        help="-h\t\t\tShow this message\n-t name.csv\t\tSave the output to the text file.\n-c name.csv\t\tSave the output to the CSV file.\nNote:\nuse command\nsudo apt install poppler-utils to install .pdf to .txt converter.\nsudo apt install pstotext to install .ps to .txt converter."
        echo -e $help 
        flags=$(($flags+1))
        output=2
    elif [[ ${!i} == -c ]]
    then
        j=$((i+1))
        if [[ ${!j} == *.csv ]]
        then    
            result_file=${!j}
            flags=$(($flags+1))
            output=1
        else
            result_file="histogram_results.csv"
            output=1
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
            result_file=histogram_results.txt
            output=1
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


if [[ $output == -1 ]]
then  
    read text
    counting_words $text
else
    for file in $@ #all files arguments passed to the script   
    do
        if [[ -f $file ]]
        then
            if [[ $file == *.pdf ]] 
            then
                #convert from pdf to txt
                text=$(pdftotext $file - | tr A-Z a-z | tr '\n' ' ' | tr -cd "a-z " | tr -s ' ') 
                counting_words $text
            elif [[ $file  == *.ps ]] #convert from ps to txt
            then
                text=$(pstotext $file - | tr A-Z a-z | tr '\n' ' ' | tr -cd "a-z " | tr -s ' ')
                echo $text
                counting_words $text
            elif [[ $file == *.txt ]]
            then
                text=$(cat $file | tr A-Z a-z | tr -cd "a-z " | tr -s ' ')
                counting_words $text
            else
                echo "Wrong format of file '$file'."
            fi
        else
            echo "File '$file' not found."
        fi
    done
fi

#displaying the histogram
if [[ $output == 1 ]]
then
    echo -e "Word\t\tCount" > $result_file
    
elif [[ $output == 0 || $output == -1 ]]
    then
        echo -e "Word\t\tCount"
fi

for i in "${!words[@]}"
do
    if [[ $i != . ]]
    then
        if [[ -f $result_file ]]
        then
            echo -e "$i\t\t${words[$i]}"  >> $result_file
        else    #to console
            echo -e "$i\t\t${words[$i]}" 
        fi
    fi
done
