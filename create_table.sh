#! /bin/bash


if [ $# -eq 0 ]; then
    form=$(yad --maximized --title "Select DB & decide TABLE NAME" --form --field="DB:FL" --field="TABLE name" "./test.db" "test") result=$?
else
    form=$(yad --maximized --title "Select DB & decide TABLE NAME" --form --field="DB:FL" --field="TABLE name" $1 "test") result=$?
fi

if ((result==0));then
    path=$(echo $form |awk 'BEGIN {FS="|"} {print $1}')
    table_name=$(echo $form |awk 'BEGIN {FS="|"} {print $2}')
    columns=()
    while :
    do
        list=$(yad --maximized --button=ADD:0 --button=OK:1  --title "set column" --list --column=name --column=type --column=PRIMARY --column=AUTOINCREMENT "${columns[@]}") result=$?
        if ((result==0));then
            add_form=$(yad --maximized --title "add" --form --field="column_name" --field="type:CB" --field="PRIMARY:CHK" --field="AUTOINCREMENT:CHK" "name" "INTEGER!TEXT" FALSE FALSE) result=$?
            c_name=$(echo $add_form |awk 'BEGIN {FS="|"} {print $1}')
            c_type=$(echo $add_form |awk 'BEGIN {FS="|"} {print $2}')
            c_primary=$(echo $add_form |awk 'BEGIN {FS="|"} {print $3}')
            c_autoinc=$(echo $add_form |awk 'BEGIN {FS="|"} {print $4}')
            if ((result==0));then
                columns+=($c_name $c_type $c_primary $c_autoinc)
            fi
        else
            I=""
            length=${#columns[@]}
            if ((length==0)); then
                exit 0
            fi
            for ((i=0;i<length;i+=4)) do
                I+="${columns[i]} ${columns[i+1]}"
                if [ "${columns[i+2]}" = "TRUE" ]; then
                    I+=" PRIMARY KEY"
                fi
                if [ "${columns[i+3]}" = "TRUE" ]; then
                    I+=" AUTOINCREMENT"
                fi
                if (($i!=$length-4)); then
                    I+=", "
                fi
            done
            sqlite3 $path "create table if not exists $table_name($I)"
            echo $1
            exit 0
        fi
    done
else
    echo $1
    exit 0
fi
echo $1
exit 0