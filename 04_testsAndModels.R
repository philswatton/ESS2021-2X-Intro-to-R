# Essex Summer School in Social Science Data Analysis
# 2X Introduction to R
# Phil Swatton
# Modified from 1X Introduction to R files by Lorenzo Crippa
# Sunday 25th July 2021, 11am-5pm BST
# File 04: statistical tests, OLS, generalised linear models


# Before proceeding: clear your environment, restart R
rm(list=ls())


## Packages
install.packages(c("stargazer", "texreg"))
library(tidyverse)
library(stargazer)
library(texreg)


## Data
avocado <- read.csv("data/avocado.csv")
simpsons <- read.csv("data/simpsons_episodes.csv")




## 1 T-tests ----

# As you may know, the reason why millennials can't afford a home is because
# they buy too much avocado toast. We're going to perform a t-test to get a
# sense of the mean price so that millennials can make better spending decisions.

# To test whether the mean avocado price is different from 0, we can use
# the t.test function:
t.test(avocado$AveragePrice) # by default a two-tailed t-test with null value = 0

# We can also test to see whether the avocado price is the same as other values,
# like the median price of a house in the US:
t.test(avocado$AveragePrice, mu = 269039) #sets the null to 269039, which according to a brief google is the median house price in the US

# We can perform one-sided tests:
t.test(avocado$AveragePrice, mu = 269039, alternative = "less")
t.test(avocado$AveragePrice, mu = 269039, alternative = "greater")

# We can also perform difference in means tests. We may for instance want
# to test to see whether conventional and organic avocados have the same mean
# price, so we can advise millennials looking to buy a house on whether avoiding
# organic will help them save up.

t.test(x = avocado$AveragePrice[avocado$type == "conventional"],
       y = avocado$AveragePrice[avocado$type == "organic"])

# Conventional avocados are cheaper! Maybe this is the secret to millennial
# home ownership...




# 2 Statistical models ----

# We're now going to switch things up and look at a dataset of 


# suppose now we want to estimate a linear model using OLS. 
# To do that we first import a dataset from an article by David Card (1993) on NBER:
card <- read.dta("Card_data.dta")
head(card)

library(haven)
card <- read_dta("Card_data.dta")


# We might check it with a linear model:
model1 <- lm(wage ~ exper, # your formula
             data = card) # where are the data stored
summary(model1)

# we probably would want to include some control variables to this model:
model2 <- lm(wage ~ exper + motheduc + fatheduc,
             data = card)
summary(model2)

# notice we can transform variables. For instance, we can use the log of wage as a dv:
model3 <- lm(log(wage) ~ exper + motheduc + fatheduc,
             data = card)
summary(model3)

# maybe then we want to show our results. There are some very good packages to produce
# neat regression tables out there. The choice between them depends mostly on the type
# of models that they can support. Two equally good choices are stargazer and texreg.
# We'll use stargazer today:


# let's see how stargazer works
stargazer(model1, model2, model3, type = "text",
          keep.stat = c("n", "rsq", "adj.rsq", "f"), df = FALSE)
# maybe we want to export it to a Word document:
stargazer(model1, model2, model3, type = "html",
          keep.stat = c("n", "rsq", "adj.rsq", "f"), df = FALSE,
          out = "my_table.doc")
# or as a txt document:
stargazer(model1, model2, model3, type = "text",
          keep.stat = c("n", "rsq", "adj.rsq", "f"), df = FALSE,
          out = "my_table.txt")
# or maybe as a latex document:
stargazer(model1, model2, model3, type = "latex",
          keep.stat = c("n", "rsq", "adj.rsq", "f"), df = FALSE,
          out = "my_table.tex")
?stargazer

# we can also extract statistics and information from our model objects:
model3$coefficients
model3$residuals
fit <- model3$fitted.values

# and more:
summary(model3)$coefficients[,1] # these are the coefficients (the betas)
summary(model3)$coefficients[,2] # these are the standard errors of our coefficients
summary(model3)$coefficients[,3] # these are the t-statistics
summary(model3)$coefficients[,4] # these are the p-values
# of course we could save this information in R objects

# if we want to obtain predictions from our model, together with confidence intervals,
# the predict() function is our friend:
prediction <- as.data.frame(predict(model1, interval = "confidence"))
?predict

# those of you who needed to obtain robust or clustered standard errors will definitely
# need the package sandwich, which contains functions like vcovHC() and vcovCL() that compute
# variance-covariance matrixes to obtain standard errors that are robust 
# to heteroskedasticity or clustered at some data level. But enough on that for today. 

### 4.2.2 generalized linear models ----

# Most statistical models in R have a syntax very similar to the one adopted by lm().
# Covering these models is not part of today's class, but we might want to show
# that other models, such as those in the family of the generalized linear model (GLM),
# work very similarly. Suppose we want to explain if a person went to college based on the
# years of education of the father and mother. A logit or probit model would be appropriate:

mod.glm <- glm(enroll ~ fatheduc + motheduc +
                 black + smsa + south + IQ,
               data = card,
               family = binomial(link = "logit"))
summary(mod.glm)

# Time for exercises!

# THE END ----