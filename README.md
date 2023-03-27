# Chan-Covid19

## Chan-Covid19
 * Code for Chan-Bader lab collaboration for Covid-19 research. 
 * Mutation frequency in probe regions used for SARS-CoV-2 detection assay.

Associated with: Genotyping SARS-CoV‐2 Variants Using Ratiometric Nucleic Acid Barcode Panels Hannah N. Kozlowski,⧖ Ayden Malekjahani,⧖ Vanessa Y. C. Li, Ayokunle A. Lekuti, Stephen Perusini, Natalie G. Bell, Veronique Voisin, Delaram Pouyabahar , Shraddha Pai, Gary D. Bader, Samira Mubareka, Jonathan B. Gubbay, and Warren C. W. Chan*

Aknowledgements to: Ruth Isserlin, Shirley Hui, Maria Abou Chakra, Zoe Clarke.

README
 * The final code and reports are located at: https://github.com/BaderLab/Chan-Covid19/tree/monthly_report_final_code


## method
* The number of mutations between probes and viral sequences was tracked by analyzing SARS-CoV-2 genomes from NCBI and GISAID databases. Genomes from GISAID and NCBI were downloaded each month between April 2020 and March 2021. Sequences were selected based on the following criteria: complete, high coverage, excluding low coverage and from humans. Sequences of lower quality were excluded from analysis including sequences with >550 Ns, >10 gaps and a length >30kb. Analysis was performed using shell-scripting and R.

 * Multiple sequence alignment (MSA) was performed using MAFFT version 7 (https://mafft.cbrc.jp/alignment/software/). We aligned all genomes and as well as the probe sequences using default parameters. MAFFT has an iterative alignment algorithm and is useful for sequences containing large gaps. MSAs were visually evaluated using UniProt UGENE (http://ugene.net/). This visualization permitted an assessment of the probe-genome alignment region to identify systematic gaps in the reference genome MSA. trimAl was used to clean the MSA and remove regions with all gaps. MSA results were then imported into R and the Biostrings_2.62.0 package was used to count the number of mismatches of each probe against the reference genome sequence "Wuhan/WIV04/2019" and logos were generated using the ggseqlogo package.


 ## monthly report and related code:
 * The main steps are:
   * download the multiple sequence alignment from the GISAID website 
   * double check that all genomes are complete (full length)
   * select the sequences from start to end dates of current monthly reporting period
   * run trimAl to remove full gap column in the selected sequences
   * create a plot for quality control of sequences (number of N and -) / sliding window
   * create a plot to study geographical distribution of the viral sequences
   * create logos and heatmap of mismatch counts:
    * find the coordinates - start and end - of each probe using a reference genome
    * "Wuhan/WIV04/2019" was used first (first wave/ 2020) and then "hCoV-19/England/CAMC-B07C46/2020" was used for second and third wave (late 2020/2021)
    * get the matrix of all sequences using the start and end coordinates
    * produce the confusion matrix which counts the frequency of mutation per nucleotide position
    * create a heatmap of the confusion matrix

 ## code
  * code is in R (3.5.0) and can be run using RStudio or R.
  * one part of the code is a bash command to run trimAl which has to be installed locally.
  
