def get_input():

    ## MAPPING READS

    input_list = {}
    input_list["sra-accessions"] = []
    input_list["sequencing-technology"] = ''
    input_list["reference-genome-url"] = ''

    if "sra-accessions" in config.keys():
        with open(config["sra-accessions"]) as infile:
            for line in infile:
                sra_accession = line.strip()
                input_list["sra-accessions"].append(sra_accession)

    if "sequencing-technology" in config.keys():
        input_list["sequencing-technology"] = config["sequencing-technology"]

    if "reference-genome-url" in config.keys():
        input_list["reference-genome-url"] = config["reference-genome-url"]



    ## CRISPRESSO ANALYSIS

    for seq in ["amplicon-seq", "sgRNA-seq", "exp-amplicon-seq", "crit-subseq"]:
        input_list[seq] = ""
        if seq in config.keys():
            with open(config[seq]) as infile:
                for line in infile:
                    input_list[seq] = input_list[seq] + line.strip('\n')

    return input_list
