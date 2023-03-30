#! /bin/bash

# ./scriptName 1 2 3 .. n
# 1. arg - name of database(table)
# 2..n args - names of the fields

echo "1.Create database"
echo "2.Select data"
echo "3.Insert data"
echo "4.Delete data"
echo "Choose your option:"

read opt

crete_database(){

    if test -e $1.txt
    then
        echo "Database already exists"
    else
        touch $1.txt
        echo $1 >> $1.txt
        num_args=$(($# - 1))
        numOfSigns=$((num_args * 8 + num_args - 1 + 4))

        for ((i=1; i<=$numOfSigns; i++))
        do
            echo -n "*" >> $1.txt
        done
        echo >> $1.txt
        line=""
        for i in $(seq 2 $#); do
            line+=${!i}
            line+=" "
        done
        if [ "$num_args" -eq 4 ]; then
            echo $line | awk '{printf "** %-6s * %-6s * %-6s * %-6s **\n", $1, $2, $3, $4}' >> $1.txt
            echo -n "">>$1.txt
        elif [ "$num_args" -eq 3 ]; then
            echo $line | awk '{printf "** %-6s * %-6s * %-6s **\n", $1, $2, $3}' >> $1.txt
            echo -n "">>$1.txt
        elif [ "$num_args" -eq 2 ]; then
            echo $line | awk '{printf "** %-6s * %-6s **\n", $1, $2}' >> $1.txt
            echo -n "">>$1.txt
        else 
            echo $line | awk '{printf "** %-6s **\n", $1}' >> $1.txt
            echo -n "">>$1.txt
        fi

    fi
}

select_data(){
    echo "Enter the ID for selecting:"
	  read -r id
    numOfRow=$(cat $1.txt | cut -d\  -f2 | grep -n $id | cut -d':'  -f1)       
    if [ -z "$numOfRow" ]; then
        echo "ID is not valid!"
    else
        for i in $(seq 2 $#); do
            echo -n ${!i}
            echo -n " "
        done
        echo
        numOfRow=$(cat $1.txt | cut -d\  -f2 | grep -n $id | cut -d':'  -f1)       
        sed -n "${numOfRow}p" $1.txt
    fi
}

enter_data(){
    newLine="";
    num_args=$(($# - 1))
    for i in $(seq 2 $#); do
        echo "Enter ${!i}:"
        read arg
        newLine+=$arg
        newLine+=" "
    done
    if [ "$num_args" -eq 4 ]; then
        echo $newLine | awk '{printf "** %-6s * %-6s * %-6s * %-6s **\n", $1, $2, $3, $4}' >> $1.txt
        echo -n "">>$1.txt
    elif [ "$num_args" -eq 3 ]; then
        echo $newLine | awk '{printf "** %-6s * %-6s * %-6s **\n", $1, $2, $3}' >> $1.txt
        echo -n "">>$1.txt
    elif [ "$num_args" -eq 2 ]; then
        echo $newLine | awk '{printf "** %-6s * %-6s **\n", $1, $2}' >> $1.txt
        echo -n "">>$1.txt
    else 
        echo $newLine | awk '{printf "** %-6s **\n", $1}' >> $1.txt
        echo -n "">>$1.txt
    fi

}

delete_data(){
	echo "Enter id:"
	read id
    numOfRow=$(cat $1.txt | cut -d\  -f2 | grep -n $id | cut -d':'  -f1)
    if [ -z "$numOfRow" ]; then
        echo "ID is not valid!"
    else
        #sed "${numOfRow}d" $1.txt > tmpfile && mv tmpfile $1.txt 
        awk -v id="$id" '$2 != id' "$1.txt" | sponge "$1.txt"
    fi
}

case $opt in 
	1)  crete_database $1 $2 $3 $4 $5 ;;
	2)  select_data $1 $2 $3 $4 $5 ;;
	3)  enter_data $1 $2 $3 $4 $5 ;;
	4)  delete_data $1 $2 $3 $4 $5 ;;
	*)  echo "Invalid option." ;;
esac