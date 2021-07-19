# 3) GET SUMMARY STATS AND PLOTS ----

## 3.1 Summary statistics ----
# let's re-import the ANES dataset
rm(list=ls())
ANES <- read.dta("anesByState.dta")

# we now want to get some description of our data. The summary() function is our friend in this:
summary(ANES$poor) # description of a single variable...
summary(ANES) # ...and of an entire dataset
summary(ANES[,3:7])

# we can also ask for specific information:
mean(ANES$voteDem) 
sd(ANES$poor)
median(ANES$dem)
min(ANES$year)
max(ANES$voteDem)
quantile(ANES$poor, 0.3) # the observation that leaves 30% of the observations to its left
quantile(ANES$poor, 0.5) # this will be the median of course!
median(ANES$poor)
var(ANES$dem) # the variance
table(ANES$year) # how often does each occurrence appear?

# notice what happens here, though:
mean(ANES$FTM)
# we get an NA. This is because this variable has missing values. We need to explicitly tell
# R how to handle these missing data: we want to exclude them from the computation of the mean:
mean(ANES$FTM, na.rm = TRUE) # remove the NAs!

# we might want to ask R to give us summaries only for observations that satisfy conditions:
# for instance, give us the mean of FTM only when year is 2004:
mean(ANES$FTM[ANES$year == 2004], na.rm = T)

# or give us the mean of FTM when year is either 2004 or 2006 or 2008
mean(ANES$FTM[ANES$year == 2004 | ANES$year == 2006 | ANES$year == 2008], na.rm = T)

# once again, tidyverse offers us a way of making this simpler:
mean(ANES$FTM[ANES$year %in% c(2004, 2006, 2008)], na.rm = T)
# we're keeping FTM observations that correspond to either year 2004, 2006, or 2008, and removing NAs

# or we might want to introduce an "and" condition. For instance, give us the mean of
# poor when the year is before 2000 and the observation of FTM is not missing
mean(ANES$poor[ANES$year < 2000 & is.na(ANES$FTM) == FALSE], na.rm = T)

# we might also need information on the covariance or correlation between our data:
cov(ANES$voteDem, ANES$poor) # covariance
cor(ANES$voteDem, ANES$poor) # correlation

# and we can also ask for an entire correlation matrix. 
# For instance the correlation of numeric variables in ANES,
#  but without the NAs that we know the variable FTM has
cor(ANES[is.na(ANES$FTM) == FALSE, 3:7]) # we do it this way because cor() has no na.rm option

# if we want to extract significance and pvalues of these correlations (pearson ans spearman tests)
# we can do:
cor.test(ANES$voteDem, ANES$poor)

# we might also want to try the describe() function in the "psych" package for psychometric analysis:
install.packages("psych")
library("psych")
describe(ANES) 
?describe # here you get a number of different options you might find interesting:

describe(ANES[,c(3,4)], skew = FALSE, IQR = TRUE, ranges = FALSE)

## 3.2 Basic plots ----

# we now want to obtain some plots about our data. We'll see how to:
# 1) obtain boxplots
# 2) obtain histograms
# 3) obtain density plots
# 4) obtain twoway plots

# we'll see how base R obtains plots and how tidyverse 
# does (using the package ggplot2, part of the suite)

### 3.2.1 boxplots ----

# to obtain it we simply run:
boxplot(ANES$white)

# we can then intervene on options and modify its appearance:
boxplot(ANES$white, frame = F, ylab = "white", main = "A boxplot")

# this would be the tidyverse way of doing it:
ggplot(ANES, aes(y = white)) + geom_boxplot()
# we use the ggplot() function to create a graph. We need to tell the function what data frame
# we draw information from (ANES), and what we should put on the y axis (white variable). Next
# we need to "add" the type of graph ("geometry" in ggplot2 jargon) we want to create: geom_boxplot()

# what if we wanted to show the distribution of a variable in separate boxplots according to
# another variable? For instance we might want to plot distributions of heights of baseball
# players for the teams "BAL", "NYY", "SEA", "WAS", "PHI", "NYM", "TEX".
# re-import the dataset first:
baseball <- read.csv("baseball.csv")
selection <- filter(baseball, team %in% c("BAL", "NYY", "SEA", "WAS", "PHI", "NYM", "TEX"))
boxplot(selection$heightinches ~ selection$team, # plot height by team
        frame = F, ylab = "height", xlab = "team", main = "Boxplot of height distributions")

# in tidyverse:
ggplot(selection, aes(y = heightinches, x = team)) + 
  geom_boxplot() +
  labs(y="Height (Inches)")


### 3.2.2 histograms ----

# plotting histograms is also very easy and similar to obtaining boxplots:
hist(ANES$FTM, main = "Histogram of FTM", xlab = "FTM")

# and we can also intervene in the plot with options:
hist(ANES$FTM, main = "Histogram of FTM", xlab = "FTM", probability = TRUE) # to have probabilities
?hist

# again, in tidyverse:
ggplot(ANES, aes(x = FTM)) + geom_histogram()

# we can intervene on the bins size:
ggplot(ANES, aes(x = FTM)) + geom_histogram(binwidth = 5)

### 3.2.3 density plots ----

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

### 3.2.4 twoway plots ----

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