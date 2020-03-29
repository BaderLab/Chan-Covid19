PROBE_NAME=$1
PROBE_SEQ=$2
TYPE=$3

echo $PROBE_SEQ $PROBE_NAME

printf ">$PROBE_NAME\n$PROBE_SEQ" > probe_${PROBE_NAME}_${TYPE}.fa

sudo docker run --rm \
	-v /home/project_resources/data/genomes:/blast/blast_covid/genomes:ro \
	-v /home/shui/software/Chan-Covid19/seqalign_blast:/blast/blast_covid/out:rw \
	-w /blast/blast_covid/out \
	ncbi/blast blastn -task blastn-short -num_alignments 535 -query /blast/blast_covid/out/probe_${PROBE_NAME}_${TYPE}.fa -subject /blast/blast_covid/genomes/SARS-CoV2-GISAID_USA_isolates_200327.fa -outfmt "6" -out /blast/blast_covid/out/blast_out_${PROBE_NAME}_${TYPE}.txt
