# 5th step
# clean poor mapping, DNA duplication, RNA containment in pairs file
hires = config["software"]["hires"]
rule clean1:
    input: rules.seg2pairs.output,
    output: os.path.join(ana_home, "pairs_c1", "{sample}.c1.pairs.gz")
    log:
        result = log_path("clean1.result"),
        log = log_path("clean1.log") 
    threads: config["cpu"]["clean1"]
    resources: nodes = config["cpu"]["clean1"]
    conda: "../envs/hires.yaml"
    message: "clean_pairs_stage1 : {wildcards.sample} : {threads} cores."
    shell: "python {hires} clean_leg -t {threads} -o {output} {input}  1> {log.result} 2> {log.log}"

rule clean12:
    input: rules.clean1.output
    output: os.path.join(ana_home, "pairs_c12", "{sample}.c12.pairs.gz")
    log:
        result = log_path("clean12.result"),
        log = log_path("clean12.log") 
    threads: config["cpu"]["clean2"]
    resources: nodes = config["cpu"]["clean2"]
    conda: "../envs/hires.yaml"
    message: "clean_pairs_stage2 : {wildcards.sample} : {threads} cores."
    shell: "python {hires} clean_isolated -t {threads} -o {output} {input} 1> {log.result} 2> {log.log}"
