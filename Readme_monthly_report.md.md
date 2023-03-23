# monthly_report_final_code

## method
* The number of mutations between probes and viral sequences was tracked by analyzing SARS-CoV-2 genomes from NCBI and GISAID databases. Genomes from GISAID and NCBI were downloaded each month between April 2020 and March 2021. Sequences were selected based on the following criteria: complete, high coverage, excluding low coverage and from humans. Sequences of lower quality were excluded from analysis including sequences with >550 Ns, >10 gaps and a length >30kb. Analysis was performed using shell-scripting and R.

 * Multiple sequence alignment (MSA) was performed using MAFFT version 7 (https://mafft.cbrc.jp/alignment/software/). We aligned all genomes and as well as the probe sequences using default parameters. MAFFT has an iterative alignment algorithm and is useful for sequences containing large gaps. MSAs were visually evaluated using UniProt UGENE (http://ugene.net/). This visualization permitted an assessment of the probe-genome alignment region to identify systematic gaps in the reference genome MSA. trimAl was used to clean the MSA and remove regions with all gaps. MSA results were then imported into R and the Biostrings_2.62.0 package was used to count the number of mismatches of each probe against the reference genome sequence "Wuhan/WIV04/2019" and logos were generated using the ggseqlogo package.


