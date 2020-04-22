
# Read GISAID
gDir <- "/home/spai/genomeQC/GISAID_humanOnly_complete_hiCovNoLowCov_200420_200420"
gFile <- sprintf("%s/GISAID_humanOnly_complete_hiCovNoLowCov_200420_countN_200420.txt",gDir)
gisaid <- read.delim(gFile,sep="\t",h=TRUE,as.is=TRUE)
colnames(gisaid)[1] <- c("seqname")
message(sprintf("GISAID FULL: %i seqs",nrow(gisaid)))

nm <- strsplit(gisaid$seqname,"\\/")
ctry <- unlist(lapply(nm,function(x) x[2]))
ser <- unlist(lapply(nm,function(x) x[3]))
ser2 <- substr(ser,1,regexpr("-",ser)-1)
gisaid$virus <- unlist(lapply(nm, function(x) x[1]))
gisaid$country <- ctry
gisaid$region <- ser2

g2 <- read.delim(sprintf("%s/GISAID_humanOnly_complete_hiCovNoLowCov_200420_passQC_probes_aligned_clean.fa_27500_32500_countN.txt",gDir),
	sep="\t",h=FALSE,as.is=TRUE)
g2 <- g2[,c(1,7)]
message(sprintf("GISAID pass QC: %i seqs",nrow(g2)))
colnames(g2) <- c("seqname","numN_ORF")

both <- merge(x=gisaid,y=g2,by="seqname")
gisaid <- both
message(sprintf("GISAID merged: %i seqs",nrow(gisaid)))

gisaid$is_bad <- gisaid$numN_ORF > 80

message("")
# Read NCBI
nDir <- "/home/spai/genomeQC/NCBI_completeSeq_200420_200420"
ncbi <- read.delim(sprintf("%s/NCBI_completeSeq_200420_countN_200420.txt",
	nDir),
	sep="\t",h=T,as.is=T)
message(sprintf("NCBI FULL: %i seqs",nrow(ncbi)))

colnames(ncbi)[1] <- "Geo_Location"
cpos <- gregexpr("\\|",ncbi[,1])
cpos <- unlist(lapply(cpos, function(x) { x[length(x)]}))
ctry <- substr(ncbi$Geo_Location,cpos+1,nchar(ncbi$Geo_Location))
idx <- which(cpos<0); ctry[idx] <- ncbi$Geo_Location[idx]
ncbi$Country <- ctry

n2 <- read.delim(sprintf("%s/NCBI_completeSeq_200420_passQC_probes_aligned.fa_22000_27000_countN.txt",nDir),
	sep="\t",h=F,as.is=T)
n2 <- n2[,c(1,7)]
colnames(n2) <- c("Geo_Location","numN_ORF")
message(sprintf("NCBI pass QC: %i seqs",nrow(n2)))

both <- merge(x=ncbi,y=n2,by="Geo_Location")
ncbi <- both;
message(sprintf("NCBI merged: %i seqs",nrow(ncbi)))

# NCBI vs GISAID: plot country count, and colour by is_bad
gcount <- table(gisaid$country)
gcount2 <- data.frame(country=names(gcount),num=as.integer(gcount))
colnames(gcount2) <- c("gisaid_country","gisaid_count")
ncount <- table(ctry)
ncount2 <- data.frame(country=names(ncount),num=as.integer(ncount))
colnames(ncount2) <- c("ncbi_country","ncbi_count")

both <- merge(x=gcount2,y=ncount2,by.x="gisaid_country",
	by.y="ncbi_country",all=TRUE)

for (k in 2:3) {
	idx <- which(is.na(both[,k]));
	if (any(idx)) both[idx,k] <- 0
}

both_raw <- both
both[,2] <- both[,2]/sum(both[,2])
both[,3] <- both[,3]/sum(both[,3])

tmp <- cbind("gisaid",gisaid$numN_ORF)
tmp2 <- cbind("ncbi", ncbi$numN_ORF)
tmp3 <- data.frame(rbind(tmp,tmp2),stringsAsFactors=FALSE)
colnames(tmp3) <- c("source","numN_ORF")
tmp3[,2] <- as.integer(tmp3[,2])
tmp3[,1] <- as.factor(tmp3[,1])
numORF <- tmp3

message("")
message("numN in ORF")
message("GISAID")
print(summary(numORF[which(numORF[,1]=="gisaid"),2]))
message("")
message("NCBI")
print(summary(numORF[which(numORF[,1]=="ncbi"),2]))
message("")

bad_country <- unique(gisaid$country[which(gisaid$is_bad)])
both2 <- subset(both, gisaid_country %in% bad_country)

blah1 <- data.frame(seqsource="NCBI",numN=ncbi$numN)
blah2 <- data.frame(seqsource="GISAID", numN=gisaid$numN)
blah3 <- rbind(blah1,blah2)

