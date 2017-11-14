# For the purposes of the SEDES workshop we are going to cover some R Basics.

# 1.  R ... What is? And, why should you care.

https://www.r-project.org "R is a free software environment for statistical computing and graphics."

R is an open-source, and therefore is free, with a huge user base that uses it for a wide range of things, such as geographic information systems or gene expression. It provides a way to conduct custom operations and access the most current methods others are doing. 

# 2.  A basic operation, assignment

R is "object-oriented." That means for us everything in R has a class with fields we can access. I'll draw an example of an object of class "car."  
The car has a field "trunk", and I can retrieve something from the trunk of the car. It may also have something in the "passenger seat." This is the basics of what I think is important in R data structures.

  * Let's create a basic object, a vector. By assigning the numbers 1 to 4 to it. A vector contains data of all the same type.
  
numbers <- c(1,2,3,4)

You'll notice that numbers was added to our environment in RStudio. See what is in numbers:

numbers

  * We could of course make the same thing with characters

letters <- c("a","b","c","d")

  * And an object may be empty

alphabet <- c()

  * But we can add things to alphabet easily, note the $ sign is accessing a field (like the trunk of a car) 

alphabet\$Numbers<-numbers
alphabet\$Letters<-letters

  * What does alphabet have in it now?

\> alphabet
\$Numbers
[1] 1 2 3 4

\$Letters
[1] "a" "b" "c" "d"

  * What type of data structure is alphabet?

typeof(alphabet)

# 3.  A basic operation, reading in data
Often, I have data in a text file such as .csv, that I'd like to do some analysis on. There is a handy R function for that.

  * Use read.csv to assign the contents of the file dfA.csv to the object "data"
  
# 4.  Operate on the new object "data"

summary(data)

# 5.  We can gain access to new functions outside base R with packages.

  * Install dplyr and ggplot2 and load these packages with "install.packages"
  * Load the packages with "library"
  * We'll convert data to a tibble and plot with ggplot


