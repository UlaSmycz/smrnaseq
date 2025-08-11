#!/usr/bin/env python3

import sys
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--contaminant_type')
parser.add_argument('--files',  nargs='+')

args = parser.parse_args()

contaminant_type = args.contaminant_type
input_files = args.files

with open('contam_files.txt', 'w') as f:
    for el in input_files:
        f.write(el+'\n')