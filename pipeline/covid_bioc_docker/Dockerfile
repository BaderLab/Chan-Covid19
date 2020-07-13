FROM bioconductor/bioconductor_docker:RELEASE_3_11

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
      cowplot \
      ggpubr

#having permission issues with the set up of the covid vm
#make sure the rstudio is part of the same group as defined on the 
# VM so we don't get permission issues.
RUN groupadd -g 1009 baderlab
RUN usermod -g baderlab rstudio
