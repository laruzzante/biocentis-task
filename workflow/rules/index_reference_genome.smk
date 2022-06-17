# Fetching the reference genome from config url

import os

def get_file_name():
    file_name = os.path.basename(input_list["reference-genome-url"])
    return file_name


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
        "wget {params.ref_url} --directory-prefix output/ref_genome -O output/ref_genome/{params.file_name}"
