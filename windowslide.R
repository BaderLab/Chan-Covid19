##code from Shraddha Sai

# count N sliding window
slidingwindow <- function(orig, quarter, orig2, myletter){
#orig <- data_ncbi
#quarter ="september"
#orig2 = "NCBI"
#myletter = "N"
class(orig)
nm <- names(orig)
message(sprintf("%i genome sequences",length(names(orig)) ))

winSize <-50 
numSeq <- length(names(orig))
runsummat <- NA
message("Collecting window freq")
t1 <- Sys.time()
for (k in 1:numSeq){
  cur <- letterFrequencyInSlidingView(orig[[k]],letters=myletter,view.width=winSize)

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

require(ggplot2)
###out <- data.frame(x=1:length(win_out),y=win_out,stringsAsFactors=FALSE)
p <- ggplot(out,aes(x=x,y=y)) + geom_line()
p <- p + ylab(sprintf("avg num N per genome (moving average; winsize=%i bp",winSize))
p <- p + xlab("Window start position on MSA (bp)")
p <- p + ylim(c(0,max(runsummat)))
p <- p + theme(text=element_text(size=15))
#p <- p + ggtitle(paste0(orig2 , quarter, "- gaps"))
p <- p + ggtitle(paste0(orig2 , quarter, myletter))
p_orig <- p


probe_start_end_indices = get_start_end_indices(orig, probes_fa)  #orig is data_gisaid_sel that you pass in paramaters
probe_start_end_indices.df <- get_start_end_df(probe_start_end_indices)

probe_start_end_indices.df
Emin = min(probe_start_end_indices.df[1:4, 1:2])
Emax = max(probe_start_end_indices.df[1:4, 1:2])
RDRPmin = min(probe_start_end_indices.df[5:8, 1:2])
RDRPmax = max(probe_start_end_indices.df[5:8, 1:2])


pdf(paste0("~/Dropbox (Bader Lab)/Veronique Voisin's files/covid19/covidproject_sept2020/slidingwindow","/slidingwindow",orig2 , quarter,myletter ,".pdf"),width=14,height=6); 
#tryCatch({
#  print(p); 
  
  
  p <- p_orig + ylim(c(0,2.5))
  #### annotate ORF1a probes
 ### p <- p + annotate("rect",xmin=22860, xmax=22980, ymin=0, ymax=2,alpha=0.3,
 ### 	fill="red",colour=NA)
 ### p <- p + annotate("text",x=22900,y=2.1,label="ORF1a",size=5)
### annotate RDRP probes
  p <- p + annotate("rect",xmin=Emin, xmax=Emax, ymin=0, ymax=2,alpha=0.3,
  	fill="red",colour=NA)
  p <- p + annotate("text",x=Emin,y=2.1,label="RdRp",size=5)
###   annotate E gene probes
  p <- p + annotate("rect",xmin=RDRPmin, xmax=RDRPmax, ymin=0, ymax=2,alpha=0.3,
  	fill="red",colour=NA)
  p <- p + annotate("text",x=RDRPmin,y=2.1,label="E gene",size=5)
  print(p)
#},error=function(ex){
#  print(ex);
#},finally={
  dev.off()
#})
  
  print(p) #i put an additional graphic so you can see it below the code snippet in addition to the one that will be displayed

}
