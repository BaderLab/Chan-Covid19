PROBE_FA_FILENAME=$1
SUBJECT_FA_FILENAME=$2

echo "Probe fasta file: ${PROBE_FA_FILENAME}"
echo "Subject fasta file: ${SUBJECT_FA_FILENAME}"

sudo docker run --rm \
	-v /home/project_resources/data/genomes:/blast/blast_covid/genomes:ro \
	-v /home/shui/software/Chan-Covid19/seqalign_blast:/blast/blast_covid/out:rw \
	-w /blast/blast_covid/out \
	ncbi/blast blastn -task blastn-short -num_alignments 3000 -query /blast/blast_covid/out/${PROBE_FA_FILENAME} -subject /blast/blast_covid/out/${SUBJECT_FA_FILENAME} -outfmt 6 | sort -k2,2 -k12,12nr -k11,11n | sort -u -k2,2 --merge > /home/shui/software/Chan-Covid19/seqalign_blast/blast_out_${PROBE_FA_FILENAME%.fa}_all_tophits.txt
