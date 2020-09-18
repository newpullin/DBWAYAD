#! /bin/bash

menu=(1 "Create DB")
menu+=(2 "Create Table")
menu+=(3 "Insert Data Into Table")
menu+=(4 "Delete Data From Table")
menu+=(5 "print Table by List")

default_file="DEFAULT"
while :
do
    list=$(yad --width 500 --height 700 --button=OK:0 --height 500 --title "Menu" --list --column=NUM --column=MENU "${menu[@]}") result=$?
    if (($result==252));then
        break
    elif (($result==0));then
        selected_num=$(echo $list | awk 'BEGIN {FS="|"} {print $1}')
        #Create DB
        if (($selected_num==1));then
            default_file=($(echo $(./create_db.sh)))
        #Create Table
        elif (($selected_num==2));then
            if [ "$default_file" == "DEFAULT" ]; then
                default_file=($(echo $(./create_table.sh)))
                
            else
            default_file=($(echo $(./create_table.sh $default_file))) 
            fi
        # Insert Data Into Table
        elif (($selected_num==3));then
            if [ "$default_file" == "DEFAULT" ]; then
                default_file=($(echo $(./insert_table.sh)))
            else
                default_file=($(echo $(./insert_table.sh $default_file)))
            fi
        elif (($selected_num==5));then
            if [ "$default_file" == "DEFAULT" ]; then
                default_file=($(echo $(./show_table.sh)))
            else
                default_file=($(echo $(./show_table.sh $default_file)))
            fi
        fi
    fi
done


exit 0