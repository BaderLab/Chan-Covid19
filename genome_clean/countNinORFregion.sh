#!/bin/bash

# count Ns in a specified substring of each genome sequence

#inFile=/home/project_resources/data/genomes/GISAID/gisaid_cov2020_sequences_hCoV19_HumanHost_Complete_LowCovExcl_200403.fasta
#inFile=/home/delaram/merged_fa_comp/merged_AllIsolates_30278Only_revComp_probes_aligned.fa
#inFile=/home/delaram/NCBI/merged_NCBI_completeSeq_revComp_probes_aligned.fa

#inFile=/home/project_resources/data/mafft/200420_genomes/GISAID_humanOnly_complete_hiCovNoLowCov_200420_passQC_probes_aligned_clean.fa
inFile=/home/project_resources/data/mafft/200420_genomes/NCBI_completeSeq_200420_passQC_probes_aligned.fa

baseF=`basename $inFile`
# write sequence on its own line with no separators
cat $inFile | awk '{ 
	if ((NR>1)&&($0~/^>/)) { 
		printf("\n%s\n", $0); 
	} else if (NR==1) { 
		printf("%s\n", $0); 
	} else { 
		printf("%s", $0); 
	} 
}' $genomeFile > ${baseF}_flatten.txt


# now extract the subsequence
#### 200403 numbers
###spos=23500; #gisaid
###epos=24000; #gisaid
###spos=22200; #ncbi
###epos=22700; #ncbi

#### 200420 numbers 
###spos=27500; #gisaid
###epos=32500; #gisaid
spos=22000 #ncbi
epos=27000 #ncbi

cat ${baseF}_flatten.txt | awk -v spos=$spos -v epos=$epos '
	BEGIN { print "spos="spos"; epos="epos }
	{
	if (NR % 2 == 0) {
		
		len=(epos-spos)+1;
		a = substr($0,spos,len);
		print a;
	} else {
		print $0;
	}
}'  > ${baseF}_${spos}_${epos}.txt

echo "counting N"
perl countN.pl < ${baseF}_${spos}_${epos}.txt > ${baseF}_${spos}_${epos}_countN.txt
