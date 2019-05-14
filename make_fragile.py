import glob
import os
import re

regex_keep = (r'\\protect\{(.*?\})\}',)
dir_in = '/Users/malcolmwhite/Desktop/White_et_al_2019a_rev1'
dir_out = '/Users/malcolmwhite/Desktop/White_et_al_2019a_fragile'

def process_file(file, dir_out):
    print(f'Processing {file}')
    file_basename = os.path.split(file)[1]
    with open(file) as infile:
        data = infile.read()

    # Keep sections
    for pattern in regex_keep:
        match = re.search(pattern, data)
        while match:
            print(f'Replacing "{match.group()}" with "{match.groups()[0]}"')
            data = data.replace(match.group(), match.groups()[0])
            match = re.search(pattern, data)

    with open(os.path.join(dir_out, file_basename), 'w') as outfile:
        outfile.write(data)

for file in glob.glob(os.path.join(dir_in, '*.tex')):
    process_file(file, dir_out)