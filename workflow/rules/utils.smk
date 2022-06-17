def get_input():

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

    return input_list
