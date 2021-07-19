# Essex Summer School in Social Science Data Analysis
# 2X Introduction to R
# Phil Swatton
# Modified from 1X Introduction to R files by Lorenzo Crippa
# Sunday 23rd July 2021, 11am-5pm BST
# File 01: data types, data structures, using functions




# 1 Introduction  ----

# First things first: text proceeded by a hashtag in R is a comment. If you 
# run a comment through R, it will ignore it! This is useful for helping both
# other people AND your future self in 6 months' time understand what your code
# was supposed to be doing.

# To run a piece of code in an R script, move your cursor to that line and press
# ctrl+enter (cmd+enter for Mac):
2 + 2

# You can also click the 'run' button at the top-right of the R script:
2 - 1

# To run a specific selection of code, or multiple unrelated lines, highlight
# them and then run them as normal:
3 * 5
20 / 10

# Note that running lines with ctrl+enter/cmd+enter/clicking 'run' skips comments:
2 * 10
# this will be ignored!
2 / 10

# ALWAYS (with one exception) do your work in R files - this ensures that you
# and others can replicate your steps

# Some other useful keyboard shortcuts in RStudio:
# ctrl+z (cmd+z for Mac): undo
# ctrl+s (cmd+s for Mac): save
# ctrl+shift+c (cmd+shift+s for Mac): comment/uncomment current/highlighted lines




## 1.1 R Data Types ----

# There are four main data types in R. We'll go over the first three now, and 
# talk about the last one later.

# 1) Numbers
0
1.5
3/4
pi
2e+10

# 2) Strings
"abc"
"hello, world!"
'notice Strings can use double or single quotes'
"strings can also contain hastags without a problem #"
# "but a hastag BEFORE the quotes will mean it's a comment"
"you can include single quotes in side a double-quotes string: ' "
'or double quotes inside a single-quotes string: " '
"or you can use a backslash to include the same kind of quotes in the same kind of string: \" "
'as above: \' '

# 3) Logical:
TRUE
FALSE

# 4) Categories: [England, Scotland, Wales, Northern Ireland]
# We'll talk about this one in a bit

# 5) Special cases
# Not really a data type in their own right, but can be important:
NA # missing data - the most important for today's purposes
NaN # not a number - will only happen if something has gone wrong!
NULL # basically an undefined value - there's nothing there (not even missing data!)




## 1.2 Creating objects ----

# Data types can be contained in R objects.

# A number is an object, a dataset is an object, a plot is an object, a function too is an object.
# The environment in R can take multiple objects at the same time.

# In R we make vast use of the <- operator to assign values to objects. 
# In RStudio you can obtain the operator quickly by typing the "alt" + "-" keys together.

# For instance:
a <- 2
# If you run this code ("ctrl" or "cmd" + "enter" to do it quickly) you'll see that you've assigned
# the value "2" to the object a. We can ask R to show us the content of an object:
a

b <- 5
a*b # the program returns the product of a and b, 10.
a+b
a-b

# notice this:
a + b == 8 # this is a statement, and it means: a + b equals 8. Is it 8? No! Then it's FALSE, or F
a + b != 8 # this means: a + b is not equal to 8. This is TRUE, or T

# you can perform operations by using objects or numbers:
2*5
2^4
a^b
2^b
2^(-b*a)
sqrt(2) # squared root of 2
sqrt(b)
sqrt(-b*a) # squared root of a negative number: it is not a real number!

# and we can also ask for more complicated objects:
log(b) # the natural logarithm of b
log(b, base = 10) # logarithm of b, base 10
log(b+1) # natural logarithm of b+1
exp(a) # e^a

# of course you can store those results in objects
my.object <- exp(b)

# notice that you can also use the "=" to assign values to objects
a = 2*5 + sqrt(3) - pi
# yet, the "=" is also used to specify options and parameters in functions 
# (more on this below), so we prefer using the <- operator to assign values

# when you work in R you have three best friends:
# first, the help files and documentations for each function in each package.
# Whenever you're in doubt on a function, just type ? and your function to get help:
?exp()
# or simply look within the pdf that is associated with each package in CRAN.
# your other two best friends when working in R are Stack Overflow and Google.

## 1.3 Types of objects ----

# There are many types of objects in R. Today we focus our attention on:
# 1) vectors
# 2) matrixes (2-dimensional vectors)
# 3) data frames
# 4) lists

