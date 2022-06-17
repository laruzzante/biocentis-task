def get_input():

    input_list = {}
    input_list["sra-accessions"] = []
    input_list["sequencing-technology"] = ''

    if "sra-accessions" in config.keys():
        with open(config["sra-accessions"]) as infile:
            for line in infile:
                sra_accession = line.strip()
                input_list["sra-accessions"].append(sra_accession)

    if "sequencing-technology" in config.keys():
        input_list["sequencing-technology"] = config["sequencing-technology"]

    return input_list
