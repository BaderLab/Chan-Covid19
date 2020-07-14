#!/bin/bash

# Pipeline script to put all the pieces of the analysis together
current_dir=`pwd`
dt=`date '+%y%m%d'`
genome_dir="data/genomes/${dt}"
log_dir="logs/${dt}"

#create a new logs directory if it doesn't exist
if [ ! -d ${current_dir}/${log_dir} ]; then
	mkdir ${current_dir}/${log_dir}
fi

#create the new genomes directory
if [ ! -d ${current_dir}/${genome_dir} ]; then
	mkdir ${current_dir}/${genome_dir}
fi 
# Download the latest NCBI covid sequences
docker run -e PASSWORD=covid19 --rm -e HOST_DIR="$(pwd)" -e USERID=1002 -e GROUPID=1009  -v "$(pwd)":/home/rstudio/projects covid_bioc311_docker /usr/local/bin/R -e "rmarkdown::render('/home/rstudio/projects/Download_ncbi.Rmd',output_file='/home/rstudio/projects/Download_ncbi.html')" > ${log_dir}/download_ncbi.log

#Manually download the GISAID genomes - to refresh data manually download new file
#cp data/fasta/gisaid/*.fa ${genome_dir}

#copy the latest NCBI fasta to the genomes directory
ncbi_file=$(ls -t data/fasta | head -1)
cp data/fasta/${ncbi_file} ${genome_dir} 

#Run the QC on the genomes. 
#replaced the qc script with an RNotebook.(./qcGenomes.sh ${genome_dir})

#make the QC dir
QC_dir=${genome_dir}/QC
if [ ! -d ${QC_dir} ]; then
	mkdir ${QC_dir}
fi

#Run QC on genomes - remove sequences with too many N, too many gaps or that are too long
for i in `ls ${genome_dir}/*.fa`
do
	#get the current fasta file processing
	cur_fasta_file=$(echo ${i} | xargs -n 1 basename) 

	echo "Genome_Dir processing ${genome_dir} and file ${cur_fasta_file}"
	docker run -e PASSWORD=covid19 --rm -e HOST_DIR="$(pwd)" -e USERID=1002 -e GROUPID=1009  -v "$(pwd)":/home/rstudio/projects covid_bioc311_docker /usr/local/bin/R -e "rmarkdown::render('/home/rstudio/projects/Find_Outliers.Rmd',output_file='/home/rstudio/projects/Find_Outliers_${data_source}.html',params = list(working_dir='/home/rstudio/projects',genomes_dir='${genome_dir}',fasta_file='${cur_fasta_file}'))" > ${log_dir}/Find_Outliers_${cur_fasta_file}.log

done

#get the newest directory of probes
probes_dir=$(ls -dt data/probes/* | head -1)

#create an output directory based on today's data
output_dir="${current_dir}/data/seqalign_blast/${dt}"
output_dir_docker=data/seqalign_blast/${dt}
if [ ! -d ${output_dir} ]; then
	mkdir ${output_dir}
fi

#copy the probes over the output directory
#cp ${probes_dir}/* ${output_dir}

#for each probe and each fasta file.
#go through each QC directory
echo "processing all fasta files in ${QC_dir}"
for i in `ls -d ${QC_dir}/* `
do
	#get the current directory processing
	current_working_dir=$(echo ${i} | xargs -n 1 basename)
	echo "current_dir ${current_working_dir}"

	#get the current fasta file processing
	cur_fasta_file=$(ls ${i}/*.fa | xargs -n 1 basename)
	echo "Processing fasta file: ${cur_fasta_file}"
	
	#get the specific datasource that we are currently processing
	IFS='_' read -r -a data_source_list <<< "${cur_fasta_file}"
	data_source=${data_source_list[0]}
	echo "Processing: ${data_source}"

	#create a directory for just this data source
        datasource_output_dir=${output_dir}/${data_source}
	if [ ! -d ${datasource_output_dir} ]; then
		mkdir ${datasource_output_dir}
	fi

	#copy the probes over to this output dir
        cp ${probes_dir}/* ${datasource_output_dir}

	#for the current fasta file go through each of the probe files
	for j in `ls ${probes_dir}`
	do 	
		#run blast
		echo "Processing probe file: ${j}, Fasta file ${current_working_dir}/${cur_fasta_file} and genome dir ${genome_dir}/QC"
		./run_blast.sh ${j} ${current_working_dir}/${cur_fasta_file} ${current_dir}/${genome_dir}/QC ${datasource_output_dir}
	done
        
	#generate summary of blast run using all the blast output files.
	docker run -e PASSWORD=covid19 --rm  -e HOST_DIR="$(pwd)" -e USERID=1002 -e GROUPID=1009  -v "$(pwd)":/home/rstudio/projects covid_bioc311_docker /usr/local/bin/R -e "rmarkdown::render('/home/rstudio/projects/plot_blast_results.Rmd',output_file='/home/rstudio/projects/plot_blast_results_${data_source}.html',params = list(working_dir='/home/rstudio/projects', output_dir='${output_dir_docker}/${data_source}'))" > ${log_dir}/plot_blast_results_${data_source}.log
	
	#create a fasta file for mafft - it needs to contain all the probes
	all_probes_fasta="All_probes.fa"
	cat ${probes_dir}/*.fa > ${QC_dir}/${current_working_dir}/${all_probes_fasta}

	mafft_fasta_file="${cur_fasta_file}_withprobes_mafft.fa"
        cat ${QC_dir}/${current_working_dir}/${cur_fasta_file} ${QC_dir}/${current_working_dir}/${all_probes_fasta} > ${QC_dir}/${current_working_dir}/${mafft_fasta_file}
        
	#run mafft on each fasta file.
	echo "Running mafft on ${mafft_fasta_file}"
	./run_mafft.sh ${current_dir}/${QC_dir}/${current_working_dir} ${mafft_fasta_file} 

done

