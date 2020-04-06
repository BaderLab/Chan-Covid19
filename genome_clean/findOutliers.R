# find seqs with outlier num gaps
args <- commandArgs(TRUE)
inFile <- args[1]

dt <- format(Sys.Date(),"%y%m%d")
logFile <- sprintf("%s_%s.log",inFile,dt)

sink(logFile,split=TRUE)
tryCatch({
dat <- read.delim(inFile,sep="\t",h=F,as.is=T)
colnames(dat) <- c("seqname","seqlen","numA","numC","numG","numT",
	"numN","numGaps")

nm <- strsplit(dat$seqname,"\\/")
ctry <- unlist(lapply(nm,function(x) x[2]))
ser <- unlist(lapply(nm,function(x) x[3]))
ser2 <- substr(ser,1,regexpr("-",ser)-1)

dat$virus <- unlist(lapply(nm, function(x) x[1]))
dat$country <- ctry
dat$region <- ser2

outDir <- dirname(inFile)
baseF <- basename(inFile)

pdf(sprintf("%s_numNandGaps_%s.pdf",inFile,dt))
tryCatch({
	cat("Num N\n")
	hist(dat$numN,n=100,main="num N")
	qtl <- quantile(dat$numN, c(0.25,0.5,0.75,0.8,0.9,0.95,0.99))
	abline(v=qtl,lty=3,col='red')
	print(qtl)

	nthresh <- 550
	idx <- which(dat$numN > nthresh) # top 5% worst
	write.table(dat[idx,],
		file=sprintf("%s_top5pct_numN_%s.txt",inFile,dt),
		sep="\t",col=T,row=F,quote=F)
	# violator 1 - too many N's
	write.table(dat[idx,1],
		file=sprintf("%s/fail_%s_NViolate_IDs_%s.txt",outDir,baseF,dt),
		sep="\t",col=F,row=F,quote=F)

	cat("Gaps\n")
	hist(dat$numGaps,n=100,main="num Gaps")
	qtl <- quantile(dat$numGaps, 
		c(0.25,0.5,0.75,0.8,0.9,0.95,0.99,0.995,0.999,0.9999))
	print(qtl)
	abline(v=qtl,lty=3,col='red')
	
	plot(dat$numGaps,dat$numN, xlab="num gaps",ylab="num N")
	abline(0,1,col='red')
	abline(h=nthresh,v=10,lty=3,col='red')

	# violator 2 - too many gaps
	idx <- which(dat$numGaps > 10) # top 5% worst
	write.table(dat[idx,],
		file=sprintf("%s_GapViolate_%s.txt",inFile,dt),
		sep="\t",col=T,row=F,quote=F)
	write.table(dat[idx,1],
		file=sprintf("%s/fail_%s_GapViolate_IDs_%s.txt",outDir,baseF,dt),
		sep="\t",col=F,row=F,quote=F)

	# violator 3 - seq too long
	idx <- which(dat$seqlen > 30000)
	if (any(idx)) {
		cat(sprintf("%i with seqs too long!", length(idx)))
		write.table(dat[idx,1],
			file=sprintf("%s/fail_%s_LenViolate_IDs_%s.txt",outDir,baseF,dt),
				sep="\t",col=F,row=F,quote=F)
	}

},error=function(ex){
	print(ex)
},finally={
	dev.off()
})

},error=function(ex){
	print(ex)
},finally={
	sink(NULL)
})
