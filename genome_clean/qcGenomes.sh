#!/bin/bash

#genomeFile=/home/project_resources/data/genomes/gisaid_cov2020_sequences_hCoV19_HumanHost_Complete_LowCovExcl_200403.fasta
#genomeFile=/home/project_resources/data/genomes/GISAID/merged_AllIsolates_30278Only.fa
genomeFile=/home/project_resources/data/genomes/NCBI/NCBI_completeSeq_200407.fasta

outRoot="/home/spai/genomeQC"
dt=`date '+%y%m%d'` 
outDir=${outRoot}/NCBI_${dt}
mkdir -p $outDir

# count N and gaps
baseF=`basename $genomeFile .fasta`
echo "counting gaps"
perl countN.pl < $genomeFile > ${outDir}/${baseF}_countN_${dt}.txt

echo "finding outliers"
Rscript findOutliers.R ${outDir}/${baseF}_countN_${dt}.txt

# create new fasta file with outliers removed
echo "removing outliers"
 awk '{ 
	if ((NR>1)&&($0~/^>/)) { 
		printf("\n%s", $0); 
	} else if (NR==1) { 
		printf("%s", $0); 
	} else { 
		printf("\t%s", $0); 
	} 
}' $genomeFile > tmp.txt

# keep sequences with headers that don't match those in the file
cat ${outDir}/fail*.txt  | sort -k1,1 | uniq > ${outDir}/failIDs.txt
numFail=`wc -l ${outDir}/failIDs.txt`
echo "$numFail genomes fail tests."
grep -vFf ${outDir}/failIDs.txt tmp.txt |  tr "\t" "\n" > ${outDir}/${baseF}_passQC.fa

rm tmp.txt
