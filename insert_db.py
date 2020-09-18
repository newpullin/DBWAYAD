import sqlite3
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--string', type=str, default=None, help='column info')
parser.add_argument('--form_string', type=str, default=None, help='form result')
parser.add_argument('--t_name', type=str, default=None, help='table_name')

args = parser.parse_args()

# columns

target_string = args.string
first_index = -1
last_index = -1
first_c = True
for index, c in enumerate(target_string):
    if c == '(' and first_c:
        first_index = index
        first_c = False

    if c == ')':
        last_index = index


inside = target_string[first_index+1:last_index]
columns = inside.split(', ')
column_names = []
column_types = []
column_autoINC = []

for col in columns:
    splited = col.split(" ")
    column_names.append(splited[0])
    column_types.append(splited[1])
    if "AUTOINCREMENT" in col:
        column_autoINC.append(True) 
    else:
        column_autoINC.append(False)


result_string = f"insert into {args.t_name}("

for i in range(len(column_names)):
    if not column_autoINC[i]:
        result_string += column_names[i]
        if i != len(column_names)-1:
            result_string += ","


result_string += ") values("

target_string = args.form_string
splited = target_string.split("|")
for index in range(len(column_names)):
    if not column_autoINC[index]:
        if column_types[index] == "INTEGER":
            result_string += splited[index]
        else :
            result_string += "'" + splited[index] + "'"
        if index != len(column_names)-1:
            result_string += ","

result_string += ")"

print(result_string)