FROM bioconductor/bioconductor_docker:RELEASE_3_10

RUN R -e 'BiocManager::install(c("Biostrings","msa"))'

RUN install2.r -d TRUE -r "https://cran.rstudio.com" \
      rentrez \
      ggplot2 \
      data.table \
      stringr \
      seqinr \
      RColorBrewer \
      ggseqlogo \
      reshape \
      cowplot


