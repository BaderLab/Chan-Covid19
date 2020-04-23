# get country breakdown of GISAID and NCBI

gFile <- "/home/spai/genomeQC/GISAID_humanOnly_complete_hiCovNoLowCov_200420_200420/GISAID_humanOnly_complete_hiCovNoLowCov_200420_countN_200420.txt"

gisaid <- read.delim(gFile,sep="\t",h=T,as.is=T)
colnames(gisaid)[1] <- c("seqname")
nm <- strsplit(gisaid$seqname,"\\/")
ctry <- unlist(lapply(nm,function(x) x[2]))
gisaid$country <- ctry

x <- aggregate(rep(1,nrow(gisaid)),by=list(gisaid$country),FUN=sum)
x <- x[order(x[,"x"],decreasing=TRUE),]
colnames(x) <- c("Country","count")
x[,2] <- x[,2]/sum(x[,2])
print(head(x))

nFile <- "/home/spai/genomeQC/NCBI_completeSeq_200420_200420/NCBI_completeSeq_200420_countN_200420.txt"
ncbi <- read.delim(nFile,sep="\t",h=T,as.is=T)
colnames(ncbi)[1] <- "Geo_Location"
cpos <- gregexpr("\\|",ncbi[,1])
cpos <- unlist(lapply(cpos, function(x) { x[length(x)]}))
ctry <- substr(ncbi$Geo_Location,cpos+1,nchar(ncbi$Geo_Location))
idx <- which(cpos<0); ctry[idx] <- ncbi$Geo_Location[idx]
ncbi$Country <- ctry

message("NCBI")
x <- aggregate(rep(1,nrow(ncbi)), by=list(Country=ncbi$Country),FUN=sum)
x <- x[order(x[,2],decreasing=TRUE),]
x[,2] <- x[,2]/sum(x[,2])
print(head(x))

# gisaid N by country
is_bad <- gisaid$numN > mean(gisaid$numN)
x <- aggregate(is_bad, by=list(country=gisaid$country),FUN=sum)
colnames(x)[2] <- "isbad_sum"
tot <-aggregate(rep(1,nrow(gisaid)), by=list(country=gisaid$country),FUN=sum) 
colnames(tot)[2] <- "totalseq"
both <- merge(x,tot,by="country")
both$badNorm <- both$isbad_sum/both$totalseq
both <- both[order(both$badNorm,decreasing=TRUE),]
both <- subset(both, totalseq > 10)

require(ggplot2)
p <- ggplot(both, aes(totalseq,badNorm)) + geom_point()
pdf("~/genomeQC/countN_byCountry.pdf")
tryCatch({
	print(p)
},error=function(ex){
	print(ex)
},finally={
	dev.off()
})


