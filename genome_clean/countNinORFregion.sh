#!/bin/bash

# count Ns in a specified substring of each genome sequence

#inFile=/home/project_resources/data/genomes/GISAID/gisaid_cov2020_sequences_hCoV19_HumanHost_Complete_LowCovExcl_200403.fasta
#inFile=/home/delaram/merged_fa_comp/merged_AllIsolates_30278Only_revComp_probes_aligned.fa
inFile=/home/delaram/NCBI/merged_NCBI_completeSeq_revComp_probes_aligned.fa

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

###cat /dev/null > test.txt
###for k in {1..10} ;do
###	echo ">blah${k}" >> test.txt
###	echo "Mary had a little lamb" >> test.txt
###done

# now extract the subsequence

spos=23500; #gisaid
epos=24000; #gisaid
spos=22200; #ncbi
epos=22700; #ncbi
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
