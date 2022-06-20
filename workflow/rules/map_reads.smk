# Mapping the reads to the indexed reference genome
rule map_reads:
    input:
        rules.merge.output[0]
    output:
        expand("output/mapped_reads/{sra_accessions}.fastq.bam", sra_accessions = get_sra_accessions())
    threads: MAX_THREADS
    resources:
        mem_mb = MAX_MEMORY,
        runtime_s = MAX_RUNTIME
    log:
        "log/map_reads.log"
    benchmark:
        "benchmarks/map_reads.tsv"
    conda:
        "../envs/samtools.yaml"
    shell:
        "bwa mem -t {threads} output/ref_genome/indexed_ref_genome {input} | samtools sort -o {output} >> {log}"


# Indexing the mapped reads for visualisation
rule index_mapped_reads:
    input:
        rules.map_reads.output
    output:
        expand("output/mapped_reads/{sra_accessions}.fastq.bai", sra_accessions = get_sra_accessions())
    threads: MAX_THREADS
    resources:
        mem_mb = MAX_MEMORY,
        runtime_s = MAX_RUNTIME
    log:
        "log/index_mapped_reads.log"
    benchmark:
        "benchmarks/index_mapped_reads.tsv"
    conda:
        "../envs/samtools.yaml"
    shell:
        "samtools index -@ {threads} {input} {output} >> {log}"
