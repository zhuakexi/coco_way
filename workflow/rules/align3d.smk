rule align3d:
    input:
        expand(rules.clean3d.output, sample="{sample}", rep=list(range(1,6)) ) #trick: expand rep, keep sample.
    output:
        directory(os.path.join(config["dirs"]["align3d"], "{sample}.20k"))
    log:
        result = config["logs"].format("align3d.rmsd.result"),
        log = config["logs"].format("align3d.log")
    conda: "../envs/hires.yaml"
    resources: nodes = 1
    message: "align3d : {wildcards.sample} : {resources.nodes}"
    shell:
        """
        python {hires} align -o {output}/ -gd {output}/good/ -bd {output}/bad/ {input} \
        > {log.result} 2> {log.log}      
        """