
# Read GISAID
#gisaid <- read.delim("/home/spai/genomeQC/Delaram_File_200413/merged_AllIsolates_30278Only.fa_countN_200413.txt",sep="\t",h=F,as.is=T)
#gisaid <- read.delim("~/genomeQC/N_fullvsorf/N_fullvsorf.txt",sep="\t",h=T,as.is=T)
gisaid <- read.delim("/home/spai/genomeQC/GISAID_humanOnly_complete_hiCovNoLowCov_200420_200420/GISAID_humanOnly_complete_hiCovNoLowCov_200420_countN_200420.txt",
	sep="\t",h=T,as.is=T)

colnames(gisaid)[1] <- c("seqname")
nm <- strsplit(gisaid$seqname,"\\/")
ctry <- unlist(lapply(nm,function(x) x[2]))
ser <- unlist(lapply(nm,function(x) x[3]))
ser2 <- substr(ser,1,regexpr("-",ser)-1)
gisaid$virus <- unlist(lapply(nm, function(x) x[1]))
gisaid$country <- ctry
gisaid$region <- ser2
#gisaid$is_bad <- gisaid$orf_numN > 150

# Read NCBI
#ncbi <- read.delim("/home/project_resources/data/genomes/NCBI/NCBI_CoV2_metadata_200407.csv",sep=",",h=T,as.is=T)
#ncbi <- read.delim("/home/spai/genomeQC/NCBI_200414/NCBI_completeSeq_200407_countN_200414.txt",
ncbi <- read.delim("/home/spai/genomeQC/NCBI_completeSeq_200420_200420/NCBI_completeSeq_200420_countN_200420.txt",
	sep="\t",h=T,as.is=T)
colnames(ncbi)[1] <- "Geo_Location"
cpos <- gregexpr("\\|",ncbi[,1])
cpos <- unlist(lapply(cpos, function(x) { x[length(x)]}))
ctry <- substr(ncbi$Geo_Location,cpos+1,nchar(ncbi$Geo_Location))
idx <- which(cpos<0); ctry[idx] <- ncbi$Geo_Location[idx]
ncbi$Country <- ctry

###n2 <- n2[,c(1,7)]
###colnames(n2) <- c("Geo_Location","numN_ORF")

###both <- merge(x=ncbi,y=n2,by="Geo_Location")
###ncbi <- both;

# NCBI vs GISAID: plot country count, and colour by is_bad
gcount <- table(gisaid$country)
gcount2 <- data.frame(country=names(gcount),num=as.integer(gcount))
colnames(gcount2) <- c("gisaid_country","gisaid_count")
ncount <- table(ctry)
ncount2 <- data.frame(country=names(ncount),num=as.integer(ncount))
colnames(ncount2) <- c("ncbi_country","ncbi_count")

both <- merge(x=gcount2,y=ncount2,by.x="gisaid_country",by.y="ncbi_country",all=TRUE)
for (k in 2:3) {
	idx <- which(is.na(both[,k]));
	if (any(idx)) both[idx,k] <- 0
}

both_raw <- both
both[,2] <- both[,2]/sum(both[,2])
both[,3] <- both[,3]/sum(both[,3])

###bad_country <- unique(gisaid$country[which(gisaid$is_bad)])
###both2 <- subset(both, gisaid_country %in% bad_country)

blah1 <- data.frame(seqsource="NCBI",numN=ncbi$numN)
blah2 <- data.frame(seqsource="GISAID", numN=gisaid$numN)
blah3 <- rbind(blah1,blah2)

require(ggplot2)         
dt <- format(Sys.Date(),"%y%m%d")
pdf(sprintf("~/genomeQC/NCBI_vs_GISAID_preQC_%s.pdf",dt))
tryCatch({
	# GISAID vs NCBI : num N
	p <- ggplot(blah3,aes(factor(seqsource), numN)) + geom_violin() + geom_point()
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
	
###	# GISAID: plot N in full vs N in orf
###	p <- ggplot(gisaid,aes(full_numN, orf_numN)) + geom_point(alpha=0.5)
###	p <- p + xlab("num N, full sequence") + ylab("num N, ORF region (23.5K - 24K)")
###	p <- p + xlim(c(0,30000))
###	p <- p + ggtitle("Comparing N in full vs ORF region - GISAID")
###    p  <- p + theme(text = element_text(size=20))
###	print(p)

###	# NCBI: plot N in full vs N in orf
###	p <- ggplot(ncbi,aes(numN, numN_ORF)) + geom_point(alpha=0.5)
###	p <- p + xlab("num N, full sequence") + ylab("num N, ORF region (23.5K - 24K)")
###	p <- p + xlim(c(0,30000))
###	p <- p + ggtitle("Comparing N in full vs ORF region - NCBI")
###    p  <- p + theme(text = element_text(size=20))
###	print(p)

	p <- ggplot(both, aes(ncbi_count,gisaid_count, label=gisaid_country))
	p <- p + ylab("% sequences in GISAID") + xlab("% sequences in NCBI")
	p <- p + geom_text(size=2)
	p2 <- p + ggtitle("Source of isolates in GISAID and NCBI")
    p2  <- p2 + theme(text = element_text(size=20))
	print(p2)
	p <- p + xlim(c(0,0.02)) + ylim(c(0,0.02))
	p2 <- p + ggtitle("Source of isolates in GISAID and NCBI - closeup at zero")
    p2  <- p2 + theme(text = element_text(size=20))
	print(p2)

###	p <- ggplot(both2, aes(ncbi_count,gisaid_count, label=gisaid_country))
###	p <- p + ylab("% sequences in GISAID") + xlab("% sequences in NCBI")
###	p <- p + geom_text(size=2,colour="red")
###	p2 <- p + ggtitle("Source of isolates in GISAID and NCBI - countries with ORF gap > 100")
###    p2  <- p2 + theme(text = element_text(size=20))
###	print(p2)
###	p <- p + xlim(c(0,0.1)) + ylim(c(0,0.1))
###	p2 <- p + ggtitle("Source of isolates in GISAID and NCBI - countries with ORF gap > 100")
###    p2  <- p2 + theme(text = element_text(size=20))
###	print(p2)

},error=function(ex){
print(ex)
},finally={
	dev.off()
})
