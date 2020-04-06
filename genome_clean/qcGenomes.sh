#!/bin/bash

genomeFile=/home/project_resources/data/genomes/gisaid_cov2020_sequences_hCoV19_HumanHost_Complete_LowCovExcl_200403.fasta

# count N and gaps
baseF=`basename $genomeFile .fasta`
echo "counting gaps"
perl countN.pl < $genomeFile > ${baseF}_countN.txt

echo "finding outliers"
Rscript findOutliers.R ${baseF}_countN.txt

# create new fasta file with outliers removed
echo "removing outliers"
$ awk '{ if ((NR>1)&&($0~/^>/)) { printf("\n%s", $0); } else if (NR==1) { printf("%s", $0); } else { printf("\t%s", $0); } }' $genomeFile | grep -Ff ${baseF}_countN.txt_GapViolate_IDs.txt - | tr "\t" "\n" > out.fa
