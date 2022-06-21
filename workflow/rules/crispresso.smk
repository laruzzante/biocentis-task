# Cripresso analyses with varying HDR thresholds

import numpy as np

def get_hdr_thresholds():
    hdr_thresholds = np.linspace(config['hdr-min'], config['hdr-max'], config['hdr-n-steps'])
    return hdr_thresholds


rule hdr_crispresso:
    input:
        r1 = rules.trim.output.qfltr_1,
        r2 = rules.trim.output.qfltr_2
    params:
        amplicon_seq = input_list["amplicon-seq"],
        sgRNA_seq = input_list["sgRNA-seq"],
        exp_amplicon_seq = input_list["exp-amplicon-seq"],
        crit_subseq = input_list["crit-subseq"],
        outdir = "output/crispresso/{sra_accession}_HDR{hdr_threshold}"
    output:
        "output/crispresso/{sra_accession}_HDR{hdr_threshold}/mockfile.txt"
    threads: 1
    resources:
        mem_mb = MAX_MEMORY,
        runtime_s = MAX_RUNTIME
    log:
        "log/hdr_grid_crispresso.log"
    benchmark:
        "benchmarks/hdr_grid_crispresso.tsv"
    conda:
        "../envs/crispresso.yaml"
    shell:
        "CRISPResso -o {params.outdir} -a {params.amplicon_seq} -g {params.sgRNA_seq} -e {params.exp_amplicon_seq} -d {params.crit_subseq} --hdr_perfect_alignment_threshold {wildcards.hdr_threshold} -r1 {input.r1} -r2 {input.r2} >> {log} && touch {output}"
