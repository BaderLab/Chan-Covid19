# plot blast results

inDir <- "/home/spai/seqalign_blast"
fList <- dir(inDir, "tophits.txt$")

numMismatch <- list()
numGap <- list()
pctMatch <- list()
alnStart <- list()
alnEnd <- list()
for (fName in fList) {

	baseF <- sub("_tophits.txt","",fName)
	pdfFile <- sprintf("%s/%s.pdf",inDir,fName)
	print(fName)	
	dat <- read.delim(sprintf("%s/%s",inDir,fName),sep="\t",header=TRUE,
		as.is=TRUE)

	numMismatch[[baseF]] <- dat$NumMismatches
	numGap[[baseF]] <- dat$NumGapOpenings
	pctMatch[[baseF]] <- dat$PctIdenticalMatch
	alnStart[[baseF]] <- dat$AlignStart
	alnEnd[[baseF]] <- dat$AlignEnd

###	pdf(pdfFile)
###	tryCatch({
###			hist(dat$NumMismatches,
###				main=sprintf("%s:Num mismatches",fName),n=20)
###			hist(dat$PctIdenticalMatch,
###				main=sprintf("%s: %% Identical Match",fName))
###			hist(dat$NumGapOpenings,
###				main=sprintf("%s: Num Gap Openings",fName),n=20)
###			hist(dat$AlignStart,
###				main=sprintf("%s: Align start",fName))
###			hist(dat$AlignEnd,
###				main=sprintf("%s: Align end",fName))
###	},error=function(ex){
###		print(ex)
###	},finally={
###		dev.off()
###	})
}

plotBoxplot <- function(cur,nm) {
x <- melt(cur)
p <- ggplot(x,aes(L1,value))
p <- p + geom_boxplot(outlier.shape=NA) + geom_jitter(width=0.2,height=0.1) 
p <- p + ggtitle(nm)
p <- p  + theme(axis.text.x=element_text(angle=90,hjust=1))
print(p)
}

require(caroline)
require(ggplot2)
pdf(sprintf("%s/overall.pdf",inDir))
par(mar=c(14,3,3,3))
tryCatch({
	plotBoxplot(numMismatch, "# mismatches")
	plotBoxplot(numGap,"# Gap Openings")
	plotBoxplot(pctMatch,"% Identical Match")
	plotBoxplot(alnStart,"Align Start Pos")
	plotBoxplot(alnEnd,"Align End Pos")
},error=function(ex){
	print(ex)
},finally={
	dev.off()
})

