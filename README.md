# biocentis-task
Snakemake workflow to fetch, process and map reads to a reference genome.

## Requirements
Conda, Snakemake, Unix environment (if using Windows, either create a VM, or activate the Windows Subsystem for Linux available in Windows10/11).

## Workflow summary
From a simple input text file containing one sra-accession per line, biocentis-task will fetch the sequence with fastq-dump (sra-toolkit), quality trim with sickle, merge the reads with FLASH, map the reads to the reference genome with bwa, sort and index them with samtools. The final output will be an indexed bam file, readily visualisable with genome visualisers such as igv.

## Installation and usage
* Make sure to have the **conda** or **miniconda** environment manager system installed:
https://docs.conda.io/en/latest/miniconda.html

* Make sure to have git and snakemake activated:
https://git-scm.com/
https://snakemake.readthedocs.io/en/stable/

* Create and activate your conda snakemake environment:
```bash
conda create --name snakemake snakemake
conda activate snakemake
```

* Clone or manually download the git repository:
```bash
git clone git@github.com:laruzzante/biocentis-task.git
```

* Move to the bio-centis workflow directory:
```bash
cd biocentis/workflow
```

* Edit the config.yaml file, make sure to specify the correct reference genome url and sequencing technology:
```bash
vim config.yaml
```

* Rune the pipeline, where N is the number of cores you want snakemake to use:
```bash
snakemake --cores <N> --use-conda
```

## Input
Modify the sra_accessions.txt input file in the input folder, add as many sra_accessions as needed, one per line.
The workflow will automatically fetch the sequences via the sra-toolkit. An example input is provided in the _workflow/input_ directory.
