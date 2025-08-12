process SAMTOOLS_QUANT_CONTAMINANTS {
    conda 'samtools=1.9-4'
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/samtools:1.9--h91753b0_4' :
        'biocontainers/samtools:1.9--h91753b0_4' }"

    input:
    tuple val(meta), val(contaminant_type), path(contaminants)

    output:
    tuple val(meta.id), path('*.tsv'), emit: contaminants_counts
    
    script:
    def args = task.ext.args ?: ""

    """
    samtools view -b -F 4 ${contaminants}  > ${meta.id}.${contaminant_type}.filter.contaminant.mapped.bam

    samtools sort ${meta.id}.${contaminant_type}.filter.contaminant.mapped.bam -@ 16 -O BAM > ${meta.id}.${contaminant_type}.filter.contaminant.mapped.sorted.bam

    samtools index -@ 16 ${meta.id}.${contaminant_type}.filter.contaminant.mapped.sorted.bam

    samtools idxstats ${meta.id}.${contaminant_type}.filter.contaminant.mapped.sorted.bam > ${meta.id}.${contaminant_type}.tsv
    """
}
