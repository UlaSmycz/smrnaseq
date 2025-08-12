process SUMMARIZE_QUANT_CONTAMINATION {
    label 'process_medium'

    conda 'conda-forge::pandas'
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'oras://community.wave.seqera.io/library/pip_pandas:ad5fe7d484b0c455' :
        'community.wave.seqera.io/library/pip_pandas:b92c1f96f3d74c53' }"

    input:
    val contaminant_type
    val(contaminants_counts)
    val(annots_file)

    output:
    path '*.csv'
    
    script:
    """
    python3 - << 'EOF'
    import sys
    sys.path.append('${projectDir}/bin')
    from summarize_contamination import *
    generate_summary_file("${contaminant_type}", "${contaminants_counts.join('*@|@*')}", "${annots_file}")
    EOF
    """
}
