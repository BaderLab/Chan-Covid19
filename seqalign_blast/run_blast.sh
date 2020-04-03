#!/bin/bash

genomeDir=/home/project_resources/data/genomes
probeDir=/home/spai/ChanProbes
outDir=/home/spai/seqalign_blast

cat /dev/null > header.txt
echo -e "Query_SeqID\tSubject_SeqID\tPctIdenticalMatch\tAlignLength\tNumMismatches\tNumGapOpenings\tAlignStart\tAlignEnd\tSubjStart\tSubjEnd\tEvalue\tBitScore" >> header.txt

for probeFull in ${probeDir}/*fa; do
	probeFile=`basename $probeFull`
	echo $probeFile
	
	tgtOut=/blast/blast_covid/out
	tgtGenome=/blast/blast_covid/genomes
	
	# copy probe file over so blast finds it
	cp ${probeDir}/${probeFile} ${outDir}/.
	
	baseF=`basename $probeFile .fa`
	
	sudo docker run --rm \
		-v ${genomeDir}:${tgtGenome}:ro \
		-v ${outDir}:${tgtOut}:rw \
		-w ${tgtOut} \
		ncbi/blast blastn -task blastn-short -num_alignments 3165 -query ${tgtOut}/${probeFile} -subject ${tgtGenome}/gisaid_cov2020_sequences_hCoV19_HumanHost_Complete_LowCovExcl_200403_NsNoHyphen.fa -outfmt "6" -out ${tgtOut}/${baseF}.txt
	
	#head ${outDir}/${baseF}.txt
	
	cat ${outDir}/${baseF}.txt | sort -k2,2 -k12,12nr -k11,11n | sort -u -k2,2 --merge > ${outDir}/tmp
	
	cat header.txt ${outDir}/tmp > ${outDir}/${baseF}_all_tophits.txt 

done

