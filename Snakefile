configfile: "config/config.yaml"
pepfile: "pep/config.yaml"
ana_home = config["ana_home"]
#raw_input_directory = pep.sample_table["directory"]["{wildcards.sample}"]
#ana_home = pep.sample_table["ana_home"]["{wildcards.sample}"]
def get_pep_fq(wildcards):
    # For protability, mapping inputs are in pep's config file. Change for every host env.
    # Mapping key in pep's main table ("directory"). Won't change much if data are stored in good manner.
    # Files in pep's sub table. Won't change much too.
    sample = wildcards.sample
    R1_path = os.path.join(pep.sample_table["directory"][sample], pep.sample_table["R1_file"][sample][0])
    R2_path = os.path.join(pep.sample_table["directory"][sample], pep.sample_table["R2_file"][sample][0])
    return {"R1" : R1_path, "R2" : R2_path}
rule bwa_mem:
    input:
        unpack(get_pep_fq)
    output:
        protected( os.path.join(ana_home,"sam","{sample}.aln.sam.gz"))
    params:
        index = config["ref"]["bwa"],
        extra = r"-R '@RG\tID:{sample}\tPL:ILLUMINA\tSM:{sample}'"
    threads: 
        config["cpu"]["bwa"]
    wrapper:
        "file://wrappers/zhuakexi/bwa_mem2"
rule all:
    input:
        expand(rules.bwa_mem.output, sample=pep.sample_table["sample_name"])