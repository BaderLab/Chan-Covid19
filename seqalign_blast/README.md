# BLAST Pairwise Sequence Alignment 

## Description
run_blast.sh runs blastn on an input query sequence (probe) against n subject sequences (viral genomes).

## Input
 * PROBE_FILE: a probe file in fasta file format
 * VIRAL_GENOMES_FILE: a fasta file containing viral genomes

## Output
 * a file called blast_out_\*\_all\_tophits.txt containing blastn staitistics and info (i.e. qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore)

## Usage
./run_blast.sh <PROBE_FILE> <VIRAL_GENOMES_FILE>

## Example
```
./run_blast.sh probe_Egene_forward.fa viral_genomes.fa
```
