#!/bin/bash

#Example how to run this script
# ./run_mafft.sh /home/risserlin/Chan-Covid19/pipeline/data/genomes/200707/QC/ncbi_sars_cov2_2020-07-07.fa_200707 ncbi_sars_cov2_2020-07-07.fa_passQC.fa 

#genomeDir=/home/project_resources/data/genomes
#genFile=gisaid_cov2020_sequences_hCoV19_HumanHost_Complete_LowCovExcl_200403.fasta
genomeDir=$1
genFile=$2

docker run -v ${genomeDir}:/home/biodev ddiez/mafft mafft $genFile > ${genomeDir}/${genFile}_mafftout.fa

