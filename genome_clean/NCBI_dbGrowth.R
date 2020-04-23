# num sequences as function of date
dat <- read.delim("/home/project_resources/data/genomes/NCBI/NCBI_CoV2_metadata_200420.csv",sep=",",h=T,as.is=T)

dt <- dat$Release_Date
dat$yr <- as.integer(substr(dt,1,4))
dat$mon <- as.integer(substr(dt,6,7))
dat$day <- as.integer(substr(dt,9,10))

idx <- order(dat$yr,dat$mon,dat$day)
dat <- dat[idx,]
dat$date2 <- sprintf("%s-%s-%s",dat$yr,dat$mon,dat$day)
uq <- dat$date2[!duplicated(dat$date2)]
dat$date2 <- factor(dat$date2,ordered=TRUE,labels=uq)

require(ggplot2)
dt <- format(Sys.Date(),"%y%m%d")
pdf(sprintf("NCBI_count_%s.pdf",dt))
tryCatch({
	p <- ggplot(dat, aes(date2))
	p <- p + geom_bar() + xlab("Release date") + ylab("Num genomes")
	p <- p + ggtitle("NCBI SARS-CoV-2 genomes: Database growth")
	p <- p + theme(axis.text.x = element_text(angle = 90, hjust = 1,size=8),
				   axis.text.y=element_text(size=15))
	print(p)
},error=function(ex) {
	print(ex)
},finally={
	dev.off()
})


