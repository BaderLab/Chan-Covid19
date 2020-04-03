#!/bin/bash

inFile=/home/project_resources/data/genomes/gisaid_cov2020_sequences_hCoV19_HumanHost_Complete_LowCovExcl_200403.fasta

outDir=`dirname $inFile`
baseF=`basename $inFile .fa`
outFile=${outDir}/${baseF}_NsNoHyphen.fa

# https://www.biostars.org/p/127714/
# ignore header lines. for non-header lines, replace all 
# non ACGTacgt with N
sed -e '/^[^>]/s/[^ATGCatgc]/N/g' $inFile > $outFile

