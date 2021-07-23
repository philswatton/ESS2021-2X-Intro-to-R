# Essex Summer School in Social Science Data Analysis
# 2X Introduction to R
# Phil Swatton
# Modified from 1X Introduction to R files by Lorenzo Crippa
# Sunday 25th July 2021, 11am-5pm BST
# File 03: Summary statistics and plots


rm(list=ls())
# Before you begin - empty your environment as before. This time, we also want
# to start with a fresh R session (no packages loaded) to make sure our work is
# replicable.

# Note the important thing - I can go back to file 02 and recreate the
# data frames I made from the raw data. NONE of the raw data has been
# overwritten!

# To do this, click on Session -> Restart R

# Once this two things are done, go ahead and load the packages:


## Packages
install.packages("psych") # normally I wouldn't include this line in a script, but today we're installing as we go
library(tidyverse)
library(readstata13)
library(psych)


## Data
aoe <- read.csv("data/match_players.csv")
ches <- read.dta13("data/CHES2019V3.dta")



# 1 Summary statistics ----

# base R's summary function is a good workhorse function for descriptive stats:
summary(aoe$rating)

# it can be used for an entire dataset:
summary(aoe)
summary(ches)

# we can store summaries like any other object:
aoeSummary <- summary(aoe)
class(aoeSummary)


# the stats package is installed with base R and doesn't need to be called via
# the library() function. That means we have functions for most descriptive
# statistics:

mean(ches$eu_position)
sd(ches$eu_position)
var(ches$eu_position)
median(ches$eu_position)
min(ches$eu_position)
max(ches$eu_position)
quantile(ches$eu_position, 0.3) # the observation that leaves 30% of the observations to its left
quantile(ches$eu_position, 0.5) # this will be the median

# note one important behaviour of missing data:
2 + NA

# which means if we use these functions with missing data:
mean(aoe$rating)

# pay attention to the arguments of these functions:
?mean
mean(aoe$rating, na.rm=T) #note we need to explicitly name na.rm as we aren't using the trim argument


# some useful functions for categorical data (especially if it's in character form):
table(aoe$civ)
prop.table(table(aoe$civ)) # note that prop.table takes a table as input




## 1.1. covariance and correlation matrices ----
ches %>% 
  select(lrecon, eu_position, galtan) %>%
  cor()

ches %>% 
  select(lrecon, eu_position, galtan) %>%
  cov()

# note cor uses Pearson's correlation by default:
?cor

# if you have missing data, you want to set the argument use="complete.obs" to
# filter for missing data:
cor(aoe$rating, as.numeric(as.logical(toupper(aoe$winner))), use="complete.obs")




## 1.2 Describe ----

# finally, the psych package includes the describe() and describeBy() functions
# which are *amazing* for continuous data:
describe(aoe)
describeBy(aoe$rating, aoe$team)

# note the *'s next to some variables - this is telling us they were originally
# characters and were converted to numeric by the function. Some of these
# stats are probably meaningless!

# to select only numeric variables with dplyr:
aoe %>% 
  select_if(is.numeric) %>% #this is one case where you don't want to include the parantheses for the is.numeric function
  describe()

# we might want to combine filtering from file 02 with these functions:
describe(aoe[aoe$civ == "Franks",])
describe(aoe %>% filter(civ == "Franks"))

# there's a lot of room to customise the output:
describe(aoe, skew = FALSE, IQR = TRUE, ranges = FALSE)


# Let's say we want to look at some variables in CHES for the UK, Germany, and France.
# From the codebook, the codes for these countries are 11, 3, and 6 respectively.

# We could do this:
ches %>%
  filter(country == 11 | country == 3 | country == 6) %>%
  select(country, lrecon, eu_position) %>%
  describeBy(., .$country) #if you want to pipe into more than one slot or a slot other than the first, use the full stop

# But the %in% operator can be VERY useful for larger OR expressions:
ches %>%
  filter(country %in% c(3,6,11)) %>%
  select(country, lrecon, eu_position) %>%
  describeBy(., .$country)




# 2 Plotting ----

# Here, we'll be doing a mix of base R plotting and tidyverse plotting via
# the tidyverse package ggplot2 (already loaded earlier).

# We'll look at four kinds of plot:
# 1) Boxplots
# 2) Histograms
# 3) Density plots
# 4) Twoway plots

# Obviously, many others can be done - especially via ggplot2 (and associated
# packages)




## 2.1 boxplots ----

# In base R we use the boxplot() function:
boxplot(aoe$rating)

# We can use arguments to modify its appearance:
boxplot(aoe$rating, frame = F, ylab = "Rating", main = "AOE2 Player Ratings")

# It's a little more involved in the tidyverse:
ggplot(aoe, aes(y = rating)) + 
  geom_boxplot()

# We start by using the ggplot() function to create a graph. Here we tell it
# what dataset to use, and what the relevant 'aesthetics' to use are. The most
# common ones are y axis, x axis, group, and fill (similar to group).

# Then, ggplot2 brings some unique syntax. After the ggplot() function, we put
# a plus sign. After that, we add a geom (geometry). We can also add further
# geoms and other features after that, each time chaining things together with
# the + sign.

