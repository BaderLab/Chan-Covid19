#!/bin/bash

#genomeFile=/home/project_resources/data/genomes/gisaid_cov2020_sequences_hCoV19_HumanHost_Complete_LowCovExcl_200403.fasta
#genomeFile=/home/project_resources/data/genomes/GISAID/merged_AllIsolates_30278Only.fa

genomeRoot=/home/project_resources/data/genomes
gFiles=("NCBI/NCBI_completeSeq_200420.fasta" 
		"GISAID/GISAID_humanOnly_complete_hiCovNoLowCov_200420.fasta")

for cur in ${gFiles[@]}; do
	genomeFile=${genomeRoot}/${cur}
	baseF=`basename $cur .fasta`

	echo "***********************************"
	echo $baseF
	echo $genomeFile

	num=`grep "^>" $genomeFile | wc -l`
	echo "Total Sequences = $num"
	
	outRoot="/home/spai/genomeQC"
	dt=`date '+%y%m%d'` 
	outDir=${outRoot}/${baseF}_${dt}
	mkdir -p $outDir
	
	# count N and gaps
	baseF=`basename $genomeFile .fasta`
	echo ""
	echo "Counting gaps"
	perl countN.pl < $genomeFile >  tmp.txt # ${outDir}/${baseF}_countN_${dt}.txt
	echo -e "seqname\tseqlen\tnumA\tnumC\tnumG\tnumT\tnumN\tnumGaps" > header.txt
	cat header.txt tmp.txt > ${outDir}/${baseF}_countN_${dt}.txt
	rm tmp.txt
	
	echo ""
	echo "Finding outliers"
	Rscript findOutliers.R ${outDir}/${baseF}_countN_${dt}.txt
	
	# create new fasta file with outliers removed
	echo ""
	echo "Removing outliers"
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
	numFail=`wc -l ${outDir}/failIDs.txt | cut -f 1 -d" "`
	echo "Sequences FAIL 1+ test: $numFail"
	
	echo ""
	if [[ "$numFail" > "0" ]]; then
		echo "** Found failed sequences; excluding"
		grep -vFf ${outDir}/failIDs.txt tmp.txt |  tr "\t" "\n" > ${outDir}/${baseF}_passQC.fa
	fi

	echo ""
	num=`grep "^>" ${outDir}/${baseF}_passQC.fa | wc -l`
	echo "Sequences passing QC = $num"
	
	rm tmp.txt
done 
