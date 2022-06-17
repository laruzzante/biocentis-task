MAX_MEMORY = config["MAX_MEMORY"]
MAX_RUNTIME = config["MAX_RUNTIME"]
MAX_THREADS = config["MAX_THREADS"]


# Get list of input files and parameters from config file
def get_sra_accessions():
    input_list = get_input()
    return input_list["sra-accessions"]


# Fetching the fastq sequence using sra-toolkit and the input file containing the SRA accessions
rule get_fastq:
    params:
        sra_accessions = get_sra_accessions()
    output:
        read_1 = expand("output/fastq/{sra_accessions}_1.fastq.gz", sra_accessions = get_sra_accessions()),
        read_2 = expand("output/fastq/{sra_accessions}_2.fastq.gz", sra_accessions = get_sra_accessions())
    threads: MAX_THREADS
    resources:
        mem_mb = MAX_MEMORY,
        runtime_s = MAX_RUNTIME
    log:
        "log/get_fastq.log"
    benchmark:
        "benchmarks/get_fastq.tsv"
    conda:
        "../envs/sra-tools.yaml"
    shell:
        "fastq-dump {params.sra_accessions} --split-files --gzip --outdir output/fastq"


# Trimming the ends of the read to increase the quality of the successive alignment using sickle-trim
rule trim:
    input:
        read_1 = rules.get_fastq.output.read_1,
        read_2 = rules.get_fastq.output.read_2
    output:
        qfltr_1 = expand("output/trimmed_fastq/qfltr_{sra_accessions}_1.fastq", sra_accessions = get_sra_accessions()),
        qfltr_2 = expand("output/trimmed_fastq/qfltr_{sra_accessions}_2.fastq", sra_accessions = get_sra_accessions()),
        single = expand("output/trimmed_fastq/single_{sra_accessions}.fastq", sra_accessions = get_sra_accessions())
    params:
        technology = input_list["sequencing-technology"]
    resources:
        mem_mb = MAX_MEMORY,
        runtime_s = MAX_RUNTIME
    log:
        "log/trim.log"
    benchmark:
        "benchmarks/trim.tsv"
    conda:
        "../envs/sickle-trim.yaml"
    shell:
        "sickle pe -f {input.read_1} -r {input.read_2} -t {params.technology} -o {output.qfltr_1} -p {output.qfltr_2} -s {output.single}"


# Merge paired-ends reads with FLASH
rule merge:
    input:
        trimmed_read_1 = rules.trim.output.qfltr_1,
        trimmed_read_2 = rules.trim.output.qfltr_2
    params:
        sra_accessions = get_sra_accessions()
    output:
        expand("output/merged_fastq/{sra_accessions}.extendedFrags.fastq", sra_accessions = get_sra_accessions()),
        expand("output/merged_fastq/{sra_accessions}.notCombined_1.fastq", sra_accessions = get_sra_accessions()),
        expand("output/merged_fastq/{sra_accessions}.notCombined_2.fastq", sra_accessions = get_sra_accessions()),
        expand("output/merged_fastq/{sra_accessions}.hist", sra_accessions = get_sra_accessions()),
        expand("output/merged_fastq/{sra_accessions}.histogram", sra_accessions = get_sra_accessions())
    resources:
        mem_mb = MAX_MEMORY,
        runtime_s = MAX_RUNTIME
    log:
        "log/merge.log"
    benchmark:
        "benchmarks/merge.tsv"
    conda:
        "../envs/flash.yaml"
    shell:
        "flash {input.trimmed_read_1} {input.trimmed_read_2} -o {params.sra_accessions} -d output/merged_fastq"
