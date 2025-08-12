#!/usr/bin/env python3

import pandas as pd

def generate_summary_file(contaminant_type, contaminants_samples, annots_file):
    with open('temp.txt', 'w') as f:
        f.write('annots: ' + annots_file)
     
    contaminants_samples = contaminants_samples.split('*@|@*')
    sample_names = contaminants_samples[::2]
    input_files = contaminants_samples[1::2]

    counts = pd.DataFrame()
    

    ii = 0
    for sample_name, fname in zip(sample_names, input_files):
        current_counts = pd.read_csv(fname, delimiter='\t', index_col=0, header=None)
        if ii==0:
            counts.index = current_counts.index
        counts[sample_name] = current_counts[2]
        ii+=1

    counts.index.rename('ID', inplace=True)

    if (annots_file):
        annots = pd.read_csv(annots_file, index_col=0)
        counts = annots.join(counts)

    counts.to_csv(contaminant_type+'_counts.csv')
