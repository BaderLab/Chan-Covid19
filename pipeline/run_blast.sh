PROBE_FA_FILENAME=$1
SUBJECT_FA_FILENAME=$2
GENOME_DIR=$3
OUTPUT_DIR=$4

echo "Probe fasta file: ${PROBE_FA_FILENAME}"
echo "Subject fasta file: ${SUBJECT_FA_FILENAME}"

docker run --rm \
	-v ${GENOME_DIR}:/blast/blast_covid/genomes:ro \
	-v ${OUTPUT_DIR}:/blast/blast_covid/out:rw \
	-w /blast/blast_covid/out \
	ncbi/blast blastn -task blastn-short -num_alignments 8000 -query /blast/blast_covid/out/${PROBE_FA_FILENAME} -subject /blast/blast_covid/genomes/${SUBJECT_FA_FILENAME} -outfmt "6" | sort -k2,2 -k12,12nr -k11,11n | sort -u -k2,2 --merge > ${OUTPUT_DIR}/blast_out_${PROBE_FA_FILENAME%.fa}_all_tophits.txt
