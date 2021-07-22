# Essex Summer School in Social Science Data Analysis
# 2X Introduction to R
# Phil Swatton
# Modified from 1X Introduction to R files by Lorenzo Crippa
# Sunday 23rd July 2021, 11am-5pm BST
# File 02: importing data sets, R packages, managing data with the tidyverse




# 1 Importing datasets ----

## 1.1 Clearing the environment ----

# Before we begin, let's make sure to clear our global environment. We can do
# this eithe with the following line of code:

rm(list = ls())

# Or by clicking on session -> clear workspace -> yes

# If you do it by code, make sure to keep that line *at the top* of your script.
# It's really important that you start fresh each time you do work in R, to make
# sure that your workflow (the order you do things) is replicable. In other words,
# it helps make sure that your future self or someone else can open up your script,
# run everything, and get the same result every time.




## 1.2 Working directories ----

# To read in and save files, R needs to know where in your computer to look.
# One way of doing this is by using the setwd() function to set your *working
# directory*. This is basically a location in your files that R will try and
# read files from and will save files to:

setwd("C:/Users/User/OneDrive/Documents/ESS/2021/1X") #this is the file path where I have the course files - you'd need to fill in your own


# you can view your current working director with getwd():
getwd()


# However, an easier and better way of managing this is with R projects. By
# opening a project in RStudio, your working directory will automatically be
# set to the location the project is in.

# This is especially useful if you ever need to move your files around or
# work with collaborators - it gets rid of all the hassle of file paths.

# In our class files I've included a project called 2X.Rproj. Go to file ->
# Open Project and open it now.

# You can create a new project from the file window. Doing so will also create
# a new folder with the project inside.

# In general, I would *strongly* recommend using R projects to manage your
# file paths.




## 1.3 CSV files ----

# R comes with a ready-made read.csv function for csv (comma separated values)
# files. Let's use that now to read in the baseball

# now import data from a csv file and save it in an object
baseball <- read.csv("baseball.csv")
class(baseball)

# we have imported this csv file on characteristics of US baseball players. It's automatically
# imported as a data frame. To see it you can type:
View(baseball) # or simply click on the data frame in your environment to the right ---->

# it's also good to take a look at our datasets by doing:
head(baseball) # shows the first 6 observations, all columns
str(baseball) # tells us what types of variables we have in our data frame

# as you can see we have a first column we don't really need.
# We can remove it by doing:
baseball$X <- NULL # great.

# before starting to do some analysis, let's see how to import datasets with other extensions.
# Suppose we have a dta file (STATA extension) to import. In this case, base R will
# not be able to import it. We need to install and load a package. We will make use
# of plenty of packages when working in R.
install.packages("foreign") # foreign is a good package to load data from STATA

# Now we have installed it. In order to use the package we need to tell R to load it:
library("foreign") # now we can use it.

ANES <- read.dta("anesByState.dta")
View(ANES)

install.packages("readr")
library("readr")

# In case we wanted to import a database from Excel, the package we want to rely on is readxl
install.packages("readxl") # and its functions read_xls() and read_xlsx()
# then you should load it, of course, using: library("readxl")
library("readxl")

# 2 Manage datasets ----

# Database management (dropping observations and vars, sorting our data, etc.) 
# can be done using the basic R language. 
# Nevertheless, a suite of packages has also been developed to write code in R in a much
# more natural syntax. The suite is called tidyverse. We can install it by running:
install.packages("tidyverse")
library("tidyverse")
# but you can also load its packages individually, like:
library("dplyr")

# in what follows, you'll see code for managing datasets in base R, and next you'll see the
# (more intuitive) tidyverse version of the same operations. It's important to know both

# suppose now we want to drop from our baseball data all observations that refer to the CLE team
# (no offense to its fans). Doing it in base R would be:
baseball.no.CLE <- baseball[baseball$team != "CLE", ]
# which means: put in the object "baseball" the object "baseball" itself, but only the rows
# that have baseball$team different from "CLE". Keep all the columns.

# Suppose now we want to get rid of all observations that are not for New York Yankees (NYY) and also
# we want to drop the column "name". Yet, we don't want to overwrite the "baseball" object
# because we might need the information we're dropping later. We can do the following:
baseball.2 <- baseball[baseball$team == "NYY", 2:4]

# create a new object called "baseball.2" where we put the object "baseball", but only the
# rows that have baseball$team equal to NYY and the columns from the 2nd to the 4th.

# notice that the condition is imposed using ==, and not = (which is used to assign values)

# these operations are made smoother by tidverse Let's do something similar on ANES:
# Remove all observations from the year 2000, then remove the variable turnout:
ANES <- filter(ANES, # what is your data frame? 
               year != 2000) # the condition you impose
ANES <- select(ANES, 
               -turnout) # keep everything BUT the variable named "turnout"

# now suppose we want to sort observations in our ANES dataset based on state, then year.
# We can do it by:
ANES[order(ANES[,2], ANES[,1]),]
# by doing this we have taken ANES and we have asked R to reorder its rows first based on the
# second column (state), then by its first column (year). Notice that this time we have not
# saved the data frame obtained into an object!

# Another useful function is unique(). It tells us what values a vector takes:
unique(ANES$year) # all possible years in the ANES dataset

# we might want to have it sorted:
sort(unique(ANES$year)) # years from 1952 to 2008 by 2-year distance. 
# We don't have 2000 as we dropped it early on.

# We can also add variables to our data frames. What if we wanted to add the squared value 
# of "poor" in the ANES data frame? In base R this is done by doing:
ANES$new.var <- ANES$poor^2

# we can also do it in tidyverse by doing:
ANES <- mutate(ANES,
               new.var = poor^2)

# ifelse() is a function that is very useful to know. If its "test" argument (a condition)
# is verified, it does what the "yes" argument says. Otherwise, it executes the "no" argument.
# For instance, in ANES we might want to have a variable that takes value 0 
# if the year is before 2000, and 1 otherwise. We can do it like this:
ANES$indicator <- ifelse(test = ANES$year >= 2000, yes = 1, no = 0)
unique(ANES$indicator)

# ifelse() is very handy but you can imagine it can make things rather complicated when you
# want to chain conditions like:
ANES$indicator.2 <- ifelse(test = ANES$year >= 2000, yes = 1,
                           no = ifelse(test = ANES$year >= 1980, yes = 2, no = 0))
# if the first condition is met, it gives a value of 1. If it is not met, this opens up a 
# new condition. If that condition is met, it gives a value of 2, otherwise a value of 0. 

# this gets extremely messy when you already have something like four conditions 
# (four ifelse() functions). To avoid the problem, we can use the tidyverse function case_when():
ANES$indicator.2 <- case_when(ANES$year >= 2000 ~ 1,
                              ANES$year >= 1980 ~ 2,
                              TRUE ~ 0)

# or you can do all of it in tidyverse and do:
ANES <- mutate(ANES,
               indicator.2 = case_when(ANES$year >= 2000 ~ 1,
                                       ANES$year >= 1980 ~ 2,
                                       TRUE ~ 0))

# Time for exercises!