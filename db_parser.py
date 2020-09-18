import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--string', type=str, default=None, help='column info')
parser.add_argument('--pos', type=int, default=0, help='0:name 1:type')
args = parser.parse_args()

target_string = args.string
pos = args.pos
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
column_names = [splited.split(" ")[pos] for splited in columns]

result_string = ""

for name in column_names:
    result_string += name + " "

print(result_string)