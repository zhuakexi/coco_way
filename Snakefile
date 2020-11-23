configfile: "config/config.yaml"
pepfile: "pep/config.yaml"
rule bwa_mem:
    input:
        R1 = pep.sample_name,
        R2 = 
    output:
        protected( os.path.join(pep.ana_home,"sam","{sample}.aln.sam.gz"))
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