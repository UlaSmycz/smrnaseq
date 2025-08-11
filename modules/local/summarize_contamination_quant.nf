process SUMMARIZE_QUANT_CONTAMINATION {
    label 'process_medium'

    conda 'conda-forge::pandas'
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'oras://community.wave.seqera.io/library/pip_pandas:ad5fe7d484b0c455' :
        'community.wave.seqera.io/library/pip_pandas:b92c1f96f3d74c53' }"

    input:
    val contaminant_type
    path input_files

    output:
    path '*.txt'
    

    script:
    """
    summarize_contamination.py --contaminant_type $contaminant_type --files $input_files 
    """
}
