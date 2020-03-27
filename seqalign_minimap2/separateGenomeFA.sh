#!/bin/bash

genomeFA=/home/project_resources/data/genomes/SARS-CoV2-GISAID_USA_isolates_200327.fa
outRoot=/home/spai/seqalign_minimap/output

d1=`basename $genomeFA .fa`
outDir=${outRoot}/${d1}
mkdir -p $outDir

cd $outDir
awk 'BEGIN {n_seq=0;} /^>/ {
	file=sprintf("seqnum_%d.fa",n_seq);
	print >> file; 
	n_seq++; 
	next;
	} { 
		print >> file; 
	}' < $genomeFA
