"""Snakemake wrapper for bwa-mem """
__author__ = "Y Chi"
__copyright__ = "Copyright 2020, Y Chi"
__email__ = "zhuakexi@126.com"
__license__ = "MIT"
from snakemake.shell import shell
extra = snakemake.params.get("extra")

shell(
    "bwa-mem2 mem"
    "-5SP"
    "{extra}"
    "-t {snakemake.threads}" 
    "{snakemake.params.index}"
    "{snakemake.input}" 
    "2> {snakemake.log} | gzip > {snakemake.output}"
)