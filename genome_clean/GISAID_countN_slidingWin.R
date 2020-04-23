# count N sliding window
rm(list=ls())

faFile<- "/home/project_resources/data/mafft/200420_genomes/GISAID_humanOnly_complete_hiCovNoLowCov_200420_passQC_probes_aligned_clean.fa"

require(Biostrings)
#orig <- readDNAMultipleAlignment(faFile)
orig <- readDNAStringSet(faFile)

nm <- names(orig)
idx <- c(grep("Primer",nm),grep("Probe",nm))
orig <- orig[-idx]
message(sprintf("%i genome sequences",length(orig)))

winSize <-50 
numSeq <- length(orig)
runsummat <- NA
message("Collecting window freq")
t1 <- Sys.time()
for (k in 1:numSeq){
	cur <- letterFrequencyInSlidingView(orig[[k]],letters="N",view.width=winSize)
	if (k==1) runsummat <- cur
	else runsummat <- runsummat + cur
}
print(t1-Sys.time())
runsummat <- runsummat/numSeq
out <- data.frame(x=1:length(runsummat),y=runsummat,stringsAsFactors=FALSE)
colnames(out) <- c("x","y")

message("computing sliding win")
###win_size <- 100
###max_y <- nrow(blah)
###win_out <- rep(NA,max_y)
###Nstr <- blah[,"N"]
###for (k in 1:max_y) {
###	sidx <- k
###	eidx <- k + (win_size-1); if (eidx > nrow(blah)) { eidx <- nrow(blah) }
###	win_out[k] <- sum(Nstr[sidx:eidx])/win_size
###}

###out <- data.frame(x=1:length(win_out),y=win_out,stringsAsFactors=FALSE)
p <- ggplot(out,aes(x=x,y=y)) + geom_line()
p <- p + ylab(sprintf("# N (moving average; winsize=%i bp",winSize))
p <- p + xlab("Window start position on MSA (bp)")
p <- p + ylim(c(0,max(runsummat)))
p <- p + theme(text=element_text(size=15))
p <- p + ggtitle("GISAID 20 April 2020 - Ns")
p_orig <- p

# annotate ORF1a probes
p <- p + annotate("rect",xmin=22860, xmax=22980, ymin=0, ymax=8,alpha=0.3,fill="red",colour=NA)
p <- p + annotate("text",x=22900,y=9,label="ORF1a",size=5)
# annotate RDRP probes
p <- p + annotate("rect",xmin=15860, xmax=15970, ymin=0, ymax=8,alpha=0.3,fill="red",colour=NA)
p <- p + annotate("text",x=15700,y=9,label="RdRp",size=5)
# annotate E gene probes
p <- p + annotate("rect",xmin=26860, xmax=27000, ymin=0, ymax=8,alpha=0.3,fill="red",colour=NA)
p <- p + annotate("text",x=26900,y=9,label="E gene",size=5)

pdf("GISAID_countN.pdf",width=14,height=6); 
tryCatch({
	print(p); 
	p <- p_orig + ylim(c(0,2.5))
# annotate ORF1a probes
p <- p + annotate("rect",xmin=22860, xmax=22980, ymin=0, ymax=2,alpha=0.3,fill="red",colour=NA)
p <- p + annotate("text",x=22900,y=2.1,label="ORF1a",size=5)
# annotate RDRP probes
p <- p + annotate("rect",xmin=15860, xmax=15970, ymin=0, ymax=2,alpha=0.3,fill="red",colour=NA)
p <- p + annotate("text",x=15700,y=2.1,label="RdRp",size=5)
# annotate E gene probes
p <- p + annotate("rect",xmin=26860, xmax=27000, ymin=0, ymax=2,alpha=0.3,fill="red",colour=NA)
p <- p + annotate("text",x=26900,y=2.1,label="E gene",size=5)
	print(p)
},error=function(ex){
	print(ex);
},finally={
	dev.off()
})

