import os

configfile: "config/config.yaml"
pepfile: "pep/config.yaml" # using PEP to define samples with meta data
ana_home = config["ana_home"] # home directory of all analysis results

def log_path(file):
    return os.path.join(ana_home, "logs", "{sample}", file)

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
    resources:
        nodes = config["cpu"]["bwa"]
    log:
        os.path.join(ana_home, "logs", "{sample}", "bwa.log")
    message:
        " ------> bwa : {wildcards.sample} : {threads} cores"
    wrapper:
        # wrapper shipped with conda yaml
        "file:./wrappers/zhuakexi/bwa_mem2"
rule sam2seg:
    input:
        bwa_mem.output
    output:
        os.path.join(ana_home, "seg", "{sample}.seg.gz")
    params:
        snp = config["snp"],
        sex = config["sex"],
        snp_file = config["ref"]["snp"]
        par_file = config["ref"]["par"]
        k8 = config["software"]["k8"]
        js = config["software"]["js"]
    resources:
        nodes = 1
    log:
        log_path("sam2seg.log")
    message:
        " ------> sam2seg : {wildcards.sample} : 1 core"
    wrapper:
        "file:./wrappers/zhuakexi/sam2seg"
rule all:
    input:
        expand(rules.bwa_mem.output, sample=pep.sample_table["sample_name"])