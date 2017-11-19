# Here, let's examine some existing packages and functions that are available.

## 1. Reading in data

A common problem I have is getting data into R. We often have a .txt file and we need an object that is usable in R, such as a data frame or a genind obect.

I have include ynpDat.txt. Let's take a look at it (open it with your text editor of choice). Consider the following:

  * What is in it? That is what are we representing?
  * Is the data described by populations or individuals?
  * Is there a header?
  

  * Task: A handy way to read in data is with the package pegas. Create an Allelic data frame "x" with pegas using the function read.loci. It should look like:
 
\> x  
Allelic data frame: 896 individuals  
                    95 loci  

A common object for population genetics is "genind." This is usable by numerous programs. Create a genind object named "obj" with loci2genind. 


## 2. What is a genind object like?

\> obj   
/// GENIND OBJECT /////////  

 // 896 individuals; 95 loci; 223 alleles; size: 887.6 Kb  

 // Basic content  
   \@tab:  896 x 223 matrix of allele counts  
   \@loc.n.all: number of alleles per locus (range: 2-35)  
   \@loc.fac: locus factor for the 223 columns of \@tab  
   \@all.names: list of allele names for each locus  
   \@ploidy: ploidy of each individual  (range: 2-2)  
   \@type:  codom  
   \@call: df2genind(X = as.matrix(x[, attr(x, "locicol")]), sep = "/",   
    pop = pop, ploidy = ploidy)  

  // Optional content  
   \@pop: population of each individual (group size range: 1-102)  
 
  
There are lots of handy attributes such as ploidy. Let's explore a couple of these.

e.g. obj\@tab, obj\@pop, levels(obj\@pop)


#### You'll notice that we have 35 pops listed, but 20 described in the study. Ruh-oh. This happens to me all the time.  Here is one way to go about fixing this. I have used "plyr" and not revised it since.
install.packages("plyr")  
library("plyr")

obj2<-obj

groups<-read.table("groupingTable.txt", header=TRUE)

obj2\@pop<-mapvalues(obj2\@pop,as.character(groups\$Code), as.character(groups\$Group))

How about now?  What exactly happened? What is the pop vector like? The \@pop vector can easily be manipulated.

### 3. Let's do some basic quality control. First thing we should not forget are that some loci are linked to adaptation, those on Omy05, and won't reflect neutral divergences. Futhermore, you may want to remove additional loci to merge datasets.

Subsetting is really easy, such as:

obj2[loc=c("SH10077163")]

Likewise for populations:

obj2[pop=c("TUOL")]

Unfortunately, I haven't found a way to negate, such as != with geninds. Here is what I have done, let me know if you find a better way.

obj3<-obj2[loc = c("SH95489423","SH10077163","SH102510682","SH105115367","SH108735311",  
"SH110201359","SH11312873","SH117286374","SH119892365","OMGH1PROM1SNP1","Omy_arp630",   
"SH96222125","SH100974386","SH102867443","SH105385406","SH109243222","SH110362585",  
"SH114315438","SH117370400","SH120255332","SH128851273","Omy_aspAT123","Omy_g1282",  
"SH9707773","SH101554306","SH103350395","SH105386347","SH109525403","SH110689148",  
"SH117540259","SH120950569","Omy_COX1221","Omy_gh475","SH97954618","SH101770410",  
"SH103577379","SH105714265","SH109651445","SH111666301","SH114587480","SH11781581",  
"SH129870756","Omy_nramp146","Omy_gsdf291","SH98188405","SH101832195","SH103705558",  
"SH106172332","SH109693461","SH112208328","SH114976223","SH118175396","SH123044128",  
"SH130524160","Omy_Ogo4304","Omy_mapK3103","SH98409549","SH101993189","SH104519624",  
"SH106313445","SH109874148","SH112301202","SH115987812","SH11865491","SH12599861",  
"SH130720100","OMY_PEPAINT6","Omy_mcsf371","SH98683165","SH102420634","SH105075162",  
"SH107074217","SH110064419","SH11282082","SH116733349","SH118938341","SH131460646",  "ONMYCRBF_1SNP1","SH95318147","SH99300202","SH102505102","SH105105448","SH10728569", "SH110078294","SH113109205","SH11725996","SH119108357","SH127510920","SH131965120")]  

##### Those are a couple of really common things that happen to me.

---

The package poppr:

Use missing.no to remove loci and individuals missing with at least 5% missing data from obj3. My obj3 now contains:

 867 individuals; 87 loci; 174 alleles; size: 690.8 Kb  


### 4. Basic characteristics.  Again, we are saved by the fact that someone has done a lot of work for us already. for instance, we can use poppr's poppr function on obj3. There are a lot of things going on here....

table<-poppr(obj3)

It should start like this:  

   Pop  N MLG  eMLG    SE    H  G lambda   E.5  Hexp      Ia     rbarD File  
1 YOSV 81  80  9.99 0.117 4.38 79  0.987 0.993 0.342  0.2751  0.003314 obj3  
2 SFMC 45  45 10.00 0.000 3.81 45  0.978 1.000 0.335 -0.0459 -0.000556 obj3  
3 CRAN 27  27 10.00 0.000 3.30 27  0.963 1.000 0.311  0.3821  0.005096 obj3  


Anything not look good? In the entire table... Let's filter it.

table[table$N\>10,]

---

Task: Create a fourth genind object "filtered" including only populaitons greater than 10 individuals.

  * Remember, there is always more than one way to accomplish a task in R.
  * Hint: you can susbet a genind object with pop= like loc=, so all you need is a vector of desired pops.
  
\> length(levels(filtered\@pop))
[1] 16

### 5. AARRGGGHHH, but we haven't done any analyses yet!! I know, but this up front wrangling is the most time consuming and I wanted to provide several examples of cases you may experience first hand.

