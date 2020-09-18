#! /bin/bash


form=$(yad --maximized --title "Create DB" --form --field="path:DIR" --field "name" ) result=$?

if ((result==0));then
    path=$(echo $form |awk 'BEGIN {FS="|"} {print $1}')
    name=$(echo $form |awk 'BEGIN {FS="|"} {print $2}')
    if ((${#name}));then
        file_name=${name%.*}.db
        touch $path/$file_name
        message="DB ${file_name} created"
        yad --width 300 --title 'working' --text "${message}" --button="ok" result=$?
        echo $path/$file_name
        exit 0
    else
        yad --width 300 --title 'warning' --text 'type title' --button="ok" result=$?
    fi
fi
if [ $# -eq 0 ]; then
    echo $1
else
    echo "DEFAULT"
fi
exit 0