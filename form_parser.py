import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--string', type=str, default=None, help='column info')
args = parser.parse_args()

target_string = args.string
result_string = ""
for c in target_string.split("|"):
    result_string += c + " "

result_string = result_string.strip()

print(result_string)
