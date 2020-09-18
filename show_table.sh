#! /bin/bash


if [ $# -eq 0 ]; then
    form=$(yad --maximized --title "Select DB " --form --field="DB:FL" "./test.db" ) result=$?
else
    form=$(yad --maximized --title "Select DB " --form --field="DB:FL"  $1) result=$?
fi

path=$(echo $form |awk 'BEGIN {FS="|"} {print $1}')
table_list=$(yad --maximized --title "tables" --list --column=NAME $(sqlite3 $path .tables)) result=$?

table_name=$(echo $table_list | awk 'BEGIN {FS="|"} {print $1}')
column_info=$(echo $(sqlite3 $path "SELECT sql FROM sqlite_master WHERE tbl_name='$table_name'"))
column_names=($(echo $(python3 db_parser.py --string "$(echo $column_info)")))
column_types=($(echo $(python3 db_parser.py --string "$(echo $column_info)" --pos 1)))
column_string=""            
for item in ${column_names[@]}
do
    column_string+="--column=$item "
done
count=$(echo $(sqlite3 $path "SELECT COUNT(*) FROM $table_name"))
if (($count==0)); then
    record_list=$(yad --maximized --title "record" --button=OK:1 --list $column_string ) result=$?
else
    records=$(echo $(sqlite3 $path "SELECT * FROM $table_name"))
    IFS="| " read -ra rows <<< "$records"
    record_list=$(yad --maximized --title "record" --button=OK:1 --list $column_string "${rows[@]}") result=$?
fi
echo $path
exit 0