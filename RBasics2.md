# Let's cover some more R basics!
## Keeping in mind R is a statisical language, let's apply some of that to our data. We'll calculate the standard error and plot it for our allele frequencies from the dfA.csv file.

Requires: dplyr and ggplot2 if you don't have them loaded. Check your "packages" tab in RStudio.

  * Get our data

data<-tbl_df(read.csv("./data/dfA.csv"))

  * Standard error, from Hartl and Clark (1997), _Principles of population genetics_, what a classic!!

![](./examples/standardError.png)  

## Let's look at what we have in data first and relate that to our formula. It is fifteen rows of this:

\# A tibble: 15 x 4  
   Population     N   Allele  Frequency  
       <fctr> <int>   <fctr>      <dbl>  
 1       YOSV    85 R04944.4 0.19047619  
 2       SFMC    49 R04944.4 0.08888889  
 3       CRAN    27 R04944.4 0.03703704 
 
   * With the mutate function in dplyr, can you add another column to the data tibble with SE? If you can, name it data2 and have it look like this:
   

\> data2  
\# A tibble: 15 x 5  
   Population     N   Allele  Frequency         SE  
       <fctr> <int>   <fctr>      <dbl>      <dbl>  
 1       YOSV    85 R04944.4 0.19047619 0.03011693  
 2       SFMC    49 R04944.4 0.08888889 0.02874725  
 3       CRAN    27 R04944.4 0.03703704 0.02569958  

  * For things like this, I usually start with what will happen in one operation before expanding to others, like so:  

  sqrt((0.19047619\*(1-0.19047619)/(2*85)))  
  
Just do it fifteen times really fast!

### Now, to plot.  Thankfully, there is a built error bar plotting feature of ggplot.

1. Generate a bar plot

ggplot(data2, aes(Population,Frequency)) +  
    geom_bar(stat="identity", fill="blue")

2. Add error bars

ggplot(data2, aes(Population,Frequency)) +  
   geom_bar(stat="identity", fill="blue") +  
   geom_errorbar(aes(x=Population, ymin=Frequency - SE, ymax=Frequency + SE), size=1, width=0.75)

3. Make it look a bit nicer

ggplot(data2, aes(Population,Frequency)) +  
    geom_bar(stat="identity", fill="blue") +  
    geom_errorbar(aes(x=Population, ymin=Frequency - SE, ymax=Frequency + SE), size=1, width=0.75) +  
    theme_classic() +  
    theme(axis.text.x = element_text(angle = 90))  

![](./examples/sePlot.png)  
