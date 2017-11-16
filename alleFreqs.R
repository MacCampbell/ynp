#Here, we generate bar plots of omy05 frequencies
library("poppr")
library("pegas")
library("adegenet")
library("plyr")
library("reshape2")

y <- read.loci("ynpDat.txt", header = TRUE, allele.sep="/", col.pop =1)
datay<-loci2genind(y)

#Group
groups<-read.table("groupingTable.txt", header=TRUE)

datay@pop<-mapvalues(datay@pop,as.character(groups$Code), as.character(groups$Order))


#Two loci are linked to omy05
data5<-datay[loc=c("Omy_R04944","SH11444887")]

#Filter for sample size
popdata5 <- poppr(data5)
popdata5Min10 <- popdata5[popdata5$N>9,]

data5Min10 <- data5[pop=popdata5Min10$Pop]

#Get data
freqs <- seploc(data5Min10)

#Omy_R04944
# 2 or C is R
#SH11444887
# 1 or A is R

#Splitting into loci
Omy_R04944<-tab(freqs[["Omy_R04944"]])
listR<-(Omy_R04944 <- apply(Omy_R04944, 2, function(e) tapply(e, pop(data5Min10), mean, na.rm = TRUE)))
listR<-listR/2

SH11444887<-tab(freqs[["SH11444887"]])
listS<-(SH11444887 <- apply(SH11444887, 2, function(e) tapply(e, pop(data5Min10), mean, na.rm = TRUE)))
listS<-listS/2



target<-c("UNFT","TUOL","UCLV","REED","JAWB","ELAN","FROG","TAEI","TAPF","GCTR","ROOS",
          "MCDH","GROS","CRAN","SFMC","YOSV")  
dfA<-melt(data.frame(R04944.4=listR[,2], Population=levels(pop(data5Min10))),
          variable.name="Allele")
          colnames(dfA)[3]<-"Frequency"
dfA$Population<-target
  #factor(dfA$Population, levels=target)

ggplot(dfA, aes(Population, Frequency)) + 
  geom_bar(position=position_dodge(width=0.5), width = 0.7, stat="identity", color="black")+
  theme(axis.title.y = element_text(size = rel(2)))+
  theme(axis.title.x = element_text(size = rel(2)))+
  theme(axis.text.x = element_text(angle = 90))+
  labs(x="\nSampling Location", y="Frequency of A-Type MAR\n")+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  scale_fill_manual(values=c("blue"))+
  scale_y_continuous(expand=c(0,0))+
  coord_cartesian(ylim = c(0, 0.4))+
  theme(text=element_text(family='Times'))+
  theme(axis.text.x= element_text(face="bold", size=14, vjust = 0.5))+
  theme(axis.text.y= element_text(face="bold", size=14))+
  guides(fill=FALSE)+
  geom_text(aes(x=Population, y=Frequency+0.005,
                label=c("*","*","","","*","","","","*","","","","","","")), size=12)

