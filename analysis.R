# Here, we are going to load the pooled data.
library(adegenet)
library(ggplot2)
library(ggrepel)
library(poppr)
library(dplyr)
library(ape)
library(pegas)

load("final.rda")

# Get basic stats

finalData<-poppr(final) 

# Filter for pop size
# Filter out n<10
tenPops<-finalData[finalData$N>9,]
final10<-final[pop=tenPops$Pop]


# Conduct a DAPC

finalDapc<-dapc(final10, n.pca=75, n.da=nPop(final10)-1 )

scatter(finalDapc,xax=2, yax=1, scree.da=FALSE, include.origin=FALSE,  addaxes = FALSE)

dapc2<-finalDapc
points<-cbind(dapc2$grp.coord[,2], dapc2$grp.coord[,1])
xp<-as.vector(points[,1])
yp<-as.vector(points[,2])*-1

inds<-tbl_df(data.frame(dapc2$ind.coord[,2], dapc2$ind.coord[,1]))
xi<-as.vector(inds[,1])
yi<-as.vector(inds[,2])*-1

inds$dapc2.ind.coord...2.<- inds$dapc2.ind.coord...1.*-1
#https://stackoverflow.com/questions/18110531/scatterplot-with-x-and-y-axis-color-scales

chooseColors <- function(x, y) {
  x <- 1-x/max(x)
  y <- 1-y/max(y)
  return(rgb(green=y/2, red=y, blue=x))
  #return(rgb(green=y, red=y, blue=x))
  
}
#set min to 0
xP<-(xp+(-1*min(xp)))
yP<-(yp+(-1*min(yp)))
xI<-(xi+(-1*min(xi$dapc2.ind.coord...2.)))
yI<-(yi+(-1*min(yi$dapc2.ind.coord...1.)))

ggplot()+
  geom_point(aes(xP,yP), color=chooseColors(xP, yP))+
  geom_label_repel(aes(x=xP, y=yP), color=chooseColors(xP, yP), label = rownames(points),
                   size = 3,
                   family = 'Times',
                   fontface = 'bold') +
  labs(x="West (Coastal)-    Axis 1    -(Central Valley) East", y="South (San Joaquin)-    Axis 2    -(Sacramento) North", title="DAPC Centers")+
  theme_classic()+
  theme(plot.title = element_text(hjust = 0.5))+
  theme(axis.ticks.x=element_blank(),
        axis.ticks.y=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.line=element_blank()
  )+
  annotate("segment", x=-1,xend=Inf,y=-0.7,yend=-0.7,arrow=arrow(), cex=1)+
  annotate("segment", x=Inf,xend=-1,y=-0.7,yend=-0.7,arrow=arrow(), cex=1)+
  annotate("segment", x=-1.2,xend=-1.2,y=-0.5,yend=Inf,arrow=arrow(), cex=1)+
  annotate("segment", x=-1.2,xend=-1.2,y=Inf,yend=-0.5,arrow=arrow(), cex=1)

###hatachery influence

###Hatcheries and tmData
tmAndHatch<-final[pop=c("YOSV","SFMC","CRAN","ELAN","FROG","GCTR","GROS","JAWB","TUOL","MCDH","MCRR","REED","ROOS","SNOW","TAEI","TAPF","UCLV","UCRY","UNFT","USNO","Kamloops", "Mt. Shasta", "Eagle", "Coleman","Moccasin")]


###Assignment plot with hatchery fish
# Data with pops of interest, tmAndHatch
tmhatchClust<-find.clusters(tmAndHatch, n.pca=60, n.clust=8)
tmhatchD<-dapc(tmAndHatch, tmhatchClust$grp, n.pca=70)

table(pop(tmAndHatch), tmhatchClust$grp)
table.value(table(pop(tmAndHatch), tmhatchClust$grp), col.lab=paste("Inferred", 1:8), row.lab=popNames(tmAndHatch))


###Phylogenetic relationships
tree<-aboot(final, strata=final@pop, tree="nj",distance="edwards.dist",
            missing="mean", cutoff=50, sample=100) #increase to 1000 for a more thorough analysis
plot.phylo(tree, type="radial",show.node.label = TRUE)


###Write Structure file
finalS<-final
popnums<-as.numeric(finalS@pop)
finalS@pop<-factor(popnums)
df <- as.loci(finalS) ###CONVERSION OF GENIND OBJECT TO LOCI OBJECT####
write.loci(df, file = "/Users/mac/Dropbox/trout/TuMe/structure/data", loci.sep ="\t", quote = FALSE,
           allele.sep ="\t", na ="-9\t-9", col.names = FALSE) ###WRITE STRUCTURE DATA FILE####