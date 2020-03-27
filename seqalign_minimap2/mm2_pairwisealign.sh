#!/bin/bash

MM2=/home/project_resources/software/minimap2/minimap2

# FASTA files for probe seq and single CoV-2 isolate genome
probeDir=/home/spai/seqalign_minimap/output/ChanProbes
seqDir=/home/spai/seqalign_minimap/output/SARS-CoV2-GISAID_USA_isolates_200327

outRoot=/home/spai/seqalign_minimap/output/mm2_probeSeqs
mkdir -p $outRoot

# loop over probe FASTA files
for fName in ${probeDir}/*fa; do
	echo "Processing $fName"
	baseF=`basename $fName .fa`

	outDir=${outRoot}/${baseF}
	mkdir -p $outDir
	for seqFile in ${seqDir}/*fa; do # loop over viral genomes; align one by one
		baseF_gen=`basename $seqFile .fa`
		outF=${outDir}/${baseF}_${baseF_gen}.sam
		
		# run minimap2
		$MM2 -a $fName $seqFile > $outF
	done
done