# We can roughly summarise objects we'll work with in R based on whether they 
# contain data of the same type (homogeneous) or not (heterogeneous), and based on 
# their number of dimensions:

#	               | Homogeneous |	Heterogeneous |
# ---------------+-------------+----------------+
# One dimension  |	 Vectors   |	    Lists     |
# Two dimensions |	Matrixes	 |	 Data frames  |
# ---------------+-------------+----------------+

### 1.3.1 vectors ----

# Vectors are one-dimensional objects that can have different lengths and can
# contain different values, but all of the same nature (all numeric, all characters, all logical...)
my.first.vector <- c(1, 5, 2, 6, 8, 9, 12, 2.4, 0.3, -2.56)
# the c() function stands for "concatenate" and is used to join objects together
my.first.vector

# how long is my vector?
length(my.first.vector) # it's a vector of length 10

# you can access the value of a specific element in your vector using squared brackets:
my.first.vector[8] # the value of the eighth element in our vector
my.first.vector[6]

# we can also decide to store string elements in our vector:
a.string.vector <- c("here", "are", "some", "elements")
a.string.vector

# paste() is a useful function to use with strings:
c <- "hello"
d <- "world"
paste(c, d)
paste(c, d, sep = ",") # specifies the separator of the two objects!
paste(1, 2)

# paste0() is a similar function, which by default puts no separator:
paste0(c, d)

# Notice this: you can't have different types of objects at the same time in a vector!
wrong <- c("this will not work", 2)
wrong # R has automatically turned our 2 into a string (a "2").

# our vector can also be a factor. This is used to create categorical variables 
# In this case we need to introduce the factor() function
category <- factor(x = c("England", "England", "England", "Scotland", "Scotland", "Wales", "Wales", "Northern Ireland"))
category
# we have created a categorical vector with four levels: England, Scotland, Wales, Northern Ireland

# we can have logical vectors (or boolean), which can only take values TRUE or FALSE (1 or 0)
l <- c(T, F, F, T)
l <- c(TRUE, FALSE, FALSE, TRUE)
l

# notice that we can get the same result by doing the following:
l2 <- as.logical(c(1, 0, 0, 1))
c(1, 0, 0, 1)
l2
# notice what we have done: we've asked R to first create a numeric vector 1,0,0,1 using
# the c() function. Then we have applied to this vector the function as.logical(), which
# tries to turn its argument into a logical vector. 

# whenever we want to know what type of object is an r object we can do:
class(l2)
class(category)
class(a.string.vector)
class(my.first.vector)

### 1.3.2 matrixes ----

#	               | Homogeneous |	Heterogeneous |
# ---------------+-------------+----------------+
# One dimension  |	 Vectors   |	    Lists     |
# Two dimensions |	Matrixes	 |	 Data frames  |
# ---------------+-------------+----------------+

# A matrix is a two-dimensional vector. Besides being two-dimensional, the same rules of vectors
# apply to matrix: a matrix can only contain data of the same type.
# Suppose we want a 3x4 matrix with numbers from 1 to 12 in its cells:  
m <- matrix(data = 1:12, # the data in our matrix. Pick all integers from 1 to 12 (included)
            nrow = 3, # the number of rows 
            ncol = 4, # the number of columns
            byrow = TRUE) # do we want data to be stored in cells by row or by column?
m

# we can access an individual element of a matrix in R by specifying its position:
m[2,4] # the object in the 2nd row, 4th column
m[,1] # all the first column
m[1,] # all the first row

# we can also give names to our columns and rows:
colnames(m) <- c("one", "two", "three", "four")
rownames(m) <- c("a", "b", "c")
m

# R can also perform matrix algebra:
m2 <- matrix(data = seq(from = -1, to = 0.1, by = 0.10), # seq() gives you a sequence
             nrow = 3)
m2

# matrix addition:
m + m2
m - m2

# multiplication by a scalar:
a * m
m * a

# matrix multiplication:
mat1 <- matrix(data = rep(4, times = 8), # rep() replicates the first argument (4) a number of times
               nrow = 4)
mat1

m %*% mat1

# you can also obtain the transpose of a matrix using the t() function:
t(m)

# and the inverse of a (square) matrix using the solve() function:
m <- matrix(data = c(9, 3, 6, -1, 2, 4, 5, 6, 4), nrow = 3)
m
solve(m)

