# Here, let's examine some existing packages and functions that are available, part 2. DAPC

### What the heck is DAPC?

Source paper: https://bmcgenet.biomedcentral.com/articles/10.1186/1471-2156-11-94

The corresponding R package is extensively documented by Thibaut Jombart and many resources are already available, especially for the adegenet package. https://github.com/thibautjombart/adegenet/wiki/Tutorials  

The main take home from me from __D__ iscriminant __A__ nalysis of __P__ rincipal __C__ omponents (DAPC) is that you can infer the number of groups (aka genetic clusters) from your data without prior knowledge.  This is a task we do subjectively all the time. What makes a sampling location? How many clades are meaningful? Etc.

Survey: Do you use STRUCTURE or DAPC now? My thoughts are that you should do both, but we don't have time to get into STRUCTURE.

### What is it doing?

DAPC is converting our data data in principal components, after which it conducts a discriminant analysis. In my mind its major strengths are:
  *  Allows for linked loci
  *  Does not assume an underlying population genetics model (e.g. panmixia)
  *  Computationally less demanding than, say, STRUCTURE

DAPC is using general mathematical procedures on our genetic data.  Principal Component (PC) analysis is often used to find axes of variation. E.g. from the lecture material.

![](./examples/Figure7.png)  

Plotting principal components shows axes of maximal variation, but does show axes that maximally distinguish groups?

### Let's generate DAPC and PC plots from our data and see what we find!

First off, we can load the data we stored earlier.

load("filtered.rda")

\> filtered
/// GENIND OBJECT /////////

 // 848 individuals; 87 loci; 174 alleles; size: 676.6 Kb

#### 1. DAPC

First, we can see how to differentiate predefined populations with dapc. Make sure the packaged "adegenet" is loaded and then:

d1<-dapc(filtered)

We have to make some choices here...

d1 is loaded with things! View by typing d1

\>d1

If you want, you can pick apart the dapc object d1 for various reasons and for plotting on your own.

Let's look at the basic scatter provided.

scatter(dapc)

There is some customization possible with scatter, such as adding scree.da = FALSE.

![](./examples/Figure7.png)  
