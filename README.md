# ESS2021-2X-Intro-to-R

This is a repository for the class files I used in teaching the class 2X Introduction to R in the 2021 Essex Summer School's second session. The materials are heavily based on the 1X class of the same year taught by [Lorenzo Crippa](https://lorenzo-crippa.github.io/).

The class covers the basics of getting started in R, including using scripts, using RStudio, using R projects to set the file path for a project, data types, R's data structures, importing data, managing datasets with dplyr, and some basic statistical tests and models.


## Data

- match_players.csv
  - Dataset containing Age of Empires 2 match data - 1% of original observations
  - Source: https://www.kaggle.com/jerkeeler/age-of-empires-ii-de-match-data?select=matches.csv
  - Licence: https://creativecommons.org/licenses/by/4.0/
  - Dataset filtered from original using the following lines in R:

```r
aoe <- read.csv("data/match_players.csv")
set.seed(42)
aoe <- aoe[rbinom(nrow(aoe), 1, 0.01),]
write.csv(aoe, "data/match_players.csv")
```

- CHES2019V3.dta
  - Chapel Hill Expert Survey 2019
  - Source: https://www.chesdata.eu/our-surveys
  - Dataset not included in repo as no clear licencing