# You can also have arrays, that are matrixes with more than 2 dimensions.
# You can think of them as matrixes stacked on top of each other, possibly
# in more than one dimension. This is not part of today's class.

# look at our environment, on the right. Now we have quite some stuff in it and we
# might want to do some cleaning. The rm() function removes objects:
rm(a, b, a.string.vector)
# or maybe we want to remove everything:
rm(list = ls())

# it's always safest to start your R script clearing everything, so 
# that line of code should always be on top of your project.

### 1.3.3 data frames ----

#	               | Homogeneous |	Heterogeneous |
# ---------------+-------------+----------------+
# One dimension  |	 Vectors   |	    Lists     |
# Two dimensions |	Matrixes	 |	 Data frames  |
# ---------------+-------------+----------------+

# They are perhaps the most common object you'll be dealing with in R.
# Most databases are imported automatically as data frames (df).
# They have multiple variables organized in columns, and each row represents one observation
# They look like the typical database you might have dealt with in STATA, SAS or SPSS

# Before importing one, let's create one from scratch and see how it looks like.

datafr <- data.frame(
  var1 = c(rep("a", 3), rep("b", 4), rep("c", 2), "d"),
  var2 = rnorm(n = 10, mean = 0, sd = 1.3), # here we are drawing 10 random values from a 
  # normal distribution with mean = 0 and sd = 1.3
  var3 = c(1, -4, 2, 4.2, 5.3333, 1/9, 7.5, 0.000, 1-12, sqrt(2)) # notice that here we are
  # creating a vector where the elements are expressions! We also include the squared root of 2
)
version
datafr

# in the code above we draw random values from a normal distribution. We can easily draw 
# random values from many distributions in R. E.g.:
set.seed(123445789)
rbinom(n = 5, size = 10, prob = 0.4) # draw 5 random values from a binomial distrib with n = 10, p = .4
rnorm(n = 5, mean = 12, sd = 0.2) # draw 5 random values from a normal distr. with mean = 12, sd = 0.2
runif(n = 3, min = 0, max = 2) # draw 3 random values from a uniform distr. with min = 0, max = 2
rt(n = 12, df = 14) # draw 12 random values from a t-student distribution with 14 degrees of freedom
rf(n = 10, df1 = 5, df2 = 12) # 10 random values from an F distribution...
# ...etc

# each variable within our data frame is a vector, and the rules of vectors apply to them.
# all variables in a data frame must have the same length. But we might have variables with
# missing values. In R these missing values are called NA:
df <- data.frame(var1 = c(rep("a", 3), rep("b", 4), rep("c", 2), "d"),
                 var2 = c(1,2,3,4,5,NA,7,8,9,10))
df # we have a missing value in var2

class(datafr)

# we can access information in one column of our data frame using the $ operator:
datafr$var1 # this gives us precisely the object we want.
datafr$var3

class(datafr)
class(datafr$var1)
class(datafr$var2)
class(datafr$var3)

# we can then use these vectors to perform all operations as for other vectors.
datafr$var2 * 4

# for instance, we might want to see what is the value of the fifth element in the
# column "var3" of the data frame "datafr":
datafr$var3[5]
df$var2[6]
df$var2[2]

# we can also change values of course!
datafr$var3[4] <- 3.79812312

### 1.3.4 lists ----

#	               | Homogeneous |	Heterogeneous |
# ---------------+-------------+----------------+
# One dimension  |	 Vectors   |	    Lists     |
# Two dimensions |	Matrixes	 |	 Data frames  |
# ---------------+-------------+----------------+

# Lists are the last object type that we briefly consider today. Lists are objects that include
# different other objects in R, of whatever type. A list can even contain another list.
ls <- list(df, datafr, datafr$var2)
ls

ls2 <- list(df, ls)
ls2

# etc.

# there are many functions that allow you to try to coerce the nature of an object:
# as.numeric() tries to coerce its argument into a numeric
# as.integer() tries to coerce its argument into an integer
# as.character() tries to coerce its argument into a character
# as.factor() tries to coerce its argument into a factor

# for instance you might want to coerce the variable var1 into a factor:
datafr$var1 <- as.factor(datafr$var1)

# and also its class!
# as.matrix()
# as.data.frame()
# as.array()
# as.list()