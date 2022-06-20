# Fetching the reference genome from config url

import os

def get_file_name():
    file_name = os.path.basename(input_list["reference-genome-url"])
    return file_name


# Downloading the reference genome from the config url address
rule fetch_ref_url:
    params:
        ref_url = input_list["reference-genome-url"],
        file_name = get_file_name()
    output:
        ref_genome = expand("output/ref_genome/{file_name}", file_name = get_file_name())
    threads: MAX_THREADS
    resources:
        mem_mb = MAX_MEMORY,
        runtime_s = MAX_RUNTIME
    log:
        "log/fetch_ref_url.log"
    benchmark:
        "benchmarks/fetch_ref_url.tsv"
    shell:
        "wget {params.ref_url} --directory-prefix output/ref_genome -O output/ref_genome/{params.file_name} >> {log}"



# Extracting the files to merge the chromosome sequences into a signle fasta file
rule process_ref:
    input:
        ref_genome = rules.fetch_ref_url.output.ref_genome
    output:
        processed_ref_genome = "output/ref_genome/processed_ref_genome.fa"
    threads: MAX_THREADS
    resources:
        mem_mb = MAX_MEMORY,
        runtime_s = MAX_RUNTIME
    log:
        "log/process_ref.log"
    benchmark:
        "benchmarks/process_ref.tsv"
    shell:
        "gunzip -c {input} | tar xopf - ;"
        "for i in `seq 1 22` X Y;do cat hg38.analysisSet.chroms/chr$i.fa >> {output};done;"
        "rm -rf hg38.analysisSet.chroms/"


# Indexing the reference genome's single fasta file
rule index_ref:
    input:
        processed_ref_genome = rules.process_ref.output.processed_ref_genome
    output:
        expand("output/ref_genome/indexed_ref_genome.{ext}", ext=["amb", "ann", "bwt", "pac", "sa"])
    threads: MAX_THREADS
    resources:
        mem_mb = MAX_MEMORY,
        runtime_s = MAX_RUNTIME
    log:
        "log/index_ref.log"
    benchmark:
        "benchmarks/index_ref.tsv"
    conda:
        "../envs/bwa.yaml"
    shell:
        "bwa index -p output/ref_genome/indexed_ref_genome {input} >> {log}"