require(ggplot2)         
dt <- format(Sys.Date(),"%y%m%d")
pdf(sprintf("~/genomeQC/NCBI_vs_GISAID_%s.pdf",dt))
tryCatch({

	# GISAID vs NCBI : num N
	p <- ggplot(blah3,aes(factor(seqsource), numN)) 
	p <- p + geom_violin() + geom_point(size=1,alpha=0.4)
    p  <- p + theme(text = element_text(size=20))
	print(p)
	
	blah <- aggregate(rep(1,nrow(gisaid)),
		by=list(country=gisaid$country),FUN=sum)
	blah <- blah[order(blah$x,decreasing=TRUE),]
	lbl <- blah$country
	lbl[11:nrow(blah)] <- ""
	blah$lbl <- lbl
	colnames(blah) <- c("variable","value","lbl")
	blah[,1] <- as.factor(blah[,1])
	p <- ggplot(blah,aes(x=reorder(variable,-value),y=value))
	p <- p + geom_bar(stat="identity",colour="white") 
	
	p <- p + geom_text(aes(label=lbl),nudge_x=4,nudge_y=-10,size=3)
	p <- p + ggtitle("GISAID: country")
	p <- p + theme(axis.text.x=element_text(angle=90,hjust=1,size=5))
	print(p)

	blah <- aggregate(rep(1,nrow(ncbi)),
		by=list(country=ncbi$Country),FUN=sum)
	blah <- blah[order(blah$x,decreasing=TRUE),]
	lbl <- blah$country
	lbl[11:nrow(blah)] <- ""
	blah$lbl <- lbl
	colnames(blah) <- c("variable","value","lbl")
	p <- ggplot(blah,aes(x=reorder(variable,-value),y=value))
	p <- p + geom_bar(stat="identity",colour="white") 
	p <- p + geom_text(aes(label=lbl),nudge_x=1,nudge_y=-3,size=3)
	p <- p + ggtitle("NCBI: country")
	p <- p + theme(axis.text.x=element_text(angle=90,hjust=1,size=1))
	print(p)

	# plot numN in ORF
	p <- ggplot(numORF, aes(factor(source),numN_ORF)) 
	p <- p + geom_violin() + geom_point(size=1,alpha=0.3)
	print(p)
	
	# GISAID: plot N in full vs N in orf
	p <- ggplot(gisaid,aes(numN, numN_ORF)) + geom_point(alpha=0.5)
	p <- p + xlab("num N, full sequence") 
	p <- p + ylab("num N, ORF region (23.5K - 24K)")
	p <- p + xlim(c(0,3000))
	p <- p + ggtitle("Comparing N in full vs ORF region - GISAID")
    p <- p + theme(text = element_text(size=20),title=element_text(size=10))
	print(p)

	# NCBI: plot N in full vs N in orf
	p <- ggplot(ncbi,aes(numN, numN_ORF)) + geom_point(alpha=0.5)
	p <- p + xlab("num N, full sequence") 
	p <- p + ylab("num N, ORF region (23.5K - 24K)")
	p <- p + xlim(c(0,500))
	p <- p + ggtitle("Comparing N in full vs ORF region - NCBI")
    p <- p + theme(text = element_text(size=20),title=element_text(size=10))
	print(p)

	p <- ggplot(both, aes(ncbi_count,gisaid_count, label=gisaid_country))
	p <- p + ylab("% sequences in GISAID") + xlab("% sequences in NCBI")
	p <- p + geom_text(size=2)
	p2 <- p + ggtitle("Source of isolates in GISAID and NCBI")
    p2 <- p2 + theme(text = element_text(size=20),title=element_text(size=10))
	print(p2)

	p <- p + xlim(c(0,0.02)) + ylim(c(0,0.02))
	p2 <- p + ggtitle("Source of isolates in GISAID and NCBI - closeup at zero")
    p2 <- p2 + theme(text = element_text(size=20),title=element_text(size=10))
	print(p2)

	p <- ggplot(both2, aes(ncbi_count,gisaid_count, label=gisaid_country))
	p <- p + ylab("% sequences in GISAID") + xlab("% sequences in NCBI")
	p <- p + geom_text(size=2,colour="red")
	p2 <- p + ggtitle("Source of isolates in GISAID and NCBI - countries with ORF gap > 80")
    p2 <- p2 + theme(text = element_text(size=20),title=element_text(size=10))
	print(p2)

	p <- p + xlim(c(0,0.1)) + ylim(c(0,0.1))
	p2 <- p + ggtitle("Source of isolates in GISAID and NCBI - countries with ORF gap > 80")
    p2 <- p2 + theme(text = element_text(size=20),title=element_text(size=10))
###	print(p2)

},error=function(ex){
print(ex)
},finally={
	dev.off()
})
