# compare overall N's in genome to N's in Orf1a region

orfFile <- "merged_AllIsolates_30278Only_revComp_probes_aligned.fa_23500_24000_countN.txt"
fullFile <- "/home/spai/genomeQC/Delaram_File_200413/merged_AllIsolates_30278Only.fa_countN_200413.txt"

orf <- read.delim(orfFile,sep="\t",h=F,as.is=T)
orf <- orf[-1,]
colnames(orf) <- paste("orf",c("id","len","numA","numC","numG","numT","numN","numGap"),sep="_")
orf <- orf[,c(1,2,7)]
full <- read.delim(fullFile,sep="\t",h=F,as.is=T)
colnames(full) <- paste("full",c("id","len","numA","numC","numG","numT","numN","numGap"),sep="_")
full <- full[,c(1,2,7)]

both <- merge(x=orf,y=full,by.x="orf_id",by.y="full_id")

nm <- strsplit(both[,1],"\\/")
ctry <- unlist(lapply(nm,function(x) x[2]))
ser <- unlist(lapply(nm,function(x) x[3]))
ser2 <- substr(ser,1,regexpr("-",ser)-1)

both$virus <- unlist(lapply(nm, function(x) x[1]))
both$country <- ctry
both$region <- ser2

x <- both$full_numN;
y <- both$orf_numN;
print(cor.test(x,y))
 pdf("N_fullvsorf.pdf"); plot(x,y,xlab="Num N, full", ylab="Num N, ORF1 region"); dev.off()

write.table(both, file="N_fullvsorf.txt",sep="\t",col=T,row=F,quote=F)

