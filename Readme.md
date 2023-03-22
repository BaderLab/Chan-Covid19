# monthly_report_final_code
* (to run the pipeline run the script run_pipeline.sh as su user)
* Pipeline will download the latest NCBI data and relies on previously downloaded gisaid data that was downloaded manually.  The gisaid data can be found in data/fasta/gisaid and the files have been chunked to contain about 10000 records which is the limit for download of meta data from the gisaid website.  

## Requirements
probes - fasta files, one for each probes.  Script will look for the probes in data/probes
gisaid fasta files - Script will look for gisaid fasta files in data/fasta/gisaid

## Details of the Pipeline
Steps performed in the run_pipeline.sh script:
1. Download NCBI ( added NCBI_dbGrowth.R to download script to generate the figure of growth) - Download_ncbi.Rmd
1. ***TODO : need a script for GISAID_dbGrowth.R***
