# Essex Summer School in Social Science Data Analysis
# 2X Introduction to R
# Phil Swatton
# Modified from 1X Introduction to R files by Lorenzo Crippa
# Sunday 25th July 2021, 11am-5pm BST
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

# csv (comma separated values) are a common file format across the world. R
# comes with a ready-made read.csv() function for csv files. Let's use it to
# read in match_players.csv:

aoe <- read.csv("data/match_players.csv") #data/ is because it's stored in the 'data' folder of these files
class(aoe)

# match_players.csv contains player data from matches from the game Age of 
# Empires 2. You can find the full version of the dataset on Kaggle at
# https://www.kaggle.com/jerkeeler/age-of-empires-ii-de-match-data?select=match_players.csv


# We can view a dataset in a pane either by clicking on its name in the global
# environemnt or with the View() function (note the capital V):
View(aoe)

# We can get a sense of our dataset by looking at the top few rows:
head(aoe)

# And we can use the str() function to see what types of variable we have in
# our data frame:
str(aoe) # 'int' or 'integer' is one kind of numeric. The other you'll likely see is 'dbl' or 'double'. In R, 99% (or more) of the time you won't need to worry about this distinction


# We can remove columns we don't need by assigning NULL to them:
aoe$X <- NULL
head(aoe)




## 1.4 Other file types

# Often, you won't find files in a csv format. One format that's very common
# (at least in political science) is STATA's dta file format. For this, we need
# to use an R package because base R doesn't have the functionality to import
# them.

# R packages contain code written by other R users that have been bundled up and
# made available on CRAN (from where you downloaded R).

# Often, if you need to do something in R, you'll probably be using a package to
# do it. The best way to find them is by using google, but I'll include some
# recommendations at the end of today's class.

# I've downloaded the 2019 Chapel Hill Expert survey from their website
# (https://www.chesdata.eu/our-surveys). But I've downloaded it in dta format.

# Since it's a fairly recent file (STATA version 13 or later), we'll use the
# readstat13 package. To install it, we use the install.packages function:

install.packages("readstata13")


# You only need to install a package once. However, since we don't want all
# of our packages in memory all the time when using R, we have to explicitly
# load them for each fresh R session. We do this with the library() function:
library(readstata13)


# While I've written this library call here, normally it's a good
# idea to have library calls at the TOP of your script. This helps your future
# self, collaborators, and replicators know in advance what packages you used.

# Now, we'll use the read.dta13 function from readstata13 to load in the CHES
# dataset:
ches <- read.dta13("data/CHES2019V3.dta")


# Some other packages you'll want installed are the foreign and readxl packages:
install.packages(c("foreign", "readxl"))

# Foreign is a good workhorse package for reading in data. It has read.dta (for
# STATA versions prior to 13 - probably more common that later dta files) and
# read.spss among other functions.

# readxl is the package you want for reading in excel files - read_xls() and
# read_xlsx() depending on your need.

# We'll also be installing readr later on in this class - I'll mention when we
# do.




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