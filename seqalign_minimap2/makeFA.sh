#!/bin/bash

# write probe seq as fa
inF=/home/project_resources/data/FromChanLab/ProbesMar2020.txt
outDir=/home/spai/seqalign_minimap/output

outDir=${outDir}/ChanProbes
mkdir -p $outDir

#cat /dev/null > $outF
#cat $inF | awk -F"\t" '(NR>1) {print ">ChanLab Probe "$1 ": ForwardPrimer"; print $2 }' >> $outF
#cat $inF | awk -F"\t" '(NR>1) {print ">ChanLab Probe "$1 ": ReversePrimer"; print $3 }' >> $outF
cd $outDir
cat $inF | awk -F"\t" '(NR>1){
	file=sprintf("%s.Fprimer.fa",$1)
	print ">"$1".forward\n"$2 > file; 

	file=sprintf("%s.Rprimer.fa",$1)
	print ">"$1".reverse\n"$3 > file; 

	file=sprintf("%s.Capture.fa",$1)
	print ">"$1".Capture\n"$4 > file; 

	file=sprintf("%s.Reporter.fa",$1)
	print ">"$1".Reporter\n"$5 > file; 

	file=sprintf("%s.Reporter2.fa",$1)
	print ">"$1".Reporter2\n"$5 > file; 
}'
