#!/bin/bash

#genomeDir=/home/project_resources/data/genomes
#genFile=gisaid_cov2020_sequences_hCoV19_HumanHost_Complete_LowCovExcl_200403.fasta
genomeDir=/home/spai/genomeQC/200406/
genFile=gisaid_cov2020_sequences_hCoV19_HumanHost_Complete_LowCovExcl_200403_passQC.fa

sudo docker run -v ${genomeDir}:/home/biodev ddiez/mafft mafft $genFile > ${genFile}_mafftout.fa