# This can get fairly involved, but it's *very* powerful:
ggplot(aoe, aes(y = rating)) + 
  geom_boxplot(fill = "gray", alpha = 0.5) +
  labs(y = "Rating", title = "Player Rating") +
  scale_y_continuous(breaks = seq(0, 3200, 800), limits = c(0, 3200), expand = c(0,0)) +
  theme(axis.line.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        panel.background=element_blank(),
        axis.line.y = element_line(colour = "black"),
        plot.title = element_text(hjust = 0.5, vjust = 5),
        aspect.ratio = 1,
        plot.margin = unit(rep(1, 4), "cm"))

# Don't worry - there are good pre-built themes! theme_classic(), theme_bw() and 
# theme_minimal() are all popular choices. There are also several packages out
# there containing other possible ggplot2 themes - the sky really is the limit
# here.

# To show the distribution of a variable in separate boxplots:
aoeSelect <- aoe %>%
  filter(civ %in% c("Franks", "Teutons", "Chinese"))

# In base R:
boxplot(aoeSelect$rating ~ aoeSelect$civ, #plot rating by civ
        frame = F, ylab = "Rating", xlab = "Civ", main = "Player Ratings by Civ")

# In the tidyverse:
ggplot(aoeSelect, aes(y = rating, x=civ)) + 
  geom_boxplot(fill = "gray", alpha = 0.5) +
  labs(y = "Rating", x = "Civlisation", title = "Player Rating") +
  scale_y_continuous(breaks = seq(0, 3200, 800), limits = c(0, 3200), expand = c(0,0)) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5, vjust = 5),
        aspect.ratio = 0.8,
        plot.margin = unit(rep(1, 4), "cm"))

# Note here that it was easier to mix and match a default theme with some
# extra adjustments of our own




## 2.2 histograms ----

# Plotting histograms is fairly easy in base R:
hist(ches$eu_position, main = "EU Party Positions", xlab = "Position")

# We can ask for probability densities instead of frequencies:
hist(ches$eu_position, main = "EU Party Positions", xlab = "Position", probability = TRUE) # to have probabilities


# In the tidyverse:
ggplot(ches, aes(x = eu_position)) + 
  geom_histogram()

# With more details:
ggplot(ches, aes(x = eu_position)) + 
  geom_histogram(binwidth = 1, fill="purple4", alpha=0.8, colour="black") +
  scale_y_continuous(breaks = seq(0,100,20), limits=c(0,100), expand=c(0,0)) +
  scale_x_continuous(breaks=seq(0,10,2), limits=c(0,10), expand=c(0,0)) +
  labs(x = "EU Position", y = "Count", title = "CHES Party EU Positions") +
  theme_classic()




## 2.3 density plots ----

# we can also obtain kernel densities of our data:
density(ANES$dem) # this function takes our data as input and computes the kernel density

# to plot it:
plot(density(ANES$dem))

# again, we can work on its options:
plot(density(ANES$dem, kernel = "epanechnikov"),
     frame = FALSE, main = "Kernel density (Epanechnikov)")
?density

# in tidyverse things are, again, simpler:
ggplot(ANES, aes(x = dem)) + geom_density()




## 2.4 twoway plots ----

# Suppose now we want to explore two-way relations in our data.
# for instance the two-way relation between height and weight of baseball players:
plot(x = baseball$heightinches, y = baseball$weightpounds,
     frame.plot = FALSE, xlab = "height", ylab = "weight",
     pch = 20) # pch is an option that selects the shape of dots we want 

# what if we want to add lines on this plot? We use the abline() function
# Maybe we want to plot a line corresponding to the mean height 
abline(v = mean(baseball$heightinches, na.rm = TRUE), col = "red", lwd = 5) # lwd makes it thicker

# Maybe we want to add a regression line to the plot...
abline(lm(weightpounds ~ heightinches, data = baseball), col = "green")
# ... but more on this in a bit!

# suppose now we want to save this plot. We simply do:
pdf("my_first_plot.pdf") # this creates a pdf file in which we put the following:
plot(x = baseball$heightinches, y = baseball$weightpounds, frame.plot = FALSE, 
     xlab = "height", ylab = "weight", pch = 20)
abline(v = mean(baseball$heightinches, na.rm = TRUE), col = "red", lwd = 2)
abline(lm(weightpounds ~ heightinches, data = baseball))
dev.off() # this closes and saves the pdf file.

# what if we wanted to limit our plot to a certain range of the x (or y) axis?
plot(x = baseball$heightinches, y = baseball$weightpounds, frame.plot = FALSE, 
     xlab = "height", ylab = "weight", pch = 20,
     xlim = c(60,75))

# again, tidyverse makes things much easier. Let's re-do all the steps we did before.
# First, we created a scatter plot. This time, let's save the plot in an object:
my.plot <- ggplot(baseball, aes(x = heightinches, y = weightpounds)) + geom_point()
my.plot

# now we want to add the mean height to the plot. It's very easy:
my.plot <- my.plot + geom_vline(xintercept = mean(baseball$heightinches), color = "red")
my.plot

# and if we want to add a regression line?
my.plot <- my.plot + geom_smooth(method = "lm")

# tidyverse makes it also simpler to save tidyverse plots:
ggsave(my.plot, filename = "my_first_ggplot.pdf")