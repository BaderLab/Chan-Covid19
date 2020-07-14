#Pipeline 
* (to run the pipeline run the script run_pipeline.sh as su user)
* Pipeline will download the latest NCBI data and relies on previously downloaded gisaid data that was downloaded manually.  The gisaid data can be found in data/fasta/gisaid and the files have been chunked to contain about 10000 records which is the limit for download of meta data from the gisaid website.  

## Requirements
probes - fasta files, one for each probes.  Script will look for the probes in data/probes
gisaid fasta files - Script will look for gisaid fasta files in data/fasta/gisaid

## Details of the Pipeline
Steps performed in the run_pipeline.sh script:
1. Download NCBI ( added NCBI_dbGrowth.R to download script to generate the figure of growth) - Download_ncbi.Rmd
1. ***TODO : need a script for GISAID_dbGrowth.R***
1. Filter genomes by numbers of Ns, number of gaps and sepquence length - Find_Outliers.Rmd
* merged scripts - qcGenomes.sh (countN.pl, findOutliers.R) into RNotebook.
1. BLAST - for each probe file run blast with the current fasta file
* for each combination runs run_blast.sh which uses the blast docker to perform the analysis
1. plot Blast results - plot_blast_results.Rmd
1. MAFFT - for fasta file including QC'ed sequences and probes run run_mafft.sh which uses the mafft docker to perform the analysis 
1. ***TODO: Sliding window Ns based on MAFFT - GISAID_countN_slidingWin_noRect.R ***
1. Seq logo - Compute_covid19_logos.Rmd
1. ***Generate summary report - Generate_Summary_report.Rmd*** 
