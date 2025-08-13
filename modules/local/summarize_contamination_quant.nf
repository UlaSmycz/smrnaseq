process SUMMARIZE_QUANT_CONTAMINATION {
    label 'process_medium'

    conda 'conda-forge::pandas'
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'oras://community.wave.seqera.io/library/pip_pandas:ad5fe7d484b0c455' :
        'community.wave.seqera.io/library/pip_pandas:b92c1f96f3d74c53' }"

    input:
    val contaminant_type
    path(contaminants_counts)
    path(annots_file)

    output:
    path '*.csv'
    
    script:
    """
    python3 - << 'EOF'
    import sys
    import pandas as pd

    file_names = "${contaminants_counts.join('*@|@*')}"
    file_names = file_names.split('*@|@*')

    counts = pd.DataFrame()

    ii = 0
    for file_name in file_names:
        current_counts = pd.read_csv(file_name, delimiter='\t', index_col=0, header=None)
        if ii==0:
            counts.index = current_counts.index
        sample_name = file_name.split('.')[0]
        counts[sample_name] = current_counts[2]
        ii+=1
    

    annots_path = "${annots_file}"

    if (annots_path):
        annots = pd.read_csv(annots_path, index_col=0)
        counts = annots.join(counts, how='outer')
    
    counts.to_csv("${contaminant_type}"+'_counts.csv')

    EOF
    """
}
