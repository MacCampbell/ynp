# Starting out
This file details the steps that the "analysis.R" script conducts.

## First, I like to load packages that we'll need

library(adegenet)  
library(ggplot2)  
library(ggrepel)  
library(poppr)  
library(dplyr)  
library(ape)  

## Load data

load("final.rda")

  * This is an R data file. You'll see that it contains an object called final, that this is a genind object.
  * A genind object contains individual genotypes
  * Practically, this means that cleanDat2 has certain properties that are useful for our analysis.

## Exploring a genind object

1. Rename it

data<-final

2. What is data like?

data

  * What does this tell us about it? This is always important.

3. @pop vector

data@pop

head(data@pop)

  * This tells us where each individual is from. we can take a look at the frist few entries with head, as the vector is very long.

## Characterize populations

finalData<-poppr(final) 

  * This uses poppr to create a table, we can look at it within RStudio
  * Hexp is of interest to us
  * We also can see that there are some very small populations

### Get populations of a certain size

tenPops<-finalData[finalData$N>9,]

final10<-final[pop=tenPops$Pop]

  *What are tenPops and final10? We can view with RStudio
typeof(tenPops)

### Look at population relationships with DAPC
The basic command is dapc, let's see what it wants

help("dapc")  
dapc(final10)  
finalDapc<-dapc(final10, n.pca=75, n.da=nPop(final10)-1 )  
scatter(finaldapc)  
  *We can make it look better

scatter(finalDapc,xax=2, yax=1, scree.da=FALSE, include.origin=FALSE,  addaxes = FALSE)


#### This is a bit messy, but that is not necessarily bad. We can isolate information from datad
  * The dapc command created an object. What is it about?
  
finaldapc

  * We can isolate group centers with datad$grp.coord

finaldapc$grp.coord

#### We won't go into detail from the analysis script, but the code now produces a geographically oriented plot with color coding along axes as a gradient. Copy the below code.

dapc2<-finalDapc
points<-cbind(dapc2\$grp\.coord[,2], dapc2\$grp\.coord[,1])  
xp<-as.vector(points[,1])  
yp<-as.vector(points[,2])\*-1  

inds<-tbl_df(data.frame(dapc2$ind.coord[,2], dapc2$ind.coord[,1]))  
xi<-as.vector(inds[,1])  
yi<-as.vector(inds[,2])*-1  

inds\$dapc2\.ind.coord\.\.\.2\.<- inds\$dapc2\.ind.coord\.\.\.1\.\*-1

\#https://stackoverflow.com/questions/18110531/scatterplot-with-x-and-y-axis-color-scales  
chooseColors <- function(x, y) {  
  x <- 1-x/max(x)  
  y <- 1-y/max(y)  
  return(rgb(green=y/2, red=y, blue=x))  
}  

\#set min to 0  
xP<-(xp+(-1\*min(xp)))  
yP<-(yp+(-1\*min(yp)))  
xI<-(xi+(-1\*min(xi\$dapc2\.ind\.coord\.\.\.2\.)))  
yI<-(yi+(-1\*min(yi\$dapc2\.ind\.coord\.\.\.1\.)))    

ggplot()+  
  geom_point(aes(xP,yP), color=chooseColors(xP, yP))+ 
  geom\_label\_repel(aes(x=xP, y=yP), color=chooseColors(xP, yP), label = rownames(points),  
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


## A key question was the influence of hatchery trout in the study.  We have some  hatchery populations.

1. Subsetting is easy  
tmAndHatch<-final[pop=c("YOSV","SFMC","CRAN","ELAN","FROG","GCTR","GROS","JAWB",  "TUOL","MCDH","MCRR","REED","ROOS","SNOW","TAEI","TAPF","UCLV","UCRY","UNFT",  "USNO","Kamloops", "Mt. Shasta", "Eagle", "Coleman","Moccasin")]

2. We'll use DAPC here too

tmhatchClust<-find.clusters(tmAndHatch, n.pca=60, n.clust=8)
tmhatchD<-dapc(tmAndHatch, tmhatchClust\$grp, n.pca=70, n.da=6)

table(pop(tmAndHatch), tmhatchClust\$grp)
table.value(table(pop(tmAndHatch), tmhatchClust\$grp), col.lab=paste("Inferred", 1:8), row.lab=popNames(tmAndHatch))

3. We can also generate a phylogenetic tree  
tree<-aboot(final, strata=final@pop, tree="nj",distance="edwards.dist",
            missing="mean", cutoff=50, sample=100) #increase to 1000 for a more thorough analysis  
plot.phylo(tree, type="radial",show.node.label = TRUE)  

4. For a STRUCTURE analysis, we can generate a datafile like this  

finalS<-final  
popnums<-as.numeric(finalS@pop)  
finalS@pop<-factor(popnums)  


df <- as.loci(finalS) #converting genind to loci object##   

write.loci(df, file = "/Users/mac/Dropbox/trout/TuMe/structure/data",  
        loci.sep ="\t", quote = FALSE, allele.sep ="\t", na ="-9\t-9",   
        col.names = FALSE) #writing the file#

-------

# Exercise
## Read in ynpDat.txt and conduct DAPC to identify how many groups are supported.
1. Reading in a file  
You can use the "pegas" package and the command "read.loci" to start  
If you have problems, look at help(read.loci) & the file being read  
2. Convert the resulting allelic data frame to a genind with "loci2genind"  
3. DAPC
  * Find the optimal number of groups with "find.clusters"
  * Assign these to the groups with the "dapc" function
  * Take a look at what we have done already
